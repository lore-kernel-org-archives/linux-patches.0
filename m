Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0EEB38F259;
	Sat, 12 Sep 2026 08:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201261; cv=none; b=jztqMAyJZl1alYreajIGPii2QjPRRMFy/AdCBHKP1ttlLPXuh0Ms3zGtzSmEurzPNqcjm/CykaYhgNT3NuVjDZ0RaB598Bijkf96niHZIbB21eI/nqQTNFNbSgM+tClsU9ZQGoCR61/lHQT2wDB1R3tcmvEtoLjFH41c5SvmXgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201261; c=relaxed/simple;
	bh=ugbC6Fy89PcS9JiISXzGOFB2IcC2wk4ZXaio5ItDiDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VOD+s0pR3uUUvpZ6WBUGsuyTpz+NWkvPAeNSKYo03cxmubv3IwgUhDqbUX/dLIS4uRfraHAcjrqOBlFUAgw9fP0YGySmYsw2sw3yS+vLFmi7s/iN4wXH5ozsGQvgjS8fmq6qnmQHujTq68kTgpZ1HCrBUntAtVtPVTdGYEvOREU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MDyf01LU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MDyf01LU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 769701F000FF;
	Sat, 12 Sep 2026 08:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201259;
	bh=zkva4dLZVlWXWeIHlR6RVVa7fSLUGiNwKxrlC/KjxV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MDyf01LUHd0YgBbMBoNQpAdP/XQPBq+CpzmtQXkbIxmLY/f3KCu3xSmi/+ZL28xH3
	 XeLySNwX69hkSEnm7gciRJezwWOXX2SxfembUOOw3BpfbzeBZAcW8zPkZqYbwXDjtx
	 a8QULrhucIcNjihZ17sqtJnXQDTZWIGgtcEpGFGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoine Monnet <antoine@montane.tech>,
	Andrey Golovko <andrey.golovko@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0917/1815] ASoC: tas2783-sdw: drop stale regcache on uninitialized re-attach
Date: Sat, 12 Sep 2026 08:44:27 +0200
Message-ID: <20260912065710.453568776@linuxfoundation.org>
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

From: Andrey Golovko <andrey.golovko@gmail.com>

[ Upstream commit b627da43035744ca4d691fbf56eef60268319873 ]

When the peripheral re-attaches after the SoundWire controller was
power-gated during system suspend (s2idle reaching S0i3 on AMD ACP), the
amplifier has lost all of its register and DSP state. tas_update_status()
handles that by re-running tas_io_init(), which writes the device's
TAS2783_SW_RESET register - a vendor register write that clears the
device's register file and DSP state, not a SoundWire reset, so no
re-enumeration is involved - and re-downloads the firmware. Before doing
any of that, it syncs back a register cache that still holds the
pre-suspend values.

That sync is useless, since the reset immediately wipes whatever it
wrote, and it leaves the cache claiming that the amplifier is already
powered up and unmuted. Subsequent read-modify-write updates - DAPM
amplifier power-up, SDCA PDE transitions at stream start - then see "no
change" and skip the hardware write. Playback runs without a single
error while the speakers stay silent. Unbinding and rebinding the driver
restores audio, since probe starts from a fresh cache.

Drop the cache instead of syncing it when an uninitialized device
attaches, so that later accesses see the real hardware state.

Reordering the sync after tas_io_init() and marking the cache dirty is
not a workable alternative here: tas_regmap has no .writeable_reg, so
the cache accepts every register up to .max_register, including ones for
which tas2783_sdca_mbq_size() returns 0. regmap_sdw_mbq_size() rejects
those with -EINVAL, so the replay fails on the first such register and
takes initialization down with it.

Cached user settings fall back to hardware defaults across such a power
loss, which seems clearly preferable to a silent amplifier - the device
is being reset and its firmware reloaded at this point anyway.

Tested on an ASUS ProArt PX13 HN7306EAC (AMD Strix Halo, ACP7.0, two
TAS2783 amplifiers plus RT721 on SoundWire link 1): the speakers work
after an s2idle resume with ~51 s of S0i3 residency, where previously
they stayed silent despite a complete firmware re-download.

Fixes: 4cc9bd8d7b32 ("ASoc: tas2783A: Add soundwire based codec driver")
Reported-by: Antoine Monnet <antoine@montane.tech>
Closes: https://lore.kernel.org/all/c66ae00a-e878-4af0-a05a-272e9574eaa5@montane.tech/
Signed-off-by: Andrey Golovko <andrey.golovko@gmail.com>
Link: https://patch.msgid.link/3e2751d1fb027bed0f09c88e5e56da8f@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2783-sdw.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/sound/soc/codecs/tas2783-sdw.c b/sound/soc/codecs/tas2783-sdw.c
index e0ee5723dbf67..4fbbf2ca5bf9a 100644
--- a/sound/soc/codecs/tas2783-sdw.c
+++ b/sound/soc/codecs/tas2783-sdw.c
@@ -1215,7 +1215,6 @@ static s32 tas_update_status(struct sdw_slave *slave,
 {
 	struct tas2783_prv *tas_dev = dev_get_drvdata(&slave->dev);
 	struct device *dev = &slave->dev;
-	int ret;
 
 	dev_dbg(dev, "Peripheral status = %s",
 		status == SDW_SLAVE_UNATTACHED ? "unattached" :
@@ -1231,14 +1230,23 @@ static s32 tas_update_status(struct sdw_slave *slave,
 	if (tas_dev->hw_init || tas_dev->status != SDW_SLAVE_ATTACHED)
 		return 0;
 
-	/* updated the cache data to device */
 	regcache_cache_only(tas_dev->regmap, false);
-	ret = regcache_sync(tas_dev->regmap);
-	if (ret) {
-		regcache_cache_only(tas_dev->regmap, true);
-		regcache_mark_dirty(tas_dev->regmap);
-		return ret;
-	}
+
+	/*
+	 * The device is attaching uninitialized: either this is the first
+	 * attach, or it lost power (and with it all register and DSP state)
+	 * while the controller was power-gated during system suspend. The
+	 * cache still holds the pre-suspend values, and tas_io_init() below
+	 * resets the device via TAS2783_SW_RESET anyway, so syncing it back
+	 * is both useless and harmful: later read-modify-write updates would
+	 * compare against stale data and skip the hardware write.
+	 *
+	 * Drop the cache instead, so that subsequent accesses see the real
+	 * hardware state. Syncing after the reset is not an option either:
+	 * the cache accepts registers for which tas2783_sdca_mbq_size()
+	 * returns 0, and writing those back fails with -EINVAL.
+	 */
+	regcache_drop_region(tas_dev->regmap, 0, UINT_MAX);
 
 	/* perform I/O transfers required for Slave initialization */
 	return tas_io_init(&slave->dev, slave);
-- 
2.53.0



