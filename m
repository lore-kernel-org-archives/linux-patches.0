Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462F45867DE;
	Wed,  9 Sep 2026 14:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963798; cv=none; b=VYtH/ymu0Haa6hKIw8WDOLZP2lRTen+J+kDWaz0gvqDZSFyvObtxD21J5N1SJPsH+D+9sO/KTzQyz63F63OjpiF7NemJu3XYdJ4EIPLJNMimVWvoQNK/oEun8vLu8YPcYAsLI/JHfOoVAjxh24zBowZWrRgzXPAxEvWlvZzpX1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963798; c=relaxed/simple;
	bh=cJnRSIn/jCU6p3yHgk7m/RIRLQ5gssqYeZoWY8QQCIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=afg4trXOwYyUhIXSEWyEg3CjHTK5OtfUBvGRRiLQERW39DCEvMZhSsoXu6pS9SkhRlBkuEk0FfNqdJTV2ehgr5msv7XKIAugE+QZ8HR2O8vSRMWyVqkhCkI++ZjAS5UDRUfMf6D0XKFxHDHuwSONO+0qm2Koacs49ooV3garsWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CtqT9wEX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CtqT9wEX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D3691F00A3E;
	Wed,  9 Sep 2026 14:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963796;
	bh=j/omcoP7KhPed3i2zjy9aBnoqX6+7mf0em5c+7LbTms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CtqT9wEX+aKap7Sprpg1dHF9H1/IJ4Kh+KI9PvEfM0lWF5bHPGEkOZ32pQRez1Vcm
	 UGGxppKav2vrOJ3f426/YjzWiKjRNcSMNyr5k19B1i54cJhggzudx0vMrN1rjGX7It
	 3X9nI57i6yAcfsbpMvoEH0BpgrzYvNfyidSbei6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 201/583] ASoC: tegra210_i2s: sort the Tegra264 register default table
Date: Wed,  9 Sep 2026 15:38:06 +0200
Message-ID: <20260909134245.115047833@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

commit 82da8df388004af4540e930ab3de2ce5787207e7 upstream.

reg_defaults must be sorted by ascending register address, as
regcache_lookup_reg() locates entries in it with bsearch().  See commit
fd80df352ba1 ("regcache: Add support for sorting defaults arrays").

TEGRA264_I2S_ENABLE (0x100), TEGRA264_I2S_RX_FIFO_WR_ACCESS_MODE (0x30)
and TEGRA264_I2S_TX_FIFO_RD_ACCESS_MODE (0xb0) are listed at the end of
the table, after TEGRA264_I2S_TIMING (0x130), which leaves 4 of the 9
entries unreachable.  regcache_reg_needs_sync() then cannot compare them
against their default and reports that a sync is needed, so they are
written to the device on every regcache_sync() even when they were never
touched.

Sort the table by register address.

Fixes: b3354438d898 ("ASoC: tegra: I2S: Add Tegra264 support")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20260805122748.13090-3-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/tegra/tegra210_i2s.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/sound/soc/tegra/tegra210_i2s.c
+++ b/sound/soc/tegra/tegra210_i2s.c
@@ -39,13 +39,13 @@ static const struct reg_default tegra210
 static const struct reg_default tegra264_i2s_reg_defaults[] = {
 	{ TEGRA210_I2S_RX_INT_MASK, 0x00000003 },
 	{ TEGRA210_I2S_RX_CIF_CTRL, 0x00003f00 },
+	{ TEGRA264_I2S_RX_FIFO_WR_ACCESS_MODE, 0x1 },
 	{ TEGRA264_I2S_TX_INT_MASK, 0x00000003 },
 	{ TEGRA264_I2S_TX_CIF_CTRL, 0x00003f00 },
+	{ TEGRA264_I2S_TX_FIFO_RD_ACCESS_MODE, 0x1 },
+	{ TEGRA264_I2S_ENABLE, 0x1 },
 	{ TEGRA264_I2S_CG, 0x1 },
 	{ TEGRA264_I2S_TIMING, 0x0000001f },
-	{ TEGRA264_I2S_ENABLE, 0x1 },
-	{ TEGRA264_I2S_RX_FIFO_WR_ACCESS_MODE, 0x1 },
-	{ TEGRA264_I2S_TX_FIFO_RD_ACCESS_MODE, 0x1 },
 };
 
 static void tegra210_i2s_set_slot_ctrl(struct tegra210_i2s *i2s,


