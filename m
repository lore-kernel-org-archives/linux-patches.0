Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A9EA55C0A;
	Tue, 14 May 2024 11:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685588; cv=none; b=huCi9U/RHxh6GFe/Ch6GeHcIsTI0Lv5UZcVSFwHcuYT8K5NMSQ7/h6FkQ8py8hahgtJXBjov/tOdAQIDrYDIbpRmIhuSeXKnmgl2sillLWpGzF+OPe1HBYqiJrTk2WbjrUzpm/PSpD8kQqRx+/J1jXT6EQqwqaUW86BwuCAawOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685588; c=relaxed/simple;
	bh=snlwj6n1CB0XkZW30sRB/fpwzcOVWnZCVg6A/UU4IrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UhwvZ/XSN90kN1F+RzpmF00k/tKpuh39V1MqXrq4wpjWcWptJh0b+nSN3O13pEFF+7Ia0C2a7XQPOwQ9QghkXAC/+cLdQjva51I+LNWUnrg62bJiXaFy4zwzIBv5vMp5sdUFgbGYr5xvchOJR8ihHDPNla+FpJ2N9aeeXza/tj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rvDmCvoe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rvDmCvoe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8575CC2BD10;
	Tue, 14 May 2024 11:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685588;
	bh=snlwj6n1CB0XkZW30sRB/fpwzcOVWnZCVg6A/UU4IrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rvDmCvoenPUVpNr3YTq0UP3GklyrhG5/5hIF06XLB/yhTw8g/+nHBIfbcfN2wHlWx
	 rXk0cu7Tzsr7eOGjQD3DKghIMCfoSs94eaFopOpEpPOLmpPnuTXzIa7d3ruHvydGyQ
	 jvh39+wC8dKd/nb81jcIitndlnpM5ih3UYZHKI9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Steffen=20B=C3=A4tz?= <steffen@innosonix.de>,
	Andrew Lunn <andrew@lunn.ch>,
	Fabio Estevam <festevam@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 211/301] net: dsa: mv88e6xxx: add phylink_get_caps for the mv88e6320/21 family
Date: Tue, 14 May 2024 12:18:02 +0200
Message-ID: <20240514101040.227627584@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steffen Bätz <steffen@innosonix.de>

[ Upstream commit f39bf3cf08a49e7d20c44bc8bc8e390fea69959a ]

As of commit de5c9bf40c45 ("net: phylink: require supported_interfaces to
be filled")
Marvell 88e6320/21 switches fail to be probed:

...
mv88e6085 30be0000.ethernet-1:00: phylink: error: empty supported_interfaces
error creating PHYLINK: -22
...

The problem stems from the use of mv88e6185_phylink_get_caps() to get
the device capabilities.
Since there are serdes only ports 0/1 included, create a new dedicated
phylink_get_caps for the 6320 and 6321 to properly support their
set of capabilities.

Fixes: de5c9bf40c45 ("net: phylink: require supported_interfaces to be filled")
Signed-off-by: Steffen Bätz <steffen@innosonix.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Link: https://lore.kernel.org/r/20240508072944.54880-2-steffen@innosonix.de
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index db1d9df7d47fe..e5bac87941f61 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -697,6 +697,18 @@ static void mv88e6352_phylink_get_caps(struct mv88e6xxx_chip *chip, int port,
 	}
 }
 
+static void mv88e632x_phylink_get_caps(struct mv88e6xxx_chip *chip, int port,
+				       struct phylink_config *config)
+{
+	unsigned long *supported = config->supported_interfaces;
+
+	/* Translate the default cmode */
+	mv88e6xxx_translate_cmode(chip->ports[port].cmode, supported);
+
+	config->mac_capabilities = MAC_SYM_PAUSE | MAC_10 | MAC_100 |
+				   MAC_1000FD;
+}
+
 static void mv88e6341_phylink_get_caps(struct mv88e6xxx_chip *chip, int port,
 				       struct phylink_config *config)
 {
@@ -4976,7 +4988,7 @@ static const struct mv88e6xxx_ops mv88e6320_ops = {
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.avb_ops = &mv88e6352_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
-	.phylink_get_caps = mv88e6185_phylink_get_caps,
+	.phylink_get_caps = mv88e632x_phylink_get_caps,
 };
 
 static const struct mv88e6xxx_ops mv88e6321_ops = {
@@ -5022,7 +5034,7 @@ static const struct mv88e6xxx_ops mv88e6321_ops = {
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.avb_ops = &mv88e6352_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
-	.phylink_get_caps = mv88e6185_phylink_get_caps,
+	.phylink_get_caps = mv88e632x_phylink_get_caps,
 };
 
 static const struct mv88e6xxx_ops mv88e6341_ops = {
-- 
2.43.0



