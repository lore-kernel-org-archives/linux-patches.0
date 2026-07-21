Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5945546EF90;
	Tue, 21 Jul 2026 19:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662136; cv=none; b=iE62gbwKyiAsz9aBEOq79FKtCBlg6cJz7B1vckAGtwHaPbC1V/7Ik9IWcsOlYscSOfQCPRpX/AeLYa9kPU3tn9NmgyzmZmFrXyyDSCAjheME03EEC3aF5H91soFo8XTJWSIh/aLxUI/nqblR3AptqcV4EhrvNEk2lxPGAmePgks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662136; c=relaxed/simple;
	bh=E4Z5PBgoXOD8Lihkcknx6DZ+CIs4kElnBeYK3IxecE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CcKyeXUGgio9Vlgnw976G9qtqE153pliq/LmcH+WGbsaLAfc3YSl6iIDZpJqBrD0UWNPaBFhCVTNSBtDjaJOnJ9xdGTJ9Sf+8+UsioQm1UtqnRg480BI3rwUqTIMgP7sLzow+N6HELtGIHXbyZtNGrkqnu0j+q6V0gfatA2LqpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fGcCAWOP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fGcCAWOP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 778DC1F00A3D;
	Tue, 21 Jul 2026 19:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662135;
	bh=0OVunfbILGH9a8K28Q1pvs3un1fYkmV0t11RDWRhfRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fGcCAWOP78MwkZjDBYTyxWK25lPdF0XzaqICphQYId4UCEZC57uW+WLeyhEOwgnE5
	 Wlj5MRqsxyAr4iIr1MDMBuv7YnF7+LiDU8g1TnYsTIfAVOI2CBl/nyD69U9jstuiCi
	 Np7a+3H/ubuXXPEnSCuDTL59cpuc1jZLsH5JUabA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0331/1276] ASoC: tegra: tegra210_ahub: Validate written enum value
Date: Tue, 21 Jul 2026 17:12:54 +0200
Message-ID: <20260721152453.508944171@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
index 51043e556b3e98..65cb699d82e8e3 100644
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



