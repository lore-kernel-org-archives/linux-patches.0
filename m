Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A239117BED0;
	Sat, 17 Oct 2026 17:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257393; cv=none; b=UDJWNgKZobVoCVoRV7WkwwQ/7hV3aoNwqrP9/jtlwNMKXik6gQ1E/GhZ+64Snw2mDeO5yW3ZxA2/I88HxZupH8X71lf0E/RMj3dChK/U6+Nj6/nJT/2fwuhOtYr28q+S5auxzc1n/hCoLgVgbPjSJcGi+7dWdpjCK8RoaGFTaec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257393; c=relaxed/simple;
	bh=I0tMbn2gzUlAVdFLxHl+luM9fpKSlrbjPXIuZwik2qQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HQx86oVeivI1SJAwe5q2T7VeC5qiQbYe/bNKouLKihsPxdGjR+LHxiW1Jw/3NuYgyQ36bSAhwQjEcNHlgGTiDOso56QX30047zkmos7u4a9tr6kuBLb+N34pPh9oEG4M0yXXMyvaI8q42PaZckUjjgT6A6XIKPDDAow8E4pVUD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vA3VSLRY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vA3VSLRY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC1E91F000C4;
	Sat, 17 Oct 2026 17:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257392;
	bh=ii7lRwwUUatD5ms3eFSJstSJ1oOUxdpJDZslJhMrWK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vA3VSLRY1bLbwyshhVp9wlXXLlGPhtkJf9J2aiKAqrRI0EblnGZYLMJqhTf6gGnkF
	 JIGbKzR1agHtsYURrUimyaJZ+16ZDBaVNMVAZyuXcez/onyR4Me9/LcLVXGe7GYeJP
	 306r83BNnWc1evugXTPqVNxqtPQDVthTm5fsz7Kc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huy Nguyen Dinh Quang <huynguyendinhquang@gmail.com>,
	Junjie Cao <junjie.cao@intel.com>,
	Cristian Fleischer <cristian.fleischer@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0545/1674] wifi: mt76: mt792x: treat 0xff ACPI SAR entries as no limit
Date: Sat, 17 Oct 2026 17:46:57 +0200
Message-ID: <20261017160445.087084480@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c4e3bfcc519e2..9e8a0b2d01a35 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c
@@ -248,10 +248,18 @@ mt792x_asar_get_geo_pwr(struct mt792x_phy *phy,
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
@@ -284,7 +292,9 @@ mt792x_asar_range_pwr(struct mt792x_phy *phy,
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



