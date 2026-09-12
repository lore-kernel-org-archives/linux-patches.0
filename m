Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D20343889;
	Sat, 12 Sep 2026 10:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209227; cv=none; b=A7L0JVLpK0APsqvD6uqYyxnPjSClHuTH2Q34tuxxnM3iZZToe21nyvbi7EcPmk/rk0Wwb8Aqvwpu6I2tPxFqAPcI3AsLkM/IsTdNfEK+Wxxnf3awctPVOtTGmix5stADkfn9MoZEHmqQcu5yEG2ISZIR0hqkMJLk9Iykv2XY0a8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209227; c=relaxed/simple;
	bh=7orv4dpn5TciRkjcbiNhN+ElehdJpkcifnPPLHlem0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cHOcNUKOtJKoZZOF3EHUg7LXL7MJDUMHuarvfveX/JS+LooJ32ipnK9q/jv3+a8U8EFPcsS2ruleyrwAOnNiAwYuadhl3YVC2pIVVC2+3Jb+VaquMp2U7QntWGfZWN4c3HQDMuF8at9uHK2QO+Xb/usUcCOAHOFOowa4V7FlNpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=poFUpaBo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="poFUpaBo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA29B1F000FF;
	Sat, 12 Sep 2026 10:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209226;
	bh=MHPU534pII+zz9HUuKfdStg+jeBd4SCiatGpCXIm/+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=poFUpaBoDIvr0HEYA3NNwsjDncmXfdfJ87+ZkkQzlBtGblteay1Y9Ts2/IbILWvDC
	 wk+8eAymSER/nzAWOjzcLCheL/3D+psmbznwogtK5dfCLcpq7jUmnM+OM3KZHPyv8d
	 9ODlRMcjGyUqdNGQZQN0J623ZEzGX6pwMWi7+t3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0776/1518] ASoC: codecs: tas2783-sdw: Propagate regcache_sync() errors
Date: Sat, 12 Sep 2026 08:49:05 +0200
Message-ID: <20260912065640.991927819@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 0d6b2d6f93a6715827a9b3c027cd8448d76e0e47 ]

regcache_sync() can fail while replaying cached register state after
SoundWire resume or attach handling. tas2783 currently ignores that
failure.

Propagate the error and restore cache-only/dirty state on failure.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260704035746.82560-1-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: b627da430357 ("ASoC: tas2783-sdw: drop stale regcache on uninitialized re-attach")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2783-sdw.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/tas2783-sdw.c b/sound/soc/codecs/tas2783-sdw.c
index 9203ddb4086ab..2659e8b0c30ca 100644
--- a/sound/soc/codecs/tas2783-sdw.c
+++ b/sound/soc/codecs/tas2783-sdw.c
@@ -1182,7 +1182,13 @@ static s32 tas2783_sdca_dev_resume(struct device *dev)
 		return ret;
 
 	regcache_cache_only(tas_dev->regmap, false);
-	regcache_sync(tas_dev->regmap);
+	ret = regcache_sync(tas_dev->regmap);
+	if (ret) {
+		regcache_cache_only(tas_dev->regmap, true);
+		regcache_mark_dirty(tas_dev->regmap);
+		return ret;
+	}
+
 	return 0;
 }
 
@@ -1234,6 +1240,7 @@ static s32 tas_update_status(struct sdw_slave *slave,
 {
 	struct tas2783_prv *tas_dev = dev_get_drvdata(&slave->dev);
 	struct device *dev = &slave->dev;
+	int ret;
 
 	dev_dbg(dev, "Peripheral status = %s",
 		status == SDW_SLAVE_UNATTACHED ? "unattached" :
@@ -1251,7 +1258,12 @@ static s32 tas_update_status(struct sdw_slave *slave,
 
 	/* updated the cache data to device */
 	regcache_cache_only(tas_dev->regmap, false);
-	regcache_sync(tas_dev->regmap);
+	ret = regcache_sync(tas_dev->regmap);
+	if (ret) {
+		regcache_cache_only(tas_dev->regmap, true);
+		regcache_mark_dirty(tas_dev->regmap);
+		return ret;
+	}
 
 	/* perform I/O transfers required for Slave initialization */
 	return tas_io_init(&slave->dev, slave);
-- 
2.53.0



