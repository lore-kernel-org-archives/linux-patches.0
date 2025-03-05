Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF1014B075;
	Wed,  5 Mar 2025 18:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197622; cv=none; b=EYQRldHBaMB4818+hnisX4K7rmZSn7yAS8ut6Ji20q9mI7ugY/IXvB1ACD449EV68rJ3P2CMvsAXWikUKHwjeedh9JW4UPNeBDkbYQen2HhYKTaJC8fO0shrEM1GrvQtTlqrOz7rOrqT0kkewXjEggwgUbb5AAvzNsULbGc8rYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197622; c=relaxed/simple;
	bh=rQO+uO9SujLCI93z0W8xp0QS/0Zb0NE+vaAlSs8maf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YVo1HrQZb5xwyKoITNgXH49I1aGe/Cj6zFVsnWVKaWkVGvDhwfxg5Ov8lKmM4QmkI7nlfuX0Iavb/VTYyMFsNl4k43ySLduJl8KHP1Bwce7cTEg+DtOqOG/M4DWyrZoTU6Ce0reuLQMnWCEFK2qaw3GD6eX3oK1uTi59HdUPWi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=diKis00v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="diKis00v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F9C5C4CED1;
	Wed,  5 Mar 2025 18:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197621;
	bh=rQO+uO9SujLCI93z0W8xp0QS/0Zb0NE+vaAlSs8maf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=diKis00vZk5/Sbg86MOZTPyGiauswWI8m8eC3KkYdRjYLe9K2ttDqtRa1bQUwAXAn
	 fyabs/EEarp3wI2hYFdSPHrFK3yQ3CtyTU/1Y9JFqiZtYgyBvDVdGN9YGZrny+BuaS
	 K/8tEYSvq1ytOg4llIGkG6X85IX6jVl8iZ82eyCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 035/142] firmware: cs_dsp: Remove async regmap writes
Date: Wed,  5 Mar 2025 18:47:34 +0100
Message-ID: <20250305174501.747364791@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174500.327985489@linuxfoundation.org>
References: <20250305174500.327985489@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit fe08b7d5085a9774abc30c26d5aebc5b9cdd6091 ]

Change calls to async regmap write functions to use the normal
blocking writes so that the cs35l56 driver can use spi_bus_lock() to
gain exclusive access to the SPI bus.

As this is part of a fix, it makes only the minimal change to swap the
functions to the blocking equivalents. There's no need to risk
reworking the buffer allocation logic that is now partially redundant.

The async writes are a 12-year-old workaround for inefficiency of
synchronous writes in the SPI subsystem. The SPI subsystem has since
been changed to avoid the overheads, so this workaround should not be
necessary.

The cs35l56 driver needs to use spi_bus_lock() prevent bus activity
while it is soft-resetting the cs35l56. But spi_bus_lock() is
incompatible with spi_async() calls, which will fail with -EBUSY.

Fixes: 8a731fd37f8b ("ASoC: cs35l56: Move utility functions to shared file")
Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://patch.msgid.link/20250225131843.113752-2-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/cirrus/cs_dsp.c | 24 ++++++------------------
 1 file changed, 6 insertions(+), 18 deletions(-)

diff --git a/drivers/firmware/cirrus/cs_dsp.c b/drivers/firmware/cirrus/cs_dsp.c
index e62ffffe5fb8d..4ce5681be18f0 100644
--- a/drivers/firmware/cirrus/cs_dsp.c
+++ b/drivers/firmware/cirrus/cs_dsp.c
@@ -1562,8 +1562,8 @@ static int cs_dsp_load(struct cs_dsp *dsp, const struct firmware *firmware,
 				goto out_fw;
 			}
 
-			ret = regmap_raw_write_async(regmap, reg, buf->buf,
-						     le32_to_cpu(region->len));
+			ret = regmap_raw_write(regmap, reg, buf->buf,
+					       le32_to_cpu(region->len));
 			if (ret != 0) {
 				cs_dsp_err(dsp,
 					   "%s.%d: Failed to write %d bytes at %d in %s: %d\n",
@@ -1578,12 +1578,6 @@ static int cs_dsp_load(struct cs_dsp *dsp, const struct firmware *firmware,
 		regions++;
 	}
 
-	ret = regmap_async_complete(regmap);
-	if (ret != 0) {
-		cs_dsp_err(dsp, "Failed to complete async write: %d\n", ret);
-		goto out_fw;
-	}
-
 	if (pos > firmware->size)
 		cs_dsp_warn(dsp, "%s.%d: %zu bytes at end of file\n",
 			    file, regions, pos - firmware->size);
@@ -1591,7 +1585,6 @@ static int cs_dsp_load(struct cs_dsp *dsp, const struct firmware *firmware,
 	cs_dsp_debugfs_save_wmfwname(dsp, file);
 
 out_fw:
-	regmap_async_complete(regmap);
 	cs_dsp_buf_free(&buf_list);
 	kfree(text);
 
@@ -2287,8 +2280,8 @@ static int cs_dsp_load_coeff(struct cs_dsp *dsp, const struct firmware *firmware
 			cs_dsp_dbg(dsp, "%s.%d: Writing %d bytes at %x\n",
 				   file, blocks, le32_to_cpu(blk->len),
 				   reg);
-			ret = regmap_raw_write_async(regmap, reg, buf->buf,
-						     le32_to_cpu(blk->len));
+			ret = regmap_raw_write(regmap, reg, buf->buf,
+					       le32_to_cpu(blk->len));
 			if (ret != 0) {
 				cs_dsp_err(dsp,
 					   "%s.%d: Failed to write to %x in %s: %d\n",
@@ -2300,10 +2293,6 @@ static int cs_dsp_load_coeff(struct cs_dsp *dsp, const struct firmware *firmware
 		blocks++;
 	}
 
-	ret = regmap_async_complete(regmap);
-	if (ret != 0)
-		cs_dsp_err(dsp, "Failed to complete async write: %d\n", ret);
-
 	if (pos > firmware->size)
 		cs_dsp_warn(dsp, "%s.%d: %zu bytes at end of file\n",
 			    file, blocks, pos - firmware->size);
@@ -2311,7 +2300,6 @@ static int cs_dsp_load_coeff(struct cs_dsp *dsp, const struct firmware *firmware
 	cs_dsp_debugfs_save_binname(dsp, file);
 
 out_fw:
-	regmap_async_complete(regmap);
 	cs_dsp_buf_free(&buf_list);
 	kfree(text);
 
@@ -2523,8 +2511,8 @@ static int cs_dsp_adsp2_enable_core(struct cs_dsp *dsp)
 {
 	int ret;
 
-	ret = regmap_update_bits_async(dsp->regmap, dsp->base + ADSP2_CONTROL,
-				       ADSP2_SYS_ENA, ADSP2_SYS_ENA);
+	ret = regmap_update_bits(dsp->regmap, dsp->base + ADSP2_CONTROL,
+				 ADSP2_SYS_ENA, ADSP2_SYS_ENA);
 	if (ret != 0)
 		return ret;
 
-- 
2.39.5



