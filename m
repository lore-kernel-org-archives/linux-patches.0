Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A624F148315;
	Tue, 25 Jun 2024 09:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308412; cv=none; b=JuJQ0pGej0ho8/NdNV2L7DL+UPSDJgdnnMfBK9XOAwGHdn5Hc92dhGHne9kNEtdhwcL5TbwDHfnvmxz5Il0VXQ56aiX+5VjUbYDkBr3rKV1bDbAhaPJzU789VaglBsKUnrD/GqcHFpsZZ+fRsp7taD9rj/RpROVEz3fYpw5qx+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308412; c=relaxed/simple;
	bh=h7CTPoNYsnIPNeTlsnYqQxwJnEBQneN/ve9LxBAPA1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J3pKbuSLyqIOFBFxzivHdRM2/VygRrbKxdcTjPL5kjOB7tjeNgrTbeH6McNB4iq7hXj1OKqezwG/KW6vg6kqWFt4ZF/G+Tg6aDoOOCHsK6u5/kg+AD8Sgh2jaBgv84nSj3mgg9QW1dgiOTPeNrC0D2GFgfnYBoL3WoJvQLcPVHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fT+v5WqA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fT+v5WqA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EC46C32781;
	Tue, 25 Jun 2024 09:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308412;
	bh=h7CTPoNYsnIPNeTlsnYqQxwJnEBQneN/ve9LxBAPA1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fT+v5WqAvjD7Xbhx8oo7H11yILYPj76OrkFvZsDRgvI9tzRUtS0usDUDkamE2nl7M
	 gUnjQtCm6rSPhyEYP4hTOgHDhYnOOr10HiJbnttJh8euluBcZ2VWyVfPkV7FevB8rn
	 IC+OG3MuQQ4CB7cIrgTfUTa4ipEP40VVT5Lyeg3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Trimmer <simont@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 113/250] ALSA: hda: tas2781: Component should be unbound before deconstruction
Date: Tue, 25 Jun 2024 11:31:11 +0200
Message-ID: <20240625085552.409511029@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Trimmer <simont@opensource.cirrus.com>

[ Upstream commit d832b5a03e94a2a9f866dab3d04937a0f84ea116 ]

The interface associated with the hda_component should be deactivated
before the driver is deconstructed during removal.

Fixes: 4e7914eb1dae ("ALSA: hda/tas2781: remove sound controls in unbind")
Signed-off-by: Simon Trimmer <simont@opensource.cirrus.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20240613133713.75550-4-simont@opensource.cirrus.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/tas2781_hda_i2c.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/tas2781_hda_i2c.c b/sound/pci/hda/tas2781_hda_i2c.c
index 75f7674c66ee7..fdee6592c502d 100644
--- a/sound/pci/hda/tas2781_hda_i2c.c
+++ b/sound/pci/hda/tas2781_hda_i2c.c
@@ -777,11 +777,11 @@ static void tas2781_hda_remove(struct device *dev)
 {
 	struct tas2781_hda *tas_hda = dev_get_drvdata(dev);
 
+	component_del(tas_hda->dev, &tas2781_hda_comp_ops);
+
 	pm_runtime_get_sync(tas_hda->dev);
 	pm_runtime_disable(tas_hda->dev);
 
-	component_del(tas_hda->dev, &tas2781_hda_comp_ops);
-
 	pm_runtime_put_noidle(tas_hda->dev);
 
 	tasdevice_remove(tas_hda->priv);
-- 
2.43.0



