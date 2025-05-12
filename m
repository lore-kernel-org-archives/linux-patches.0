Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65CFC230BE8;
	Mon, 12 May 2025 17:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072749; cv=none; b=mydjxCd0Gs8/SHiHGOeFcDzO0wXbybS43fYNhhduZtYBiPmYa2jgswTVHgHYwuVQPuYhRqvU83hbFRKKnpYE/IPbc4h3k8fI0aS9/yzzV+f9jW4C/ThEePJ5olFI5I3ODbQV+LI4qtyhYFsuRs31uplO2FbAdDfO4uLu7GRe9wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072749; c=relaxed/simple;
	bh=JT6wWC01v/QHdd3Ugddr6bGKd2eV2bctZiZnsiy6An4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WsdXvZTSl6N1uTSU6/Y6v+vROUfgCiju2jTh1f/2A7vaN7/bYvPcYRo6Xk597m8ShlfsWSeChREq0WFQN1G2TvJgW15y4PGWm/elztGp4r/SbHZdsz1st8xf5rY48HMEaPpk34GrJ9OW4z5we8DKpMiAJwor99NTwG559d6JnF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xLJ4K8lT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xLJ4K8lT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E225FC4CEE7;
	Mon, 12 May 2025 17:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072749;
	bh=JT6wWC01v/QHdd3Ugddr6bGKd2eV2bctZiZnsiy6An4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xLJ4K8lT7N845bYnmutPXfmd7Aj3PB1Ivwqm7AIkFDdbN5JWZvRrc2MARwXssN3BO
	 AtogdPLiWDjuAnLUEP0Tw/pTRv3tnLlp0O9usTPjtdIoa2QuTMj5sVmWdUCybDbqzI
	 sBOxKjAZRzDuISYk5wxq32NY2xTktzkbk3PhWYk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 045/184] net: dsa: b53: do not set learning and unicast/multicast on up
Date: Mon, 12 May 2025 19:44:06 +0200
Message-ID: <20250512172043.567882037@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit 2e7179c628d3cb9aee75e412473813b099e11ed4 ]

When a port gets set up, b53 disables learning and enables the port for
flooding. This can undo any bridge configuration on the port.

E.g. the following flow would disable learning on a port:

$ ip link add br0 type bridge
$ ip link set sw1p1 master br0 <- enables learning for sw1p1
$ ip link set br0 up
$ ip link set sw1p1 up <- disables learning again

Fix this by populating dsa_switch_ops::port_setup(), and set up initial
config there.

Fixes: f9b3827ee66c ("net: dsa: b53: Support setting learning on port")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20250429201710.330937-12-jonas.gorski@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 21 +++++++++++++--------
 drivers/net/dsa/b53/b53_priv.h   |  1 +
 drivers/net/dsa/bcm_sf2.c        |  1 +
 3 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 5ac34e6f877db..e072d2b50c987 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -578,6 +578,18 @@ static void b53_eee_enable_set(struct dsa_switch *ds, int port, bool enable)
 	b53_write16(dev, B53_EEE_PAGE, B53_EEE_EN_CTRL, reg);
 }
 
+int b53_setup_port(struct dsa_switch *ds, int port)
+{
+	struct b53_device *dev = ds->priv;
+
+	b53_port_set_ucast_flood(dev, port, true);
+	b53_port_set_mcast_flood(dev, port, true);
+	b53_port_set_learning(dev, port, false);
+
+	return 0;
+}
+EXPORT_SYMBOL(b53_setup_port);
+
 int b53_enable_port(struct dsa_switch *ds, int port, struct phy_device *phy)
 {
 	struct b53_device *dev = ds->priv;
@@ -590,10 +602,6 @@ int b53_enable_port(struct dsa_switch *ds, int port, struct phy_device *phy)
 
 	cpu_port = dsa_to_port(ds, port)->cpu_dp->index;
 
-	b53_port_set_ucast_flood(dev, port, true);
-	b53_port_set_mcast_flood(dev, port, true);
-	b53_port_set_learning(dev, port, false);
-
 	if (dev->ops->irq_enable)
 		ret = dev->ops->irq_enable(dev, port);
 	if (ret)
@@ -724,10 +732,6 @@ static void b53_enable_cpu_port(struct b53_device *dev, int port)
 	b53_write8(dev, B53_CTRL_PAGE, B53_PORT_CTRL(port), port_ctrl);
 
 	b53_brcm_hdr_setup(dev->ds, port);
-
-	b53_port_set_ucast_flood(dev, port, true);
-	b53_port_set_mcast_flood(dev, port, true);
-	b53_port_set_learning(dev, port, false);
 }
 
 static void b53_enable_mib(struct b53_device *dev)
@@ -2394,6 +2398,7 @@ static const struct dsa_switch_ops b53_switch_ops = {
 	.phy_read		= b53_phy_read16,
 	.phy_write		= b53_phy_write16,
 	.phylink_get_caps	= b53_phylink_get_caps,
+	.port_setup		= b53_setup_port,
 	.port_enable		= b53_enable_port,
 	.port_disable		= b53_disable_port,
 	.get_mac_eee		= b53_get_mac_eee,
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index e9aab4f8d15e1..4f8c97098d2a7 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -382,6 +382,7 @@ enum dsa_tag_protocol b53_get_tag_protocol(struct dsa_switch *ds, int port,
 					   enum dsa_tag_protocol mprot);
 void b53_mirror_del(struct dsa_switch *ds, int port,
 		    struct dsa_mall_mirror_tc_entry *mirror);
+int b53_setup_port(struct dsa_switch *ds, int port);
 int b53_enable_port(struct dsa_switch *ds, int port, struct phy_device *phy);
 void b53_disable_port(struct dsa_switch *ds, int port);
 void b53_brcm_hdr_setup(struct dsa_switch *ds, int port);
diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 0e663ec0c12a3..c4771a07878ea 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -1230,6 +1230,7 @@ static const struct dsa_switch_ops bcm_sf2_ops = {
 	.resume			= bcm_sf2_sw_resume,
 	.get_wol		= bcm_sf2_sw_get_wol,
 	.set_wol		= bcm_sf2_sw_set_wol,
+	.port_setup		= b53_setup_port,
 	.port_enable		= bcm_sf2_port_setup,
 	.port_disable		= bcm_sf2_port_disable,
 	.get_mac_eee		= b53_get_mac_eee,
-- 
2.39.5



