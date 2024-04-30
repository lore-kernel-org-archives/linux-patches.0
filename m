Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B1AB12C805;
	Tue, 30 Apr 2024 11:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475639; cv=none; b=eG+U+ppx+KdiRu2twrphratRBkRVKK4ECzt+BW1BSEgDNS3kcryWdapYkybobAUDlaych9cLoKfqRFhEOZNmQfv+7rri093NAMkfONYcl4/L4AaTdMOBr0TYBXYfUE61S0xXwIui56IFX0Hl9BBXARvOclujfbbjQNbq6FaB8iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475639; c=relaxed/simple;
	bh=VrAuTUA/rgwYQoLrJo4If0hCMM8vFzbaKZsuDOfHtkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ASCdyBkGaWjoLTPT2miuS6IE9ZrV9rBHyShf5mmiJpElvLIBcgPwqU1ovTcrPdPukDj9FlrdP5gHzVdkaG4W9A5sUMbM5KR3vrha+HYA9lAfT45765rLYfhxCv8PT17BHQej/rGLdOqMzLVZWtKErC91ZzcZhyYkL29C/zlcC3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fmVoZXSa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fmVoZXSa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B91C9C2BBFC;
	Tue, 30 Apr 2024 11:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475639;
	bh=VrAuTUA/rgwYQoLrJo4If0hCMM8vFzbaKZsuDOfHtkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fmVoZXSaMXaXWJ/uhYDFS47Hu7kMoqLGEAo6Vk24ElGlT1DsU3SfCsvicVaztiM/p
	 BVzBuiv3LkmjTCfcfk1s7QnWVLs+DNVvTjzjT4GYHh0sQcHxKxh6iw2LHGLw3rHoXE
	 newePfkHSc7e6Z7HIHpdQDInULKGClqvDoIbCJHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Chris Oo <cho@microsoft.com>
Subject: [PATCH 6.6 156/186] x86/tdx: Preserve shared bit on mprotect()
Date: Tue, 30 Apr 2024 12:40:08 +0200
Message-ID: <20240430103102.562870952@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

From: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

commit a0a8d15a798be4b8f20aca2ba91bf6b688c6a640 upstream.

The TDX guest platform takes one bit from the physical address to
indicate if the page is shared (accessible by VMM). This bit is not part
of the physical_mask and is not preserved during mprotect(). As a
result, the 'shared' bit is lost during mprotect() on shared mappings.

_COMMON_PAGE_CHG_MASK specifies which PTE bits need to be preserved
during modification. AMD includes 'sme_me_mask' in the define to
preserve the 'encrypt' bit.

To cover both Intel and AMD cases, include 'cc_mask' in
_COMMON_PAGE_CHG_MASK instead of 'sme_me_mask'.

Reported-and-tested-by: Chris Oo <cho@microsoft.com>

Fixes: 41394e33f3a0 ("x86/tdx: Extend the confidential computing API to support TDX guests")
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20240424082035.4092071-1-kirill.shutemov%40linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/coco.h          |    5 ++++-
 arch/x86/include/asm/pgtable_types.h |    3 ++-
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/coco.h
+++ b/arch/x86/include/asm/coco.h
@@ -12,9 +12,10 @@ enum cc_vendor {
 };
 
 extern enum cc_vendor cc_vendor;
-extern u64 cc_mask;
 
 #ifdef CONFIG_ARCH_HAS_CC_PLATFORM
+extern u64 cc_mask;
+
 static inline void cc_set_mask(u64 mask)
 {
 	RIP_REL_REF(cc_mask) = mask;
@@ -24,6 +25,8 @@ u64 cc_mkenc(u64 val);
 u64 cc_mkdec(u64 val);
 void cc_random_init(void);
 #else
+static const u64 cc_mask = 0;
+
 static inline u64 cc_mkenc(u64 val)
 {
 	return val;
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -148,7 +148,7 @@
 #define _COMMON_PAGE_CHG_MASK	(PTE_PFN_MASK | _PAGE_PCD | _PAGE_PWT |	\
 				 _PAGE_SPECIAL | _PAGE_ACCESSED |	\
 				 _PAGE_DIRTY_BITS | _PAGE_SOFT_DIRTY |	\
-				 _PAGE_DEVMAP | _PAGE_ENC | _PAGE_UFFD_WP)
+				 _PAGE_DEVMAP | _PAGE_CC | _PAGE_UFFD_WP)
 #define _PAGE_CHG_MASK	(_COMMON_PAGE_CHG_MASK | _PAGE_PAT)
 #define _HPAGE_CHG_MASK (_COMMON_PAGE_CHG_MASK | _PAGE_PSE | _PAGE_PAT_LARGE)
 
@@ -173,6 +173,7 @@ enum page_cache_mode {
 };
 #endif
 
+#define _PAGE_CC		(_AT(pteval_t, cc_mask))
 #define _PAGE_ENC		(_AT(pteval_t, sme_me_mask))
 
 #define _PAGE_CACHE_MASK	(_PAGE_PWT | _PAGE_PCD | _PAGE_PAT)


