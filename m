Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6583651475A;
	Wed,  9 Sep 2026 14:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962460; cv=none; b=PnGf95acbAiMHfLPkcCi+XEmzVnF9zdFi1PJgATgneV2NpKrPJ3IjS4uNUuWbY7cOjjy5WGkQIOsnaG35PEA0og7gIfPTjy7WVOWRMLjuSIPXDtqnki6hnc3dsqJBDF3p4I5MjCWXfAiDI2CMXSxR0HeL16irJJNJlMs8CMvEs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962460; c=relaxed/simple;
	bh=4ZmlCe17mVNpPs4YISmvLGDPpdq8aXLw3se7iY9vhjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oGK2n22l7/nGmfUCmx/4+8zk5Qs6W9ruVkVT9FVyvaaCgETuPWoAm+e3u5ZRieHq8ST+r89hSxItNVxbMEXeXDyZpr4WmvehPI/cm68zLtdUL84/2I2Qqj6iUuVzQivpFrItMQY1yVyvTzPbVT6/RxfEXzZACkPNcLoQ7oPy3Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cFwkXSFy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cFwkXSFy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC6F11F00A3D;
	Wed,  9 Sep 2026 14:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962459;
	bh=MCYwtUwhZ4A0fpcUaAZoQKgRinGEf6g+KMJnMbzdEX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cFwkXSFyvx8bdFwzaK7FWzyj5+egj2ZDFN7/v9u//r3WVhMo8cSH3yQXt5ufSqVrq
	 MGYYXUQGzGnZwK/4Lk44dDObnKE4wrRorM2B+5Au7D3gc23P74KrerrDp67zoyjR6W
	 nNETPq0nQ4QEhvVNdkRma3tCASYkenwmdkz2rH2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.2 256/556] ASoC: tas2780: sort the register default table
Date: Wed,  9 Sep 2026 15:38:56 +0200
Message-ID: <20260909134239.512835261@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

commit e725093e9e53db9298e38e7332a44dcaac2fd135 upstream.

reg_defaults must be sorted by ascending register address, as
regcache_lookup_reg() locates entries in it with bsearch().  See commit
fd80df352ba1 ("regcache: Add support for sorting defaults arrays").

TAS2780_DVC (0x1a) is listed before TAS2780_CHNL_0 (0x03), which makes
it unreachable.  regcache_reg_needs_sync() then cannot compare it
against its default and reports that a sync is needed, so it is written
to the device on every regcache_sync() even when it was never touched.

Sort the table by register address.

Fixes: eae9f9ce181b ("ASoC: add tas2780 driver")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20260805104149.9795-5-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/tas2780.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/tas2780.c
+++ b/sound/soc/codecs/tas2780.c
@@ -527,13 +527,13 @@ static const struct reg_default tas2780_
 	{ TAS2780_PAGE, 0x00 },
 	{ TAS2780_SW_RST, 0x00 },
 	{ TAS2780_PWR_CTRL, 0x1a },
-	{ TAS2780_DVC, 0x00 },
 	{ TAS2780_CHNL_0, 0x00 },
 	{ TAS2780_TDM_CFG0, 0x09 },
 	{ TAS2780_TDM_CFG1, 0x02 },
 	{ TAS2780_TDM_CFG2, 0x0a },
 	{ TAS2780_TDM_CFG3, 0x10 },
 	{ TAS2780_TDM_CFG5, 0x42 },
+	{ TAS2780_DVC, 0x00 },
 };
 
 static const struct regmap_range_cfg tas2780_regmap_ranges[] = {


