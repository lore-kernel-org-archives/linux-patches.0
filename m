Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4CA18468;
	Thu, 25 Jul 2024 14:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918791; cv=none; b=LxGGD3YZtzYtGWruANKyzv1iQNm1rFg7DH4W2sqsQA1lc/olKQU3r1z+AvrbM8/qYwU26mzRGUfpTcDuTPSNt547IIUYAM0Bw2FhiNTrwuayeZ1jqz7M4I6aKtG5Qx0StOq9ItBx76aai5d6kZuvi/5tJSwhlleDkxV2vJOOKQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918791; c=relaxed/simple;
	bh=CQTQhZPfbdNMZmFi3hS2SbZbun8U02axy2YPyHOOnLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JDuYRpAcWAiYBalmJyDdamAkRQ9Z07YfsYZB7DMx4BplOm8twSj4yY7oTIC6/LzeeMTin+eImhFzgjhZnSgqjUPE3bkV1h/vOjm+7Z580Xjr58pMLxaKSnkbEtjfzKgNEYW7eN65CrWMT+Prp7UrSoxXACsqE8EdXskBR4Y/eVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pk/HjXt9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pk/HjXt9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DC58C116B1;
	Thu, 25 Jul 2024 14:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918790;
	bh=CQTQhZPfbdNMZmFi3hS2SbZbun8U02axy2YPyHOOnLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pk/HjXt9BM6n4Ywm82IHpvjp1iw63LUvUB+5AKFo+7pos+m1OmP78x/ytSqe8DgGr
	 CdxTRZTPVsWqw3WtS13uZvnFznD0s3fTlnvu8UgGF4sKC7KSVD499i/P6dkyywHGvt
	 WYjxrrRJl95fZb94jsh+eHKo7WeJq70siNc+Jwy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunseong Kim <yskelg@gmail.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.9 02/29] s390/mm: Fix VM_FAULT_HWPOISON handling in do_exception()
Date: Thu, 25 Jul 2024 16:37:12 +0200
Message-ID: <20240725142731.773049432@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142731.678993846@linuxfoundation.org>
References: <20240725142731.678993846@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gerald Schaefer <gerald.schaefer@linux.ibm.com>

commit df39038cd89525d465c2c8827eb64116873f141a upstream.

There is no support for HWPOISON, MEMORY_FAILURE, or ARCH_HAS_COPY_MC on
s390. Therefore we do not expect to see VM_FAULT_HWPOISON in
do_exception().

However, since commit af19487f00f3 ("mm: make PTE_MARKER_SWAPIN_ERROR more
general"), it is possible to see VM_FAULT_HWPOISON in combination with
PTE_MARKER_POISONED, even on architectures that do not support HWPOISON
otherwise. In this case, we will end up on the BUG() in do_exception().

Fix this by treating VM_FAULT_HWPOISON the same as VM_FAULT_SIGBUS, similar
to x86 when MEMORY_FAILURE is not configured. Also print unexpected fault
flags, for easier debugging.

Note that VM_FAULT_HWPOISON_LARGE is not expected, because s390 cannot
support swap entries on other levels than PTE level.

Cc: stable@vger.kernel.org # 6.6+
Fixes: af19487f00f3 ("mm: make PTE_MARKER_SWAPIN_ERROR more general")
Reported-by: Yunseong Kim <yskelg@gmail.com>
Tested-by: Yunseong Kim <yskelg@gmail.com>
Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Message-ID: <20240715180416.3632453-1-gerald.schaefer@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/mm/fault.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -432,12 +432,13 @@ error:
 			handle_fault_error_nolock(regs, 0);
 		else
 			do_sigsegv(regs, SEGV_MAPERR);
-	} else if (fault & VM_FAULT_SIGBUS) {
+	} else if (fault & (VM_FAULT_SIGBUS | VM_FAULT_HWPOISON)) {
 		if (!user_mode(regs))
 			handle_fault_error_nolock(regs, 0);
 		else
 			do_sigbus(regs);
 	} else {
+		pr_emerg("Unexpected fault flags: %08x\n", fault);
 		BUG();
 	}
 }


