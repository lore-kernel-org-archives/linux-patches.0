Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D975061FE7;
	Wed,  3 Jul 2024 10:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003938; cv=none; b=WfEIFUe52him16FiPB/Y6PhsSNE5maLNpdivHYmyiVyKF3ylm9hrTv9GHV6I5g3yxf8K0BXO2l5GgFcJk8SEXTQXqbuLZEYWXP6TkAslC13BA94mZqb0azd1xXwJmUag/mdSLrqHE7Ku882sFh5cvxGC9ShvMYB09IGJjIap9O0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003938; c=relaxed/simple;
	bh=/SxluMjsZAla8EsHHSw1Wd0if0PHMlp3K6KiMTco6Jo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DvDZimx9kf18oW0/o9waNZ1VPjc1g63XlWRCyXQrNEzs9sysh0L2sg2QEOUu3/0wQzUDjsC01xXQ9dYanb1Q3U9LvF0jpYvGu8tN551pVRsLcNFyfp8itiMeNyCqV6gSpay9mfzNjqaAm9VopYkuroBPOLRGv8mfddlGSlQooCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LhLoTHHB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LhLoTHHB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 079F2C2BD10;
	Wed,  3 Jul 2024 10:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003938;
	bh=/SxluMjsZAla8EsHHSw1Wd0if0PHMlp3K6KiMTco6Jo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LhLoTHHBVB+ymNoA7zJOiF2Lwcmz5dMZai4rcLaUAh/WnwaFpGX/dFM/F+D2kJauN
	 ltoBtrEdrPecw/Nhb0tbDQV42+45/QEOJjl9HOlXDvg1/9evSHOtQFf+2bOZxtJyt/
	 y8+AQE9IuHeu7Eiks3zN0E5OBXWQPIAa7Rlie9kc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rik van Riel <riel@surriel.com>,
	Baoquan He <bhe@redhat.com>,
	Dave Young <dyoung@redhat.com>,
	Vivek Goyal <vgoyal@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.4 071/189] fs/proc: fix softlockup in __read_vmcore
Date: Wed,  3 Jul 2024 12:38:52 +0200
Message-ID: <20240703102844.187186058@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -374,6 +374,8 @@ static ssize_t __read_vmcore(char *buffe
 		/* leave now if filled buffer already */
 		if (buflen == 0)
 			return acc;
+
+		cond_resched();
 	}
 
 	list_for_each_entry(m, &vmcore_list, list) {


