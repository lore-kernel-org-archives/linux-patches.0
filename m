Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75BB030DEC4;
	Wed,  3 Dec 2025 16:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779626; cv=none; b=JLbAFjfXdlZNDvfl2M1vcE4O9YNtLHoS6yUeyBhkLLRSB7WbwlIVVrp85k7Zj14ZmW4NJstK4R1bG6wh5GhpAUAMmTLr8Eo8fJM7LIPBY9at0z5MkniMU+9DpwZv+yLP0MEDLjR8HyQW7wcc3ZXF3mONP85TyIySD8vDI9Tssqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779626; c=relaxed/simple;
	bh=XxVmpzUlB5fuGervVhGyhoYF35grvSpY0Jx68Z/cfFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mTyEsk7KCletexZrNPCtWTigd+abz3eEJyC9ulpiDc/qAe7IOMgUBFnva00AHJyKxLpKjn4pYNcxTaosCXpNJsPBgl8btfWukv0aobyJc0HiwDLGKYeDEF1nAFC4XWnKEyaKh6iLW/ujMwUU6JGKD6td9rbc7RMoI2cFTqz42vQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NpTtQg05; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NpTtQg05"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D58C7C116B1;
	Wed,  3 Dec 2025 16:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779626;
	bh=XxVmpzUlB5fuGervVhGyhoYF35grvSpY0Jx68Z/cfFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NpTtQg05jEzhhvmVfXokV6IHmQpRcpkEFb4ddQNXmBTsSbDHgKFq24e5XJQzH/fR8
	 Th15FPGqeQbb2RLOKn5Grhp+yFSeBL/rg79+lPF7JGjVg1uv9sUqwjHbD2ED0kKbJM
	 8WMZD1r3y+xUpClV4ITiAVr5k4z3HsQ9USWHF6ks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 312/568] net: dsa: b53: fix resetting speed and pause on forced link
Date: Wed,  3 Dec 2025 16:25:14 +0100
Message-ID: <20251203152452.140905775@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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
index b0e283bc3efbc..d5a1d26e8e3de 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1215,6 +1215,10 @@ static void b53_force_port_config(struct b53_device *dev, int port,
 	else
 		reg &= ~PORT_OVERRIDE_FULL_DUPLEX;
 
+	reg &= ~(0x3 << GMII_PO_SPEED_S);
+	if (is5301x(dev) || is58xx(dev))
+		reg &= ~PORT_OVERRIDE_SPEED_2000M;
+
 	switch (speed) {
 	case 2000:
 		reg |= PORT_OVERRIDE_SPEED_2000M;
@@ -1233,6 +1237,11 @@ static void b53_force_port_config(struct b53_device *dev, int port,
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



