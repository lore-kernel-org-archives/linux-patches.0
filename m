Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E67E617B4FF;
	Wed,  3 Jul 2024 10:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003433; cv=none; b=V+zSXlaGgePkk85joqBQro0zIbS34JvB39+D04eSxwu3DPGL+6Hl6jEM6NdXyj0HrmH0++Dti0Hs3/KEJwq9z62l0e12LqktTi0UI4/GrUGfqAxeqP58nCYQGThg5VTdHtCbld3DwMfhpDxkKBPIur98/4Qlv5mv3RpLeWGc5v4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003433; c=relaxed/simple;
	bh=3gpsihCq1+frJdbEYLExpWwqljOkVcSp5GVS76d9y6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cjCZdYTtfxziYRqHEkwg0OJWa/iyuju/RN/NqhqSdtuZ2uGFufmWF9lmcKoq1RQCl6LNVBI1lbzAHwnQz7rODBrgxmhB9BOJX9eD9AAp9bcZBinXae45QbfPFYW2XHRkZ0gzFaWGDuRyOR0/6mebTAB+3OTaPKPIZfXqFIYLaXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BUvvjhWB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BUvvjhWB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C800C2BD10;
	Wed,  3 Jul 2024 10:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003432;
	bh=3gpsihCq1+frJdbEYLExpWwqljOkVcSp5GVS76d9y6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BUvvjhWB+HLbFXpC1g27edlABkEZxYi3sRGpcff/oCKYX2OTpvJdMkDjiP6ZysbPG
	 EulqZ2KUxqF6aRAtUb2q4gc3IhADDwzQp2o6f+TxGiqhC1x/8DC03Zi/TiY3LvL3tf
	 O7/o3598wOyTiLtM19v67icCvM4xhyorAH/xW1JA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rik van Riel <riel@surriel.com>,
	Baoquan He <bhe@redhat.com>,
	Dave Young <dyoung@redhat.com>,
	Vivek Goyal <vgoyal@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4.19 047/139] fs/proc: fix softlockup in __read_vmcore
Date: Wed,  3 Jul 2024 12:39:04 +0200
Message-ID: <20240703102832.212636666@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rik van Riel <riel@surriel.com>

commit 5cbcb62dddf5346077feb82b7b0c9254222d3445 upstream.

While taking a kernel core dump with makedumpfile on a larger system,
softlockup messages often appear.

While softlockup warnings can be harmless, they can also interfere with
things like RCU freeing memory, which can be problematic when the kdump
kexec image is configured with as little memory as possible.

Avoid the softlockup, and give things like work items and RCU a chance to
do their thing during __read_vmcore by adding a cond_resched.

Link: https://lkml.kernel.org/r/20240507091858.36ff767f@imladris.surriel.com
Signed-off-by: Rik van Riel <riel@surriel.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/vmcore.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -359,6 +359,8 @@ static ssize_t __read_vmcore(char *buffe
 		/* leave now if filled buffer already */
 		if (buflen == 0)
 			return acc;
+
+		cond_resched();
 	}
 
 	list_for_each_entry(m, &vmcore_list, list) {


