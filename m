Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B17B82236EE;
	Tue, 13 Oct 2026 12:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791896016; cv=none; b=LzFG0JYyNPkncrmTaDcNSmDEZ5cXMKmK2XXkt3m7l96XOd8W9qdyFMza/LbPwVPq/c3l2YBJDBfGshpJ4vmjaZvNON34XubdE1KAIy+6VWGri+3bO1n4d34vKCJ8n8CqIZCBgfML4+/yKZfBIyOJMRxeX+T2HC6P88KwwyQ+zxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791896016; c=relaxed/simple;
	bh=3Xmoxt80u1VEzJMlZhLOuw9MRvdZ7HfEEK7OAWqTcVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MjiP37bbvJMud+SLVnMJ/9y1e7/Dp52uPOIzZuiGCcQ5eoTc5tkyZN/URq6l4ubJQ3QsndhK4n3z5JaCjSMoWtJSAt+qr7mxy3K1wbe6dExqHg2vG211fpxNIVXL7V42/nD4EUGqxmARWSoHb02WcyPzuSIr6Ng3XpFfBIxh41g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=npwaf0ih; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="npwaf0ih"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D36291F000FF;
	Tue, 13 Oct 2026 12:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791896015;
	bh=VoUgvdWgyrcKpPBPrztxC+AbJH30nrv/R+4oktLzAC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=npwaf0ihLpVbao7G7yJPnVXAtyVF1PwDKt7lGrsfAw90LNbxELgz+UcEU/ovs7HnN
	 qbNAPipGtgH88BHqR7O4liimRQjM7PKzutxtsoUPk/lAr1y8H/oc/w36TYT0Qt1DKe
	 NnWhpdTDPFKiX7AzXOQXBMVe/1ZMYO1kbZMweT74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagun Kayastha <sgn.kayastha@gmail.com>,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 470/497] wifi: mt76: mt792x: pick the SAR table layout from the table itself
Date: Tue, 13 Oct 2026 13:40:37 +0200
Message-ID: <20261013112919.036730239@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Devin Wittmayer <lucid_duck@justthetip.ca>

[ Upstream commit af97bf5a7e72da9026de184676df8e2fa57e1058 ]

The SAR power tables are parsed with a version byte from a different
ACPI table, never their own.

Some firmware declares version 1 and ships version 2 tables. The
entries then start a byte early, and the 6 GHz limits the table
carries are dropped, because the older layout has no room for them.

  ASUS GA503RM, MTCL declares v1:
  MTGS  28 bytes   v1: (28-6) % 5 = 2, no fit   v2: 3 tables
  MTDS  19 bytes   v1: (19-6) % 6 = 1, no fit   v2: 1 table

The layouts accept disjoint lengths, so take whichever one fits and
keep it per table.

Reported-by: Sagun Kayastha <sgn.kayastha@gmail.com>
Closes: https://github.com/morrownr/mt76/issues/62
Fixes: f965333e491e ("mt76: mt7921: introduce ACPI SAR support")
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Link: https://patch.msgid.link/20260905013551.24635-1-lucid_duck@justthetip.ca
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/mediatek/mt76/mt792x_acpi_sar.c  | 110 +++++++++++-------
 .../wireless/mediatek/mt76/mt792x_acpi_sar.h  |   2 +
 2 files changed, 73 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c b/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c
index 1cd4c7f6cbf4b..2bbffaa204a03 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c
@@ -77,68 +77,98 @@ mt792x_asar_acpi_read_mtcl(struct mt792x_dev *dev, u8 **table, u8 *version)
 	return ret;
 }
 
+/* A table's layout is decided by the version byte in MTCL, but some firmware
+ * labels a version 2 table as version 1.  Accept whichever layout the table
+ * actually has: for every accepted entry count the two do not overlap, since
+ * one is 6 + 5n bytes and the other 7 + 7n.
+ */
+static bool
+mt792x_asar_fits(u8 *table, int len, int prelen, int sarlen, int nr_off,
+		 int min, int max)
+{
+	int tblcnt;
+
+	if (len < prelen || (len - prelen) % sarlen)
+		return false;
+
+	tblcnt = (len - prelen) / sarlen;
+	if (tblcnt < min || tblcnt > max)
+		return false;
+
+	return tblcnt == table[nr_off];
+}
+
 /* MTDS : Dynamic SAR Power Table */
 static int
-mt792x_asar_acpi_read_mtds(struct mt792x_dev *dev, u8 **table, u8 version)
+mt792x_asar_acpi_read_mtds(struct mt792x_dev *dev, u8 **table, u8 version,
+			   u8 *used)
 {
-	int len, ret, sarlen, prelen, tblcnt;
-	bool enable;
+	int len, ret;
+	u8 *t;
 
 	ret = mt792x_acpi_read(dev, MT792x_ACPI_MTDS, table, &len);
 	if (ret)
 		return ret;
 
+	t = *table;
+
 	/* Table content validation */
-	switch (version) {
-	case 1:
-		enable = ((struct mt792x_asar_dyn *)*table)->enable;
-		sarlen = sizeof(struct mt792x_asar_dyn_limit);
-		prelen = sizeof(struct mt792x_asar_dyn);
-		break;
-	case 2:
-		enable = ((struct mt792x_asar_dyn_v2 *)*table)->enable;
-		sarlen = sizeof(struct mt792x_asar_dyn_limit_v2);
-		prelen = sizeof(struct mt792x_asar_dyn_v2);
-		break;
-	default:
+	if (mt792x_asar_fits(t, len, sizeof(struct mt792x_asar_dyn),
+			     sizeof(struct mt792x_asar_dyn_limit),
+			     offsetof(struct mt792x_asar_dyn, nr_tbl),
+			     MT792x_ASAR_MIN_DYN, MT792x_ASAR_MAX_DYN))
+		*used = 1;
+	else if (mt792x_asar_fits(t, len, sizeof(struct mt792x_asar_dyn_v2),
+				  sizeof(struct mt792x_asar_dyn_limit_v2),
+				  offsetof(struct mt792x_asar_dyn_v2, nr_tbl),
+				  MT792x_ASAR_MIN_DYN, MT792x_ASAR_MAX_DYN))
+		*used = 2;
+	else
 		return -EINVAL;
-	}
 
-	tblcnt = (len - prelen) / sarlen;
-	if (!enable ||
-	    tblcnt > MT792x_ASAR_MAX_DYN || tblcnt < MT792x_ASAR_MIN_DYN)
+	if (!t[offsetof(struct mt792x_asar_dyn, enable)])
 		return -EINVAL;
 
+	if (version && *used != version)
+		dev_info(dev->mt76.dev,
+			 "MTDS is v%u, MTCL says v%u; using v%u\n",
+			 *used, version, *used);
+
 	return 0;
 }
 
 /* MTGS : Geo SAR Power Table */
 static int
-mt792x_asar_acpi_read_mtgs(struct mt792x_dev *dev, u8 **table, u8 version)
+mt792x_asar_acpi_read_mtgs(struct mt792x_dev *dev, u8 **table, u8 version,
+			   u8 *used)
 {
-	int len, ret, sarlen, prelen, tblcnt;
+	int len, ret;
+	u8 *t;
 
 	ret = mt792x_acpi_read(dev, MT792x_ACPI_MTGS, table, &len);
 	if (ret)
 		return ret;
 
+	t = *table;
+
 	/* Table content validation */
-	switch (version) {
-	case 1:
-		sarlen = sizeof(struct mt792x_asar_geo_limit);
-		prelen = sizeof(struct mt792x_asar_geo);
-		break;
-	case 2:
-		sarlen = sizeof(struct mt792x_asar_geo_limit_v2);
-		prelen = sizeof(struct mt792x_asar_geo_v2);
-		break;
-	default:
+	if (mt792x_asar_fits(t, len, sizeof(struct mt792x_asar_geo),
+			     sizeof(struct mt792x_asar_geo_limit),
+			     offsetof(struct mt792x_asar_geo, nr_tbl),
+			     MT792x_ASAR_MIN_GEO, MT792x_ASAR_MAX_GEO))
+		*used = 1;
+	else if (mt792x_asar_fits(t, len, sizeof(struct mt792x_asar_geo_v2),
+				  sizeof(struct mt792x_asar_geo_limit_v2),
+				  offsetof(struct mt792x_asar_geo_v2, nr_tbl),
+				  MT792x_ASAR_MIN_GEO, MT792x_ASAR_MAX_GEO))
+		*used = 2;
+	else
 		return -EINVAL;
-	}
 
-	tblcnt = (len - prelen) / sarlen;
-	if (tblcnt > MT792x_ASAR_MAX_GEO || tblcnt < MT792x_ASAR_MIN_GEO)
-		return -EINVAL;
+	if (version && *used != version)
+		dev_info(dev->mt76.dev,
+			 "MTGS is v%u, MTCL says v%u; using v%u\n",
+			 *used, version, *used);
 
 	return 0;
 }
@@ -174,14 +204,16 @@ int mt792x_init_acpi_sar(struct mt792x_dev *dev)
 		asar->countrylist = NULL;
 	}
 
-	ret = mt792x_asar_acpi_read_mtds(dev, (u8 **)&asar->dyn, asar->ver);
+	ret = mt792x_asar_acpi_read_mtds(dev, (u8 **)&asar->dyn, asar->ver,
+					 &asar->dyn_ver);
 	if (ret) {
 		devm_kfree(dev->mt76.dev, asar->dyn);
 		asar->dyn = NULL;
 	}
 
 	/* MTGS is optional */
-	ret = mt792x_asar_acpi_read_mtgs(dev, (u8 **)&asar->geo, asar->ver);
+	ret = mt792x_asar_acpi_read_mtgs(dev, (u8 **)&asar->geo, asar->ver,
+					 &asar->geo_ver);
 	if (ret) {
 		devm_kfree(dev->mt76.dev, asar->geo);
 		asar->geo = NULL;
@@ -223,7 +255,7 @@ mt792x_asar_get_geo_pwr(struct mt792x_phy *phy,
 		break;
 	}
 
-	if (asar->ver == 1) {
+	if (asar->geo_ver == 1) {
 		band_pwr = &asar->geo->tbl[idx].band[0];
 		max = ARRAY_SIZE(asar->geo->tbl[idx].band);
 	} else {
@@ -274,7 +306,7 @@ mt792x_asar_range_pwr(struct mt792x_phy *phy,
 	if (!capa)
 		return 127;
 
-	if (asar->ver == 1) {
+	if (asar->dyn_ver == 1) {
 		limit = &asar->dyn->tbl[0].frp[0];
 		max = ARRAY_SIZE(asar->dyn->tbl[0].frp);
 	} else {
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.h b/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.h
index 2298983b6342f..2ac7cbef11f26 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.h
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.h
@@ -92,6 +92,8 @@ struct mt792x_asar_fg {
 
 struct mt792x_acpi_sar {
 	u8 ver;
+	u8 dyn_ver;
+	u8 geo_ver;
 	union {
 		struct mt792x_asar_dyn *dyn;
 		struct mt792x_asar_dyn_v2 *dyn_v2;
-- 
2.53.0



