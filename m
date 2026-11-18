Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022308;
	b=HQ19p1563q9+ir1tW82+AEbsr0dit8ZVgYqQRHmgf1wRHEaP/or7UShm5CUu83zc/hBM
	 6gKEJXyLzGIGQn62Lc3rsJIlyMMT/60cuzb4Xv4amNRu+X06y+O2ZveiGESXtGhKuk3jH
	 8mZ+ZGcMLJkxkb+DBVlmUENNV3IaXC8+WrtbXKILdmZkvzf2Gbxi3iTa3289zWOn2KzHD
	 yQXfGrAZHZ0a7g+xHdUsOH3BP7llJXRHbiuX0ern/csJqTjImtmYn6jZO9QUo4y0yunOT
	 Q0wM5Pa5ZnyGr6E0iY7mMduDIj/jHhTez2PpenmVeKRIlsngeoI8NzOJeYXnQL7pKmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022308;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tL4ljBRIz5yAkv05jLczSC/Krm1r5xm4hi4x660UdmA=;
	b=NCowP6dYO53F5koa1BauRiBOH4r4bWH7u9Dg5XbXYTRKwD7lRCNO4wXMTF9ozHAoOxgG
	 5Vy0Kdm2jTsoPEnPNwXLCHTo6byuhlDCwC4VP30m/04o8t8tN1Gu+nHa1tkXYCR1HGrTw
	 PSwULx9YvUXND4FGCPfa7gEr76kB4qZE442nS/8+Ym0+hILHQPrrS9546tZ3SWNtzwyp5
	 uWFIyT3L4iK9Smg6k0tvV424UmwmD9fVkFKSP5pReo4K2HPGdC63/WE4wwoEvBeJwlmd3
	 gN6RgKYFPgylQFh3GcUIT43pQcB47AGvHwxBZT95zOUC3/ktFaO1t6zXj8x3Kp3mTog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I4N2eZnA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D61606A31C;
	Wed, 18 Nov 2026 17:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I4N2eZnA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2012C1F000C4;
	Wed, 18 Nov 2026 17:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022308;
	bh=tL4ljBRIz5yAkv05jLczSC/Krm1r5xm4hi4x660UdmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I4N2eZnAGtLNMA4Ggl+heDt9SZ+vqzQYaJhPVzZeAGPnHwdbHYYw5nFwaf6MM+seZ
	 22uVL+WHihG7w17W2ys9A6YvKn4ogpEw4QpVlNcic7EwObP8j6VBWSYEPaBXNPA7xc
	 itXSiqIHuDT9EQ+yEX1mlTEIO2gUij1WlyLEURW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2615/2651] eth: bnxt: resize Rx head buffers when rx-copybreak changes
Date: Wed, 18 Nov 2026 16:04:15 +0100
Message-ID: <20261118150418.380976878@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 09f10efee6f93863ea71489ce84563f4d51787f6 ]

Since rx-copybreak became configurable, bnxt_set_ring_params() sizes
the head buffers to fit at least rx_copybreak bytes, and the copybreak
path in bnxt_copy_data() syncs rx_copybreak bytes of the head buffer.
bnxt_set_tunable() however only updates bp->rx_copybreak, and nothing
on the open path recalculates the ring parameters. After raising
rx-copybreak the head buffers keep their old size until some other
setting changes, and bnxt_copy_data() syncs past their end, into the
next buffer in the page or past the end of the page:

  DMA-API: bnxt_en 0000:01:00.0: device driver tries to sync DMA memory it has not allocated [device address=0x00000002aa210c40] [size=1024 bytes]
  WARNING: kernel/dma/debug.c:1162 at check_sync+0x577/0x1eb0, CPU#22: swapper/22/0
  Call Trace:
   <IRQ>
   debug_dma_sync_single_for_cpu+0x66/0x90
   bnxt_copy_data+0x12f/0x290
   bnxt_rx_pkt+0x24ea/0x50f0
   __bnxt_poll_work+0x42c/0xc00
   bnxt_poll_p5+0x579/0x17a0
   __napi_poll+0x8b/0x2c0
   net_rx_action+0x58f/0xbb0

Here the head buffers were still sized for the 640B HDS threshold,
four 1kB buffers per page, while rx-copybreak was raised to 1024.
Without coherent DMA or with swiotlb the oversized sync can corrupt
a neighboring buffer owned by the device or by an skb.

The device must be down for rx-copybreak to change, so recalculate the
ring parameters right away, like bnxt_set_ringparam() does.

Hit while testing patch 1, tested on BCM57504 - boot; set rx-copybreak
to 1024 with the link down (CONFIG_DMA_API_DEBUG); ifup.

Fixes: 152f4da05aee ("bnxt_en: add support for rx-copybreak ethtool command")
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20261027234940.1267225-3-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 622e89587e5db..ef4bea4a0f8cc 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -4601,6 +4601,7 @@ static int bnxt_set_tunable(struct net_device *dev,
 			if (netif_running(dev))
 				return -EBUSY;
 			bp->rx_copybreak = rx_copybreak;
+			bnxt_set_ring_params(bp);
 		}
 		return 0;
 	case ETHTOOL_PFC_PREVENTION_TOUT:
-- 
2.53.0



