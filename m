Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC35726FD9B;
	Tue, 17 Mar 2026 17:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767562; cv=none; b=l+XDELoVAZnMv77SerRmnrNjle537sWp0AbYRmod29nD27b/Ht/0Nzq0wt+fuQkL22YAxDF5PO4ViLY6nHXc0j2QpxaJ2zagen8ETOvwcQ9eVdalbGIMYKvHe3CL97MaSHwGXQ625MwH2Rqzg8CXipdrZ5zwBVGGvA1lhGFeDDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767562; c=relaxed/simple;
	bh=F+yqQINf8MZoRnLjiuf1Mjbp97G6vidGXgYfkL4Xctc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WRrpZd6GVm1d7kc5swhyzSUJmnnO0j/sVqJr7JHY2/4GcNayCjRlRJ4zmuNTzdjW/bW8UhsWziUiv9Ao7DOHT/egzBciTQg2dnoUc2oFKUu7a3nSzARX/+TwyjTScOOY0gPSiZkZry3HBxbxYQrSD4iO/DjxE/KHHfiI3lGv+qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ELcwPbyF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ELcwPbyF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22A6EC4CEF7;
	Tue, 17 Mar 2026 17:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767562;
	bh=F+yqQINf8MZoRnLjiuf1Mjbp97G6vidGXgYfkL4Xctc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ELcwPbyFnmw6qfZLwiUCJ5aj2TrGooCeYpsWoXh5DWkK4DhQ5I5jGO/+FEbR0Nut+
	 tWEAPgA3dnv2i1rdrZnNQqNAUFqHES2L5Q2moxhfBOq4txytEkmAFhRya/Ku5vPyb6
	 T7H5zycqJXUaET3CmjSwFbKOO6Rr3o9MqjheC36E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 113/333] net: usb: lan78xx: skip LTM configuration for LAN7850
Date: Tue, 17 Mar 2026 17:32:22 +0100
Message-ID: <20260317163003.558153558@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


