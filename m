Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD477261B99;
	Mon,  1 Dec 2025 11:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588655; cv=none; b=i6LADLA4YJS36aFMuUDqAOZpGgS6+0MvX1i0QVSnoDfrOMCV3I+YCwH0RxFwAfE0Jkkw3n8/rjekEIDCQrjX1FpPe4A7MFxMVFdOy9StqNA+dpPWom8WVb6dAhEg3wr43bd+2Ot3yUQ5SR3piOWAM13zmFsmdoe9/h80lHC5PS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588655; c=relaxed/simple;
	bh=Rc9DI4jmAiO9hhJs7f6sn8cUQtdQ4VkgPrjiEpMs7tM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KdiumkmUBed1XKyOi36jthx7EOvBM78DEVeaHdzLM5qV0SJCDIqv1qB9Xd7kEywpJk+V4Y/Ds4AwsSvd8es28Js4FK96uO00WnuxBkXSrPtwO/xNFK+dZIwIx8MlsvU7XfOT/BMlLhUZpLz5aYerH5gECHybUUN6HQvO4JawuQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rMEHm/UD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rMEHm/UD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39627C113D0;
	Mon,  1 Dec 2025 11:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588655;
	bh=Rc9DI4jmAiO9hhJs7f6sn8cUQtdQ4VkgPrjiEpMs7tM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rMEHm/UDJv1n5Jqde3vdkcGU455H2YPmpVW7PknwlT0Ss3CsIgoIBW/NQJFePm5C8
	 XC1cQ2R3KwbWp7gIkJIXbPafQ8MW18UJo1b0figVXazaux7GJ+MkQlwWUdjzOvTKT6
	 n3aip8gz6sym5rdgDrEwYfASb+GsaA0Aj/sPRFuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 117/187] net: dsa: b53: fix resetting speed and pause on forced link
Date: Mon,  1 Dec 2025 12:23:45 +0100
Message-ID: <20251201112245.456691158@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit b6a8a5477fe9bd6be2b594a88f82f8bba41e6d54 ]

There is no guarantee that the port state override registers have their
default values, as not all switches support being reset via register or
have a reset GPIO.

So when forcing port config, we need to make sure to clear all fields,
which we currently do not do for the speed and flow control
configuration. This can cause flow control stay enabled, or in the case
of speed becoming an illegal value, e.g. configured for 1G (0x2), then
setting 100M (0x1), results in 0x3 which is invalid.

For PORT_OVERRIDE_SPEED_2000M we need to make sure to only clear it on
supported chips, as the bit can have different meanings on other chips,
e.g. for BCM5389 this controls scanning PHYs for link/speed
configuration.

Fixes: 5e004460f874 ("net: dsa: b53: Add helper to set link parameters")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20251101132807.50419-2-jonas.gorski@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index dca23e0edb9a8..234ef7771ceef 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1066,6 +1066,10 @@ static void b53_force_port_config(struct b53_device *dev, int port,
 	else
 		reg &= ~PORT_OVERRIDE_FULL_DUPLEX;
 
+	reg &= ~(0x3 << GMII_PO_SPEED_S);
+	if (is5301x(dev) || is58xx(dev))
+		reg &= ~PORT_OVERRIDE_SPEED_2000M;
+
 	switch (speed) {
 	case 2000:
 		reg |= PORT_OVERRIDE_SPEED_2000M;
@@ -1084,6 +1088,11 @@ static void b53_force_port_config(struct b53_device *dev, int port,
 		return;
 	}
 
+	if (is5325(dev))
+		reg &= ~PORT_OVERRIDE_LP_FLOW_25;
+	else
+		reg &= ~(PORT_OVERRIDE_RX_FLOW | PORT_OVERRIDE_TX_FLOW);
+
 	if (rx_pause) {
 		if (is5325(dev))
 			reg |= PORT_OVERRIDE_LP_FLOW_25;
-- 
2.51.0



