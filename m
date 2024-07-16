Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A07BE1DDF5;
	Tue, 16 Jul 2024 15:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144520; cv=none; b=Zn7mCg+CWwrFmDqeYX7tI02/l/qwoTctEr6AjkrLmA5ZhjpkwZqbi5ct/A1FOw4zFbRYJYzptzkK/0am/hjgtbRkTNYjG71oyrbtW9RvPWbKXwiTwnFh//dgPyiL/C3Y7aEIWHxt9lq3z1AIhzArqkSa4NJQ3dcwL+b63pjWJ54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144520; c=relaxed/simple;
	bh=NeX+ULFTwturiwn3e6gBbDBpIv1Gv8TACqV+JIsVPMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KhIJ67ntHEA2Sdb9vDOpdu8iGWcSd79nBUHpHDeaUmwLelpXTaJ++vVrchDIs3qvOJ5SlCLxgTMUs1oFZsXVgneyyXcbQjhQAfl0nhU/X7fbEec3jvfvdk4RdfVMn5HKAg1W9Sye2VQjVXA5/e54P4SOCzPzcgvWt/5cyCT6VUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RpISGFoA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RpISGFoA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 276E1C116B1;
	Tue, 16 Jul 2024 15:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144520;
	bh=NeX+ULFTwturiwn3e6gBbDBpIv1Gv8TACqV+JIsVPMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RpISGFoAVR4LUffAQWurq437JDZHJbA0J5KMqliGvBa2Syhq7lvTR+TShFlhVoZNQ
	 4ev5Cfu199x2wDedSX6MvE+JPLFf3yyHOEVm32t/aBi74FKp3xb4Bz/JuhJk8C8a7m
	 xMagMMGi1cWv2llCJOrZrmqxySzzMBCiKEOau950=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 020/108] powerpc/64: Set _IO_BASE to POISON_POINTER_DELTA not 0 for CONFIG_PCI=n
Date: Tue, 16 Jul 2024 17:30:35 +0200
Message-ID: <20240716152746.776706179@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152745.988603303@linuxfoundation.org>
References: <20240716152745.988603303@linuxfoundation.org>
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

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit be140f1732b523947425aaafbe2e37b41b622d96 ]

There is code that builds with calls to IO accessors even when
CONFIG_PCI=n, but the actual calls are guarded by runtime checks.

If not those calls would be faulting, because the page at virtual
address zero is (usually) not mapped into the kernel. As Arnd pointed
out, it is possible a large port value could cause the address to be
above mmap_min_addr which would then access userspace, which would be
a bug.

To avoid any such issues, set _IO_BASE to POISON_POINTER_DELTA. That
is a value chosen to point into unmapped space between the kernel and
userspace, so any access will always fault.

Note that on 32-bit POISON_POINTER_DELTA is 0, so the patch only has an
effect on 64-bit.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20240503075619.394467-2-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/io.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/io.h b/arch/powerpc/include/asm/io.h
index 058d21f493fad..c6b56aa0334fd 100644
--- a/arch/powerpc/include/asm/io.h
+++ b/arch/powerpc/include/asm/io.h
@@ -45,7 +45,7 @@ extern struct pci_dev *isa_bridge_pcidev;
  * define properly based on the platform
  */
 #ifndef CONFIG_PCI
-#define _IO_BASE	0
+#define _IO_BASE	POISON_POINTER_DELTA
 #define _ISA_MEM_BASE	0
 #define PCI_DRAM_OFFSET 0
 #elif defined(CONFIG_PPC32)
-- 
2.43.0



