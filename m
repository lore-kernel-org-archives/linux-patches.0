Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033354;
	b=Is05TuCgtIH5ZCbXvtBbQzPFt1fEoD7uaht6de5IcbZF+4Gcaf9av/1cmWDat4XtB0Bl
	 PbSp6SU8i8OpCuWzYqFETrigSn2duH1tr42vXpIdZncUbDCt/t8Q5WHpN9AkX4EA8aRSh
	 myqy2dIxFGtZZ6ihsZtfns8iCwQqHqNi9rerUAx/oOTXfIF+9W5ukC12qgv71fy31HcJh
	 yrtSYKEqABfxGdD1lGqUi2XM20ELtQDL/Y4UpTio6LDeItJjnRuHl6Kr0jjxpjRHfcxnv
	 j8JWPINqnDsjf0XVqzmmhk/pr6vpKmfKAIYmY0sctV94Uqp50H4juOTw33TVbgJxBgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033354;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qzC6qB/XiWQPOjYR51qvCcYRGfxDHbBCz8xwynZh+z4=;
	b=Cxud/RdWi0BVupPNgDBbapZ1mNmrfXwkHmD24img1p55XFSaizn8CLE+NajrM1le2oMp
	 OFjUbnw6MtiqSvTxcObfaR0nKXQdgLvX2s4FYImUoBejvJTfQ1GBxLYnBVx4pCZYOOS+6
	 x4aP7+mSCA0wo/m++L0+r1w1De1y668Odfk8wT3624ka4exae6a8SDxiPO593skuM0MpV
	 rx+q0xHeYDxhORJlpvDWffaJI9Sw6qklgOx6bS9yR+lNA55UkrO/KjWk/8AKcPnq62WTD
	 Vy2qWyYJsR22f2QikcRJCYd/kZrjUVHsn+TYpK2sSE3tvDIGv3myOo5qYb+O1nAIXwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NzkZl1P0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE25606A31C;
	Wed, 18 Nov 2026 20:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NzkZl1P0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 831751F000C4;
	Wed, 18 Nov 2026 20:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033354;
	bh=qzC6qB/XiWQPOjYR51qvCcYRGfxDHbBCz8xwynZh+z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NzkZl1P0BuepzxljUfRgNdNb8A/HCnOEyPlUbOab9PgJX7n+gIvEKznj+g7zWP1wU
	 rmPAsXeQ0wiDxS6JX5ZYgrf7N1rUNhZWzk313y9zj9aZVORbdz4ZNLEDupIWhMHcUr
	 Dypndk5e5nbOLPY12gyN557a3rQ2/7KLP4OjR9IU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1696/1756] eth: bnxt: free XDP frags when xdp_do_redirect() fails
Date: Wed, 18 Nov 2026 16:03:43 +0100
Message-ID: <20261118150117.181985850@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit c10f3420d59859df107838aa97b49357616d9b47 ]

When xdp_do_redirect() fails bnxt_rx_xdp() recycles the head page but
not the frags of a multi-buffer frame. Their agg ring slots have
already been refilled, so the pages leak, and the page pool can't be
destroyed until they are returned, which will never happen. Redirect
to an AF_XDP socket in copy mode fails this way with -ENOMEM whenever
the socket's fill ring runs out of buffers.
A socket bound without XDP_USE_SG also fails with -ENOSPC for every
frame that doesn't fit in a single chunk.

All the other drop paths in this function free the frags.

Pointed out in LLM review of the first patch of the series.
Tested on a BCM57504 at MTU 9000 by redirecting 60k 8000B ICMPv6
echo requests (a head and two agg buffers each) to lo, which can't
transmit XDP frames. The page pools' inflight count stayed flat
rather than growing by two pages per frame.

Fixes: a7559bc8c17c ("bnxt: support transmit and free of aggregation buffers")
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20261027234940.1267225-5-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
index fcdffdc3ffa8c..0512b61c2cf69 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
@@ -306,6 +306,7 @@ bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr, u16 cons,
 
 		if (xdp_do_redirect(bp->dev, xdp, xdp_prog)) {
 			trace_xdp_exception(bp->dev, xdp_prog, act);
+			bnxt_xdp_buff_frags_free(rxr, xdp);
 			page_pool_recycle_direct(rxr->page_pool, page);
 			return true;
 		}
-- 
2.53.0



