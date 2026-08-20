Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D0237AA7D;
	Thu, 20 Aug 2026 17:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247622; cv=none; b=olRhaesZq0S2g6rh/Z/2PTQ2qBL8x9HZkYag2qHcOr/1X80rw/GCubhJ9jLmmVB2xxfyR3qgVQZ2AhlcRFuCclzj30KXDN3bIkEwOGwr4zoiaiE9S8m+HY5LXSq0x9voqNvWOC8176GPoY667lzHrciJ5J49TPeYd+70f1A0g8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247622; c=relaxed/simple;
	bh=IC8jpiGPzWbRu7zVbYUvdqCXW719whggaKTzZoAOScI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pdnrsK0AZ66C6Ef/Xto53YQ5sEfgkHGBNc/yC5rH/EIOqE6ZTG6DSyO2+fnRZahFv7Ku96FSpfg4yDiHgFvHwNVoUW/+zjvStakOx0KLUzEgtnqOFK07U/gw0UT0qzhuf/OnJN81YAkahl+IYS+/ATQEM/EDg2kGSCdB0ZCsMxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PaCfnle0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PaCfnle0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F701F000E9;
	Thu, 20 Aug 2026 17:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247621;
	bh=Wm0sZbYDMFRxlSW+AutQaeebBJlj6Gl0vULHx2u8Lz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PaCfnle0K+8PIsKLp+MX3pK4LzI++5twhK8KjNOgXLJ7eL6kHTd55DIOGq5hN7Bwz
	 Gp8zaP1wkiNVkqPhP7liEWDRmbCsOsFLX9SABs9hr+lweu9Bj/VAkCK0zp9lqxoQwh
	 iRYDSiyynyfGjvxfpaEVtKqPmDt1yyhgOeCC6tMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 109/166] ASoC: tas2562: Validate values for volume writes
Date: Thu, 20 Aug 2026 16:56:08 +0200
Message-ID: <20260820145214.442922188@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 8fb41964f7e4e4207c8999af2056894caa7a252a ]

tas2562_volume_control_put() does not do any validation of the control
value written by userspace, it uses it to look up a value in a fixed
size array which can easily be overflowed and then writes whatever value
it gets back to the device.  Add validation that we are loading a value
we have in the array.

Cc: stable@vger.kernel.org
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20260715-asoc-tas2562-put-retval-v1-1-97bf467c924e@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/tas2562.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/sound/soc/codecs/tas2562.c
+++ b/sound/soc/codecs/tas2562.c
@@ -473,10 +473,15 @@ static int tas2562_volume_control_put(st
 {
 	struct snd_soc_component *component = snd_soc_kcontrol_component(kcontrol);
 	struct tas2562_data *tas2562 = snd_soc_component_get_drvdata(component);
-	int ret;
+	int ret, index;
 	u32 reg_val;
 
-	reg_val = float_vol_db_lookup[ucontrol->value.integer.value[0]/2];
+	index = ucontrol->value.integer.value[0] / 2;
+	if (index < 0 || index >= ARRAY_SIZE(float_vol_db_lookup))
+		return -EINVAL;
+
+	reg_val = float_vol_db_lookup[index];
+
 	/*
 	 * The device applies the 32-bit coefficient to the playback path on
 	 * the write to DVC_CFG4 (the LSB, book 0 page 2 reg 0x0F), so the


