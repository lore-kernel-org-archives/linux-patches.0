Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFE293515D2;
	Fri,  4 Sep 2026 05:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498347; cv=none; b=eMiCC1JvCj5lvQY63rltN89IEHJ7eE8oZFefOpm75COz7aIG8cgfbJ1NIn9mYc8/by/+ZwMbNO494Fdbx+duBo80A4PsVOgHx3NhbEIr0IGeH76ts0qJ8ujwC7MCqYa6/QvNxS7d9mzXv0UZTewfgiGoXwMXDGOARkVyrRcTKLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498347; c=relaxed/simple;
	bh=7HPkK/NVIIeeLoLNP8OZwpH+7H68YwRgYWF7KFcAQNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R0LqkYnlCdx20oSczi/rGjDUgLOQ1NT5UoIjonbzetWb3t+0G1pfOtu6LFiaPJP0DEQGjfxW/d8EaMsL8kgBTSFsfkqsvvmnODE3At5+9GdSWvYt1L8Cph1SzexlygTbigRvNUdOOQpRA3dVSt96ck/ZQBjOtpL9ka0xaRNLwQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pNRcEQ//; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pNRcEQ//"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 151001F00A3D;
	Fri,  4 Sep 2026 05:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498346;
	bh=zdTwI5/5lAK0dXC0F5nGj6kuXjoIow+cL4tWSHSv9lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pNRcEQ//T/ySmFKUpGO6aejlRYjAUneuwnhjX/eZ8ftShpmG4L8XGUigmc+gSJ5wH
	 XezonL2ZBXECsnZ//3xGiqI4detzV0L5feHbcPVbfn8aJcW08znBHLth/K9b4fpZbB
	 fda9DvaEcSXRwMmBMjI7fT9RjiGZl7XzXHrCsKTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 003/713] ASoC: tegra210_i2s: sort the Tegra264 register default table
Date: Fri,  4 Sep 2026 06:49:31 +0200
Message-ID: <20260904045803.894774936@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit 82da8df388004af4540e930ab3de2ce5787207e7 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/tegra/tegra210_i2s.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/tegra/tegra210_i2s.c b/sound/soc/tegra/tegra210_i2s.c
index fd49d2d6ee498..e4d11518ff019 100644
--- a/sound/soc/tegra/tegra210_i2s.c
+++ b/sound/soc/tegra/tegra210_i2s.c
@@ -38,13 +38,13 @@ static const struct reg_default tegra210_i2s_reg_defaults[] = {
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
-- 
2.53.0



