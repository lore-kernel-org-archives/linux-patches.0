Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 125A939FD9;
	Fri, 24 Nov 2023 18:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NcQvd3ca"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 919CCC433C7;
	Fri, 24 Nov 2023 18:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700848832;
	bh=5n+Qvt5g9B2mSxH+egOZ5s8bZrtqOXrFcOrRBKFYQU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NcQvd3ca53DG5oHCyh+6HTkYqMfburm9rB0y8zIsIva64J2rCXDTxtjt5kdwGwShf
	 Ib/CroHz/ED7LafZO184F55posOxjg/PyyDPXVxsbN10j+4qB2GNZvYCELIT/Ofut9
	 ptrAGWdmjqjHn9fxdeGt/sHNqTpyrmlqK/PtN3vE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 4.19 72/97] parisc/pgtable: Do not drop upper 5 address bits of physical address
Date: Fri, 24 Nov 2023 17:50:45 +0000
Message-ID: <20231124171936.831223040@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171934.122298957@linuxfoundation.org>
References: <20231124171934.122298957@linuxfoundation.org>
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
@@ -522,13 +522,13 @@
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
@@ -536,8 +536,7 @@
 	depdi		_HUGE_PAGE_SIZE_ENCODING_DEFAULT,63,\
 				(63-58)+PAGE_ADD_HUGE_SHIFT,\pte
 #else /* Huge pages disabled */
-	extrd,u		\pte,(63-ASM_PFN_PTE_SHIFT)+(63-58)+PAGE_ADD_SHIFT,\
-				64-PAGE_SHIFT-PAGE_ADD_SHIFT,\pte
+	extrd,u		\pte,PFN_START_BIT,PFN_START_BIT+1,\pte
 	depdi		_PAGE_SIZE_ENCODING_DEFAULT,63,\
 				(63-58)+PAGE_ADD_SHIFT,\pte
 #endif


