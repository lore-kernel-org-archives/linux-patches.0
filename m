Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE9A2580C9;
	Mon, 12 May 2025 17:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071741; cv=none; b=o/RbVOOURI53PLWGCwVPtnuiF2OK4FaDpT7zJNW2KkVSPi/sWJ4eHcgJ2v0QoD10r/dRqOVyX1Gyuhmgfs9136L6r8Luk2IbYlvgPFUmhdH6AH67r7dsiLeJFB/5fKlLD4dGsxEmQJJ8tx/jyam9zlk0kVOXBOwaRYZv7YGkWXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071741; c=relaxed/simple;
	bh=DpdWbt7g1cOxSr5hfXIZhnXHy4yw9C321umj/W3o2Tg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Npu3eBxjOGhw19+NxWz7d/98TyzKYRFSxX3x972YeyeLaF4SM8HLmCxwEEHYAdFMlHIc8NgNJ+KvrYSIJWi2MqmCK/T8VWJQHb6gAt7Cai5Rv0ipUK0LvHc5WfOsJPoF51UHxDWEEDSpzbhJcb+wGKyqxXPAvj0so4BWkXpTV4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xCd/20V5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xCd/20V5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D82C1C4CEE7;
	Mon, 12 May 2025 17:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071741;
	bh=DpdWbt7g1cOxSr5hfXIZhnXHy4yw9C321umj/W3o2Tg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xCd/20V5e/sqycqTYJAUUA5Dw/poXII2Sr7tzBjqFijDX0k8Ldkih7sApbiXnxI1i
	 25Y2e3TqqXmxw+2UDpQF4hSvQnvvhDpAW4ALUgVgfDq8QRptXAfooCYy7iRWjQOuJR
	 MV5VVxfZz0sL70zUoGS0Cqy1n71/4mPtLHM4b2nM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Schneider-Pargmann <msp@baylibre.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.14 012/197] can: rockchip_canfd: rkcanfd_remove(): fix order of unregistration calls
Date: Mon, 12 May 2025 19:37:42 +0200
Message-ID: <20250512172044.846833735@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit 037ada7a3181300218e4fd78bef6a741cfa7f808 upstream.

If a driver is removed, the driver framework invokes the driver's
remove callback. A CAN driver's remove function calls
unregister_candev(), which calls net_device_ops::ndo_stop further down
in the call stack for interfaces which are in the "up" state.

The removal of the module causes a warning, as can_rx_offload_del()
deletes the NAPI, while it is still active, because the interface is
still up.

To fix the warning, first unregister the network interface, which
calls net_device_ops::ndo_stop, which disables the NAPI, and then call
can_rx_offload_del().

Fixes: ff60bfbaf67f ("can: rockchip_canfd: add driver for Rockchip CAN-FD controller")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20250502-can-rx-offload-del-v1-2-59a9b131589d@pengutronix.de
Reviewed-by: Markus Schneider-Pargmann <msp@baylibre.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/rockchip/rockchip_canfd-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/can/rockchip/rockchip_canfd-core.c
+++ b/drivers/net/can/rockchip/rockchip_canfd-core.c
@@ -937,8 +937,8 @@ static void rkcanfd_remove(struct platfo
 	struct rkcanfd_priv *priv = platform_get_drvdata(pdev);
 	struct net_device *ndev = priv->ndev;
 
-	can_rx_offload_del(&priv->offload);
 	rkcanfd_unregister(priv);
+	can_rx_offload_del(&priv->offload);
 	free_candev(ndev);
 }
 


