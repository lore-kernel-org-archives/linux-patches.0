Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57E238D6A2;
	Sat, 12 Sep 2026 08:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201256; cv=none; b=f6KjtHxbaA0cmLW7QflMFu8e40y8vmaXITiZ0lH5WKt6xLpYpGtyT+UQsa+Ijo/x7iJiM9rXSVCqq8ZASfnuUzZzH9ebL/7DO9wJRqhemqXaOI8qdJEZ8tsF7w3SjoXBcualibtMz4vbNUx2XX3DjOB0fTyUYsjYqg1omDPxxno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201256; c=relaxed/simple;
	bh=xf3MISqATB05mH1+MT7zyxQtZ5L0PHu7Vp+OVfcMXmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sNZQ9Vk5FisIt8gctiGB3EgOZz7PfOovux5+qKxSdkbuKaDliWpB0FeH2eTXksF/cIlVhEh/gXbExKAYmtb0AZzq4jned28y71gCOkQ3AFM4xtpPYTblxpDiZzosGViSX86wQCv6k4qXuxfTn2y9nTLFKSzU2TwiTxBVlSrP/rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NPeAoK6A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NPeAoK6A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CC781F000FF;
	Sat, 12 Sep 2026 08:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201254;
	bh=j1GjZnYuz+9jk5Zp5C6UE4dbMScM5Ow2UfivV1lXHtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NPeAoK6AaN+iGfbL3/U1h30eLi3MUJTXz1arstLUPtnXrbX3hrlylsBfEkZh2dXdo
	 1xVhKy3tncfqfTdYb5/6ZDBy5la14lVMILSZi2EmaKWTxQbFFl6YN49A3KM5ASGa4L
	 NpMSF0Nsv+Lj3npM/uD5fBWDP2SUU/aQswwFGGWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0916/1815] ASoC: codecs: tas2783-sdw: Propagate regcache_sync() errors
Date: Sat, 12 Sep 2026 08:44:26 +0200
Message-ID: <20260912065710.428247811@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index e5d27266370e2..e0ee5723dbf67 100644
--- a/sound/soc/codecs/tas2783-sdw.c
+++ b/sound/soc/codecs/tas2783-sdw.c
@@ -1098,7 +1098,13 @@ static s32 tas2783_sdca_dev_resume(struct device *dev)
 	}
 
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
 
@@ -1209,6 +1215,7 @@ static s32 tas_update_status(struct sdw_slave *slave,
 {
 	struct tas2783_prv *tas_dev = dev_get_drvdata(&slave->dev);
 	struct device *dev = &slave->dev;
+	int ret;
 
 	dev_dbg(dev, "Peripheral status = %s",
 		status == SDW_SLAVE_UNATTACHED ? "unattached" :
@@ -1226,7 +1233,12 @@ static s32 tas_update_status(struct sdw_slave *slave,
 
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



