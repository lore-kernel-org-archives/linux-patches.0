Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053E551357A;
	Wed, 30 Sep 2026 17:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787923; cv=none; b=OMzlIzkH6mRs+IoVoIRcfXJD9CsIk9dA7/X5vl+9lMk7uIFOyHjyRup9f3fIKG5pEag9skc3PyXRccRo+g5+Ynwxcqk9dB6PYhBFiHvKOd2M5q6qdEVDXpgleen7yYbPn2augUiF1tKJFz1UZjCKP+sb1prOMjvP0ZaLK7YIs4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787923; c=relaxed/simple;
	bh=LBaTNRkk1HDB+UnI4hCPqpwIYHzF6g03e44cHAnpYBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J8WgRrwgLmX5p6xRiqoM2K8LnrrHst+sGN/C+dekLaRwwgBX2+lE3aQNQrKCJaPk6iF0o/EEXxteejYHmu9F/S0R5EG0ncTdexH5rE9QuXiy/fT+Sa5LUzzbvG+grh8/HduidvKS9Kg17wvo/jit6BmN/hDO3AHa6opPQe8TPjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NSI3JduG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NSI3JduG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E9091F000FF;
	Wed, 30 Sep 2026 17:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787921;
	bh=UuIA/jkCob50Hs2SwdyQVXplcr+EGeXunoHW5AjBlvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NSI3JduGr8Wr3XkAZy/7zmWZ6iyciS4yVplxMIHCxGHzUG6bDFHalAPWVuZJN/LxP
	 Woug0USJkCudVi5dQolbJHqKex/tMEeE++gJ/o0BWOeJ7/RGEzuP877UfR5WF1tvwO
	 NlWeNqF8La2bmRx7fh+gqcpVAfMycwuIhelkuRX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 345/457] net: phy: intel-xway: workaround 100BASE-TX Link-Up issue
Date: Wed, 30 Sep 2026 17:27:30 +0200
Message-ID: <20260930152353.459637422@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Sverdlin <alexander.sverdlin@siemens.com>

commit b94773dc4df7026a6f29b2c65e96e88d29cdb576 upstream.

MaxLinear GSW12x/GSW14x Ethernet Switch Errata Sheet states:
"An issue has been sporadically observed after device power-on on the first
link-up attempt in 100BASE-TX mode resulting in either the link-up taking a
long time, or failing to link-up altogether...

Workaround:
After power-on, enable Cable Diagnostic Mode for all ports and disable
it..."

Implement the proposed workaround unconditionally in the Intel XWAY driver
(MaxLinear GSW1xx switches incorporate Intel XWAY PHYs) because the
diagnostic bits have the same meaning even in older integral PHYs such as
GPY111/PEF7071/PHY11G. So it's not clear how to distinguish the affected
newer integrated PHYs, but the workaround should not hurt the older PHYs.

Cc: stable@vger.kernel.org
Fixes: 22335939ec90 ("net: dsa: add driver for MaxLinear GSW1xx switch family")
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@siemens.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20260922075251.23386-1-alexander.sverdlin@siemens.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/intel-xway.c |   29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

--- a/drivers/net/phy/intel-xway.c
+++ b/drivers/net/phy/intel-xway.c
@@ -16,6 +16,11 @@
 #define XWAY_MDIO_ISTAT			0x1A	/* interrupt status */
 #define XWAY_MDIO_LED			0x1B	/* led control */
 
+#define XWAY_MDIO_GCTRL_TM_MASK		GENMASK(15, 13)
+#define XWAY_MDIO_GCTRL_TM(mode)	FIELD_PREP(XWAY_MDIO_GCTRL_TM_MASK, (mode))
+#define XWAY_MDIO_GCTRL_TM_NOP		XWAY_MDIO_GCTRL_TM(0)	/* Normal operation */
+#define XWAY_MDIO_GCTRL_TM_CDIAG	XWAY_MDIO_GCTRL_TM(6)	/* Cable diagnostics */
+
 #define XWAY_MDIO_ERRCNT_SEL		GENMASK(11, 8)
 #define XWAY_MDIO_ERRCNT_COUNT		GENMASK(7, 0)
 #define XWAY_MDIO_ERRCNT_SEL_RXERR	0
@@ -326,6 +331,28 @@ static int xway_gphy_probe(struct phy_de
 	return 0;
 }
 
+static int xway_11g_int_config_init(struct phy_device *phydev)
+{
+	int err;
+
+	/* An issue has been sporadically observed after device power-on on the
+	 * first link-up attempt in 100BASE-TX mode resulting in either the
+	 * link-up taking a long time, or failing to link-up altogether.
+	 *
+	 * Workaround:
+	 * After power-on, enable Cable Diagnostic Mode for all ports and
+	 * disable it.
+	 */
+	err = phy_modify(phydev, MII_CTRL1000, XWAY_MDIO_GCTRL_TM_MASK, XWAY_MDIO_GCTRL_TM_CDIAG);
+	if (err)
+		return err;
+	err = phy_modify(phydev, MII_CTRL1000, XWAY_MDIO_GCTRL_TM_MASK, XWAY_MDIO_GCTRL_TM_NOP);
+	if (err)
+		return err;
+
+	return xway_gphy_config_init(phydev);
+}
+
 static int xway_gphy14_config_aneg(struct phy_device *phydev)
 {
 	int reg, err;
@@ -735,7 +762,7 @@ static struct phy_driver xway_gphy[] = {
 		.phy_id_mask	= 0xffffffff,
 		.name		= "Intel XWAY PHY11G (xRX v1.2 integrated)",
 		/* PHY_GBIT_FEATURES */
-		.config_init	= xway_gphy_config_init,
+		.config_init	= xway_11g_int_config_init,
 		.probe		= xway_gphy_probe,
 		.handle_interrupt = xway_gphy_handle_interrupt,
 		.config_intr	= xway_gphy_config_intr,


