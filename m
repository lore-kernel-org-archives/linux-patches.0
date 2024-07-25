Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3857519A29C;
	Thu, 25 Jul 2024 14:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918339; cv=none; b=edODhC68LC2RFQW9/pE76PUX29ZyYefqLK6Zp6ZoUXd1FA+lHVlq7H/G0qkGcHYvHYKk++ZdKsAtadA00l30ReRo5rJVpFtF5Kxop8QC33lMOQwzn9Bl7BSHbOp5fngJdQ1NVWUgvegb11TR/zvWSrZmQuvQEaJxFfY3/9uPJJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918339; c=relaxed/simple;
	bh=/F178W1nI/O83DORbG59fQ95fqtRKsMle9yHkYSxZ/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H+XnxvV+FbeHaDyj5Rz2GSeJT/qqk6kUtV02n/JUWoW1F8H+yjmZdQ/8+8U+HderSABh//HeEN4/bd8HlT5731022z+H3O0gD+6E2RfSKqQIt9zn/8HKi3mksK2pGGEEl7HHmcRGBTPMT83JoRTvwAPTKxboEL21+M861JQ91rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UCqAdkdS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UCqAdkdS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 849B0C116B1;
	Thu, 25 Jul 2024 14:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918339;
	bh=/F178W1nI/O83DORbG59fQ95fqtRKsMle9yHkYSxZ/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UCqAdkdShxq0bA7lIvusDpjM1utrMWgM28RIq17sX8teI/2kTrgsr7K9TXR0Z9qq0
	 +UZqTQn5cMeAS7IkjQjFbj9Dky+U/YgrnCve9tCM3kwQ9S+5qfqdc7RO1kU7XMvKiE
	 qTsWu/+rDRWm1lH1Eyo/8Lxe8L+PTXySQ4jtq22o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunseong Kim <yskelg@gmail.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.10 02/29] s390/mm: Fix VM_FAULT_HWPOISON handling in do_exception()
Date: Thu, 25 Jul 2024 16:36:18 +0200
Message-ID: <20240725142731.910029742@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142731.814288796@linuxfoundation.org>
References: <20240725142731.814288796@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -433,12 +433,13 @@ error:
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


