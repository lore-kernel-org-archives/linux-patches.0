Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A7B1C68BF;
	Thu,  6 Jun 2024 14:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683699; cv=none; b=LY3/PBZ6oQIHGYWqOe3cLsJwjbtjm6C2Rw1vrJz8ThW3UxC8givQA4zYEy6NKOmQBpbhxI6LNAsHjp16Hv8ESickuYwianMdlSJuCUIP+9rJjEhtJWGnZu9NrgawbITzigdIt9VU9KkEnWS3Ml5iIawcxRatvmQK9nuP3fDOI2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683699; c=relaxed/simple;
	bh=BdzbaNDxUCxl8bWzJJ3dMJoRx9rMBcxeQ2JigSJIaYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n+PUdqvn/xLQganvAAX3zE5+5EKius/da+JpVWmimK664vcMIts48dUrCmgdfI3QLotbyEURpULPSA9CNnTg+GKNhQ6rs3qAYm5esNMfOipL/cUkt2c7+ccM0P0IiwQfxPoI7r8ywwkKkcODm6wCbkM05600uadey6SuLD8AD/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gHYj8vC9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gHYj8vC9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77F0EC32781;
	Thu,  6 Jun 2024 14:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683699;
	bh=BdzbaNDxUCxl8bWzJJ3dMJoRx9rMBcxeQ2JigSJIaYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gHYj8vC9uvDiC5+lvtT/W4SZs5yQwxJwZcnmxYcemm9hc9R4pvHJWn0hoxZ8P5dg8
	 I3F35qUWGo2z2259yv5TcIOQMFcNRnLuq1DYyN6lZSOqu4r12iq8NVLwZ81c6ES3gc
	 LDjo6yiSzYdFOO7Lh2JrFjY95v77X/NFCuF4arh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 620/744] ALSA: hda: cs35l56: Initialize all ASP1 registers
Date: Thu,  6 Jun 2024 16:04:52 +0200
Message-ID: <20240606131752.388654311@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 856ce8982169acb31a25c5f2ecd2570ab8a6af46 ]

Add ASP1_FRAME_CONTROL1, ASP1_FRAME_CONTROL5 and the ASP1_TX?_INPUT
registers to the sequence used to initialize the ASP configuration.
Write this sequence to the cache and directly to the registers to
ensure that they match.

A system-specific firmware can patch these registers to values that are
not the silicon default, so that the CS35L56 boots already in the
configuration used by Windows or by "driverless" Windows setups such
as factory tuning.

These may not match how Linux is configuring the HDA codec. And anyway
on Linux the ALSA controls are used to configure routing options.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: 73cfbfa9caea ("ALSA: hda/cs35l56: Add driver for Cirrus Logic CS35L56 amplifier")
Link: https://msgid.link/r/20240129162737.497-10-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: d344873c4cbd ("ALSA: hda: cs35l56: Fix lifetime of cs_dsp instance")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/cs35l56_hda.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/sound/pci/hda/cs35l56_hda.c b/sound/pci/hda/cs35l56_hda.c
index 05b1412868fc0..e599b287f0961 100644
--- a/sound/pci/hda/cs35l56_hda.c
+++ b/sound/pci/hda/cs35l56_hda.c
@@ -29,14 +29,23 @@
   *  ASP1_RX_WL = 24 bits per sample
   *  ASP1_TX_WL = 24 bits per sample
   *  ASP1_RXn_EN 1..3 and ASP1_TXn_EN 1..4 disabled
+  *
+  * Override any Windows-specific mixer settings applied by the firmware.
   */
 static const struct reg_sequence cs35l56_hda_dai_config[] = {
 	{ CS35L56_ASP1_CONTROL1,	0x00000021 },
 	{ CS35L56_ASP1_CONTROL2,	0x20200200 },
 	{ CS35L56_ASP1_CONTROL3,	0x00000003 },
+	{ CS35L56_ASP1_FRAME_CONTROL1,	0x03020100 },
+	{ CS35L56_ASP1_FRAME_CONTROL5,	0x00020100 },
 	{ CS35L56_ASP1_DATA_CONTROL5,	0x00000018 },
 	{ CS35L56_ASP1_DATA_CONTROL1,	0x00000018 },
 	{ CS35L56_ASP1_ENABLES1,	0x00000000 },
+	{ CS35L56_ASP1TX1_INPUT,	0x00000018 },
+	{ CS35L56_ASP1TX2_INPUT,	0x00000019 },
+	{ CS35L56_ASP1TX3_INPUT,	0x00000020 },
+	{ CS35L56_ASP1TX4_INPUT,	0x00000028 },
+
 };
 
 static void cs35l56_hda_play(struct cs35l56_hda *cs35l56)
@@ -132,6 +141,10 @@ static int cs35l56_hda_runtime_resume(struct device *dev)
 		}
 	}
 
+	ret = cs35l56_force_sync_asp1_registers_from_cache(&cs35l56->base);
+	if (ret)
+		goto err;
+
 	return 0;
 
 err:
@@ -969,6 +982,9 @@ int cs35l56_hda_common_probe(struct cs35l56_hda *cs35l56, int id)
 
 	regmap_multi_reg_write(cs35l56->base.regmap, cs35l56_hda_dai_config,
 			       ARRAY_SIZE(cs35l56_hda_dai_config));
+	ret = cs35l56_force_sync_asp1_registers_from_cache(&cs35l56->base);
+	if (ret)
+		goto err;
 
 	/*
 	 * By default only enable one ASP1TXn, where n=amplifier index,
-- 
2.43.0



