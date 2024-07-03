Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7850717C238;
	Wed,  3 Jul 2024 10:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003950; cv=none; b=CUbl+IBVxyNunhsS079CclOb1hksGM2x/duNf+shvpwXP9LL4fT1u3ugHG/ddpF24PztMq6VlxbFGlVtro4w1OfEyx250DjYGCFBiSp4d9XegFa90lIjqhBtxYOmqbBz6AxElOBXtGUuTwl/JPcexGZDKk6CGYMNxXg8oM0WJhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003950; c=relaxed/simple;
	bh=mJLc6JwVjbS5GTeHQPWg9VQLYIR3yyAEdkI6iq20p40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kWXz925m4xZQG0wHED/WgNbBZSaXP6cLD5KB5IvTDgBlNTFGA0AX8ErnPLnsAZfJFdSzO0tEU4AEk1XmJtPBGpgY0+n0uO4Cq0S96wCAezB/yzxmTXrAVlhSQlcbhkJbIWco0B7rNZpwBRKhzvi84mpLXAX7bVjL9gOril6mVBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hJVgjjr9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hJVgjjr9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE961C2BD10;
	Wed,  3 Jul 2024 10:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003950;
	bh=mJLc6JwVjbS5GTeHQPWg9VQLYIR3yyAEdkI6iq20p40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hJVgjjr9otJ5rnUKf+5KkIFtG3ac6IOoYXcZ5FHqlXT6q3mPrmA3ihypNXZCatRQ6
	 dGvURmNJROGyAG4SDMpqTFPX4MhV7dOlhGaNIigEpva0LJiENBT4OImo3U5vPqvkxM
	 U6/PkQ7FzDTfyAr10wcDdchQN+wt5qUZTEg4adkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 057/189] liquidio: Adjust a NULL pointer handling path in lio_vf_rep_copy_packet
Date: Wed,  3 Jul 2024 12:38:38 +0200
Message-ID: <20240703102843.662828002@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index f3f2e71431acb..07334f83ccfe3 100644
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



