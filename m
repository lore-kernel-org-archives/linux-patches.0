Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32015415F12;
	Tue, 21 Jul 2026 18:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659721; cv=none; b=e9vmRVsKBTcF2GCLKR8UseBRHmI2eq5wDYoIfMZx3+yw9EQglcs0dq1TFAEINquAZDPn/tdlUoxlVtkcbH2HE6gcK56lbp8jx7qj7pBgwNhXU75Lal/K/sFNRCT2NhIV84CEZi3AHtrlX25NOamoPgESsoGY+FqArnXMkule4Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659721; c=relaxed/simple;
	bh=dcy95YjIMpHohEtjfo+C5s2Dmo5KqvUOxlAAzHAnZuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dtez5VHpfYpVqhSw9X6crj8gM28OzGPvo5NFQWFNgkQQj/OlTljpcx/RwTBOzZ+hLPi0Fg9HiGJI+hI7DJWrqdS1ePrjNrvqW+ocbw6HlGrvbTjFHS4iX+VrfyYl1pI89Wtd21Z7Jb/yvnqD8+lX47LI/wZTgiY+LCiRKB5+0DU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q/ZMOGRs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q/ZMOGRs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98D221F00A3E;
	Tue, 21 Jul 2026 18:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659720;
	bh=LsU7CNx4dPCQpOtYcKCPGTTlYpqsG23QIzAdgovdeLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q/ZMOGRsK6rJmnm/GCyfuGYUEVVEBPbzso+oXxgFoOpCmE7QJsWN8uxCfOo6AUIMW
	 B8DHKwr+WEH+LGDaU2CQuSDJX8x9QAfj/R9nONF0Na/L5jvOm4QtS+AqRepYypCbUG
	 Y/RveqhE5vk24L0lvfzDIQ3TM3x9NBocpjXrUxOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	George Moussalem <george.moussalem@outlook.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0708/2077] net: dsa: qca8k: fix led devicename when using external mdio bus
Date: Tue, 21 Jul 2026 17:06:21 +0200
Message-ID: <20260721152609.495562780@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: George Moussalem <george.moussalem@outlook.com>

[ Upstream commit 0b7b378ce6cafbb948786cb6f17f406d94016c8c ]

The qca8k dsa switch can use either an external or internal mdio bus.
This depends on whether the mdio node is defined under the switch node
itself. Upon registering the internal mdio bus, the internal_mdio_bus
of the dsa switch is assigned to this bus. When an external mdio bus is
used, the driver still uses the internal_mdio_bus id which is used to
create the device names of the leds.
This leads to the leds being prefixed with '(efault)' as the
internal_mii_bus is null. So let's fix this by adding a null check and
use the devicename of the external bus instead when an external bus is
configured.

Fixes: 1e264f9d2918 ("net: dsa: qca8k: add LEDs basic support")
Signed-off-by: George Moussalem <george.moussalem@outlook.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20260608-qca8k-leds-fix-v3-1-a915bb2f37ae@outlook.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/qca/qca8k-leds.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/qca/qca8k-leds.c b/drivers/net/dsa/qca/qca8k-leds.c
index 43ac68052baf9f..ef496e345a4e7d 100644
--- a/drivers/net/dsa/qca/qca8k-leds.c
+++ b/drivers/net/dsa/qca/qca8k-leds.c
@@ -429,7 +429,8 @@ qca8k_parse_port_leds(struct qca8k_priv *priv, struct fwnode_handle *port, int p
 		init_data.fwnode = led;
 		init_data.devname_mandatory = true;
 		init_data.devicename = kasprintf(GFP_KERNEL, "%s:0%d",
-						 priv->internal_mdio_bus->id,
+						 priv->internal_mdio_bus ?
+						 priv->internal_mdio_bus->id : priv->bus->id,
 						 port_num);
 		if (!init_data.devicename) {
 			fwnode_handle_put(led);
-- 
2.53.0



