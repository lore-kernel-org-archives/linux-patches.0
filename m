Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6832269823;
	Tue,  8 Apr 2025 12:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114298; cv=none; b=hWxlg1HMSgZKVj0Ps9E1Fg177ZnPzyLdbxNcr8Gbdo1tXaWx2e7O/00fBgy6YQxmjqX46ErMLID1k0cVf99qJAs0nuElzti47JaqC7gdnIWliPbyet7C4+bE3iA40j9TuqrFBbhDdRcLG/zy3yMF5Fl4DDuk++KdJPZfQ9nPC0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114298; c=relaxed/simple;
	bh=qS4GtOlRxVgkeB6MRGIsKcfw/FdHgLVJb+hFRftkGVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Og65LIi2Xu0EQgDTZX+MQ/NXTzt2ziluNN+ZF6Bdz59ndhPSNlQxDfn+zD1FOOZiLiVrpAR6WgAz5sB0sI1VnUFUyPBWAGDnY7UQ16SsNEL7/2/ThUzXUZqC2Ii0KPpO4a/LH4kU5y7RgktBPTjx43nWuOPB4cPG85yMDnx6IdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o00AZPXi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o00AZPXi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 125AFC4CEE5;
	Tue,  8 Apr 2025 12:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114298;
	bh=qS4GtOlRxVgkeB6MRGIsKcfw/FdHgLVJb+hFRftkGVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o00AZPXiq/+AkICyrmuJh4O6IlsD72IrYfqKakjqdP29C3DlXHGBynrtCg2zY8CWs
	 14CAZwAGft+zmsN0kVDSexr0uqPMAfoVguKVfre8cXMahcKIJoSxE0p2MVKCQR3yfW
	 SO+gcdQEseQW9+/raPzS5TEZXE0ft6B/UMV6wDdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ritu Chaudhary <rituc@nvidia.com>,
	Sheetal <sheetal@nvidia.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 056/499] ASoC: tegra: Use non-atomic timeout for ADX status register
Date: Tue,  8 Apr 2025 12:44:28 +0200
Message-ID: <20250408104852.632580037@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ritu Chaudhary <rituc@nvidia.com>

[ Upstream commit f1d742c35b659fb0122da0a8ff09ad9309cb29d8 ]

ADX startup() callback uses atomic poll timeout on ADX status register.

This is unnecessary because:

- The startup() callback itself is non-atomic.
- The subsequent timeout call in the same function already uses a
  non-atomic version.

Using atomic version can hog CPU when it is not really needed,
so replace it with non-atomic version.

Fixes: a99ab6f395a9e ("ASoC: tegra: Add Tegra210 based ADX driver")
Signed-off-by: Ritu Chaudhary <rituc@nvidia.com>
Signed-off-by: Sheetal <sheetal@nvidia.com>
Link: https://patch.msgid.link/20250311062010.33412-1-sheetal@nvidia.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/tegra/tegra210_adx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/tegra/tegra210_adx.c b/sound/soc/tegra/tegra210_adx.c
index 0aa93b948378f..3c10e09976ad0 100644
--- a/sound/soc/tegra/tegra210_adx.c
+++ b/sound/soc/tegra/tegra210_adx.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
-// SPDX-FileCopyrightText: Copyright (c) 2021-2024 NVIDIA CORPORATION & AFFILIATES.
+// SPDX-FileCopyrightText: Copyright (c) 2021-2025 NVIDIA CORPORATION & AFFILIATES.
 // All rights reserved.
 //
 // tegra210_adx.c - Tegra210 ADX driver
@@ -57,8 +57,8 @@ static int tegra210_adx_startup(struct snd_pcm_substream *substream,
 	int err;
 
 	/* Ensure if ADX status is disabled */
-	err = regmap_read_poll_timeout_atomic(adx->regmap, TEGRA210_ADX_STATUS,
-					      val, !(val & 0x1), 10, 10000);
+	err = regmap_read_poll_timeout(adx->regmap, TEGRA210_ADX_STATUS,
+				       val, !(val & 0x1), 10, 10000);
 	if (err < 0) {
 		dev_err(dai->dev, "failed to stop ADX, err = %d\n", err);
 		return err;
-- 
2.39.5



