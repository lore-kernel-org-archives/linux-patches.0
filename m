Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41080311C07;
	Fri,  7 Aug 2026 14:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786113926; cv=none; b=XQGf3J93GpV8vtFQjHz+jmUjPkkwJzUSiOUJpMkHhFG8Euqog+G3Xq2elLJLalp3VeVXbF+GtOXSTVtpeGeqjC9HBHf4u8FL8IOTVQkoo8TTVwbAG1DgRyL+ruigsIO8SBXo+Rw5CdFhtlHiGQvyUt4whYO2W6VT8Kmd6Q8dOII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786113926; c=relaxed/simple;
	bh=QxXLDfZSZdhJw+DerpJU4v2MZk6fXGT1ozP62AXgURw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DIBJo8hRez0NVABg6tkJaudpTuMfHPyRt8dH1UjSgW/M7c5NpKLFfyTau5W7ZUl8ElYjoHrefKd4wViHohsSlPzBIPZV7op0lV/ydBThKvPoF+1q+8VgtyW8D6aX8B1bwhs7huTc7v7hSVfdvVBFHiUtxFGsaxnseYolo7IEvoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tELi/yct; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tELi/yct"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C9FF1F000E9;
	Fri,  7 Aug 2026 14:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786113920;
	bh=YqF7921wFA4o5heBUbgt+0eeWf3ztf/u4msmk0yOY3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tELi/yctuXtj9jgvSOk4XZLiOeUOqjO58oLKWr7k1sUvhVyXZ4YYezglKtxXE7daE
	 SLp/Xru7VJVfHBBaXN3bYJV2cKjF6cPHDTDbOxsOGYKJzLpOVDPIOHDUpDifSqcpkO
	 kzADV3WsEBrVkGm6cndkdD/HWexlGzeFpXvCTLdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 027/337] ahci: Introduce ahci_ignore_port() helper
Date: Fri,  7 Aug 2026 16:33:50 +0200
Message-ID: <20260807143419.107005648@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit c9b5be909e6595547ed5d45aef39fd65948aa342 ]

libahci and AHCI drivers may ignore some ports if the port is invalid
(its ID does not correspond to a valid physical port) or if the user
explicitly requested the port to be ignored with the mask_port_map
ahci module parameter. Such port that shall be ignored can be identified
by checking that the bit corresponding to the port ID is not set in the
mask_port_map field of struct ahci_host_priv. E.g. code such as:
"if (!(hpriv->mask_port_map & (1 << portid)))".

Replace all direct use of the mask_port_map field to detect such port
with the new helper inline function ahci_ignore_port() to make the code
more readable/easier to understand.

The comment describing the mask_port_map field of struct ahci_host_priv
is also updated to be more accurate.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Stable-dep-of: 4d99a91574c4 ("ata: ahci_ceva: fix error paths in ceva_ahci_platform_enable_resources()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/ahci.h             | 13 ++++++++++++-
 drivers/ata/ahci_brcm.c        |  2 +-
 drivers/ata/ahci_ceva.c        |  4 ++--
 drivers/ata/libahci_platform.c |  6 +++---
 4 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index 10a5fe02f0a45..5814245e43ceb 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -329,7 +329,7 @@ struct ahci_port_priv {
 struct ahci_host_priv {
 	/* Input fields */
 	unsigned int		flags;		/* AHCI_HFLAG_* */
-	u32			mask_port_map;	/* mask out particular bits */
+	u32			mask_port_map;	/* Mask of valid ports */
 
 	void __iomem *		mmio;		/* bus-independent mem map */
 	u32			cap;		/* cap to use */
@@ -380,6 +380,17 @@ struct ahci_host_priv {
 						  int port);
 };
 
+/*
+ * Return true if a port should be ignored because it is excluded from
+ * the host port map.
+ */
+static inline bool ahci_ignore_port(struct ahci_host_priv *hpriv,
+				    unsigned int portid)
+{
+	return portid >= hpriv->nports ||
+		!(hpriv->mask_port_map & (1 << portid));
+}
+
 extern int ahci_ignore_sss;
 
 extern const struct attribute_group *ahci_shost_groups[];
diff --git a/drivers/ata/ahci_brcm.c b/drivers/ata/ahci_brcm.c
index 60505e1e247ab..12bb0c2f914e7 100644
--- a/drivers/ata/ahci_brcm.c
+++ b/drivers/ata/ahci_brcm.c
@@ -288,7 +288,7 @@ static unsigned int brcm_ahci_read_id(struct ata_device *dev,
 
 	/* Re-initialize and calibrate the PHY */
 	for (i = 0; i < hpriv->nports; i++) {
-		if (!(hpriv->mask_port_map & (1 << i)))
+		if (ahci_ignore_port(hpriv, i))
 			continue;
 
 		rc = phy_init(hpriv->phys[i]);
diff --git a/drivers/ata/ahci_ceva.c b/drivers/ata/ahci_ceva.c
index 6e115da23d3f0..93275b1b48898 100644
--- a/drivers/ata/ahci_ceva.c
+++ b/drivers/ata/ahci_ceva.c
@@ -206,7 +206,7 @@ static int ceva_ahci_platform_enable_resources(struct ahci_host_priv *hpriv)
 		goto disable_clks;
 
 	for (i = 0; i < hpriv->nports; i++) {
-		if (!(hpriv->mask_port_map & (1 << i)))
+		if (ahci_ignore_port(hpriv, i))
 			continue;
 
 		rc = phy_init(hpriv->phys[i]);
@@ -218,7 +218,7 @@ static int ceva_ahci_platform_enable_resources(struct ahci_host_priv *hpriv)
 	ahci_platform_deassert_rsts(hpriv);
 
 	for (i = 0; i < hpriv->nports; i++) {
-		if (!(hpriv->mask_port_map & (1 << i)))
+		if (ahci_ignore_port(hpriv, i))
 			continue;
 
 		rc = phy_power_on(hpriv->phys[i]);
diff --git a/drivers/ata/libahci_platform.c b/drivers/ata/libahci_platform.c
index b68777841f7a5..53b2c7719dc51 100644
--- a/drivers/ata/libahci_platform.c
+++ b/drivers/ata/libahci_platform.c
@@ -49,7 +49,7 @@ int ahci_platform_enable_phys(struct ahci_host_priv *hpriv)
 	int rc, i;
 
 	for (i = 0; i < hpriv->nports; i++) {
-		if (!(hpriv->mask_port_map & (1 << i)))
+		if (ahci_ignore_port(hpriv, i))
 			continue;
 
 		rc = phy_init(hpriv->phys[i]);
@@ -73,7 +73,7 @@ int ahci_platform_enable_phys(struct ahci_host_priv *hpriv)
 
 disable_phys:
 	while (--i >= 0) {
-		if (!(hpriv->mask_port_map & (1 << i)))
+		if (ahci_ignore_port(hpriv, i))
 			continue;
 
 		phy_power_off(hpriv->phys[i]);
@@ -94,7 +94,7 @@ void ahci_platform_disable_phys(struct ahci_host_priv *hpriv)
 	int i;
 
 	for (i = 0; i < hpriv->nports; i++) {
-		if (!(hpriv->mask_port_map & (1 << i)))
+		if (ahci_ignore_port(hpriv, i))
 			continue;
 
 		phy_power_off(hpriv->phys[i]);
-- 
2.53.0



