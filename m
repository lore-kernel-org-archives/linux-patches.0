Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906CF304BDC;
	Tue, 11 Nov 2025 01:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825524; cv=none; b=pozhKlfDLWLdeF1zN7FAQDW3JToo/r1HVfrmsgrtqW5Rla+wfWDNR7Kbieo4iUh9erDsvWtQGFuJTfLpfNtU/X9ypq1Ew0n5OIFcwRZs69LYl9WTYWij9z5sYXdr6JQv4YaDbrKlZElrk+bPzSH/U7rSbnH4hpxgYQALBQx/Ph4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825524; c=relaxed/simple;
	bh=uLkN/DMyWvuCnEU4u2DRbycyuZbEaubuiZa9DLVH8Lo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AGix9vkiKkmEAV0fV7tYlVmyXJAJtxLwS6pviVr9znQIth3pZt+g6KcKGnM8M5ZdMkgKsHbgAau61uHEYUktMfGcntA/r0L5DJPE95ybMrhT/c3fGFb48IucMN336vaR544BuuMwXVXEiWi6A//wDpHDlkmRl09BL7TLbTJGFro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z7WqNoiy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z7WqNoiy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D9F6C16AAE;
	Tue, 11 Nov 2025 01:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825524;
	bh=uLkN/DMyWvuCnEU4u2DRbycyuZbEaubuiZa9DLVH8Lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z7WqNoiyejGPnzCAeK2ZsqUgs3HRA/nA5vtMVz2+LoiYTV4o68HF8IFoZ2WF+njZO
	 aPWOHkqbrPV7IbKizEqOaoRdIXD4xklz/1oixcoXzAXl9NdoCcNRpRK/v53mlJDQyn
	 JAvmJpGODtTD/t1D/Ev8sS5FKMRmk4Xj/1kFyMA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shenghao Ding <shenghao-ding@ti.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.17 838/849] ALSA: hda/tas2781: Enable init_profile_id for device initialization
Date: Tue, 11 Nov 2025 09:46:48 +0900
Message-ID: <20251111004556.683005115@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shenghao Ding <shenghao-ding@ti.com>

commit 7ddb711b6e0d33e0a673b49f69dff0d950ed60b9 upstream.

Optimize the time consumption of profile switching, init_profile saves
the common settings of different profiles, such as the dsp coefficients,
etc, which can greatly reduce the profile switching time comsumption and
remove the repetitive settings.

Fixes: e83dcd139e77 ("ASoC: tas2781: Add keyword "init" in profile section")
Signed-off-by: Shenghao Ding <shenghao-ding@ti.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/side-codecs/tas2781_hda_i2c.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/sound/hda/codecs/side-codecs/tas2781_hda_i2c.c
+++ b/sound/hda/codecs/side-codecs/tas2781_hda_i2c.c
@@ -472,6 +472,12 @@ static void tasdevice_dspfw_init(void *c
 	if (tas_priv->fmw->nr_configurations > 0)
 		tas_priv->cur_conf = 0;
 
+	/* Init common setting for different audio profiles */
+	if (tas_priv->rcabin.init_profile_id >= 0)
+		tasdevice_select_cfg_blk(tas_priv,
+			tas_priv->rcabin.init_profile_id,
+			TASDEVICE_BIN_BLK_PRE_POWER_UP);
+
 	/* If calibrated data occurs error, dsp will still works with default
 	 * calibrated data inside algo.
 	 */
@@ -760,6 +766,12 @@ static int tas2781_system_resume(struct
 	tasdevice_reset(tas_hda->priv);
 	tasdevice_prmg_load(tas_hda->priv, tas_hda->priv->cur_prog);
 
+	/* Init common setting for different audio profiles */
+	if (tas_hda->priv->rcabin.init_profile_id >= 0)
+		tasdevice_select_cfg_blk(tas_hda->priv,
+			tas_hda->priv->rcabin.init_profile_id,
+			TASDEVICE_BIN_BLK_PRE_POWER_UP);
+
 	if (tas_hda->priv->playback_started)
 		tasdevice_tuning_switch(tas_hda->priv, 0);
 


