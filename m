Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 013DF1A616E;
	Tue, 30 Jul 2024 16:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356828; cv=none; b=vDltLAhjEDyanA8YrO8oL60tDtvWiml4PaGdotMufROhhbk2Q7SF4uQAtLfLzKvkztR4pvAWN5b4nc/7Un2wyYYS3hg88CytA9ucrSaz94qR+M+YwDqEKdS1mZS1uyo1ADTkRctqXWs2duDGfXELORnoViGfErrkp30dKYgqDR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356828; c=relaxed/simple;
	bh=4CoCHLi9i6ufcYuA84GvHbpqN7Y7oWJgWZYP2CWA7wc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k9SJDA+INxZeFb+KXPBmt3P284BcXlxl0oRklf8O2Mt7mSjrxgPBxftpTJjJLAP2rJ/R7csq6MZ7FzQsRGOcbPje8s1PwdfMR9BNEkGbCTr50UaQyn/pkQkH6um2rg7qSpkh/TddNuw83m+xNt9A8xYa00xCOigo2O550SdzEwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v3Wc7YCn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v3Wc7YCn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D709C32782;
	Tue, 30 Jul 2024 16:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356827;
	bh=4CoCHLi9i6ufcYuA84GvHbpqN7Y7oWJgWZYP2CWA7wc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v3Wc7YCnj5pROOrLsDEWPGtsXhJBoKKjM+hE63wDZQ84aphYd8qdCpKL/0R8NpCO+
	 JdGmRrK6dXuUuYGzaIsWpyPZziRdGpwcS6KBOI3/ti1CDTfuEVOc9y5uQ3KHRm/EVE
	 rFACJ+UR7hPpzm/lJwmP3hVN11D9h+417OTf1sQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuro Chung <kuro.chung@ite.com.tw>,
	Hermes Wu <hermes.wu@ite.com.tw>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 188/568] drm/bridge: it6505: fix hibernate to resume no display issue
Date: Tue, 30 Jul 2024 17:44:55 +0200
Message-ID: <20240730151647.225523272@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Kuro Chung <kuro.chung@ite.com.tw>

[ Upstream commit 484436ec5c2bffe8f346a09ae1cbc4cbf5e50005 ]

When the system power resumes, the TTL input of IT6505 may experience
some noise before the video signal stabilizes, necessitating a video
reset. This patch is implemented to prevent a loop of video error
interrupts, which can occur when a video reset in the video FIFO error
interrupt triggers another such interrupt. The patch processes the SCDT
and FIFO error interrupts simultaneously and ignores any video FIFO
error interrupts caused by a video reset.

Fixes: b5c84a9edcd4 ("drm/bridge: add it6505 driver")
Signed-off-by: Kuro Chung <kuro.chung@ite.com.tw>
Signed-off-by: Hermes Wu <hermes.wu@ite.com.tw>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240522065528.1053439-1-kuro.chung@ite.com.tw
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ite-it6505.c | 73 +++++++++++++++++++----------
 1 file changed, 49 insertions(+), 24 deletions(-)

diff --git a/drivers/gpu/drm/bridge/ite-it6505.c b/drivers/gpu/drm/bridge/ite-it6505.c
index b589136ca6da9..4ad527fe04f27 100644
--- a/drivers/gpu/drm/bridge/ite-it6505.c
+++ b/drivers/gpu/drm/bridge/ite-it6505.c
@@ -1306,9 +1306,15 @@ static void it6505_video_reset(struct it6505 *it6505)
 	it6505_link_reset_step_train(it6505);
 	it6505_set_bits(it6505, REG_DATA_MUTE_CTRL, EN_VID_MUTE, EN_VID_MUTE);
 	it6505_set_bits(it6505, REG_INFOFRAME_CTRL, EN_VID_CTRL_PKT, 0x00);
-	it6505_set_bits(it6505, REG_RESET_CTRL, VIDEO_RESET, VIDEO_RESET);
+
+	it6505_set_bits(it6505, REG_VID_BUS_CTRL1, TX_FIFO_RESET, TX_FIFO_RESET);
+	it6505_set_bits(it6505, REG_VID_BUS_CTRL1, TX_FIFO_RESET, 0x00);
+
 	it6505_set_bits(it6505, REG_501_FIFO_CTRL, RST_501_FIFO, RST_501_FIFO);
 	it6505_set_bits(it6505, REG_501_FIFO_CTRL, RST_501_FIFO, 0x00);
+
+	it6505_set_bits(it6505, REG_RESET_CTRL, VIDEO_RESET, VIDEO_RESET);
+	usleep_range(1000, 2000);
 	it6505_set_bits(it6505, REG_RESET_CTRL, VIDEO_RESET, 0x00);
 }
 
@@ -2244,12 +2250,11 @@ static void it6505_link_training_work(struct work_struct *work)
 	if (ret) {
 		it6505->auto_train_retry = AUTO_TRAIN_RETRY;
 		it6505_link_train_ok(it6505);
-		return;
 	} else {
 		it6505->auto_train_retry--;
+		it6505_dump(it6505);
 	}
 
-	it6505_dump(it6505);
 }
 
 static void it6505_plugged_status_to_codec(struct it6505 *it6505)
@@ -2470,31 +2475,53 @@ static void it6505_irq_link_train_fail(struct it6505 *it6505)
 	schedule_work(&it6505->link_works);
 }
 
-static void it6505_irq_video_fifo_error(struct it6505 *it6505)
+static bool it6505_test_bit(unsigned int bit, const unsigned int *addr)
 {
-	struct device *dev = it6505->dev;
-
-	DRM_DEV_DEBUG_DRIVER(dev, "video fifo overflow interrupt");
-	it6505->auto_train_retry = AUTO_TRAIN_RETRY;
-	flush_work(&it6505->link_works);
-	it6505_stop_hdcp(it6505);
-	it6505_video_reset(it6505);
+	return 1 & (addr[bit / BITS_PER_BYTE] >> (bit % BITS_PER_BYTE));
 }
 
-static void it6505_irq_io_latch_fifo_overflow(struct it6505 *it6505)
+static void it6505_irq_video_handler(struct it6505 *it6505, const int *int_status)
 {
 	struct device *dev = it6505->dev;
+	int reg_0d, reg_int03;
 
-	DRM_DEV_DEBUG_DRIVER(dev, "IO latch fifo overflow interrupt");
-	it6505->auto_train_retry = AUTO_TRAIN_RETRY;
-	flush_work(&it6505->link_works);
-	it6505_stop_hdcp(it6505);
-	it6505_video_reset(it6505);
-}
+	/*
+	 * When video SCDT change with video not stable,
+	 * Or video FIFO error, need video reset
+	 */
 
-static bool it6505_test_bit(unsigned int bit, const unsigned int *addr)
-{
-	return 1 & (addr[bit / BITS_PER_BYTE] >> (bit % BITS_PER_BYTE));
+	if ((!it6505_get_video_status(it6505) &&
+	     (it6505_test_bit(INT_SCDT_CHANGE, (unsigned int *)int_status))) ||
+	    (it6505_test_bit(BIT_INT_IO_FIFO_OVERFLOW,
+			     (unsigned int *)int_status)) ||
+	    (it6505_test_bit(BIT_INT_VID_FIFO_ERROR,
+			     (unsigned int *)int_status))) {
+		it6505->auto_train_retry = AUTO_TRAIN_RETRY;
+		flush_work(&it6505->link_works);
+		it6505_stop_hdcp(it6505);
+		it6505_video_reset(it6505);
+
+		usleep_range(10000, 11000);
+
+		/*
+		 * Clear FIFO error IRQ to prevent fifo error -> reset loop
+		 * HW will trigger SCDT change IRQ again when video stable
+		 */
+
+		reg_int03 = it6505_read(it6505, INT_STATUS_03);
+		reg_0d = it6505_read(it6505, REG_SYSTEM_STS);
+
+		reg_int03 &= (BIT(INT_VID_FIFO_ERROR) | BIT(INT_IO_LATCH_FIFO_OVERFLOW));
+		it6505_write(it6505, INT_STATUS_03, reg_int03);
+
+		DRM_DEV_DEBUG_DRIVER(dev, "reg08 = 0x%02x", reg_int03);
+		DRM_DEV_DEBUG_DRIVER(dev, "reg0D = 0x%02x", reg_0d);
+
+		return;
+	}
+
+	if (it6505_test_bit(INT_SCDT_CHANGE, (unsigned int *)int_status))
+		it6505_irq_scdt(it6505);
 }
 
 static irqreturn_t it6505_int_threaded_handler(int unused, void *data)
@@ -2507,15 +2534,12 @@ static irqreturn_t it6505_int_threaded_handler(int unused, void *data)
 	} irq_vec[] = {
 		{ BIT_INT_HPD, it6505_irq_hpd },
 		{ BIT_INT_HPD_IRQ, it6505_irq_hpd_irq },
-		{ BIT_INT_SCDT, it6505_irq_scdt },
 		{ BIT_INT_HDCP_FAIL, it6505_irq_hdcp_fail },
 		{ BIT_INT_HDCP_DONE, it6505_irq_hdcp_done },
 		{ BIT_INT_AUX_CMD_FAIL, it6505_irq_aux_cmd_fail },
 		{ BIT_INT_HDCP_KSV_CHECK, it6505_irq_hdcp_ksv_check },
 		{ BIT_INT_AUDIO_FIFO_ERROR, it6505_irq_audio_fifo_error },
 		{ BIT_INT_LINK_TRAIN_FAIL, it6505_irq_link_train_fail },
-		{ BIT_INT_VID_FIFO_ERROR, it6505_irq_video_fifo_error },
-		{ BIT_INT_IO_FIFO_OVERFLOW, it6505_irq_io_latch_fifo_overflow },
 	};
 	int int_status[3], i;
 
@@ -2545,6 +2569,7 @@ static irqreturn_t it6505_int_threaded_handler(int unused, void *data)
 			if (it6505_test_bit(irq_vec[i].bit, (unsigned int *)int_status))
 				irq_vec[i].handler(it6505);
 		}
+		it6505_irq_video_handler(it6505, (unsigned int *)int_status);
 	}
 
 	pm_runtime_put_sync(dev);
-- 
2.43.0



