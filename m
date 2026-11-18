Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028322;
	b=UeorCB5fRu0ySUaf/4FPSxfXKT1iVEFM2/j+QJ3LrdnoRTIURMoP0aoTMac7hnip5hcJ
	 B6APBUPG/0CPV9817g7n7TWctTTgRsRuZP1woXwmGZiR6IkexMul2gPBru4G1uB5nzHal
	 tSOIj9M6OPv4PZnnI56GmppGc2Tm5Zrq3F0HaMofGP5Oi4n0Yo74eZM0sWpRE8kE0XCFS
	 72xAA+AjpZv6M9jpOVqwkFOGRw3E3ulzd9at6MwliRVmGMQXCicNRsDxNMLnFMV8HqhbB
	 5JgoRtV8s5AeWxUOz0Na0e9UrEnO7ntoECe7utJhZGSAfhzpdXhC8H56fVMt3R+V9/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028322;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jt2NsKZibRCYksrrv7OTi1dxivLW9lOJqgxBvjkFjRI=;
	b=Wmgqh+bK5klbdVbVOnHNfG2WeYR51vJAk1x62vbehBsZRoHi/7SqRAal28u+xCFH9esE
	 wix5a6LIloRV09llSnnLWzEi7cJKwBBxdTkZl6zOnFGSauE/iwlQn9oAB8jxwqF7sQRlW
	 oBn6Z0jStk61WJjfmOTyQ3pUcQu2dbCsbn0DqMjuXj6zUviKh1oI0Th91eC8BpsOMD26O
	 TEfxzg2YzPfQJXHHTHsWo9X8rLMBfTQawEdzQ3b4K2NgYw+Gs4m4x3wXkYbNoWRMT00Do
	 jbmoYGQ9FhawAQ6n+x/UrCBXxu5utys24SlyooVL36l2NFbNm/iZW3ZlbobeM0d31aw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0GZTldRP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB7460A2612;
	Wed, 18 Nov 2026 18:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0GZTldRP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E43221F000C5;
	Wed, 18 Nov 2026 18:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028322;
	bh=jt2NsKZibRCYksrrv7OTi1dxivLW9lOJqgxBvjkFjRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0GZTldRPwYndN/TYLXij0gvAFZNqc4IXxKoVg3+IPLdCJqP7GR1ejqHuSLUnNoziE
	 PRhVE2a1vkym2cPMIzgJLng/USPtWqB2mS32Yb8EvfmBHmpGaWkl4AW1rDtXXyMETz
	 tZthcosaNiOiys2zHeXrUBXbizVYLjxVwiQ/BajU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2105/2151] eth: bnxt: free XDP frags when xdp_do_redirect() fails
Date: Wed, 18 Nov 2026 16:04:00 +0100
Message-ID: <20261118150238.378209863@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 2db8cfcf922f3..52563b9489809 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
@@ -307,6 +307,7 @@ bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr, u16 cons,
 
 		if (xdp_do_redirect(bp->dev, xdp, xdp_prog)) {
 			trace_xdp_exception(bp->dev, xdp_prog, act);
+			bnxt_xdp_buff_frags_free(rxr, xdp);
 			page_pool_recycle_direct(rxr->page_pool, page);
 			return true;
 		}
-- 
2.53.0



