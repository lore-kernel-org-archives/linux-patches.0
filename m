Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE74A3BB9F9;
	Mon, 23 Mar 2026 16:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282555; cv=none; b=EnZfvNWzsM7q2e7nczyAJP6plRYBDgAl7mURitWlHwAcgEV2tks/vyHB8Ev1CBgLMk2YSMVMpnHOxGg4/4hZ3MTFU24UGTuiuPl1zGqHebIu1/jAZwAHRKwIXTjJvyRW3G2QCnUe9Gmnr3c9f+71giDM+J+gOAr0IHivZ/5hAuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282555; c=relaxed/simple;
	bh=mDNSGjDzs0uF0rGrOnFgFk+QRVR/sx5+lsie2HwqEXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ez1nldX24uM8JWeIqe61S9KgPbn985BSV4Li/LltykiZ5CPquevuWEw+0RkeLYRq2mN7gzs00ENmOkhraCisU/lFzVrp5BBKctKGKN/IoI3GOxNoQ7irvBUArn/BUzFU0Z6DMdzKerY90u0nzQzaVHcRWq11PNSLI57zi+FpjXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1989u+9V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1989u+9V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F3DEC4CEF7;
	Mon, 23 Mar 2026 16:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282555;
	bh=mDNSGjDzs0uF0rGrOnFgFk+QRVR/sx5+lsie2HwqEXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1989u+9VeLWk1k7TRBKQmgeQtHQrwwNdzwIwJwT7QjrfTC3vpbmLrUOO0VNwYWVBE
	 Y1dFt0TetpOfar9ZE9WG8EsRM+ZRp83DPglW8VUStMFaVK+R7HOe+ZEQqCPs0HCesg
	 WFTIP3LdWc2StUR/1G7DWWibBk0fUtFrq3SlwpDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 201/481] net: usb: lan78xx: skip LTM configuration for LAN7850
Date: Mon, 23 Mar 2026 14:43:03 +0100
Message-ID: <20260323134530.075460035@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Oleksij Rempel <o.rempel@pengutronix.de>

commit d9cc0e440f0664f6f3e2c26e39ab9dd5f3badba7 upstream.

Do not configure Latency Tolerance Messaging (LTM) on USB 2.0 hardware.

The LAN7850 is a High-Speed (USB 2.0) only device and does not support
SuperSpeed features like LTM. Currently, the driver unconditionally
attempts to configure LTM registers during initialization. On the
LAN7850, these registers do not exist, resulting in writes to invalid
or undocumented memory space.

This issue was identified during a port to the regmap API with strict
register validation enabled. While no functional issues or crashes have
been observed from these invalid writes, bypassing LTM initialization
on the LAN7850 ensures the driver strictly adheres to the hardware's
valid register map.

Fixes: 55d7de9de6c3 ("Microchip's LAN7800 family USB 2/3 to 10/100/1000 Ethernet device driver")
Cc: stable@vger.kernel.org
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://patch.msgid.link/20260305143429.530909-4-o.rempel@pengutronix.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/lan78xx.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -2672,6 +2672,10 @@ static void lan78xx_init_ltm(struct lan7
 	u32 buf;
 	u32 regs[6] = { 0 };
 
+	/* LAN7850 is USB 2.0 and does not support LTM */
+	if (dev->chipid == ID_REV_CHIP_ID_7850_)
+		return;
+
 	ret = lan78xx_read_reg(dev, USB_CFG1, &buf);
 	if (buf & USB_CFG1_LTM_ENABLE_) {
 		u8 temp[2];


