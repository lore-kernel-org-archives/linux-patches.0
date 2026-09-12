Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA986343889;
	Sat, 12 Sep 2026 10:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209222; cv=none; b=Qg2M7ELg8uBWy+41qHdOy6EPoCsCMIiR14HrAVXamvjtej2P4MogGd28PkozXG0/z1gwxVK3LZ/3FxrBKmnEbPM9bThlgti7HfbbJ9vkrHvoqyU58uTTTLAKkF3vsyT5Al5G6k2t/lLsbndWvfUSVzfgdslyOTdqgRpf636A4Os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209222; c=relaxed/simple;
	bh=/+dpH0cegMD3CF+if3fnDMND3f9hbTZfH+pKgKHYbwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JyaaIBzHmvIXjRidMPEZvld2hFUKa0Wp3docV0lwrCXjDVQC/GIFbbsn/BWdFP5g8MeS6FNpzds9Zi1nD6j3dbOgogtiKYvBC21lWmQ9HHnlFgZ+o5sOvWNWP10aV7POAMw7AE44E+3mM/B4T9x0ysjCwJnhlfVCWXcj9131p3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1D/yLwuL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1D/yLwuL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B1C51F000FF;
	Sat, 12 Sep 2026 10:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209221;
	bh=Ip3B0spTRewiSvpuRuS/amKZvdubprYU5Q8MPa3WCJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1D/yLwuLo0EoasM3IDRIUqIxoFa3fy/KA/JUV4VNyK0yaEUdlkPnAsRshrG+G5IHx
	 OGOS836Cmf/UkLVqMc+2n/s6wAgf0eAjdLdwHl65fjBV7Eqetv9CPzC5sAzioPQ+d4
	 ybig/D/0hFOI2VKiavxyfhjgt8QaOwFT1ycF71kQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0775/1518] ASoC: tas2783: Use new SoundWire enumeration helper
Date: Sat, 12 Sep 2026 08:49:04 +0200
Message-ID: <20260912065640.969421737@linuxfoundation.org>
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

[ Upstream commit ac6d4f298160bebf6979e63c2758414af5266f28 ]

Update the driver to use the new core helper that waits for the device
to enumerate on SoundWire and be initialised by the SoundWire core.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260512103022.1154645-19-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: b627da430357 ("ASoC: tas2783-sdw: drop stale regcache on uninitialized re-attach")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2783-sdw.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/sound/soc/codecs/tas2783-sdw.c b/sound/soc/codecs/tas2783-sdw.c
index e273b80d033e1..9203ddb4086ab 100644
--- a/sound/soc/codecs/tas2783-sdw.c
+++ b/sound/soc/codecs/tas2783-sdw.c
@@ -1175,22 +1175,12 @@ static s32 tas2783_sdca_dev_resume(struct device *dev)
 {
 	struct sdw_slave *slave = dev_to_sdw_dev(dev);
 	struct tas2783_prv *tas_dev = dev_get_drvdata(dev);
-	unsigned long t;
+	int ret;
 
-	if (!slave->unattach_request)
-		goto regmap_sync;
-
-	t = wait_for_completion_timeout(&slave->initialization_complete,
-					msecs_to_jiffies(TAS2783_PROBE_TIMEOUT));
-	if (!t) {
-		dev_err(&slave->dev, "resume: initialization timed out\n");
-		sdw_show_ping_status(slave->bus, true);
-		return -ETIMEDOUT;
-	}
-
-	slave->unattach_request = 0;
+	ret = sdw_slave_wait_for_init(slave, TAS2783_PROBE_TIMEOUT);
+	if (ret)
+		return ret;
 
-regmap_sync:
 	regcache_cache_only(tas_dev->regmap, false);
 	regcache_sync(tas_dev->regmap);
 	return 0;
-- 
2.53.0



