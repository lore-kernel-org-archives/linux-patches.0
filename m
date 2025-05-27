Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 045CF27FB3D;
	Tue, 27 May 2025 17:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368546; cv=none; b=VsvySgY+C7iUXv5UX2aOHbMxZGAHDW5P/kQ3HcfJMr2GdFpGI0KFovv7CzzBjgy5VvfrMGEN3Jhoa3hR7rCbUlrCvvPOwLFV7TwutWZdtoXI0i6SD2c9GhFUG7SL1jToMR5MyKdo6MZV8pVfaOI379xwOg1iVs1kcisZCTR1YO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368546; c=relaxed/simple;
	bh=cLAD6gHjkwSqydvMjDeqGhNU+o3gmfJz2ePnhPThhKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IzXdSvSl3kO0ofhR3JBJLrvkSnankSAC6zLOwJNk2y6CL2TgFOX/7z9WMUOU6YTp7MlrT4QH+F58DzRZLe9bMAPzxrkqCeBdBtlTa98CeMEX1C8DJiB4OQqbHhrvtWjV/n3M2idcOdKAggjvVruaqcwRYvcR7u9JrGsTpZC+LrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eYBfYBZH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eYBfYBZH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88B8CC4CEE9;
	Tue, 27 May 2025 17:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368545;
	bh=cLAD6gHjkwSqydvMjDeqGhNU+o3gmfJz2ePnhPThhKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eYBfYBZHYWoAfQ26/PrDgTkOAng+kcdDaL1JtYcASDo64NVoz0Enpd2asvF7gN4Or
	 Qk4PjlmRdnw9+tNqKfJuIps6BOdrCCsoHXJc+D98jeyl0eIONjtJ6of2p6UVZdaG53
	 Ng1Lskv4/p5UBc7gIW8kKvtlBiDovSHR8sPy/zUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 710/783] xsk: Bring back busy polling support in XDP_COPY
Date: Tue, 27 May 2025 18:28:27 +0200
Message-ID: <20250527162542.028792137@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samiullah Khawaja <skhawaja@google.com>

[ Upstream commit b95ed5517354a5f451fb9b3771776ca4c0b65ac3 ]

Commit 5ef44b3cb43b ("xsk: Bring back busy polling support") fixed the
busy polling support in xsk for XDP_ZEROCOPY after it was broken in
commit 86e25f40aa1e ("net: napi: Add napi_config"). The busy polling
support with XDP_COPY remained broken since the napi_id setup in
xsk_rcv_check was removed.

Bring back the setup of napi_id for XDP_COPY so socket level SO_BUSYPOLL
can be used to poll the underlying napi.

Do the setup of napi_id for XDP_COPY in xsk_bind, as it is done
currently for XDP_ZEROCOPY. The setup of napi_id for XDP_COPY in
xsk_bind is safe because xsk_rcv_check checks that the rx queue at which
the packet arrives is equal to the queue_id that was supplied in bind.
This is done for both XDP_COPY and XDP_ZEROCOPY mode.

Tested using AF_XDP support in virtio-net by running the xsk_rr AF_XDP
benchmarking tool shared here:
https://lore.kernel.org/all/20250320163523.3501305-1-skhawaja@google.com/T/

Enabled socket busy polling using following commands in qemu,

```
sudo ethtool -L eth0 combined 1
echo 400 | sudo tee /proc/sys/net/core/busy_read
echo 100 | sudo tee /sys/class/net/eth0/napi_defer_hard_irqs
echo 15000   | sudo tee /sys/class/net/eth0/gro_flush_timeout
```

Fixes: 5ef44b3cb43b ("xsk: Bring back busy polling support")
Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xdp/xsk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index c13e13fa79fc0..dc67870b76122 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -1301,7 +1301,7 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 	xs->queue_id = qid;
 	xp_add_xsk(xs->pool, xs);
 
-	if (xs->zc && qid < dev->real_num_rx_queues) {
+	if (qid < dev->real_num_rx_queues) {
 		struct netdev_rx_queue *rxq;
 
 		rxq = __netif_get_rx_queue(dev, qid);
-- 
2.39.5



