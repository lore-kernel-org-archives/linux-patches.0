Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B035429A0;
	Wed,  7 May 2025 19:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644499; cv=none; b=X88+6c5Y/XGbe7TfAZWi7lfNnloe9LocuSqdwX11PBh+SH/I850xnXLCeFeLSOHt53c8nSIv35SVHXcRKCaDb69S1UHaW+Dr1/vWmT4SDNxlLXBc6hjj6ARaSF4Obk9MATfjZ4vJvAm38itoMXwfLRJX3TTGunKqdcuq8Y6iLvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644499; c=relaxed/simple;
	bh=SP6kdkk9y56PT7/LTwHZk5oiDvIEDkkTBOn1zy9bE1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mygG0x3YMtYhGniuDtCiMKwhpPITf3AX++DdZYwp+yR3AN6speIRBET3j4WwxzRYpb6XRh89ojVEUmJpV6sq2cBNwDt8zrXp3dHwurtooU8NrxzfSAGP8cTG0QOvV+hTynCjSmM3RAjHjoMHj/gPrnXbMba7lP1AKcQn7luMnWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OjgkM9vZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OjgkM9vZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DE1FC4CEE2;
	Wed,  7 May 2025 19:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644499;
	bh=SP6kdkk9y56PT7/LTwHZk5oiDvIEDkkTBOn1zy9bE1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OjgkM9vZ0/YwabPhST0yua7/eC/5y607knjnkiaTHzD2PED3JhVLl02AFnMlUJnyP
	 7AtQTonjKkK3gHhwmAQnxBwkndlPR5y2+lKk7Rw6OwfvEXDDmZbig8qbqBLxuh48lD
	 2xkGnlnXrtTUJAcssMDuY6NtdaLS45GKxJj3sxRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Wang <hui.wang@canonical.com>,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 056/164] pinctrl: imx: Return NULL if no group is matched and found
Date: Wed,  7 May 2025 20:39:01 +0200
Message-ID: <20250507183823.203637809@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Wang <hui.wang@canonical.com>

[ Upstream commit e64c0ff0d5d85791fbcd126ee558100a06a24a97 ]

Currently if no group is matched and found, this function will return
the last grp to the caller, this is not expected, it is supposed to
return NULL in this case.

Fixes: e566fc11ea76 ("pinctrl: imx: use generic pinctrl helpers for managing groups")
Signed-off-by: Hui Wang <hui.wang@canonical.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/20250327031600.99723-1-hui.wang@canonical.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/freescale/pinctrl-imx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/freescale/pinctrl-imx.c b/drivers/pinctrl/freescale/pinctrl-imx.c
index d05c2c478e795..4e1fe457a608a 100644
--- a/drivers/pinctrl/freescale/pinctrl-imx.c
+++ b/drivers/pinctrl/freescale/pinctrl-imx.c
@@ -37,16 +37,16 @@ static inline const struct group_desc *imx_pinctrl_find_group_by_name(
 				struct pinctrl_dev *pctldev,
 				const char *name)
 {
-	const struct group_desc *grp = NULL;
+	const struct group_desc *grp;
 	int i;
 
 	for (i = 0; i < pctldev->num_groups; i++) {
 		grp = pinctrl_generic_get_group(pctldev, i);
 		if (grp && !strcmp(grp->grp.name, name))
-			break;
+			return grp;
 	}
 
-	return grp;
+	return NULL;
 }
 
 static void imx_pin_dbg_show(struct pinctrl_dev *pctldev, struct seq_file *s,
-- 
2.39.5



