Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11E339EF2C;
	Sat, 17 Oct 2026 18:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260447; cv=none; b=mWC5PPnNdStd0qu7WIHCQI0RJ+ylglOsFLuxdnGOqo56EJxaQW33aqZPXGtEbsq3r8GFS1F/nIpqIyi4rLL35I7L8GnP/z3dbfdef8SuZAwX9XkbFJyuhs7sXirHgbWxT/d3xJpSi8YJxMletU7irHUMQ3sfJqlXRfgKCoiznW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260447; c=relaxed/simple;
	bh=w2JUeNZOEnM6xriNwX1Ja5UQbq4abuSewRKcu2R9VI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oks67zw1xe6plUjpQyE9zaRnhYqkzKXGi/QFRXjsfC/zhB3lQ9iti0NnS8X8iInJeOTkCGIhdQsHPw3Sinmhz7KeqsVpxMmgN9VHya7SL0FK15vsxiXgaQ1A8Vss0SQTeODOaV8h6Tb6PVJ5uzLRsVEmWnVNcI3BG5e/z/IL86Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1eSfEDss; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1eSfEDss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 439BC1F000C4;
	Sat, 17 Oct 2026 18:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260446;
	bh=FTU0J/KZK+R7a56/2Dugau1eUQacL9LdJY+5h7QdCaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1eSfEDssTHzTORxdAryiak5iqojYN3CfspIrD0qp4gorhzKfG60qKUPh8F96HXbaQ
	 82bY9YgJ4wK1+tzsaw5d7LT0AU80S10cSrWueCUSyxs7JOACeKmycchnQ0tVZejQEi
	 JjZoqXDNVSoAXCL2ncnEzi9TfQcXMJ+JSMlruGlQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	=?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= <noltari@gmail.com>,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1549/1674] net: dsa: b53: do not enable EEE on bcm63xx
Date: Sat, 17 Oct 2026 18:03:41 +0200
Message-ID: <20261017160510.865614178@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit 1237c2d4a8db79dfd4369bff6930b0e385ed7d5c ]

BCM63xx internal switches do not support EEE, but provide multiple RGMII
ports where external PHYs may be connected. If one of these PHYs are EEE
capable, we may try to enable EEE for the MACs, which then hangs the
system on access of the (non-existent) EEE registers.

Fix this by checking if the switch actually supports EEE before
attempting to configure it.

Fixes: 22256b0afb12 ("net: dsa: b53: Move EEE functions to b53")
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Tested-by: Álvaro Fernández Rojas <noltari@gmail.com>
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Link: https://patch.msgid.link/20250602193953.1010487-2-jonas.gorski@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index f8b34fa8b99ee..41961e3809b20 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -2268,8 +2268,12 @@ EXPORT_SYMBOL(b53_eee_enable_set);
  */
 int b53_eee_init(struct dsa_switch *ds, int port, struct phy_device *phy)
 {
+	struct b53_device *dev = ds->priv;
 	int ret;
 
+	if (is5325(dev) || is5365(dev) || is63xx(dev))
+		return 0;
+
 	ret = phy_init_eee(phy, false);
 	if (ret)
 		return 0;
@@ -2286,7 +2290,7 @@ int b53_get_mac_eee(struct dsa_switch *ds, int port, struct ethtool_eee *e)
 	struct ethtool_eee *p = &dev->ports[port].eee;
 	u16 reg;
 
-	if (is5325(dev) || is5365(dev))
+	if (is5325(dev) || is5365(dev) || is63xx(dev))
 		return -EOPNOTSUPP;
 
 	b53_read16(dev, B53_EEE_PAGE, B53_EEE_LPI_INDICATE, &reg);
@@ -2302,7 +2306,7 @@ int b53_set_mac_eee(struct dsa_switch *ds, int port, struct ethtool_eee *e)
 	struct b53_device *dev = ds->priv;
 	struct ethtool_eee *p = &dev->ports[port].eee;
 
-	if (is5325(dev) || is5365(dev))
+	if (is5325(dev) || is5365(dev) || is63xx(dev))
 		return -EOPNOTSUPP;
 
 	p->eee_enabled = e->eee_enabled;
-- 
2.53.0



