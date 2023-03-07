Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D1F1BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:18:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 775AEC433A0;
	Tue,  7 Mar 2023 17:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209504;
	bh=JG5bjN08qGQAVUiT6fBjulGwx/mj3eOcOV6E0q3xiAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KfuIo8QoxM46x2k4QHPDDsPobaM+md62kyXReQL/dyJVX5JGx56xCEUDr9s1hVXkX
	 3GmWI7/R5mSs/EkzZDVhB/VkK1k4BsuwbiWwKlxODcL3kaPrnhyIzQ3b/dDhm5TVqW
	 zM/PiIOK7hEw5f+kxrwpxM9PVT1wmDcXoE+uO3SY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryder Lee <ryder.lee@mediatek.com>,
	Howard Hsu <howard-yh.hsu@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0240/1001] wifi: mt76: mt7915: rework mt7915_thermal_temp_store()
Date: Tue,  7 Mar 2023 17:50:12 +0100
Message-Id: <20230307170032.240435116@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Howard Hsu <howard-yh.hsu@mediatek.com>

[ Upstream commit ecaccdae7a7e8f76eeb6544295ca0593c2f65a33 ]

Call mt7915_mcu_set_thermal_protect() through
mt7915_thermal_temp_store() to update firmware trigger/restore temp
directly.

Fixes: 02ee68b95d81 ("mt76: mt7915: add control knobs for thermal throttling")
Reviewed-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Howard Hsu <howard-yh.hsu@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7915/init.c   | 18 ++++++++++++++++--
 .../net/wireless/mediatek/mt76/mt7915/mt7915.h |  3 +++
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/init.c b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
index 4c351bfd4b270..a80ae31e7abff 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -83,9 +83,23 @@ static ssize_t mt7915_thermal_temp_store(struct device *dev,
 
 	mutex_lock(&phy->dev->mt76.mutex);
 	val = clamp_val(DIV_ROUND_CLOSEST(val, 1000), 60, 130);
+
+	if ((i - 1 == MT7915_CRIT_TEMP_IDX &&
+	     val > phy->throttle_temp[MT7915_MAX_TEMP_IDX]) ||
+	    (i - 1 == MT7915_MAX_TEMP_IDX &&
+	     val < phy->throttle_temp[MT7915_CRIT_TEMP_IDX])) {
+		dev_err(phy->dev->mt76.dev,
+			"temp1_max shall be greater than temp1_crit.");
+		return -EINVAL;
+	}
+
 	phy->throttle_temp[i - 1] = val;
 	mutex_unlock(&phy->dev->mt76.mutex);
 
+	ret = mt7915_mcu_set_thermal_protect(phy);
+	if (ret)
+		return ret;
+
 	return count;
 }
 
@@ -195,8 +209,8 @@ static int mt7915_thermal_init(struct mt7915_phy *phy)
 		return PTR_ERR(hwmon);
 
 	/* initialize critical/maximum high temperature */
-	phy->throttle_temp[0] = 110;
-	phy->throttle_temp[1] = 120;
+	phy->throttle_temp[MT7915_CRIT_TEMP_IDX] = 110;
+	phy->throttle_temp[MT7915_MAX_TEMP_IDX] = 120;
 
 	return 0;
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h b/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
index 855779f86bde0..e58650bbbd14a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
@@ -70,6 +70,9 @@
 
 #define MT7915_WED_RX_TOKEN_SIZE	12288
 
+#define MT7915_CRIT_TEMP_IDX		0
+#define MT7915_MAX_TEMP_IDX		1
+
 struct mt7915_vif;
 struct mt7915_sta;
 struct mt7915_dfs_pulse;
-- 
2.39.2



