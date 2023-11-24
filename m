Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B57BB33CCA;
	Fri, 24 Nov 2023 19:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eG+mWE54"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E26E2C433C7;
	Fri, 24 Nov 2023 19:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853548;
	bh=XgyJ+kfbT5/stxlSX0hi+Tg8K5AUOQ79lF38NghMDhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eG+mWE54V+wGrreFel9+ZZiAWZcYui6lfgmQlZ5pfeGII8J/215SYbZX3cCm7iHD3
	 hhaee1jm6PNyrF/YhDvXm9AcNbt4yVpnRvFvmko3pL3r+dHBHVTVJqvfMvW46epLct
	 mOyLAG5wJ7R2lYkaSLw/iSAjAq7M3qaFcfmq0FVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.15 232/297] parisc/pgtable: Do not drop upper 5 address bits of physical address
Date: Fri, 24 Nov 2023 17:54:34 +0000
Message-ID: <20231124172008.311843916@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172000.087816911@linuxfoundation.org>
References: <20231124172000.087816911@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit 166b0110d1ee53290bd11618df6e3991c117495a upstream.

When calculating the pfn for the iitlbt/idtlbt instruction, do not
drop the upper 5 address bits. This doesn't seem to have an effect
on physical hardware which uses less physical address bits, but in
qemu the missing bits are visible.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc:  <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/entry.S |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/arch/parisc/kernel/entry.S
+++ b/arch/parisc/kernel/entry.S
@@ -497,13 +497,13 @@
 	 * to a CPU TLB 4k PFN (4k => 12 bits to shift) */
 	#define PAGE_ADD_SHIFT		(PAGE_SHIFT-12)
 	#define PAGE_ADD_HUGE_SHIFT	(REAL_HPAGE_SHIFT-12)
+	#define PFN_START_BIT	(63-ASM_PFN_PTE_SHIFT+(63-58)-PAGE_ADD_SHIFT)
 
 	/* Drop prot bits and convert to page addr for iitlbt and idtlbt */
 	.macro		convert_for_tlb_insert20 pte,tmp
 #ifdef CONFIG_HUGETLB_PAGE
 	copy		\pte,\tmp
-	extrd,u		\tmp,(63-ASM_PFN_PTE_SHIFT)+(63-58)+PAGE_ADD_SHIFT,\
-				64-PAGE_SHIFT-PAGE_ADD_SHIFT,\pte
+	extrd,u		\tmp,PFN_START_BIT,PFN_START_BIT+1,\pte
 
 	depdi		_PAGE_SIZE_ENCODING_DEFAULT,63,\
 				(63-58)+PAGE_ADD_SHIFT,\pte
@@ -511,8 +511,7 @@
 	depdi		_HUGE_PAGE_SIZE_ENCODING_DEFAULT,63,\
 				(63-58)+PAGE_ADD_HUGE_SHIFT,\pte
 #else /* Huge pages disabled */
-	extrd,u		\pte,(63-ASM_PFN_PTE_SHIFT)+(63-58)+PAGE_ADD_SHIFT,\
-				64-PAGE_SHIFT-PAGE_ADD_SHIFT,\pte
+	extrd,u		\pte,PFN_START_BIT,PFN_START_BIT+1,\pte
 	depdi		_PAGE_SIZE_ENCODING_DEFAULT,63,\
 				(63-58)+PAGE_ADD_SHIFT,\pte
 #endif


