Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A316014288
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HgSqBzGe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E50A7C433C8;
	Mon, 16 Oct 2023 14:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697467777;
	bh=MrSsbie/OoQuMS+d/3res83Ya324GUfHWotMr6T61z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HgSqBzGeY3wj6pmW9uuT0euek+F8L1kXXyBsoFLPUiEeexk3Owvdyuk1vhd8JZ2fI
	 sUmSsAD8pdSiE+NVgN75y1EQyb395DpL5+Zmj+VQM0HbLF8vjXYmXYB2jey+CFb8W8
	 YhO/ijZO87pWq5p/uFflRG/tJDUlvsyaJG0uiwTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
	Ross Lagerwall <ross.lagerwall@citrix.com>,
	Wei Liu <wei.liu@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 064/191] xen-netback: use default TX queue size for vifs
Date: Mon, 16 Oct 2023 10:40:49 +0200
Message-ID: <20231016084016.893631037@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roger Pau Monne <roger.pau@citrix.com>

[ Upstream commit 66cf7435a26917c0c4d6245ad9137e7606e84fdf ]

Do not set netback interfaces (vifs) default TX queue size to the ring size.
The TX queue size is not related to the ring size, and using the ring size (32)
as the queue size can lead to packet drops.  Note the TX side of the vif
interface in the netback domain is the one receiving packets to be injected
to the guest.

Do not explicitly set the TX queue length to any value when creating the
interface, and instead use the system default.  Note that the queue length can
also be adjusted at runtime.

Fixes: f942dc2552b8 ('xen network backend driver')
Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Reviewed-by: Ross Lagerwall <ross.lagerwall@citrix.com>
Acked-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/xen-netback/interface.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
index f3f2c07423a6a..fc3bb63b9ac3e 100644
--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -41,8 +41,6 @@
 #include <asm/xen/hypercall.h>
 #include <xen/balloon.h>
 
-#define XENVIF_QUEUE_LENGTH 32
-
 /* Number of bytes allowed on the internal guest Rx queue. */
 #define XENVIF_RX_QUEUE_BYTES (XEN_NETIF_RX_RING_SIZE/2 * PAGE_SIZE)
 
@@ -530,8 +528,6 @@ struct xenvif *xenvif_alloc(struct device *parent, domid_t domid,
 	dev->features = dev->hw_features | NETIF_F_RXCSUM;
 	dev->ethtool_ops = &xenvif_ethtool_ops;
 
-	dev->tx_queue_len = XENVIF_QUEUE_LENGTH;
-
 	dev->min_mtu = ETH_MIN_MTU;
 	dev->max_mtu = ETH_MAX_MTU - VLAN_ETH_HLEN;
 
-- 
2.40.1



