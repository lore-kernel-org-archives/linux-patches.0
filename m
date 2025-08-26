Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E3AD3375D9;
	Tue, 26 Aug 2025 11:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207755; cv=none; b=AZR80p+H8tWGUsL2hOVoSDeBuxbfuetpUVIxl9C6qotW6OPuTRtpiUXG7h2/K2pFuXtUlQvqOke10bpU0ZWqxhlMEKMSWhpPvvYZOq0ch8s5GJ/i4R6xYlondKnMYe2+dtI3EoS2dy3EoOk+GYIAxpChfgA4twkdlqGWSQKRmzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207755; c=relaxed/simple;
	bh=xB0BnQ74jhWQuAkzZPJB6pe63ashfLznKUJxh31lOj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cTY/VfKw5GyeuXfD4TOEzk1BDegF/5ciDvPAPo//o4yxtcwXjvhJAOZ+qUVpSbsYyc8ILl3t7FKzrFeB2MRMaCiEL7PSg8aFCVNzA9/Eg550OBJ7dX9AI89JRzg8vTHTYZpJC4l0ofzxlzJ5pEnlMif2cAcb2nEaV2gflZ70EJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mCTbw5PF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mCTbw5PF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 234D2C4CEF1;
	Tue, 26 Aug 2025 11:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207755;
	bh=xB0BnQ74jhWQuAkzZPJB6pe63ashfLznKUJxh31lOj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mCTbw5PF5eFsJWgPV9QNIcK2HU7cjRFUpR/zO5Y+/rkCUVUPbLL6tS/Qw9fVUE425
	 SMCMErNPd1tKriFuhJOEySxn0FhD2yEO440cxiYA4ZCnnsMDsluJ+D+cUutiFqsNXo
	 Z+Y1mWWbKEiwCvxYlGt9io7ZViTcTiBu6jEen3sg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.16 304/457] iio: adc: ad7173: prevent scan if too many setups requested
Date: Tue, 26 Aug 2025 13:09:48 +0200
Message-ID: <20250826110944.883749714@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

commit 1cfb22c277c7274f54babaa5b416dfbc00181e16 upstream.

Add a check to ad7173_update_scan_mode() to ensure that we didn't exceed
the maximum number of unique channel configurations.

In the AD7173 family of chips, there are some chips that have 16
CHANNELx registers but only 8 setups (combination of CONFIGx, FILTERx,
GAINx and OFFSETx registers). Since commit 92c247216918 ("iio: adc:
ad7173: fix num_slots"), it is possible to have more than 8 channels
enabled in a scan at the same time, so it is possible to get a bad
configuration when more than 8 channels are using unique configurations.
This happens because the algorithm to allocate the setup slots only
takes into account which slot has been least recently used and doesn't
know about the maximum number of slots available.

Since the algorithm to allocate the setup slots is quite complex, it is
simpler to check after the fact if the current state is valid or not.
So this patch adds a check in ad7173_update_scan_mode() after setting up
all of the configurations to make sure that the actual setup still
matches the requested setup for each enabled channel. If not, we prevent
the scan from being enabled and return an error.

The setup comparison in ad7173_setup_equal() is refactored to a separate
function since we need to call it in two places now.

Fixes: 92c247216918 ("iio: adc: ad7173: fix num_slots")
Signed-off-by: David Lechner <dlechner@baylibre.com>
Link: https://patch.msgid.link/20250722-iio-adc-ad7173-fix-setup-use-limits-v2-1-8e96bdb72a9c@baylibre.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7173.c |   87 ++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 75 insertions(+), 12 deletions(-)

--- a/drivers/iio/adc/ad7173.c
+++ b/drivers/iio/adc/ad7173.c
@@ -200,7 +200,7 @@ struct ad7173_channel_config {
 	/*
 	 * Following fields are used to compare equality. If you
 	 * make adaptations in it, you most likely also have to adapt
-	 * ad7173_find_live_config(), too.
+	 * ad7173_is_setup_equal(), too.
 	 */
 	struct_group(config_props,
 		bool bipolar;
@@ -562,12 +562,19 @@ static void ad7173_reset_usage_cnts(stru
 	st->config_usage_counter = 0;
 }
 
-static struct ad7173_channel_config *
-ad7173_find_live_config(struct ad7173_state *st, struct ad7173_channel_config *cfg)
+/**
+ * ad7173_is_setup_equal - Compare two channel setups
+ * @cfg1: First channel configuration
+ * @cfg2: Second channel configuration
+ *
+ * Compares all configuration options that affect the registers connected to
+ * SETUP_SEL, namely CONFIGx, FILTERx, GAINx and OFFSETx.
+ *
+ * Returns: true if the setups are identical, false otherwise
+ */
+static bool ad7173_is_setup_equal(const struct ad7173_channel_config *cfg1,
+				  const struct ad7173_channel_config *cfg2)
 {
-	struct ad7173_channel_config *cfg_aux;
-	int i;
-
 	/*
 	 * This is just to make sure that the comparison is adapted after
 	 * struct ad7173_channel_config was changed.
@@ -580,14 +587,22 @@ ad7173_find_live_config(struct ad7173_st
 				     u8 ref_sel;
 			     }));
 
+	return cfg1->bipolar == cfg2->bipolar &&
+	       cfg1->input_buf == cfg2->input_buf &&
+	       cfg1->odr == cfg2->odr &&
+	       cfg1->ref_sel == cfg2->ref_sel;
+}
+
+static struct ad7173_channel_config *
+ad7173_find_live_config(struct ad7173_state *st, struct ad7173_channel_config *cfg)
+{
+	struct ad7173_channel_config *cfg_aux;
+	int i;
+
 	for (i = 0; i < st->num_channels; i++) {
 		cfg_aux = &st->channels[i].cfg;
 
-		if (cfg_aux->live &&
-		    cfg->bipolar == cfg_aux->bipolar &&
-		    cfg->input_buf == cfg_aux->input_buf &&
-		    cfg->odr == cfg_aux->odr &&
-		    cfg->ref_sel == cfg_aux->ref_sel)
+		if (cfg_aux->live && ad7173_is_setup_equal(cfg, cfg_aux))
 			return cfg_aux;
 	}
 	return NULL;
@@ -1229,7 +1244,7 @@ static int ad7173_update_scan_mode(struc
 				   const unsigned long *scan_mask)
 {
 	struct ad7173_state *st = iio_priv(indio_dev);
-	int i, ret;
+	int i, j, k, ret;
 
 	for (i = 0; i < indio_dev->num_channels; i++) {
 		if (test_bit(i, scan_mask))
@@ -1240,6 +1255,54 @@ static int ad7173_update_scan_mode(struc
 			return ret;
 	}
 
+	/*
+	 * On some chips, there are more channels that setups, so if there were
+	 * more unique setups requested than the number of available slots,
+	 * ad7173_set_channel() will have written over some of the slots. We
+	 * can detect this by making sure each assigned cfg_slot matches the
+	 * requested configuration. If it doesn't, we know that the slot was
+	 * overwritten by a different channel.
+	 */
+	for_each_set_bit(i, scan_mask, indio_dev->num_channels) {
+		const struct ad7173_channel_config *cfg1, *cfg2;
+
+		cfg1 = &st->channels[i].cfg;
+
+		for_each_set_bit(j, scan_mask, indio_dev->num_channels) {
+			cfg2 = &st->channels[j].cfg;
+
+			/*
+			 * Only compare configs that are assigned to the same
+			 * SETUP_SEL slot and don't compare channel to itself.
+			 */
+			if (i == j || cfg1->cfg_slot != cfg2->cfg_slot)
+				continue;
+
+			/*
+			 * If we find two different configs trying to use the
+			 * same SETUP_SEL slot, then we know that the that we
+			 * have too many unique configurations requested for
+			 * the available slots and at least one was overwritten.
+			 */
+			if (!ad7173_is_setup_equal(cfg1, cfg2)) {
+				/*
+				 * At this point, there isn't a way to tell
+				 * which setups are actually programmed in the
+				 * ADC anymore, so we could read them back to
+				 * see, but it is simpler to just turn off all
+				 * of the live flags so that everything gets
+				 * reprogramed on the next attempt read a sample.
+				 */
+				for (k = 0; k < st->num_channels; k++)
+					st->channels[k].cfg.live = false;
+
+				dev_err(&st->sd.spi->dev,
+					"Too many unique channel configurations requested for scan\n");
+				return -EINVAL;
+			}
+		}
+	}
+
 	return 0;
 }
 


