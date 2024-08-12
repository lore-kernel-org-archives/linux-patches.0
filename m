Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD27715C127;
	Mon, 12 Aug 2024 16:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480407; cv=none; b=Ruasv64AY/S2S9kzYwXDzOsH/gaVjU8NnJGQJqw3J67Iu12YCiRd1ZI2hQwUxLrAF0XNlJe+giaALK2sPIFwP/C+8/N6L8JwFPQB14Lqnkhd/5h8LWecl1hIP7c7kfkUUcMmBrIzXxfdhNAzqPA4NnP0TVWfEviuFG9XbIb3qgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480407; c=relaxed/simple;
	bh=hX6uzq41yCpOQ+f95tS0fkIj/yye9hNHW4pldUigoo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lc9JHkgf4aZT6vAbrAvxpxAYomeQNaVrv/yS8XiStVmNw120ZlN+nGLZ7Fd32lt0kyZfE/0GbI0wpMXGKq+u6afLwd5Yx6Wxl3KMG+x3mkvMTpSiOB1MGQkjt3a34ws/iu5H9OyVw4enPdYOTea/fykzBDeVRdw/jJeTVaH6XSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G3cegkOQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G3cegkOQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD014C4AF12;
	Mon, 12 Aug 2024 16:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480407;
	bh=hX6uzq41yCpOQ+f95tS0fkIj/yye9hNHW4pldUigoo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G3cegkOQNuxJ0LoWYg4y6gtq3EOSPOL28JircmieLnPw0F/AtLA8KDkWT5FeZjQM5
	 R+w/XXyHhRm6pfUTBjt9lFb0GCFu3jkI9zd+ZC+TsJ4v3ZJadFWJoZ6TTJRc5k0r8s
	 kZiLyqX+xdnaclIRdu42Q5yVR7iYKVKEBtEGyEqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 155/263] ASoC: cs35l56: Handle OTP read latency over SoundWire
Date: Mon, 12 Aug 2024 18:02:36 +0200
Message-ID: <20240812160152.480824015@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit e42066df07c0fcedebb32ed56f8bc39b4bf86337 ]

Use the late-read buffer in the CS35L56 SoundWire interface to
read OTP memory.

The OTP memory has a longer access latency than chip registers
and cannot guarantee to return the data value in the SoundWire
control response if the bus clock is >4.8 MHz. The Cirrus
SoundWire peripheral IP exposes the bridge-to-bus read buffer
and status bits. For a read from OTP the bridge status bits are
polled to wait for the OTP data to be loaded into the read buffer
and the data is then read from there.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: e1830f66f6c6 ("ASoC: cs35l56: Add helper functions for amp calibration")
Link: https://patch.msgid.link/20240805140839.26042-1-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/cs35l56.h        |  5 +++
 sound/soc/codecs/cs35l56-sdw.c | 77 ++++++++++++++++++++++++++++++++++
 2 files changed, 82 insertions(+)

diff --git a/include/sound/cs35l56.h b/include/sound/cs35l56.h
index b0be189bdc000..347959585deb6 100644
--- a/include/sound/cs35l56.h
+++ b/include/sound/cs35l56.h
@@ -279,6 +279,11 @@ static inline int cs35l56_force_sync_asp1_registers_from_cache(struct cs35l56_ba
 	return 0;
 }
 
+static inline bool cs35l56_is_otp_register(unsigned int reg)
+{
+	return (reg >> 16) == 3;
+}
+
 extern struct regmap_config cs35l56_regmap_i2c;
 extern struct regmap_config cs35l56_regmap_spi;
 extern struct regmap_config cs35l56_regmap_sdw;
diff --git a/sound/soc/codecs/cs35l56-sdw.c b/sound/soc/codecs/cs35l56-sdw.c
index 70ff55c1517fe..29a5476af95ae 100644
--- a/sound/soc/codecs/cs35l56-sdw.c
+++ b/sound/soc/codecs/cs35l56-sdw.c
@@ -23,6 +23,79 @@
 /* Register addresses are offset when sent over SoundWire */
 #define CS35L56_SDW_ADDR_OFFSET		0x8000
 
+/* Cirrus bus bridge registers */
+#define CS35L56_SDW_MEM_ACCESS_STATUS	0xd0
+#define CS35L56_SDW_MEM_READ_DATA	0xd8
+
+#define CS35L56_SDW_LAST_LATE		BIT(3)
+#define CS35L56_SDW_CMD_IN_PROGRESS	BIT(2)
+#define CS35L56_SDW_RDATA_RDY		BIT(0)
+
+#define CS35L56_LATE_READ_POLL_US	10
+#define CS35L56_LATE_READ_TIMEOUT_US	1000
+
+static int cs35l56_sdw_poll_mem_status(struct sdw_slave *peripheral,
+				       unsigned int mask,
+				       unsigned int match)
+{
+	int ret, val;
+
+	ret = read_poll_timeout(sdw_read_no_pm, val,
+				(val < 0) || ((val & mask) == match),
+				CS35L56_LATE_READ_POLL_US, CS35L56_LATE_READ_TIMEOUT_US,
+				false, peripheral, CS35L56_SDW_MEM_ACCESS_STATUS);
+	if (ret < 0)
+		return ret;
+
+	if (val < 0)
+		return val;
+
+	return 0;
+}
+
+static int cs35l56_sdw_slow_read(struct sdw_slave *peripheral, unsigned int reg,
+				 u8 *buf, size_t val_size)
+{
+	int ret, i;
+
+	reg += CS35L56_SDW_ADDR_OFFSET;
+
+	for (i = 0; i < val_size; i += sizeof(u32)) {
+		/* Poll for bus bridge idle */
+		ret = cs35l56_sdw_poll_mem_status(peripheral,
+						  CS35L56_SDW_CMD_IN_PROGRESS,
+						  0);
+		if (ret < 0) {
+			dev_err(&peripheral->dev, "!CMD_IN_PROGRESS fail: %d\n", ret);
+			return ret;
+		}
+
+		/* Reading LSByte triggers read of register to holding buffer */
+		sdw_read_no_pm(peripheral, reg + i);
+
+		/* Wait for data available */
+		ret = cs35l56_sdw_poll_mem_status(peripheral,
+						  CS35L56_SDW_RDATA_RDY,
+						  CS35L56_SDW_RDATA_RDY);
+		if (ret < 0) {
+			dev_err(&peripheral->dev, "RDATA_RDY fail: %d\n", ret);
+			return ret;
+		}
+
+		/* Read data from buffer */
+		ret = sdw_nread_no_pm(peripheral, CS35L56_SDW_MEM_READ_DATA,
+				      sizeof(u32), &buf[i]);
+		if (ret) {
+			dev_err(&peripheral->dev, "Late read @%#x failed: %d\n", reg + i, ret);
+			return ret;
+		}
+
+		swab32s((u32 *)&buf[i]);
+	}
+
+	return 0;
+}
+
 static int cs35l56_sdw_read_one(struct sdw_slave *peripheral, unsigned int reg, void *buf)
 {
 	int ret;
@@ -48,6 +121,10 @@ static int cs35l56_sdw_read(void *context, const void *reg_buf,
 	int ret;
 
 	reg = le32_to_cpu(*(const __le32 *)reg_buf);
+
+	if (cs35l56_is_otp_register(reg))
+		return cs35l56_sdw_slow_read(peripheral, reg, buf8, val_size);
+
 	reg += CS35L56_SDW_ADDR_OFFSET;
 
 	if (val_size == 4)
-- 
2.43.0



