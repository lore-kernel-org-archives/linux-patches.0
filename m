Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF3DA14600E;
	Thu, 11 Apr 2024 10:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832442; cv=none; b=BKVGcnpDrls58ZMJBOTYotADFv5drUAqZXD9F9pWJZhAMCP+naEmDtWFNUr/AO2hBNI2aLm2eNFllkUzLVtqemKTkXBHvXZa4mZuUMvFp0iK+nUgy/OsW8/f3szkyDAnJe0mbWI5llH6yeaIs6nRo7Hd6LLYHcN5Dl/zQikQTjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832442; c=relaxed/simple;
	bh=l9KZbiRRhulvlJhTg/YbSR38kK4xFqDVYboyOjoQlA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Yzhqx0WRRwOubrjbhZHwSbQnBk1B3m/+CMy37NYQ2ItA24UVAq7+Ltoz7Bd8R32rk5ZDAdPnonmz1mMdjCbr5rkGzlakvtonqKemS6KV/Mydpmz7/yb+8ZuZfxqDQv1vmHUrdm3pTNNMxeJiHWR/Af1gkJ1WFFzk34zody2we0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rk0uVjht; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rk0uVjht"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46844C43390;
	Thu, 11 Apr 2024 10:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832442;
	bh=l9KZbiRRhulvlJhTg/YbSR38kK4xFqDVYboyOjoQlA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rk0uVjht1Gh1JPJoT2tzjwC/GFSNYqim1cAhNsw24tdVHBERaCKoBcpoByqus9yyE
	 z426oWwhRItIjHSUhgPT6PS5WmgJQln0V/sO3WhuGip6JdMGPohHe2g1Zn3JWi3j0z
	 F57m2s4G5v9QTIKNYIUEgPh0dHf8F2ly6hFWS/8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Duje=20Mihanovi=C4=87?= <duje.mihanovic@skole.hr>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 51/83] Input: imagis - use FIELD_GET where applicable
Date: Thu, 11 Apr 2024 11:57:23 +0200
Message-ID: <20240411095414.220318172@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095412.671665933@linuxfoundation.org>
References: <20240411095412.671665933@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Duje Mihanović <duje.mihanovic@skole.hr>

[ Upstream commit c0ca3dbd03d66c6b9e044f48720e6ab5cef37ae5 ]

Instead of manually extracting certain bits from registers with binary
ANDs and shifts, the FIELD_GET macro can be used. With this in mind, the
*_SHIFT macros can be dropped.

Signed-off-by: Duje Mihanović <duje.mihanovic@skole.hr>
Link: https://lore.kernel.org/r/20240306-b4-imagis-keys-v3-1-2c429afa8420@skole.hr
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/imagis.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/input/touchscreen/imagis.c b/drivers/input/touchscreen/imagis.c
index b667914a44f1d..2636e1c9435d8 100644
--- a/drivers/input/touchscreen/imagis.c
+++ b/drivers/input/touchscreen/imagis.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 
+#include <linux/bitfield.h>
 #include <linux/bits.h>
 #include <linux/delay.h>
 #include <linux/i2c.h>
@@ -23,12 +24,9 @@
 #define IST3038C_I2C_RETRY_COUNT	3
 #define IST3038C_MAX_FINGER_NUM		10
 #define IST3038C_X_MASK			GENMASK(23, 12)
-#define IST3038C_X_SHIFT		12
 #define IST3038C_Y_MASK			GENMASK(11, 0)
 #define IST3038C_AREA_MASK		GENMASK(27, 24)
-#define IST3038C_AREA_SHIFT		24
 #define IST3038C_FINGER_COUNT_MASK	GENMASK(15, 12)
-#define IST3038C_FINGER_COUNT_SHIFT	12
 #define IST3038C_FINGER_STATUS_MASK	GENMASK(9, 0)
 
 struct imagis_ts {
@@ -92,8 +90,7 @@ static irqreturn_t imagis_interrupt(int irq, void *dev_id)
 		goto out;
 	}
 
-	finger_count = (intr_message & IST3038C_FINGER_COUNT_MASK) >>
-				IST3038C_FINGER_COUNT_SHIFT;
+	finger_count = FIELD_GET(IST3038C_FINGER_COUNT_MASK, intr_message);
 	if (finger_count > IST3038C_MAX_FINGER_NUM) {
 		dev_err(&ts->client->dev,
 			"finger count %d is more than maximum supported\n",
@@ -101,7 +98,7 @@ static irqreturn_t imagis_interrupt(int irq, void *dev_id)
 		goto out;
 	}
 
-	finger_pressed = intr_message & IST3038C_FINGER_STATUS_MASK;
+	finger_pressed = FIELD_GET(IST3038C_FINGER_STATUS_MASK, intr_message);
 
 	for (i = 0; i < finger_count; i++) {
 		error = imagis_i2c_read_reg(ts,
@@ -118,12 +115,11 @@ static irqreturn_t imagis_interrupt(int irq, void *dev_id)
 		input_mt_report_slot_state(ts->input_dev, MT_TOOL_FINGER,
 					   finger_pressed & BIT(i));
 		touchscreen_report_pos(ts->input_dev, &ts->prop,
-				       (finger_status & IST3038C_X_MASK) >>
-						IST3038C_X_SHIFT,
-				       finger_status & IST3038C_Y_MASK, 1);
+				       FIELD_GET(IST3038C_X_MASK, finger_status),
+				       FIELD_GET(IST3038C_Y_MASK, finger_status),
+				       true);
 		input_report_abs(ts->input_dev, ABS_MT_TOUCH_MAJOR,
-				 (finger_status & IST3038C_AREA_MASK) >>
-					IST3038C_AREA_SHIFT);
+				 FIELD_GET(IST3038C_AREA_MASK, finger_status));
 	}
 
 	input_mt_sync_frame(ts->input_dev);
-- 
2.43.0



