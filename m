Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA9C02D738F;
	Wed,  4 Feb 2026 15:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219171; cv=none; b=NFwDlvgO0E79ica7odwSweTSXRNU2pY6m2JuEBri63h+HygdE33kD+3sUKQcEVHyswGRIz2hw7kOSWbv25nBRkk4KQGHsEDfMWu9bhsALiBnykyzOSsFd40i9k9hxo7KaDoF+T5453STJ/iIRtqxc/EwFCSAbaHWZW0xvdSxGMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219171; c=relaxed/simple;
	bh=IpqBlnf4SVj91UydQQT1mROWsEhiZpb6J+VTQjw74Mw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IcJQhz9bMzTzLsWPSuzUBQMV4FQCCWO6twQE2mRmWNAmtCVXrZWuGfljX/Zmi0k7t9qzdyw87PSluOP2w1ShX+CryRBNw2eGiIWl23FvuzRL/1YUcKuN1KniK6AFZwungnzKzb4R+NtAH3481OWU3aOSXPqhwyxupbt/+exDvWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pR201Nou; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pR201Nou"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 275B9C4CEF7;
	Wed,  4 Feb 2026 15:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770219170;
	bh=IpqBlnf4SVj91UydQQT1mROWsEhiZpb6J+VTQjw74Mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pR201Nou7QlVXWu+Oo5VNsvrnVw6RISs0RGldGXJAcbjR9pFPN/MFM++QsO2d34l9
	 LztP6wyY0FtWdLNhdVtLfPnZFB1AyKcdbNrFO3D0M+8EUrWr/c77SkFt4IyquTGaAF
	 3juEWb5M+N+jHvqfu/qgc62K94Qnl1RcxFw9Wxvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"robin.kuo" <robin.kuo@mediatek.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"andrew.yang" <andrew.yang@mediatek.com>,
	AngeloGiaocchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Chinwen Chang <chinwen.chang@mediatek.com>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kairui Song <ryncsn@gmail.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Mathias Brugger <matthias.bgg@gmail.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Qun-wei Lin <Qun-wei.Lin@mediatek.com>
Subject: [PATCH 6.18 087/122] mm, swap: restore swap_space attr aviod kernel panic
Date: Wed,  4 Feb 2026 15:41:09 +0100
Message-ID: <20260204143854.981902181@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: robin.kuo <robin.kuo@mediatek.com>

commit a0f3c0845a4ff68d403c568266d17e9cc553e561 upstream.

commit 8b47299a411a ("mm, swap: mark swap address space ro and add context
debug check") made the swap address space read-only.  It may lead to
kernel panic if arch_prepare_to_swap returns a failure under heavy memory
pressure as follows,

el1_abort+0x40/0x64
el1h_64_sync_handler+0x48/0xcc
el1h_64_sync+0x84/0x88
errseq_set+0x4c/0xb8 (P)
__filemap_set_wb_err+0x20/0xd0
shrink_folio_list+0xc20/0x11cc
evict_folios+0x1520/0x1be4
try_to_shrink_lruvec+0x27c/0x3dc
shrink_one+0x9c/0x228
shrink_node+0xb3c/0xeac
do_try_to_free_pages+0x170/0x4f0
try_to_free_pages+0x334/0x534
__alloc_pages_direct_reclaim+0x90/0x158
__alloc_pages_slowpath+0x334/0x588
__alloc_frozen_pages_noprof+0x224/0x2fc
__folio_alloc_noprof+0x14/0x64
vma_alloc_zeroed_movable_folio+0x34/0x44
do_pte_missing+0xad4/0x1040
handle_mm_fault+0x4a4/0x790
do_page_fault+0x288/0x5f8
do_translation_fault+0x38/0x54
do_mem_abort+0x54/0xa8

Restore swap address space as not ro to avoid the panic.

Link: https://lkml.kernel.org/r/20260116062535.306453-2-robin.kuo@mediatek.com
Fixes: 8b47299a411a ("mm, swap: mark swap address space ro and add context debug check")
Signed-off-by: robin.kuo <robin.kuo@mediatek.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: andrew.yang <andrew.yang@mediatek.com>
Cc: AngeloGiaocchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chinwen Chang <chinwen.chang@mediatek.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Mathias Brugger <matthias.bgg@gmail.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Qun-wei Lin <Qun-wei.Lin@mediatek.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/swap.h       | 2 +-
 mm/swap_state.c | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/swap.h b/mm/swap.h
index d034c13d8dd2..1bd466da3039 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -198,7 +198,7 @@ int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug);
 void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug);
 
 /* linux/mm/swap_state.c */
-extern struct address_space swap_space __ro_after_init;
+extern struct address_space swap_space __read_mostly;
 static inline struct address_space *swap_address_space(swp_entry_t entry)
 {
 	return &swap_space;
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 5f97c6ae70a2..44d228982521 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -37,8 +37,7 @@ static const struct address_space_operations swap_aops = {
 #endif
 };
 
-/* Set swap_space as read only as swap cache is handled by swap table */
-struct address_space swap_space __ro_after_init = {
+struct address_space swap_space __read_mostly = {
 	.a_ops = &swap_aops,
 };
 
-- 
2.53.0



