Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA9616DECF;
	Wed,  3 Jul 2024 11:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004558; cv=none; b=bwj0aLYYph4G6JNUua7FkJJPXG03jczzaaDiCDy01LU2nZHjrjw/D/eMv4nBwdXQv6VhsxPvOxUzmNpNxjHB4mdspb0/0bC1XfsVXG5EqbaRwF9BWtRYjcrJoLaQw7phGfk1beNknQULQELbSx7fKsHGn4z6wXIzlkNrT7+sq7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004558; c=relaxed/simple;
	bh=ONXEDvZaH3oHxQDR/o6j04DlR7eazmBAkLx5KWzVGgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ONhiMdHxjND+ii8kJqTuK80n6KT8CsOQs5xxQKEHCHxxN+A3Bw5GkxKtFtIHn9jzOwC3L86sNTfXHq9lVyJnWLNzTDghUSWsi5DAJ0rwuPwv3HU7/mYXauNpjVP4b0K/Foo3G1nm5Imqb9XL3Cs1nV4+H+KNBd6ZMDshqv5x9SI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e4f129fq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e4f129fq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A686FC2BD10;
	Wed,  3 Jul 2024 11:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004558;
	bh=ONXEDvZaH3oHxQDR/o6j04DlR7eazmBAkLx5KWzVGgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e4f129fq5Lav9O/Itmr01Fq6N4mZ68YbHrwSenbZe1/J9kmh4OPU/RSbi9qRXHMZo
	 c8IVOxybHVJsO0FIZeVtlVXU7/HYyv13Y9qSNebK7WIaeNT7LEjDvbDrQRaEzcntGP
	 YO9t+l0T/SoxFUw5l5Bj/1SIZDKK3ynE5+yxSXDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rik van Riel <riel@surriel.com>,
	Baoquan He <bhe@redhat.com>,
	Dave Young <dyoung@redhat.com>,
	Vivek Goyal <vgoyal@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.10 081/290] fs/proc: fix softlockup in __read_vmcore
Date: Wed,  3 Jul 2024 12:37:42 +0200
Message-ID: <20240703102907.255758616@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -373,6 +373,8 @@ static ssize_t __read_vmcore(char *buffe
 		/* leave now if filled buffer already */
 		if (buflen == 0)
 			return acc;
+
+		cond_resched();
 	}
 
 	list_for_each_entry(m, &vmcore_list, list) {


