Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E1914F68B1;
	Tue, 13 Oct 2026 11:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892636; cv=none; b=JxE7Er4ot3z9zkvIkwhsVZK4Ze8ByFuSE+LPQcApwv0jtS/jXOq5SUs5StmkaVZCaPRjG5q6LycYdKXF9+JWjpX61QvWEdrfLMrx68dFGf3XPLPyRjjEjkvFEsRSWjVVx2JpvE5a+owiNGYk//XKQOCM6fG1dgmf/5SwiWZvN0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892636; c=relaxed/simple;
	bh=eTSiLvZjJ26klsXi5m1sDfTLift3ImXEWzDkzDeFR9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ps/WpZBRL3FOXT2WNBl+x9KhuvlNaUIVA+7NfiYPlwQvxCNi3Tnv61pUT3O4EsaTsVQF/D+gG1h0kWDex5ZzIklxNtnVrXVcT3qLQsgQ3tbKVnr4hWpmnBs7rSMLN4HfB5bqaCFMATK8xeIFGe94FgmEmPfrku6mFisUoFnMtKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o5P+QGbJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o5P+QGbJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A3CA1F000FF;
	Tue, 13 Oct 2026 11:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892633;
	bh=3m4GJhbGQbTQNvadkh9LGCbCn8hRVhB0ZwpuMDaSOnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o5P+QGbJRNqx07icItFQRKrv/ZFq58z8i+prIlqqzuQTdDeISSXTVDyb8tFUJSYsb
	 Yapf0qVhC1Auho3T0yCOzjmScIdwNtYU9oPgyUgSASMneulRXFC2hdcZV+eL0yDp3e
	 1rem365MJSedQYixhfTGTINl0UIdrp6Om2EuJDac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huy Nguyen Dinh Quang <huynguyendinhquang@gmail.com>,
	Junjie Cao <junjie.cao@intel.com>,
	Cristian Fleischer <cristian.fleischer@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 238/281] wifi: mt76: mt792x: treat 0xff ACPI SAR entries as no limit
Date: Tue, 13 Oct 2026 13:39:14 +0200
Message-ID: <20261013112900.925746844@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

From: Junjie Cao <junjie.cao@intel.com>

[ Upstream commit 45f53d98cbaa078907b6a300ff3974dfb5ae8776 ]

Some ASUS firmware carries 0xff in MTGS power slots. The driver narrows
the byte to s8, so the slot reads as -1 in its 0.5 dBm units, wins the
min() against the regulatory limit and caps every rate the driver
programs. On an ASUS Zenbook 14 UM3406HA (MT7922) all six MTGS tables
hold 0xff in every power byte, and txpower_sku shows tmac 3 on every
supported OFDM/HT/VHT/HE rate against EEPROM entries of 25-39, under
both the FR and the world regulatory domain. Huy Nguyen Dinh Quang saw
the same clamp on a Vivobook S 14 M5406WA, with 5 GHz TX at ~40 Mbps,
and proposed skipping the geo entry.

Skip a geo entry whose power byte is 0xff. The MTDS entry is narrowed
the same way on its way into the geo lookup, so give it the same
treatment, and clamp the dynamic value plus offset at 127 so a no-limit
entry cannot wrap.

Fixes: f965333e491e ("mt76: mt7921: introduce ACPI SAR support")
Link: https://bugzilla.redhat.com/show_bug.cgi?id=2515420
Reported-by: Huy Nguyen Dinh Quang <huynguyendinhquang@gmail.com>
Closes: https://lore.kernel.org/linux-wireless/20260827134820.2607530-1-huynguyendinhquang@gmail.com/
Signed-off-by: Junjie Cao <junjie.cao@intel.com>
Tested-by: Cristian Fleischer <cristian.fleischer@gmail.com>
Link: https://patch.msgid.link/acb947435fc78d5c06039c7bd5609c735468b0ee.1789002236.git.junjie.cao@intel.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/mediatek/mt76/mt792x_acpi_sar.c   | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c b/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c
index 946dd7956e4a0..9f0ea3d23e0f5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c
@@ -279,10 +279,18 @@ mt792x_asar_get_geo_pwr(struct mt792x_phy *phy,
 	if (idx >= max)
 		return dyn_power;
 
-	geo_power = (band_pwr + idx)->pwr;
-	dyn_power += (band_pwr + idx)->offset;
+	band_pwr += idx;
 
-	return min(geo_power, dyn_power);
+	/* Some OEM tables carry 0xff here; narrowed to s8 that is -1 and
+	 * wins the min() below. Take it as no limit.
+	 */
+	if (band_pwr->pwr == 0xff)
+		return dyn_power;
+
+	geo_power = band_pwr->pwr;
+
+	return min_t(int, geo_power,
+		     min_t(int, dyn_power + band_pwr->offset, 127));
 }
 
 static s8
@@ -315,7 +323,9 @@ mt792x_asar_range_pwr(struct mt792x_phy *phy,
 	else
 		band = NL80211_BAND_2GHZ;
 
-	return mt792x_asar_get_geo_pwr(phy, band, limit[idx]);
+	/* 0xff: no dynamic limit, see mt792x_asar_get_geo_pwr() */
+	return mt792x_asar_get_geo_pwr(phy, band,
+				       limit[idx] == 0xff ? 127 : limit[idx]);
 }
 
 int mt792x_init_acpi_sar_power(struct mt792x_phy *phy, bool set_default)
-- 
2.53.0



