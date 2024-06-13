Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ACF356458;
	Thu, 13 Jun 2024 12:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280315; cv=none; b=LzsFVqL9EO/hx3xDquRHBIypVI8pQsyKmv5lOKyQo7WTSXGuBeBCDRTFvUovVftQp7arMwCt/QafNK+RGjaOmrukp4pDQaeShfduhweVM7sCCzpEGBibw8Tzw+TCCAzu0R3ykOmtrNvHLZkRgryESm/YSAOsdsaCWL1+xP2WzsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280315; c=relaxed/simple;
	bh=236x9JkAn1HN7bkLaa30orKevFlfREOWkYYQ5rhfERU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WbiKJf2ovPzY5S2zwuA0tDaZOxwusMEzFzN/aKyw50OCrLcu+lWhTG7fmoUaJFDArHAxUErc+pniL/HPTzN1q796jo256NLloc8mOlZzWJ/qUAoWEDIuJzW74haDmdnYI+OSRlsVeiBOD5XW/4nha6nSyK/ryBTi5jSP9oCHgAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tU8iJhzZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tU8iJhzZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45A2DC2BBFC;
	Thu, 13 Jun 2024 12:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280314;
	bh=236x9JkAn1HN7bkLaa30orKevFlfREOWkYYQ5rhfERU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tU8iJhzZ7/YOe3IAYDD6fE3Qo3aPArsZMehE5T3JNPTH0HzJvHCvt8+XG8NF4kcHo
	 v6a5XgexkwtHvW9S5wPa2QE4vm94CeWuLmzWDRJbyDKCLr+8fAuvh0vNZg/6X+5baH
	 Onu1chMXxrRo422zNB1Yho3Dh2brJWg9c7mQlGpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Daniel Golle <daniel@makrotopia.org>
Subject: [PATCH 6.6 004/137] net: sfp-bus: fix SFP mode detect from bitrate
Date: Thu, 13 Jun 2024 13:33:04 +0200
Message-ID: <20240613113223.454096893@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

commit 97eb5d51b4a584a60e5d096bdb6b33edc9f50d8d upstream.

The referenced commit moved the setting of the Autoneg and pause bits
early in sfp_parse_support(). However, we check whether the modes are
empty before using the bitrate to set some modes. Setting these bits
so early causes that test to always be false, preventing this working,
and thus some modules that used to work no longer do.

Move them just before the call to the quirk.

Fixes: 8110633db49d ("net: sfp-bus: allow SFP quirks to override Autoneg and pause bits")
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://lore.kernel.org/r/E1rPMJW-001Ahf-L0@rmk-PC.armlinux.org.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Cc: Daniel Golle <daniel@makrotopia.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/sfp-bus.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/phy/sfp-bus.c
+++ b/drivers/net/phy/sfp-bus.c
@@ -151,10 +151,6 @@ void sfp_parse_support(struct sfp_bus *b
 	unsigned int br_min, br_nom, br_max;
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(modes) = { 0, };
 
-	phylink_set(modes, Autoneg);
-	phylink_set(modes, Pause);
-	phylink_set(modes, Asym_Pause);
-
 	/* Decode the bitrate information to MBd */
 	br_min = br_nom = br_max = 0;
 	if (id->base.br_nominal) {
@@ -339,6 +335,10 @@ void sfp_parse_support(struct sfp_bus *b
 		}
 	}
 
+	phylink_set(modes, Autoneg);
+	phylink_set(modes, Pause);
+	phylink_set(modes, Asym_Pause);
+
 	if (bus->sfp_quirk && bus->sfp_quirk->modes)
 		bus->sfp_quirk->modes(id, modes, interfaces);
 


