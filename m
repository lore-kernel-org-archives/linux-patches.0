Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D9BA37F008;
	Tue, 17 Mar 2026 16:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765918; cv=none; b=ELKgqUwAtIiVqR/AOUpHfBDwxFUk8klgBaeTpEoB8mvhYFriiBqtXRCpimO20qix0pVpUqJX5JePAGJbOdgblvUMX+lS1yLzQn9kpCTmFDzjERXd3Cz+m3rRMeAtU4vKZ43QOmcAZj+jvWGro2/Z0lvMnGxeQHXGk9pqTwEKEw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765918; c=relaxed/simple;
	bh=6OrhKCTjNiWnp2uay5W4KVmIHVfDrdX1SWN8XO8Xk7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oXEiwVhnAhQnXbOsH0erorfI3mKSwsbGBgbYaX5tsBt95btn5dNqyQoZcdWEB0TC56Ajqb4xf8XCWTIN00CHdBsj3oZ0H9RsbAgpp6kPrUxiIw/OjaEg3CDaPg0vBSjO2SyATOR7SnbO3an98OunkRmJZF+btWvPaIJgIJHrSIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dooTeG7Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dooTeG7Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFF49C4CEF7;
	Tue, 17 Mar 2026 16:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765918;
	bh=6OrhKCTjNiWnp2uay5W4KVmIHVfDrdX1SWN8XO8Xk7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dooTeG7Yaeag8PE2evDXr08dqcg9zBPCNU1SaY0yjLEs3H/sjDaCP6e+Wwus9Rkrq
	 HkfWRt7DdMTRJJa2QaVoxYko5kDH7ACMPUNXURvjeoskunap1pCMIaQdri6fHcHVHq
	 0uVmwVpk8ylMysaPxN9hGBdGgG3FtteriCZ52Aqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.19 124/378] net: usb: lan78xx: skip LTM configuration for LAN7850
Date: Tue, 17 Mar 2026 17:31:21 +0100
Message-ID: <20260317163011.578048281@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3119,6 +3119,10 @@ static int lan78xx_init_ltm(struct lan78
 	int ret;
 	u32 buf;
 
+	/* LAN7850 is USB 2.0 and does not support LTM */
+	if (dev->chipid == ID_REV_CHIP_ID_7850_)
+		return 0;
+
 	ret = lan78xx_read_reg(dev, USB_CFG1, &buf);
 	if (ret < 0)
 		goto init_ltm_failed;


