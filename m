Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214D746C4B9;
	Tue, 21 Jul 2026 18:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659716; cv=none; b=h2Lvi6sgOfAMF72tMsvMDu2Ez4/DcMNLoZYfuqZmcsBJV/8mYP89jduCA3LpEz1X2YRoXRrbkbjHpTP5mcsXWWiQou0gMcpxLAz53LUlhCTnqcHLgd+t+rXudecJdx5aGQiwdSzvGez5s6uUBpWz788l6Ly0VdFhfRWmGYdHAFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659716; c=relaxed/simple;
	bh=HYmdGBEiT19ZR1gzWjk9jyBs/Ikqj1roaHR3Al/JWG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PEHEHejpnbUyztRWQkxNJcr/84ALn0Hr7ytIiprXhX8CCF19Qvuw8yJPZxDkk2exdPB1ymHZ8ID4/7ppx11YE2LapSdmxYKIYCqB8yA0KSlTkJ7Zjpuoe+x/22uqIxdrCe/XFE/1239YCW3cj7P+cngjsaY6Wg1smdfug4K3Yto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W1Si9UUA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W1Si9UUA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BF831F00A3A;
	Tue, 21 Jul 2026 18:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659714;
	bh=2X4hssoySN8gNP8Py+JF9lSM49b5KwAzGRU/gqNHPmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W1Si9UUA2h1kUDoMaVVxwK/z+mF+aZAMVJI4zCWAJTQ1ewan1llqwoO4hQlAD6z8S
	 /Ek50bACqzh+vN9q6RQJHO1DWhipVM0S1yOxc1bHFNEdJHaW5+6oVEJGv2Oez3xDh9
	 y4yow7mVfuqrk8y5oOkS0kchVrQtTYwU6BKvzZBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0706/2077] ASoC: tegra: tegra210_ahub: Validate written enum value
Date: Tue, 21 Jul 2026 17:06:19 +0200
Message-ID: <20260721152609.444269151@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit 1d8aabb413b5638670dfd1162169edc0ba276a2e ]

tegra_ahub_put_value_enum() reads e->values[item[0]] before
checking whether item[0] is within the enum item range. The existing
check therefore happens too late to prevent an out-of-range read of the
values array.

Move the check before the array access.

Fixes: 16e1bcc2caf4 ("ASoC: tegra: Add Tegra210 based AHUB driver")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/20260609124317.38046-5-sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/tegra/tegra210_ahub.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/tegra/tegra210_ahub.c b/sound/soc/tegra/tegra210_ahub.c
index ece33b7ff190ac..efc8f338866828 100644
--- a/sound/soc/tegra/tegra210_ahub.c
+++ b/sound/soc/tegra/tegra210_ahub.c
@@ -62,13 +62,15 @@ static int tegra_ahub_put_value_enum(struct snd_kcontrol *kctl,
 	struct snd_soc_dapm_update update[TEGRA_XBAR_UPDATE_MAX_REG] = { };
 	int val_bytes = snd_soc_component_regmap_val_bytes(cmpnt);
 	unsigned int *item = uctl->value.enumerated.item;
-	unsigned int value = e->values[item[0]];
+	unsigned int value;
 	unsigned int i, bit_pos, reg_idx = 0, reg_val = 0;
 	int change = 0;
 
 	if (item[0] >= e->items)
 		return -EINVAL;
 
+	value = e->values[item[0]];
+
 	if (value) {
 		/* Get the register index and value to set */
 		reg_idx = (value - 1) / (8 * val_bytes);
-- 
2.53.0



