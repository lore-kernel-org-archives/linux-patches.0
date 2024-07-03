Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 832BC17FAB8;
	Wed,  3 Jul 2024 11:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005496; cv=none; b=HdDEBiNemVYN338x68mAwUl9cMJ7r9iKSV8pwTiJ0vH9SpmPSt1fSulY081yonW8rxLayXXRriLMXJo5i4thfkLqDfPdAn3boGSCJnVJVYtezS9dvVyDwZSqw2WADwQ4/P2BDqr/BEXJZHbX7acRFl/IzYtB/Pg0r3XbeQ6oyl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005496; c=relaxed/simple;
	bh=anx8VRZQTa3ja4KC5vlhF0GisHlFkdIrWG3Omg2hpKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ncSKQB+/zjCybMGXMGsv1+7uxFPMEJ2ViDNykvXZMB8Aaj/qf8FipPZDY80JY6wn7Gj3Tk7MVPXjjOdd2Hd80tyPOo7x5ifZeC07Iha54vskPrFeHg+pFe0rvUfa7FrM1N1GFVtnQmi4o2a18Fxe4YsdKABEpwcSZ5xwEBMwWUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pCZHaQWU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pCZHaQWU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0581DC2BD10;
	Wed,  3 Jul 2024 11:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005496;
	bh=anx8VRZQTa3ja4KC5vlhF0GisHlFkdIrWG3Omg2hpKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pCZHaQWUoypI4jOemJo0EzqQKGtmeaZfzDofM9j5/tU3UIxa58xhVHwyKYnaTWeje
	 cvYSVoHc9yr+jaDmRxlHJ0iB7+txnBuq4lsP6FA5EOiH74EpeVj9K73WIm3L2pzjWQ
	 0XUXxGZ8SCn3+XKF8Oj8lKqfH64PUOKjOf0fgo44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 100/356] liquidio: Adjust a NULL pointer handling path in lio_vf_rep_copy_packet
Date: Wed,  3 Jul 2024 12:37:16 +0200
Message-ID: <20240703102916.886201117@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

From: Aleksandr Mishin <amishin@t-argos.ru>

[ Upstream commit c44711b78608c98a3e6b49ce91678cd0917d5349 ]

In lio_vf_rep_copy_packet() pg_info->page is compared to a NULL value,
but then it is unconditionally passed to skb_add_rx_frag() which looks
strange and could lead to null pointer dereference.

lio_vf_rep_copy_packet() call trace looks like:
	octeon_droq_process_packets
	 octeon_droq_fast_process_packets
	  octeon_droq_dispatch_pkt
	   octeon_create_recv_info
	    ...search in the dispatch_list...
	     ->disp_fn(rdisp->rinfo, ...)
	      lio_vf_rep_pkt_recv(struct octeon_recv_info *recv_info, ...)
In this path there is no code which sets pg_info->page to NULL.
So this check looks unneeded and doesn't solve potential problem.
But I guess the author had reason to add a check and I have no such card
and can't do real test.
In addition, the code in the function liquidio_push_packet() in
liquidio/lio_core.c does exactly the same.

Based on this, I consider the most acceptable compromise solution to
adjust this issue by moving skb_add_rx_frag() into conditional scope.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 1f233f327913 ("liquidio: switchdev support for LiquidIO NIC")
Signed-off-by: Aleksandr Mishin <amishin@t-argos.ru>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c b/drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c
index 600de587d7a98..e70b9ccca380e 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c
@@ -272,13 +272,12 @@ lio_vf_rep_copy_packet(struct octeon_device *oct,
 				pg_info->page_offset;
 			memcpy(skb->data, va, MIN_SKB_SIZE);
 			skb_put(skb, MIN_SKB_SIZE);
+			skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
+					pg_info->page,
+					pg_info->page_offset + MIN_SKB_SIZE,
+					len - MIN_SKB_SIZE,
+					LIO_RXBUFFER_SZ);
 		}
-
-		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
-				pg_info->page,
-				pg_info->page_offset + MIN_SKB_SIZE,
-				len - MIN_SKB_SIZE,
-				LIO_RXBUFFER_SZ);
 	} else {
 		struct octeon_skb_page_info *pg_info =
 			((struct octeon_skb_page_info *)(skb->cb));
-- 
2.43.0



