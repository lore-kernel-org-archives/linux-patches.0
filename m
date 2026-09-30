Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2686251B16A;
	Wed, 30 Sep 2026 17:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789949; cv=none; b=gaMxfcM2WQt2subfI5OrtkAp+hYoOUXlY9jQPzCJmNYUinUqNvVYHK3PV2fOkoIEVvkyS7PxGsmoz7foly0CzJVx2A5kq8RXkLH+oVBC/8oY20twxOQpZZgM6jkeOLzU/uiH5JaYy4Hbr5a7tT6HeUDMxPiEa3Cs3y+RgUecFT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789949; c=relaxed/simple;
	bh=VWGqqZ0844S+bOoJ/tNe9HPaWrVwduTOX/tf3RBVSJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qdU4wGA4jfdfaIRoHoIaktvb86H3qbVdXjQci2Sf0srVmzdERtvpGueviME0YaFsYsdsv+emxypckAe5a4LiC5f/CJkKKYpxPd5hzzzgVldL2Sexb8xoEoQg9FFnrgz+uRYBj2TzHhmBpj09R9434KVfRhnmlvjSkBfu3TpAQmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dDv/iFnI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dDv/iFnI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A9C31F000FF;
	Wed, 30 Sep 2026 17:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789948;
	bh=gWp+ipPnoJadQrDrv+YXW9EiYNzF7Ozb7nYAUvgQSLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dDv/iFnIMLPjG5/AourPKNZ/1xqTCetUcvoCt65Ep8YW2o4FbG1jA4+tgn81bO5md
	 s4im5SLcPI9hKFOxk64IzYr85IntAG7xOPXJ1GleKm5FVxoY1MBQnKKORpOVBAduhn
	 B91g1Dovg0TLQLHhjubY1+7wNTO56ndsF9xxTCTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 657/877] ASoC: tegra210_mixer: sort the register default table
Date: Wed, 30 Sep 2026 17:26:08 +0200
Message-ID: <20260930152428.839718715@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit f70bc276fc7f712ff5c8e995d5050558a3198df2 ]

reg_defaults must be sorted by ascending register address, as
regcache_lookup_reg() locates entries in it with bsearch().  See commit
fd80df352ba1 ("regcache: Add support for sorting defaults arrays").

TEGRA210_MIXER_ENABLE (0x400) is the last entry of the table, after
TEGRA210_MIXER_PEAKM_RAM_CTRL (0x434), which makes it unreachable.
regcache_reg_needs_sync() then cannot compare it against its default and
reports that a sync is needed, so it is written to the device on every
regcache_sync() even when it was never touched.

Sort the table by register address.

Fixes: 05bb3d5ec64a ("ASoC: tegra: Add Tegra210 based Mixer driver")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20260805122748.13090-4-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 5442b8093a2f ("ASoC: tegra: Fix the MIXER enable default value")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/tegra/tegra210_mixer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/tegra/tegra210_mixer.c
+++ b/sound/soc/tegra/tegra210_mixer.c
@@ -57,10 +57,10 @@ static const struct reg_default tegra210
 	MIXER_TX_REG_DEFAULTS(3),
 	MIXER_TX_REG_DEFAULTS(4),
 
+	{ TEGRA210_MIXER_ENABLE, 0x1 },
 	{ TEGRA210_MIXER_CG, 0x00000001},
 	{ TEGRA210_MIXER_GAIN_CFG_RAM_CTRL, 0x00004000},
 	{ TEGRA210_MIXER_PEAKM_RAM_CTRL, 0x00004000},
-	{ TEGRA210_MIXER_ENABLE, 0x1 },
 };
 
 /* Default gain parameters */


