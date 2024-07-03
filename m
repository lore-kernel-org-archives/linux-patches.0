Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0BA5173326;
	Wed,  3 Jul 2024 10:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003403; cv=none; b=NzErGO5ksA9JkvhdAVtxJnHAfPtIuWawOV8T5pDA42zE2cetCq9jMPloAw5vde9vyHhK3hcmAFo825uHXA9a+xD0dT1fXEXpKg+i7xOC/Zte/dA79AzJZxO4c7i/FW43pljVSFMpC6Sriro33wAranzmBX9GFY0ewpmnyAt0FRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003403; c=relaxed/simple;
	bh=3m4R4KpJwSUJVsuSDqqsi56NGxooyOJ/xa5YbZVnMf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MZ+Igivu9wEllKd/aHs4lg3O8Hgb/xM04SE3Lig4yCRPvr5jgDQr+S7Mc1YXwNStmK+fvmV70wcmfkS4PIhoHDfIWOeDxVchHyQflvgHAb0uYPAffyuFlJcT6McnQQRQ+smvrxUt730AL3hzNWSe3JID01uanNafEAsBm1jWf/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AT2tDSY4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AT2tDSY4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 660A9C4AF0A;
	Wed,  3 Jul 2024 10:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003402;
	bh=3m4R4KpJwSUJVsuSDqqsi56NGxooyOJ/xa5YbZVnMf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AT2tDSY4wDy6hpPdeoO0RUJsbR4GkdjFfER6JnweD4nIuTsBmcRMLd/ftm5GgMb+a
	 llveISui6VUTkk0lXdF1GkVVS0CMPkFXe2ESCQE8O72K0LkwQiJYktzIs1toM/WRf+
	 fgCwngSjXUVVLcB24Rv4yrAKABtlUM0dISrInOK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 038/139] liquidio: Adjust a NULL pointer handling path in lio_vf_rep_copy_packet
Date: Wed,  3 Jul 2024 12:38:55 +0200
Message-ID: <20240703102831.876561668@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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
index a1bda1683ebfc..d90500573f5b7 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c
@@ -289,13 +289,12 @@ lio_vf_rep_copy_packet(struct octeon_device *oct,
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



