Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C35298F70
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 19:55:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 417A6C433C7;
	Sun, 16 Jul 2023 19:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537353;
	bh=aNxoazp4NMcFeDS9Hr4NkTVxUVnTXHuucJk+6VkprIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iGOzR4XFfw0XoZbB6QzFZy11+bkWrpgr0fniHQ+6Hq3jN7VbjH8l09olFYHK9zU9C
	 Lt+vwjueCcycsAqy/gFdAvOaSl6wRIfRJFDjMz3kqnIn/qUI+pl/wrqsZ9ePEh3+5a
	 BukyMKhfr5RjbN8Swx+Nlf5U35BwKOE3VN1IdTVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 066/800] x86/tdx: Fix race between set_memory_encrypted() and load_unaligned_zeropad()
Date: Sun, 16 Jul 2023 21:38:39 +0200
Message-ID: <20230716194950.625896578@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

[ Upstream commit 195edce08b63d293377f615f4f7f086715d2d212 ]

tl;dr: There is a race in the TDX private<=>shared conversion code
       which could kill the TDX guest.  Fix it by changing conversion
       ordering to eliminate the window.

TDX hardware maintains metadata to track which pages are private and
shared. Additionally, TDX guests use the guest x86 page tables to
specify whether a given mapping is intended to be private or shared.
Bad things happen when the intent and metadata do not match.

So there are two thing in play:
 1. "the page" -- the physical TDX page metadata
 2. "the mapping" -- the guest-controlled x86 page table intent

For instance, an unrecoverable exit to VMM occurs if a guest touches a
private mapping that points to a shared physical page.

In summary:
	* Private mapping => Private Page == OK (obviously)
	* Shared mapping  => Shared Page  == OK (obviously)
	* Private mapping => Shared Page  == BIG BOOM!
	* Shared mapping  => Private Page == OK-ish
	  (It will read generate a recoverable #VE via handle_mmio())

Enter load_unaligned_zeropad(). It can touch memory that is adjacent but
otherwise unrelated to the memory it needs to touch. It will cause one
of those unrecoverable exits (aka. BIG BOOM) if it blunders into a
shared mapping pointing to a private page.

This is a problem when __set_memory_enc_pgtable() converts pages from
shared to private. It first changes the mapping and second modifies
the TDX page metadata.  It's moving from:

        * Shared mapping  => Shared Page  == OK
to:
        * Private mapping => Shared Page  == BIG BOOM!

This means that there is a window with a shared mapping pointing to a
private page where load_unaligned_zeropad() can strike.

Add a TDX handler for guest.enc_status_change_prepare(). This converts
the page from shared to private *before* the page becomes private.  This
ensures that there is never a private mapping to a shared page.

Leave a guest.enc_status_change_finish() in place but only use it for
private=>shared conversions.  This will delay updating the TDX metadata
marking the page private until *after* the mapping matches the metadata.
This also ensures that there is never a private mapping to a shared page.

[ dhansen: rewrite changelog ]

Fixes: 7dbde7631629 ("x86/mm/cpa: Add support for TDX shared memory")
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Link: https://lore.kernel.org/all/20230606095622.1939-3-kirill.shutemov%40linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/coco/tdx/tdx.c | 51 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 48 insertions(+), 3 deletions(-)

diff --git a/arch/x86/coco/tdx/tdx.c b/arch/x86/coco/tdx/tdx.c
index e146b599260f8..64f1343df062f 100644
--- a/arch/x86/coco/tdx/tdx.c
+++ b/arch/x86/coco/tdx/tdx.c
@@ -840,6 +840,30 @@ static bool tdx_enc_status_changed(unsigned long vaddr, int numpages, bool enc)
 	return true;
 }
 
+static bool tdx_enc_status_change_prepare(unsigned long vaddr, int numpages,
+					  bool enc)
+{
+	/*
+	 * Only handle shared->private conversion here.
+	 * See the comment in tdx_early_init().
+	 */
+	if (enc)
+		return tdx_enc_status_changed(vaddr, numpages, enc);
+	return true;
+}
+
+static bool tdx_enc_status_change_finish(unsigned long vaddr, int numpages,
+					 bool enc)
+{
+	/*
+	 * Only handle private->shared conversion here.
+	 * See the comment in tdx_early_init().
+	 */
+	if (!enc)
+		return tdx_enc_status_changed(vaddr, numpages, enc);
+	return true;
+}
+
 void __init tdx_early_init(void)
 {
 	u64 cc_mask;
@@ -867,9 +891,30 @@ void __init tdx_early_init(void)
 	 */
 	physical_mask &= cc_mask - 1;
 
-	x86_platform.guest.enc_cache_flush_required = tdx_cache_flush_required;
-	x86_platform.guest.enc_tlb_flush_required   = tdx_tlb_flush_required;
-	x86_platform.guest.enc_status_change_finish = tdx_enc_status_changed;
+	/*
+	 * The kernel mapping should match the TDX metadata for the page.
+	 * load_unaligned_zeropad() can touch memory *adjacent* to that which is
+	 * owned by the caller and can catch even _momentary_ mismatches.  Bad
+	 * things happen on mismatch:
+	 *
+	 *   - Private mapping => Shared Page  == Guest shutdown
+         *   - Shared mapping  => Private Page == Recoverable #VE
+	 *
+	 * guest.enc_status_change_prepare() converts the page from
+	 * shared=>private before the mapping becomes private.
+	 *
+	 * guest.enc_status_change_finish() converts the page from
+	 * private=>shared after the mapping becomes private.
+	 *
+	 * In both cases there is a temporary shared mapping to a private page,
+	 * which can result in a #VE.  But, there is never a private mapping to
+	 * a shared page.
+	 */
+	x86_platform.guest.enc_status_change_prepare = tdx_enc_status_change_prepare;
+	x86_platform.guest.enc_status_change_finish  = tdx_enc_status_change_finish;
+
+	x86_platform.guest.enc_cache_flush_required  = tdx_cache_flush_required;
+	x86_platform.guest.enc_tlb_flush_required    = tdx_tlb_flush_required;
 
 	pr_info("Guest detected\n");
 }
-- 
2.39.2



