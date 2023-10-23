Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A225315EA5
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PAZ1ni9Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C77BC433C9;
	Mon, 23 Oct 2023 11:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698061343;
	bh=xZUqhsoRCu/dB6gCK7DGBobwx/eMSRalt9P4WMvhjTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PAZ1ni9QJOeRnstgxcQOQSmmb03T8YVJ+KEqCN6sOjgOoLUM74tyhY17sWuqb2V6p
	 E2QUJPo/r2r36lX5p8ELTbjfCRHIdKuR+RzBqDWPEUPWBuIG8j39H/yCh+tF8kLUe3
	 9h7KfMMXIqI86BDXv//s0QVnbge19kd+47DWnBH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
	Ross Lagerwall <ross.lagerwall@citrix.com>,
	Wei Liu <wei.liu@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 016/202] xen-netback: use default TX queue size for vifs
Date: Mon, 23 Oct 2023 12:55:23 +0200
Message-ID: <20231023104827.083254773@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104826.569169691@linuxfoundation.org>
References: <20231023104826.569169691@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/net/xen-netback/interface.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -41,7 +41,6 @@
 #include <asm/xen/hypercall.h>
 #include <xen/balloon.h>
 
-#define XENVIF_QUEUE_LENGTH 32
 #define XENVIF_NAPI_WEIGHT  64
 
 /* Number of bytes allowed on the internal guest Rx queue. */
@@ -528,8 +527,6 @@ struct xenvif *xenvif_alloc(struct devic
 	dev->features = dev->hw_features | NETIF_F_RXCSUM;
 	dev->ethtool_ops = &xenvif_ethtool_ops;
 
-	dev->tx_queue_len = XENVIF_QUEUE_LENGTH;
-
 	dev->min_mtu = ETH_MIN_MTU;
 	dev->max_mtu = ETH_MAX_MTU - VLAN_ETH_HLEN;
 


