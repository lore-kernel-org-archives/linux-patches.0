Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5372F3B6C17;
	Tue, 21 Jul 2026 22:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673686; cv=none; b=jIeEIxujq8erjmRsmg96/7hUzNIJV/q/DhVvU63BUj5ODF5Bdj8PPw5l5zWzJVyDdx81h89tDRZnZr6eMnIkimAt49+LNOKu1mdxVx5NauIwr5MlJNhf201l7upZWbzz3ILTlozmliJTu2YAFFL+RbR88AsrIwsbgWhWMYrZT4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673686; c=relaxed/simple;
	bh=RfA2KxrfN7OUkDvm+lBMSPK7tP0hjli+gUmBArfgS88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SpwS3SDp7sXm9lzMI01wOCyLL9LEwCoUC6ILQSCvPwQ/9JZp/iMCZqKs8DqW3tFlPmlc0GR7kd5JtQOVb3ExSVKyBTW+Pu5l3CqGiOLzuU0L+tZ4Jvw720ZIMJMueEdbJHB6mdAe+PpqJkzW2KRuciVGPyKRQg+VvimijvGPGoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aa+ZEnpr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aa+ZEnpr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B86251F000E9;
	Tue, 21 Jul 2026 22:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673685;
	bh=DzVNuZm7boG0lXZNWrn0sUKeK9T/TCACC3pTp+5FZ0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aa+ZEnprCK9WWl+3E4UD+sinOw1qW5WY4GSQmbU0ClxU0tOJLcuFcHh86VFCTgDXb
	 a/SOfPWbbPKxmodYe9y528pUfkRaYZkxfD8gmfza3/9PP6Gr7TCstwpT5yVuo0E33a
	 vpttslLrO0SfemKlriuZAAflQqKT6BX1xtxQlyGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 255/699] ASoC: tegra: tegra210_ahub: Validate written enum value
Date: Tue, 21 Jul 2026 17:20:14 +0200
Message-ID: <20260721152401.450513224@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 686c8ff46ec8a1..3050ad46348c94 100644
--- a/sound/soc/tegra/tegra210_ahub.c
+++ b/sound/soc/tegra/tegra210_ahub.c
@@ -60,13 +60,15 @@ static int tegra_ahub_put_value_enum(struct snd_kcontrol *kctl,
 	struct soc_enum *e = (struct soc_enum *)kctl->private_value;
 	struct snd_soc_dapm_update update[TEGRA_XBAR_UPDATE_MAX_REG] = { };
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
 		reg_idx = (value - 1) / (8 * cmpnt->val_bytes);
-- 
2.53.0



