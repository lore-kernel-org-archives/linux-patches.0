Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CEF6227E8A;
	Mon, 12 May 2025 17:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072643; cv=none; b=Cd7S47VntRDMIuxSO0p3hEzicKgu7U/WEOTaTWYWKfeKHwuijRb8Tan8V1jUgujcmf+k/UXrdlb3+qOdoIA9wBzYFbTAwBOe2r2vfcvxV1FYuUKDj0I4Ouf6hP0xBkIOHR1Y+Yd1TA1S8O2eybzNYq6YsWbn7veFyjTYy7DHS3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072643; c=relaxed/simple;
	bh=iV1ttcH5p4vQadtE7TkO6+7emW2J7tRjQ/GVAOckDY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ss/5Rg0E/gZ5V8Nuc4jsKkWpCOkvNODG/KvhalosedlRf/1EbBxRUdMJZ948BsDRIYVWr1AQ594pES0+pmAPgME9YWKTXVIlOPVqBI+5oWKsBIMTR/i+MUi2TJ0ERfRckRfo+S2OsRyrUvaYATtZzunldJXOlgV8eHcnu5c3jAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rXIxdTEf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rXIxdTEf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36337C4CEE7;
	Mon, 12 May 2025 17:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072642;
	bh=iV1ttcH5p4vQadtE7TkO6+7emW2J7tRjQ/GVAOckDY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rXIxdTEfJy8JmXKRQjbz+JdhZ4Wq5YCb5ys9dl6Hf8YXs2Ls/eCmyrI/Jmu4aRNib
	 +BCg+wjkgsXPEYntk5l2kH+aA7atFpf4I6+nlIIG9y4fb2gl27F1vWBK7VhxG2vwSL
	 XCSEcSPZBUwjo5DfAzpndI2yQp6VZR7Tc5elP+IA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Schneider-Pargmann <msp@baylibre.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.12 012/184] can: rockchip_canfd: rkcanfd_remove(): fix order of unregistration calls
Date: Mon, 12 May 2025 19:43:33 +0200
Message-ID: <20250512172042.160817209@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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
@@ -942,8 +942,8 @@ static void rkcanfd_remove(struct platfo
 	struct rkcanfd_priv *priv = platform_get_drvdata(pdev);
 	struct net_device *ndev = priv->ndev;
 
-	can_rx_offload_del(&priv->offload);
 	rkcanfd_unregister(priv);
+	can_rx_offload_del(&priv->offload);
 	free_candev(ndev);
 }
 


