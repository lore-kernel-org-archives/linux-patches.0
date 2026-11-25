Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624790;
	b=A0XHJMRNjWfFNBmyJQ3TryvXwL9v2ne7oyOe0KrWEStsbZ5wRYiQKCqYfvP/RBZoNmWq
	 Qdv45U5g1RjnDYVmTiDaSkFbVje3MwZyg77Mmra74WTXCviDwgGJs82KdZPpvqgis4mX8
	 fqJX9Zxr+VSI2DzhyPB1snyBj5ItNZ85FoprFaKGADbLuk7NOklUQ8lGzlJWeKqN4rLrT
	 L03+22nEuOb5EAwXxRF5WaHgNNXpsSK3GFE02bY0qyymMvzs1MXZWX4+UTULhjSI0ppPt
	 j5tyMRIBtPIC3O0HrtAc+w0QSu2L2Q8EWhK0gRTHJ1gqcuXnZR3xTQzRtSBYWTiODQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624790;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=JfpPs61rwgoB9TrHFYZcEbGuwwH+z4nppxgphp8e34Y=;
	b=G/VuJiJKgEoX/7aT30GuC6EGkhBW5AGX+fXo//xwQMYYA1labNydIq3PUIE1OG5mg7K3
	 0Ew9IX+YZxC+8ap8qzz/vbN3lAjftLXE7vajmcPSWW2uf1EreulRpfHIpQglBiaWZXeSb
	 phSNIit5QgZvsFsPKEPeGNESutpn9GodZUAN8955NOSwmB+GzXGuMunEv3qp0VDQ0raZ8
	 oydvDGil9R5iRUrD82Dm7UbbdYXPahuEunx6WbGLn6HjmMpKUcSqvpMu/16dWhZwshwDl
	 oZL018JDGosgFxaGNH48szJRp8JXJxp4jUcBORUWVZUWIuoUrIWA1rhCiFFG76yJP+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GJ6tvdFU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57399606A68B;
	Wed, 25 Nov 2026 16:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GJ6tvdFU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0C7E1F000F4;
	Wed, 25 Nov 2026 16:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624790;
	bh=JfpPs61rwgoB9TrHFYZcEbGuwwH+z4nppxgphp8e34Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GJ6tvdFUdt+e2zxq1knTrDooPXTpbwrTpv38vD04RcwYGMbryw0+g6bi3WeegmchJ
	 4oW2CmX/Sje44EOsG6MmJvxojOtnQsHC4Zel/2J1bAUj+wBZGSn6FjxSspjSNbYvG/
	 SxERnuw04f/N3EwTdRyN21vonWuQwwuoBsPk9I7w=
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
Subject: [PATCH 6.12 307/816] i40e: xsk: fix multi-buffer XDP_PASS skb construction
Date: Wed, 25 Nov 2026 15:30:55 +0100
Message-ID: <20261125143856.307601597@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4e885df789ef4..a1892373e9216 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -317,22 +317,19 @@ static struct sk_buff *i40e_construct_skb_zc(struct i40e_ring *rx_ring,
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



