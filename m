Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882FD1AA1F4;
	Fri,  4 Sep 2026 05:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498316; cv=none; b=mzmmx9hC+cmrTiqmK6zuBw1MmS3DLx4/2EQMSHoVzNxwcboPHqz6M+59wpbhEv984Ok1GX6x5p9TJdtgOdjsJsDGrm0Y09wJ7jOuBCSE9dCr3ufH6AZTjw43k+8YrJwMv6fw/kowzWWX/+9r0YLqnZ+FV8I5b/MQIXF9KnMehaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498316; c=relaxed/simple;
	bh=qRdegvdtaQE6qRjaYJ63mRWQOLxBrSxouISbatDYmMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ST84jNxdRw58J92tyO6vA2MVyC2RcwCimyH1h0yq1CSlyi6Ej9p3abyWJWlZyZVNHALZFW9cILIGAO3fhvCHTqz6WfQtHLCrrvsOnV2w81Y784RjN/FFYK41ixFw8y7EGdPz7q237Vx+4wt0i76EOdf89PE6t5M3pDbWPVf9Sk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vcq54bfu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vcq54bfu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E141B1F00A3D;
	Fri,  4 Sep 2026 05:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498315;
	bh=/43WgJ0TUF+Uvi47jfM+zYIr/LcOMTLXOJyrrgE7GLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vcq54bfu2GI27kFLuOsNTQdVknixwXwObJpsi3gvQjyjgRTk1FS6A8PkzCFIZacUg
	 MDqNjXi+e8I1DtxkXT1DleKdaC73z4lKX8LYSvJCNaNGSUqW6WnWALIkumL3H5Apif
	 MaTd2i/tnTMzubBDRJmmDrFjSZGnQZwybhWi4uiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 002/713] ASoC: tegra210_i2s: sort the register default table
Date: Fri,  4 Sep 2026 06:49:30 +0200
Message-ID: <20260904045803.870566090@linuxfoundation.org>
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

[ Upstream commit 597273563d90d03fda852a29c3a76c41a22bf6ac ]

reg_defaults must be sorted by ascending register address, as
regcache_lookup_reg() locates entries in it with bsearch().  See commit
fd80df352ba1 ("regcache: Add support for sorting defaults arrays").

TEGRA210_I2S_ENABLE (0x80) is listed after TEGRA210_I2S_CG (0x88) and
TEGRA210_I2S_TIMING (0xa4), so both it and TEGRA210_I2S_TIMING are
unreachable.  regcache_reg_needs_sync() then cannot compare them against
their default and reports that a sync is needed, so they are written to
the device on every regcache_sync() even when they were never touched.

Sort the table by register address.

Fixes: c0bfa98349d1 ("ASoC: tegra: Add Tegra210 based I2S driver")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20260805122748.13090-2-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/tegra/tegra210_i2s.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/tegra/tegra210_i2s.c b/sound/soc/tegra/tegra210_i2s.c
index ff8c72fc38c5c..fd49d2d6ee498 100644
--- a/sound/soc/tegra/tegra210_i2s.c
+++ b/sound/soc/tegra/tegra210_i2s.c
@@ -23,9 +23,9 @@ static const struct reg_default tegra210_i2s_reg_defaults[] = {
 	{ TEGRA210_I2S_RX_CIF_CTRL, 0x00007700 },
 	{ TEGRA210_I2S_TX_INT_MASK, 0x00000003 },
 	{ TEGRA210_I2S_TX_CIF_CTRL, 0x00007700 },
+	{ TEGRA210_I2S_ENABLE, 0x1 },
 	{ TEGRA210_I2S_CG, 0x1 },
 	{ TEGRA210_I2S_TIMING, 0x0000001f },
-	{ TEGRA210_I2S_ENABLE, 0x1 },
 	/*
 	 * Below update does not have any effect on Tegra186 and Tegra194.
 	 * On Tegra210, I2S4 has "i2s4a" and "i2s4b" pins and below update
-- 
2.53.0



