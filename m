Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7108218A6BC;
	Tue, 30 Jul 2024 17:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359693; cv=none; b=bgrT+V+u+ntwvF+Dv2D7JG5gHOeTfE4bw16EF7n2fLmSSYsnfRNoGOoWGDLva/px5uVcNu9pWeQW9An6yDg6rKBKar9wDyBDcWwfrW0x66ZRZMHIsVUnK9ouG2zPkK3GwnwpljS//ZWnRPf+nu2jPGZfGOSCSNsfYp6y/sxenTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359693; c=relaxed/simple;
	bh=lQbPPyugxsi3iO2gXGDFZZL9m+7DVzSN4SQXSviOW90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oifm+7DochaxmQC0la59nPm/bPv4Jq0ni914sLGMLsi0DoJJ98AJ4vFst5ZRz65wLhb0NJdMchgYk36MkNF3NcWREQWXsrmxpZdchS/xdtAPurVpc/3uo0lrAb6Hk+s+ooCZOYGX2JptIi01ok//xWnXv7x5nBTIgVBQm0BjzXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1+pBsjCI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1+pBsjCI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9309C4AF0F;
	Tue, 30 Jul 2024 17:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359693;
	bh=lQbPPyugxsi3iO2gXGDFZZL9m+7DVzSN4SQXSviOW90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1+pBsjCIEQfMGS697hVeMSIngBCluRpZr7mOOedbJd5JSUUIQznaw1x1yPYqzgHpi
	 5Ytk/cdibLnQeBb5qx3kk+8TGBpJuM673xXibub8yaMkw91b7/AoAoFFUKhQiDqwHN
	 a+2Oc770wmSmn9FifYzzyVPFPBWlc4MubXpvx8NM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunseong Kim <yskelg@gmail.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.6 514/568] s390/mm: Fix VM_FAULT_HWPOISON handling in do_exception()
Date: Tue, 30 Jul 2024 17:50:21 +0200
Message-ID: <20240730151700.113056142@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Yunseong Kim <yskelg@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/mm/fault.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -331,14 +331,16 @@ static noinline void do_fault_error(stru
 				do_no_context(regs, fault);
 			else
 				do_sigsegv(regs, SEGV_MAPERR);
-		} else if (fault & VM_FAULT_SIGBUS) {
+		} else if (fault & (VM_FAULT_SIGBUS | VM_FAULT_HWPOISON)) {
 			/* Kernel mode? Handle exceptions or die */
 			if (!user_mode(regs))
 				do_no_context(regs, fault);
 			else
 				do_sigbus(regs);
-		} else
+		} else {
+			pr_emerg("Unexpected fault flags: %08x\n", fault);
 			BUG();
+		}
 		break;
 	}
 }


