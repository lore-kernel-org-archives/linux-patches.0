Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C0731DE4E3;
	Mon, 12 May 2025 17:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071018; cv=none; b=ZgA+ToqUB0xcZZyqtDltffYCv8HT7969X2QqPerPXyfs/+NaSkkTcfZsPTodftUSW+HKjjFm3qxAmn8sh/1Sv3wKx/kN4euPvRqpmo1mlVZ9SnpDV5nrhVDLCnBGr6GJr07PeD86R97oJJq1RQk32+b92Q1sIpNgmPLwlqnsYuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071018; c=relaxed/simple;
	bh=CHqIHrTuewSxcPgtdT4GMFQxlvjajWcet7gasn+0VZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QlvAHvvH/bntLDmNlQqri6l3C4vky/m8Hzf6de/CRHFVfA2wmKzrk8r05OLWbE6lvrZiYwm7GU8I2KtJFqTnr2YvYtnAxCR60phw55E7+agYnclVB5HP3FXVcp7T9pAZ/SCCIAfrr+eqQizrm5JJyikPFzAT9wLf7x8Y1Mpy1pQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Q9vBAyY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Q9vBAyY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D6ADC4CEF1;
	Mon, 12 May 2025 17:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071017;
	bh=CHqIHrTuewSxcPgtdT4GMFQxlvjajWcet7gasn+0VZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Q9vBAyYT/1SsVHAziIAPa4wAcphMuXATh9/d2vnFXzRqRrzhSpC+WnAKfN49OYtH
	 AMrkv/k6q62yuimD0mKJcmoI7QpJpASzVzKVS8bI5FJ/3tlofx5hnXztCYDVENv6Mm
	 5ojP66RPWsHaQp6yyQf0bzlW3IL5aQSj+TW07OvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Schneider-Pargmann <msp@baylibre.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.15 01/54] can: mcan: m_can_class_unregister(): fix order of unregistration calls
Date: Mon, 12 May 2025 19:29:13 +0200
Message-ID: <20250512172015.706330093@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172015.643809034@linuxfoundation.org>
References: <20250512172015.643809034@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2066,9 +2066,9 @@ EXPORT_SYMBOL_GPL(m_can_class_register);
 
 void m_can_class_unregister(struct m_can_classdev *cdev)
 {
+	unregister_candev(cdev->net);
 	if (cdev->is_peripheral)
 		can_rx_offload_del(&cdev->offload);
-	unregister_candev(cdev->net);
 }
 EXPORT_SYMBOL_GPL(m_can_class_unregister);
 


