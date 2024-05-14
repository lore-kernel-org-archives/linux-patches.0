Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E3C13C833;
	Tue, 14 May 2024 11:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686792; cv=none; b=Smn/0iDtXBDNJrqfpTtZH90vsImoBMiEY1xrf/Rqq0xq9DaBN3ggD9TVkTf7yKYLSfoAbJPo3wv7NBPgOtaxCUixzRaqwTpBGoPgP2G2P/8iGT/dtUzV6mSOSIy9AwUGfG2MB+jgzGBfofuX+hxMZM4YN+t+/YOeWVvNmE7wJaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686792; c=relaxed/simple;
	bh=C3Am/4bzD1PSMX0/CBZNUbzt1XAr4Jzk0HywqsHr3+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q/g9zkb9S/nHDSbi1OhCsedx1eGA6XpvSwTm4bwRJOjebz09OHYg4a1koGzJGp0QL8HxUpxAgZWb+TT7Ad7R/TPzZy1tnXYE46hGv3/sP19ynNXLXyRCm1cIWuv/SuvbGFPNobl0MTzT0nDT6QGk6QX9bbw3PQp8QJ4uIcu9jgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ziF7WRPd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ziF7WRPd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F33EC2BD10;
	Tue, 14 May 2024 11:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686791;
	bh=C3Am/4bzD1PSMX0/CBZNUbzt1XAr4Jzk0HywqsHr3+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ziF7WRPdfPPOPL2gJbiZ6WphYLSjwntwfe1EjlLagTjFJ2Qvko39Z4IBVYRQ4iBme
	 WZ8d3KRWNlhY48BYZjZmJQAVHi2d8c5HfnjJJCEoNjsjv2TEupXlERU846vxiomiP1
	 ZO+ybKWicG+sUIheZsjIuG3OExPMoilsfaWBKoqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Chapman <jchapman@katalix.com>,
	David Bauer <mail@david-bauer.net>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 16/63] net l2tp: drop flow hash on forward
Date: Tue, 14 May 2024 12:19:37 +0200
Message-ID: <20240514100948.629085293@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100948.010148088@linuxfoundation.org>
References: <20240514100948.010148088@linuxfoundation.org>
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

From: David Bauer <mail@david-bauer.net>

[ Upstream commit 42f853b42899d9b445763b55c3c8adc72be0f0e1 ]

Drop the flow-hash of the skb when forwarding to the L2TP netdev.

This avoids the L2TP qdisc from using the flow-hash from the outer
packet, which is identical for every flow within the tunnel.

This does not affect every platform but is specific for the ethernet
driver. It depends on the platform including L4 information in the
flow-hash.

One such example is the Mediatek Filogic MT798x family of networking
processors.

Fixes: d9e31d17ceba ("l2tp: Add L2TP ethernet pseudowire support")
Acked-by: James Chapman <jchapman@katalix.com>
Signed-off-by: David Bauer <mail@david-bauer.net>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20240424171110.13701-1-mail@david-bauer.net
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/l2tp/l2tp_eth.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/l2tp/l2tp_eth.c b/net/l2tp/l2tp_eth.c
index 8aadc4f3bb9e9..b0d520c8bdfd6 100644
--- a/net/l2tp/l2tp_eth.c
+++ b/net/l2tp/l2tp_eth.c
@@ -154,6 +154,9 @@ static void l2tp_eth_dev_recv(struct l2tp_session *session, struct sk_buff *skb,
 	/* checksums verified by L2TP */
 	skb->ip_summed = CHECKSUM_NONE;
 
+	/* drop outer flow-hash */
+	skb_clear_hash(skb);
+
 	skb_dst_drop(skb);
 	nf_reset(skb);
 
-- 
2.43.0



