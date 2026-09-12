Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C09343889;
	Sat, 12 Sep 2026 10:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209217; cv=none; b=dyGmMsmxbLlGwg5xELHOtQ3SI0BfvqeUjjrBc+A+F+CWhVsx3aSDmogU8FvUGHZ4A26oi1PxBwm+tA+d96TP8dAoFLSDOwaaTNBew7fJeBesrS0DIBo9sjr6Qpp0IASNv/mO3u23fBJ1sahvOa5fUszedcfIdxEHezn3Gwhw5HA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209217; c=relaxed/simple;
	bh=8waCSu6G2zgfgPwBj6GSDrG98PC8CKObr0nX0Dj3iPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aGuYMTm3cY84o9yhseyQElLT/1A5jTZq69dH/rfhZG8Bfd4RPSRCwxBnxUlq3XdBrcxjoos700hnnV9TbkgUtTCCveTr4/vxN88Xe3u9OJmTmSflsFZoGIYRL0p5CaaV0knNVydjo7hnel5JOhFeJnyChY9lORqO/qc2XkV7WOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gcPvnAdr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gcPvnAdr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 990CE1F0089A;
	Sat, 12 Sep 2026 10:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209216;
	bh=UFVW1uZkqE2jdw/QABpiPEEqGepYGnn27kmrQH2Juo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gcPvnAdr6JlIwgbqC2oHveq0X1b+LvR4uy1mDGpNBU5JOWTLGl72HrhTkntXvgZnW
	 8l5nKHsqNJRgVvqLKzEMg8/+6Biyi4T6S2GWfysY+jFJb1PCtPfp7LoI1jIOJu7RjD
	 ZKE4WqAW/WgAoJUVPxmjN5Qyd7IRg4obJHWzfba4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vinod Koul <vkoul@kernel.org>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0774/1518] soundwire: Add a helper function to wait for device initialisation
Date: Sat, 12 Sep 2026 08:49:03 +0200
Message-ID: <20260912065640.946368345@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 3492e8b494c18028044d4a2e03db5c7331fbd789 ]

Add a new helper function to wait for the device to enumerate
and be initialised by the SoundWire core. Most of the SoundWire
drivers have very similar boiler plate code in their runtime
resume, and that boiler plate tends to access various internals
of the SoundWire structs which is a mild layering violation.

Adding a new core helper function greatly eases both of these
issues.

Acked-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260512103022.1154645-2-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: b627da430357 ("ASoC: tas2783-sdw: drop stale regcache on uninitialized re-attach")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/bus.c       | 31 +++++++++++++++++++++++++++++++
 include/linux/soundwire/sdw.h |  8 ++++++++
 2 files changed, 39 insertions(+)

diff --git a/drivers/soundwire/bus.c b/drivers/soundwire/bus.c
index 14e1351a3f8ae..45d786f379d84 100644
--- a/drivers/soundwire/bus.c
+++ b/drivers/soundwire/bus.c
@@ -1372,6 +1372,37 @@ int sdw_slave_get_current_bank(struct sdw_slave *slave)
 }
 EXPORT_SYMBOL_GPL(sdw_slave_get_current_bank);
 
+/**
+ * sdw_slave_wait_for_init - Wait for device initialisation
+ * @slave: Pointer to the SoundWire peripheral.
+ * @timeout_ms: Timeout in milliseconds.
+ *
+ * Wait for a peripheral device to enumerate and be initialised by the
+ * SoundWire core.
+ *
+ * Return: Zero on success, and a negative error code on failure.
+ */
+int sdw_slave_wait_for_init(struct sdw_slave *slave, int timeout_ms)
+{
+	unsigned long time;
+
+	if (!slave->unattach_request)
+		return 0;
+
+	time = wait_for_completion_timeout(&slave->initialization_complete,
+					   msecs_to_jiffies(timeout_ms));
+	if (!time) {
+		dev_err(&slave->dev, "Initialization not complete\n");
+		sdw_show_ping_status(slave->bus, true);
+		return -ETIMEDOUT;
+	}
+
+	slave->unattach_request = 0;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(sdw_slave_wait_for_init);
+
 static int sdw_slave_set_frequency(struct sdw_slave *slave)
 {
 	int scale_index;
diff --git a/include/linux/soundwire/sdw.h b/include/linux/soundwire/sdw.h
index e6a3476bcef1a..bf2ddd429620f 100644
--- a/include/linux/soundwire/sdw.h
+++ b/include/linux/soundwire/sdw.h
@@ -1093,6 +1093,8 @@ int sdw_slave_get_current_bank(struct sdw_slave *sdev);
 
 int sdw_slave_get_scale_index(struct sdw_slave *slave, u8 *base);
 
+int sdw_slave_wait_for_init(struct sdw_slave *slave, int timeout_ms);
+
 /* messaging and data APIs */
 int sdw_read(struct sdw_slave *slave, u32 addr);
 int sdw_write(struct sdw_slave *slave, u32 addr, u8 value);
@@ -1136,6 +1138,12 @@ static inline int sdw_slave_get_current_bank(struct sdw_slave *sdev)
 	return -EINVAL;
 }
 
+static inline int sdw_slave_wait_for_init(struct sdw_slave *slave, int timeout_ms)
+{
+	WARN_ONCE(1, "SoundWire API is disabled");
+	return -EINVAL;
+}
+
 /* messaging and data APIs */
 static inline int sdw_read(struct sdw_slave *slave, u32 addr)
 {
-- 
2.53.0



