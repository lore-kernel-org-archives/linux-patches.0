Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE05D2566DD;
	Mon, 12 May 2025 17:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072381; cv=none; b=D9bqNUwG0y8QkurlMPV7mGe23dPN53ulc2rj+A3FqQ8eFmgIuLZi+BEv/8YLZ1+wxQgMpTmGjyJeNxOF5zcp/WR5Mfilktr4Ao7EsAN/jxUlhvRh6A0Oycyrjq/cTfTZ4qIE0rNJ4Wk9PHDLuFELw71saeQCNbl+/pVPUcKeSxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072381; c=relaxed/simple;
	bh=cZz9gJx+rYeyvDVzYhoDgWY+7cQBMvtcPLKW3dTm/0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nuryYnrb7mu21QtgitdG7Fqae5Kx64rsRRiQIpx7gkTpcXwAl8o7pUZyTxL+cRUJgDCb+/E5WrHyGiLhPRc9dC3H2nBt2Jy21UrpSnhoZzzsneGseynw+fjWW0oKntvALVZ0WyTsYX86ZieT0m8Xnx3hxrSytYAmuxgmzV5/gJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kAHeFp0x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kAHeFp0x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1322C4CEE7;
	Mon, 12 May 2025 17:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072381;
	bh=cZz9gJx+rYeyvDVzYhoDgWY+7cQBMvtcPLKW3dTm/0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kAHeFp0xFRDh/fA68S7DZ7uoAkrnt3NQrQcjS5Wlb8fY9fMGtPxkiSBPifQwwYo20
	 2seocIGxolm/uHAKbaUtNutT+GhJDg2UjXG9GuL/HjlWPo5ZKlYw0oTyRFCVuJ6qRP
	 wpAiQoDRpgo4Un+8xSCRNmosrXeWaIPyAgryj7g0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Schneider-Pargmann <msp@baylibre.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.1 03/92] can: mcan: m_can_class_unregister(): fix order of unregistration calls
Date: Mon, 12 May 2025 19:44:38 +0200
Message-ID: <20250512172023.275957137@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172023.126467649@linuxfoundation.org>
References: <20250512172023.126467649@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit 0713a1b3276b98c7dafbeefef00d7bc3a9119a84 upstream.

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

Fixes: 1be37d3b0414 ("can: m_can: fix periph RX path: use rx-offload to ensure skbs are sent from softirq context")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20250502-can-rx-offload-del-v1-3-59a9b131589d@pengutronix.de
Reviewed-by: Markus Schneider-Pargmann <msp@baylibre.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/m_can/m_can.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -2047,9 +2047,9 @@ EXPORT_SYMBOL_GPL(m_can_class_register);
 
 void m_can_class_unregister(struct m_can_classdev *cdev)
 {
+	unregister_candev(cdev->net);
 	if (cdev->is_peripheral)
 		can_rx_offload_del(&cdev->offload);
-	unregister_candev(cdev->net);
 }
 EXPORT_SYMBOL_GPL(m_can_class_unregister);
 


