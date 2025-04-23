Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE9F28134C;
	Wed, 23 Apr 2025 14:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419710; cv=none; b=bErLR6sqbk1XAt4knuJff9aEQOHkGyq42AzEShjpivkM8ueq94paD3cd1K3pgRRb4CyfGqKwUO5/xs9+8bU+xpsVg/beX0wF0xpdQCWXH6kmPkCrGetI4N7dZ6V2J2RW8R/d9IQIPze0G01CsdU/q7FilFyteYmTkH2ineNzd+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419710; c=relaxed/simple;
	bh=n2WiBPdErB05xkyu+MfAFo1k8IIpSd5/aLmlmRIqh9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b/UiUW94VzbwpCFBLY3SLAwEXAilxhoT3N7QNUB1ZOG1eAsoK2iwAnE1uuO6qE4beoyDe2uOoBAqqxkSl7BfdKsK5jave80QYXaDXmSkAGNypGHG1CYg+nPNJOGo7ECJ1KVTXxK3vRTALUMEOzCVPZIFKV5kcNO6jveGQT+O9y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rWdDyei6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rWdDyei6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19B7CC4CEE2;
	Wed, 23 Apr 2025 14:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419710;
	bh=n2WiBPdErB05xkyu+MfAFo1k8IIpSd5/aLmlmRIqh9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rWdDyei6lxXDyeWp6ll6HIW4maF75kjfHY88ac3nWnHJfWuRyN1QweSQ1TLZs1k9k
	 o0CnwLRATGfjJpqKWTY6MCpNYd3nBpg37KZEjOEXb5uAuk1RxQdthq85o7n5pnx+58
	 rpLmeqZnGZoHILIWmx2gmoLp4WTtaWD4Zi01U2rw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weizhao Ouyang <o451686892@gmail.com>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 048/223] can: rockchip_canfd: fix broken quirks checks
Date: Wed, 23 Apr 2025 16:42:00 +0200
Message-ID: <20250423142619.090464799@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weizhao Ouyang <o451686892@gmail.com>

[ Upstream commit 6315d93541f8a5f77c5ef5c4f25233e66d189603 ]

First get the devtype_data then check quirks.

Fixes: bbdffb341498 ("can: rockchip_canfd: add quirk for broken CAN-FD support")
Signed-off-by: Weizhao Ouyang <o451686892@gmail.com>
Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://patch.msgid.link/20250324114416.10160-1-o451686892@gmail.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/rockchip/rockchip_canfd-core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/rockchip/rockchip_canfd-core.c b/drivers/net/can/rockchip/rockchip_canfd-core.c
index d9a937ba126c3..ac514766d431c 100644
--- a/drivers/net/can/rockchip/rockchip_canfd-core.c
+++ b/drivers/net/can/rockchip/rockchip_canfd-core.c
@@ -907,15 +907,16 @@ static int rkcanfd_probe(struct platform_device *pdev)
 	priv->can.data_bittiming_const = &rkcanfd_data_bittiming_const;
 	priv->can.ctrlmode_supported = CAN_CTRLMODE_LOOPBACK |
 		CAN_CTRLMODE_BERR_REPORTING;
-	if (!(priv->devtype_data.quirks & RKCANFD_QUIRK_CANFD_BROKEN))
-		priv->can.ctrlmode_supported |= CAN_CTRLMODE_FD;
 	priv->can.do_set_mode = rkcanfd_set_mode;
 	priv->can.do_get_berr_counter = rkcanfd_get_berr_counter;
 	priv->ndev = ndev;
 
 	match = device_get_match_data(&pdev->dev);
-	if (match)
+	if (match) {
 		priv->devtype_data = *(struct rkcanfd_devtype_data *)match;
+		if (!(priv->devtype_data.quirks & RKCANFD_QUIRK_CANFD_BROKEN))
+			priv->can.ctrlmode_supported |= CAN_CTRLMODE_FD;
+	}
 
 	err = can_rx_offload_add_manual(ndev, &priv->offload,
 					RKCANFD_NAPI_WEIGHT);
-- 
2.39.5



