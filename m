Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028317;
	b=w7lP9grDib+Gk95x6ynuv8BRzd4aLGPy8ulNNUoF6HoqdBPGS5R7bjVXCJkDepByH189
	 iAq6WmWGEWyYzqSpEIy2HwOHY6icpzpR8p54arZ60t3sOscR7HECj6VoUR4a1XvJxTFWg
	 fzHgdW88Hck4/WnIotugppmmCPvBXDi+V1MCNXpPND2DYThCMfuaH79MqUcYX2LecoK9L
	 1w9emXr2Mo222abpT+nITFa3vNy7BG7l0LNoJE36y8dh1x1tWbhbZz8E0jOXDdSCDQXTn
	 1kIR+ST8Y/b+KUhRGKpSKs34eytwZr5r/3Js9F1gveZRCmT8EbQ8Td1fJVhA2kRcjpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028317;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RLLukXZokpPLo3O1Bp1MSL3ujYw5hkhELeF4bZ6VJps=;
	b=fb71OjNB5ekQHCm+InM7CiUfsbL4jcC9oREOyKA4xHByTXDeF6IprbC+XD/Z5xKMUE30
	 0L6eMqOC011+OtOelMhyrQiAEX9ipbl4UbfHIfRHMP8frpWQijrHdaRE/Qt2XHZ/Bw73H
	 k8RK4W0c4K0PFHu/9zHDaS9P/QUSlPoCjKcK3jzL8B20e+3eyWatXT2DZ0xwqL4gUyDif
	 Jc6r0q8WYXwqB17KcXmYkUbfZFmB/jmCTvDN6ccytRw4jDmoLnfkq07MjGARCFioEgMdP
	 osDVvARrLgci5/nkNLb/rxvJIRKgsad9BvyM9EBMK0pHVRbO0TiLXNKEhqSIIh82ndg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="dlXQjY/q";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 368AD60A260D;
	Wed, 18 Nov 2026 18:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dlXQjY/q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5407A1F000CA;
	Wed, 18 Nov 2026 18:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028316;
	bh=RLLukXZokpPLo3O1Bp1MSL3ujYw5hkhELeF4bZ6VJps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dlXQjY/qUmeP7IOZvyUZlwo+8/7s7VwypKFHtDHDsmdrkZnjtfRfEvKSufXRhpUVa
	 13I6Edw0XP4EWsuoGSB+6kshBen90xt0FEvJ0tM5zQYyyBAA59JU9VyQkTRK61vymH
	 W87jLIAKQsheXOGrHXORJLUHPoM6DjUwNoC7m/R4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2103/2151] eth: bnxt: resize Rx head buffers when rx-copybreak changes
Date: Wed, 18 Nov 2026 16:03:58 +0100
Message-ID: <20261118150238.305955139@linuxfoundation.org>
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
index 2dc9708fb63f6..8181d1bdca028 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -4445,6 +4445,7 @@ static int bnxt_set_tunable(struct net_device *dev,
 			if (netif_running(dev))
 				return -EBUSY;
 			bp->rx_copybreak = rx_copybreak;
+			bnxt_set_ring_params(bp);
 		}
 		return 0;
 	case ETHTOOL_PFC_PREVENTION_TOUT:
-- 
2.53.0



