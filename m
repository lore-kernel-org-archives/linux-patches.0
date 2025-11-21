Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E500B34D93A;
	Fri, 21 Nov 2025 13:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732485; cv=none; b=uMQPuVmrBBdrjFxGIfsLd37MkSXt4TpVC2KU69MRHTuZVSf0jcVXdFMlcBYrMEsj1SNJ2FBzIGwNwPigk56YKZlfEmTxnnOuvdG3+BOYLmIN+J8B+CgAJ0l6jSUET8b6KbSD1d1ghqEQOD2UTgNTtWWdDDSj6BeXwnndnvqI6YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732485; c=relaxed/simple;
	bh=+1Osw+9FpVQeKY81DTXam5L9Ps4n5guJAVzyTIQbfQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NduvFRG1dyopkVTkyuz59SxkTwxEQfcmhjCfL4BCwQh9dU3jpeRUzniaUKFKsIc9M/GKl535Bm5yUx1WuFjgU/LY/vug/4ydKBmelJuciMW9XMDs4h0+k058knAc0cVBIAjTzrJrlQ85MWOx88cwPPM/WLwKQCMX8NuAsHu+PDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lx+NOZr/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lx+NOZr/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72524C4CEF1;
	Fri, 21 Nov 2025 13:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732484;
	bh=+1Osw+9FpVQeKY81DTXam5L9Ps4n5guJAVzyTIQbfQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lx+NOZr/EvsXrv5nLgGDWr7p+jpMfS+bI8Kg0d60Y8zNvG5gNTuXZqzMlcz+20wy/
	 QVdQOkiugiyaZ3cjJK69nUlXWuHz2ofe7q9qSXOZQ340Zbv7KXbYk4QIA0f/+lG420
	 6UAtFcJJQb75KpzVgT671hfwSi73pU4LdP6ckTc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Fenglin Wu <fenglin.wu@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 094/529] power: supply: qcom_battmgr: handle charging state change notifications
Date: Fri, 21 Nov 2025 14:06:33 +0100
Message-ID: <20251121130234.372844878@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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
index c1cb338e54bbc..0c993780d3ef2 100644
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
 
@@ -940,12 +941,14 @@ static void qcom_battmgr_notification(struct qcom_battmgr *battmgr,
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



