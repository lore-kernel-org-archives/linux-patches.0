Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5ADA13E050;
	Tue, 14 May 2024 10:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683543; cv=none; b=refyOAXgG6YNvz8sF8y97QC6jOcJ3jtiDnJeyBxvf/VG85z310udkyKT4Rutx3swf3aGL0eAKf+zqtimw6emfrJBeZ/AJTMyqepxnhlrhe7VdyjO3w9rVxw4/wrcLi7YlcYv6a18QGKuXO2BDl9/XC71ovbRrc4LO90b30/sUpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683543; c=relaxed/simple;
	bh=Qwh65TR070YMNjSKWTKj6qQhe7McrCo0SMx858fMqW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IBr/gPUASpeuOkIPwvaxk3OZ8MnQMGuEQv73Ntrv40pNRiyqpM63G10RBsXixJPi8n1IJsc0id7Ltf9CNyHVvTSFPjqdXiFj+Xay4bFwHWzmZ7c1mGQKtTg+WyR6NiuhKSBaBveDDDJcHi8znKoaxiNDCeNAp5HVBVsXv2BlW+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O5Bh6sV7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O5Bh6sV7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8238CC2BD10;
	Tue, 14 May 2024 10:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683543;
	bh=Qwh65TR070YMNjSKWTKj6qQhe7McrCo0SMx858fMqW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O5Bh6sV74kxLNXR0s4hlhWAB0/dQHKTOfOJl1MytexzpaMnMiiX/bPPdrnSZsOvVF
	 88Fk01tQYMEaKJt8WDYapqwrzpPzAfP+ZPJe4pVMGuaumvhWofFxYC/3+lOsZ0MO8F
	 PgovVlPE2BuoKpYn6qK+Y1TPbBFgN2adDZTP4MTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Steffen=20B=C3=A4tz?= <steffen@innosonix.de>,
	Andrew Lunn <andrew@lunn.ch>,
	Fabio Estevam <festevam@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 233/336] net: dsa: mv88e6xxx: add phylink_get_caps for the mv88e6320/21 family
Date: Tue, 14 May 2024 12:17:17 +0200
Message-ID: <20240514101047.412107062@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index bb0552469ae84..967d9136313f4 100644
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
@@ -5090,7 +5102,7 @@ static const struct mv88e6xxx_ops mv88e6320_ops = {
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.avb_ops = &mv88e6352_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
-	.phylink_get_caps = mv88e6185_phylink_get_caps,
+	.phylink_get_caps = mv88e632x_phylink_get_caps,
 };
 
 static const struct mv88e6xxx_ops mv88e6321_ops = {
@@ -5136,7 +5148,7 @@ static const struct mv88e6xxx_ops mv88e6321_ops = {
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.avb_ops = &mv88e6352_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
-	.phylink_get_caps = mv88e6185_phylink_get_caps,
+	.phylink_get_caps = mv88e632x_phylink_get_caps,
 };
 
 static const struct mv88e6xxx_ops mv88e6341_ops = {
-- 
2.43.0



