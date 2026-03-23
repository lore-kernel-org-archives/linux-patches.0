Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51E51FC101;
	Mon, 23 Mar 2026 14:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275427; cv=none; b=TiyKx06hDBeeaznB+1feXSIjo4TmyHFQcOETtcK+HpBPHYF2NmD0qC3PKsDUA7YA/1YsuPzgxVs8ACvheYC89JxPPRMY2e7+BQdxIItakVEx0RoglpmiZ/DFmj5icybQ7aQ4TdrYRpzfer7jfurMMlthHBd5FO4xlA+V+cHLOrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275427; c=relaxed/simple;
	bh=TyYovEgjRiTvD2VsfAIIPh8zsySlOvKkpMjwtgG25JY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HFdDPE117ui8ISgmqjy3qxJtxfIPLDhU5UAUbbMD7setrDJ7WymW8y0kPfnqFeanHUMtXIxNnuOT5UsJB4vGbmN5u9fyin5k6Z4xxyOwd/45ctATYZCkRCPQF+iIWWZnPeskZkP2LqsEK9h3T/jKKrzD0cxM7ocw+2XzLh/uDEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d0837YlU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d0837YlU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F2B8C4CEF7;
	Mon, 23 Mar 2026 14:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275427;
	bh=TyYovEgjRiTvD2VsfAIIPh8zsySlOvKkpMjwtgG25JY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d0837YlUlXaSgqssz2KqcZLFAQNPYS5Qr+CNlpWaShVrg/Ml4Y6mVjV5fT4aQAeL9
	 8KLcYTZy7pxjNVvYsWvCkETbI15uEY/FXrErDGgenRjZfIXIU3NHRsVD94E/INTtJE
	 Xq37Vz78EPyPrR9mUTvBq2Zgr3zxjpco908rAyx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 094/460] net: usb: lan78xx: skip LTM configuration for LAN7850
Date: Mon, 23 Mar 2026 14:41:30 +0100
Message-ID: <20260323134528.971576820@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2667,6 +2667,10 @@ static void lan78xx_init_ltm(struct lan7
 	u32 buf;
 	u32 regs[6] = { 0 };
 
+	/* LAN7850 is USB 2.0 and does not support LTM */
+	if (dev->chipid == ID_REV_CHIP_ID_7850_)
+		return;
+
 	ret = lan78xx_read_reg(dev, USB_CFG1, &buf);
 	if (buf & USB_CFG1_LTM_ENABLE_) {
 		u8 temp[2];


