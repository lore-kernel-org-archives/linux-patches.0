Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622004;
	b=DYC9lzGm+si4DycXbdcX1gectQlIBvebFkXNg6S5z8LV2Nzwo0iaXapPqKuW7aIvZamG
	 XeABa9Ay3tMAKEfiepwXvMifvnu5h4VE1D2U2u2ljc1Rk/OyLEf61568nKNun/DQZF7j6
	 JkEaaCHC7vC/VDsBPZ0CR7IU5Du8FvNUICY8N+B31kHsr0sJ1+r2h+1lkkOhdg5al9fX0
	 GU+8+DI8AmFARcrf8LcYYg1AdeUzL0G1uHahmc2w6Xh4gzDth/gyfgfwxzcyNsLcZEGbw
	 KVzVSyOJMgRzqglbZ8A8b7i5p+5xfnyOYeEXLu2pviZTbNIh2UV2mbeiDxC4UNGHsYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622004;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=78SMURKg5OzS0sZmRo7zSxDW03IaqCvSQ6sv23S7FuE=;
	b=C7Uz2l5dseLDuGqM5f8u/uMGK7xoqF3qs+GnN7578HBwFFPi+mfTZVnJI1WOUs0SVHMi
	 d1u7xJa19gDX+wfyO6NQyNvwj7u3k3f46fL6ibHz4dd1sgOvbP9cNAgJzQoVQeXlQUPZC
	 a1+h0YXbTGmW0sA+MBCvJ3188H7kgTkBE1ltAuwkB3v8ksCiWvzMMPy0c0sr+f8OCD/VG
	 YZrNXF30unSmPuKccVjtH8Xtao9+FYaxWZxsQ++hMwdCiBFXgsC1aGTnEZfmwoPoKligI
	 09CkrJjq0HoqIek1EkcZXbar/pI8bn5IvTHpcK/etIdA8h43Alcck2cnSwMEMRsaQfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rMdluApG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DDE9606A321;
	Wed, 25 Nov 2026 15:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rMdluApG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83E1B1F000CA;
	Wed, 25 Nov 2026 15:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622004;
	bh=78SMURKg5OzS0sZmRo7zSxDW03IaqCvSQ6sv23S7FuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rMdluApGxUf1cfti0vWmUB6Ezk/7SRn+Lbbv9BP5Sc3kRSWs0ZaU4Bk4AWqMeDy/G
	 vSXyKZfWTVh5P7mpVBnr2G6SGHe+Cs7MDDROaJnZvTxPutsmPQ7vl5WztSJc2WHEML
	 pssgqHICQNzjMynw3erUjutjNzomxspBPJPRlm1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Patryk Holda <patryk.holda@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 398/990] i40e: xsk: fix multi-buffer XDP_PASS skb construction
Date: Wed, 25 Nov 2026 15:29:25 +0100
Message-ID: <20261125143831.421980410@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chenguang Zhao <zhaochenguang@kylinos.cn>

[ Upstream commit 76b41e83e69ae4ab23cc3535e36b780ea17e76c2 ]

When AF_XDP ZC receives a multi-buffer frame and the XDP program
returns XDP_PASS, i40e_construct_skb_zc() copies frags into a new
skb. The copy used skb_frag_page() as the memcpy source (page
metadata instead of packet data) and passed a virtual address to
__skb_fill_page_desc_noacc(), which expects a struct page *.

Use skb_frag_address() for the copy, attach frags with
skb_add_rx_frag() so len/data_len/truesize are updated, and on
dev_alloc_page() failure free the skb via the shared out path so
xsk_buff_free() still runs and previously attached pages are
released by kfree_skb.

Fixes: 1c9ba9c14658 ("i40e: xsk: add RX multi-buffer support")
Signed-off-by: Chenguang Zhao <zhaochenguang@kylinos.cn>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Patryk Holda <patryk.holda@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Reviewed-by: Björn Töpel <bjorn@kernel.org>
Link: https://patch.msgid.link/20261102124950.958345-8-maciej.fijalkowski@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 624f85851a7d1..e48fee2a4229e 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -318,22 +318,19 @@ static struct sk_buff *i40e_construct_skb_zc(struct i40e_ring *rx_ring,
 		goto out;
 
 	for (int i = 0; i < nr_frags; i++) {
-		struct skb_shared_info *skinfo = skb_shinfo(skb);
 		skb_frag_t *frag = &sinfo->frags[i];
+		unsigned int frag_size = skb_frag_size(frag);
 		struct page *page;
-		void *addr;
 
 		page = dev_alloc_page();
 		if (!page) {
 			dev_kfree_skb(skb);
-			return NULL;
+			skb = NULL;
+			goto out;
 		}
-		addr = page_to_virt(page);
 
-		memcpy(addr, skb_frag_page(frag), skb_frag_size(frag));
-
-		__skb_fill_page_desc_noacc(skinfo, skinfo->nr_frags++,
-					   addr, 0, skb_frag_size(frag));
+		memcpy(page_to_virt(page), skb_frag_address(frag), frag_size);
+		skb_add_rx_frag(skb, i, page, 0, frag_size, PAGE_SIZE);
 	}
 
 out:
-- 
2.53.0



