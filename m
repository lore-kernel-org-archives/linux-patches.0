Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050736;
	b=zFoVdTry53dLy/3jCCkTkHf5x+L+YSKS2T+IQCBlNsUY0hOUM2lMGo3+loR46+u0TbGq
	 PzWOXVTe3h9p6B7ZaFW5zUPnzeCg8VRUPmp7J8kvXdIqLJay/QYG5wXXvmt9UrR7EJrTn
	 MMvRJugaTduWECy3dyr1OLIzdmuf8DSJdMjSFz2Ely9HsJr4zNLLIUqDX11elNu9Lc9i0
	 3oyj1LQmW9QB5MUF+op8wETm4vwQiqmooet4/DxHpuZy6cEzUokGRT8WuFIeQfRkJMeTy
	 DNZfRhDobDV9fxU5AvUrx9FbOIfD6m2jSFgeSfNRr1wBhH/Pkrs4GdKngHnSTfXysMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050736;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RMsC3R9PH4JrO1/2agaNNl6qHfbj3TrThXIwyHGotnw=;
	b=YWsn1CaNKLt2bJmhEYWhNAkHARH+axFh1JdIHPwnkwjCUhR7oBQ/4/d++ywx6xfS+Xae
	 gOO9GzMUZ7FKVSfuYxLGfID32U0owTiu8WP0vR5+RU3+i1qLQrAkyUgdyGbsvFiwkQGXK
	 jL+EJ4IO377jA4jfKm4TA3cqQnQ40SoTQ17l65VmyOe+ekyQ4psaSebG4okF3GXel8bZ/
	 Jg9rNnGkMNH07ApX/uyBJHGIR5bvKPLF5tH3Lh1EqjqLfWlqp38xZyfT5YHTzCd7ufKaj
	 w9/uNrVY0/w5vtRam4N6JB+djMAbyiEvdfqvfPkdTEb4n1g8dBz8wsIxotOj6WNiDVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G4sIRsIE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3682606A320;
	Thu, 19 Nov 2026 01:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G4sIRsIE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFC461F000C4;
	Thu, 19 Nov 2026 01:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050736;
	bh=RMsC3R9PH4JrO1/2agaNNl6qHfbj3TrThXIwyHGotnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G4sIRsIEaiCTN863w4TuCzRGuJIb+0eKyOpshMIml55AdZbOX/MkfoxisMaBAjXLk
	 QR8dqp1gHxlKvZRbNz6dpiIvQdcFz9k4OMvpVcxSczjI/9lE/hJFrGo1PgmG6h3MSM
	 grjolT9b2UFTmrWLAqTHSrdgGZhPLCoIdSpZq6D4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2815/2857] eth: bnxt: free XDP frags when xdp_do_redirect() fails
Date: Wed, 18 Nov 2026 16:04:09 +0100
Message-ID: <20261118150342.961388041@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c68b5b045f300..95f620991ec78 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
@@ -310,6 +310,7 @@ bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr, u16 cons,
 
 		if (xdp_do_redirect(bp->dev, xdp, xdp_prog)) {
 			trace_xdp_exception(bp->dev, xdp_prog, act);
+			bnxt_xdp_buff_frags_free(rxr, xdp);
 			page_pool_recycle_direct(rxr->page_pool, page);
 			return true;
 		}
-- 
2.53.0



