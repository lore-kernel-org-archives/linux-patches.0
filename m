Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE451D0164;
	Wed,  2 Oct 2024 13:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876565; cv=none; b=rFxsIAZNbrunG5+YY0jPVbY18DmnTyrGKQxU1RVpCihnivBt+wWsNoH0klKiBcMTZYhg4dUl5DSqeJyIyf/LUKvemKXs20Vwwy23XZO5BG3ZF+HYmhWnLjkh7RpaQosGy1IwlB7QK+JW3tQsqajw9dURoigTtVjeNI9SBeK1qBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876565; c=relaxed/simple;
	bh=d9YyE1ZsMqSKQ28BRMBpM2sZm6+AAHJfeHxud3y4mfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p50wJZpcAFjsKoxWbMRYzNSKsPjGvZToo/C3pSapvA2N6L0acrcfeCL1SkERVpwL9d20d0qFUkVVaqybpNdEyI+ov3vJoafcLwtJhU4tWzbiimhOwclM1WsmlpM5EYzoUInReP4eG/SqpyAV7F/84adsAL5FTnAsfSydUbWBYvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=09xfJDO7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="09xfJDO7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0516FC4CEC5;
	Wed,  2 Oct 2024 13:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876565;
	bh=d9YyE1ZsMqSKQ28BRMBpM2sZm6+AAHJfeHxud3y4mfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=09xfJDO7jzqvkRIy6hhqpn0Z2WztniUUfK30rXhQyAE10o6/q/BLpOv6VkSwDn2DH
	 G3kxEaKJWcWfj53pbieJl8s7uRUbKOFcm4LgvmPSg4zObnY95bL9Cd40R9Ugi9Hs2T
	 M9C9NTmTA6GKy6klvGep3OAoVrTgXViT+7og/fJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Paul Barker <paul.barker.ct@bp.renesas.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 486/695] net: ravb: Fix R-Car RX frame size limit
Date: Wed,  2 Oct 2024 14:58:04 +0200
Message-ID: <20241002125841.868584957@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Barker <paul.barker.ct@bp.renesas.com>

[ Upstream commit ec8234717db8589078d08b17efa528a235c61f4f ]

The RX frame size limit should not be based on the current MTU setting.
Instead it should be based on the hardware capabilities.

While we're here, improve the description of the receive frame length
setting as suggested by Niklas.

Fixes: c156633f1353 ("Renesas Ethernet AVB driver proper")
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Signed-off-by: Paul Barker <paul.barker.ct@bp.renesas.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/ravb_main.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 471a68b0146ed..6b82df11fe8d0 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -555,8 +555,16 @@ static void ravb_emac_init_gbeth(struct net_device *ndev)
 
 static void ravb_emac_init_rcar(struct net_device *ndev)
 {
-	/* Receive frame limit set register */
-	ravb_write(ndev, ndev->mtu + ETH_HLEN + VLAN_HLEN + ETH_FCS_LEN, RFLR);
+	struct ravb_private *priv = netdev_priv(ndev);
+
+	/* Set receive frame length
+	 *
+	 * The length set here describes the frame from the destination address
+	 * up to and including the CRC data. However only the frame data,
+	 * excluding the CRC, are transferred to memory. To allow for the
+	 * largest frames add the CRC length to the maximum Rx descriptor size.
+	 */
+	ravb_write(ndev, priv->info->rx_max_frame_size + ETH_FCS_LEN, RFLR);
 
 	/* EMAC Mode: PAUSE prohibition; Duplex; RX Checksum; TX; RX */
 	ravb_write(ndev, ECMR_ZPF | ECMR_DM |
-- 
2.43.0



