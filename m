Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA6618027;
	Tue, 11 Nov 2025 01:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822984; cv=none; b=ehncmKtFj8DUix4AA2X9ujjO6fdBoA0kUr1Yul4BoIHSmXw47OIBHmEWbICHkLLhojf2oe6RhNgIttaxuoB4lfy1gL6xVQa9Mh+e7kXfNZMrJ2uaBgwsfnnQRae4U+o/f80lHg/xLVaBVgobj3Xpmwo0ameBH0x//C1ZG159ATk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822984; c=relaxed/simple;
	bh=56DjzD+1aGSvbW07nm/7kPWMoFHLGp8QSOtrm3I/bWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q5yeYx7VkSdRsJ2EBnUhQI4pl/P0ylSCeIKgtnzAqdCmPHi7ZtJDxLvgM8YvA/wDCrShen/yMVKCmN09eG+Dru8G0abFQ+aE7hOM6ugneu/U1bM7lg/cwVFA75ySht041rFiZsiyQln02nI57dPPYkV96UwxQKZIIjWJa4E806Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0YhYYf+B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0YhYYf+B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5FBDC16AAE;
	Tue, 11 Nov 2025 01:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822984;
	bh=56DjzD+1aGSvbW07nm/7kPWMoFHLGp8QSOtrm3I/bWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0YhYYf+BOh8Tw/b3Tdr0HTIOdm2HsI56Yrq2GGQ4Bpaw0KQcIkV2+9GlTQtBcezhx
	 vRKv/r7NmwCZqMSNGPcM/RkfFwWj4Z1Ew3lGad61NakPNQ5JPlzhf9UeyMexpboiiB
	 JRgB5ZRAdP+cF256dP1wi1YE8IE0oLirihg8Kxi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Fenglin Wu <fenglin.wu@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 144/565] power: supply: qcom_battmgr: handle charging state change notifications
Date: Tue, 11 Nov 2025 09:40:00 +0900
Message-ID: <20251111004530.181703480@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Fenglin Wu <fenglin.wu@oss.qualcomm.com>

[ Upstream commit 41307ec7df057239aae3d0f089cc35a0d735cdf8 ]

The X1E80100 battery management firmware sends a notification with
code 0x83 when the battery charging state changes, such as switching
between fast charge, taper charge, end of charge, or any other error
charging states.

The same notification code is used with bit[8] set when charging stops
because the charge control end threshold is reached. Additionally,
a 2-bit value is included in bit[10:9] with the same code to indicate
the charging source capability, which is determined by the calculated
power from voltage and current readings from PDOs: 2 means a strong
charger over 60W, 1 indicates a weak charger, and 0 means there is no
charging source.

These 3-MSB [10:8] in the notification code is not much useful for now,
hence just ignore them and trigger a power supply change event whenever
0x83 notification code is received. This helps to eliminate the unknown
notification error messages.

Reported-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Closes: https://lore.kernel.org/all/r65idyc4of5obo6untebw4iqfj2zteiggnnzabrqtlcinvtddx@xc4aig5abesu/
Signed-off-by: Fenglin Wu <fenglin.wu@oss.qualcomm.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/qcom_battmgr.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/power/supply/qcom_battmgr.c b/drivers/power/supply/qcom_battmgr.c
index dd89104cb1672..f8bea732ba7f2 100644
--- a/drivers/power/supply/qcom_battmgr.c
+++ b/drivers/power/supply/qcom_battmgr.c
@@ -29,8 +29,9 @@ enum qcom_battmgr_variant {
 #define NOTIF_BAT_PROPERTY		0x30
 #define NOTIF_USB_PROPERTY		0x32
 #define NOTIF_WLS_PROPERTY		0x34
-#define NOTIF_BAT_INFO			0x81
 #define NOTIF_BAT_STATUS		0x80
+#define NOTIF_BAT_INFO			0x81
+#define NOTIF_BAT_CHARGING_STATE	0x83
 
 #define BATTMGR_BAT_INFO		0x9
 
@@ -943,12 +944,14 @@ static void qcom_battmgr_notification(struct qcom_battmgr *battmgr,
 	}
 
 	notification = le32_to_cpu(msg->notification);
+	notification &= 0xff;
 	switch (notification) {
 	case NOTIF_BAT_INFO:
 		battmgr->info.valid = false;
 		fallthrough;
 	case NOTIF_BAT_STATUS:
 	case NOTIF_BAT_PROPERTY:
+	case NOTIF_BAT_CHARGING_STATE:
 		power_supply_changed(battmgr->bat_psy);
 		break;
 	case NOTIF_USB_PROPERTY:
-- 
2.51.0



