Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BAA1168A7
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:38:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85551C433D2;
	Mon,  8 May 2023 10:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542300;
	bh=z/l2lYS6pqmB61WX3fwNLT9bcnjGYy14NP6+JeyfDCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0mjSdE6CZC5of9E5Yngymotibn+/rfM13FLn+VYxpN3MUCwN4gF3vYLjuESdXt4rc
	 WDgwuHSgm2BXcBZrhWxUxpKZCuVMKGikdIDfJO5yQ0XL0soXSiEq2oP69Fv9CoQZpg
	 iiZlY5I7Bh/iC48pduKBZdL0uTVjTGklxMclCpHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Howard Hsu <howard-yh.hsu@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 392/663] wifi: mt76: mt7915: rework init flow in mt7915_thermal_init()
Date: Mon,  8 May 2023 11:43:38 +0200
Message-Id: <20230508094440.822499092@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
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

[ Upstream commit 9c97df11dfe68b548a47744ba9fa6beddcfba2bc ]

If kernel do not enable CONFIG_HWMON, it may cause thermal
initialization to be done with temperature value 0 and then can not
transmit. This commit fixes it by setting trigger/restore temperature
before checking CONFIG_HWMON.

Fixes: 7d12b38ab6f6 ("wifi: mt76: mt7915: call mt7915_mcu_set_thermal_throttling() only after init_work")
Signed-off-by: Howard Hsu <howard-yh.hsu@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/init.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/init.c b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
index db0a35974ca7e..0d8bc7b06a46b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -204,6 +204,10 @@ static int mt7915_thermal_init(struct mt7915_phy *phy)
 			phy->cdev = cdev;
 	}
 
+	/* initialize critical/maximum high temperature */
+	phy->throttle_temp[MT7915_CRIT_TEMP_IDX] = MT7915_CRIT_TEMP;
+	phy->throttle_temp[MT7915_MAX_TEMP_IDX] = MT7915_MAX_TEMP;
+
 	if (!IS_REACHABLE(CONFIG_HWMON))
 		return 0;
 
@@ -212,10 +216,6 @@ static int mt7915_thermal_init(struct mt7915_phy *phy)
 	if (IS_ERR(hwmon))
 		return PTR_ERR(hwmon);
 
-	/* initialize critical/maximum high temperature */
-	phy->throttle_temp[MT7915_CRIT_TEMP_IDX] = MT7915_CRIT_TEMP;
-	phy->throttle_temp[MT7915_MAX_TEMP_IDX] = MT7915_MAX_TEMP;
-
 	return 0;
 }
 
-- 
2.39.2



