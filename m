Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E6918CC1F;
	Mon, 28 Oct 2024 06:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730096900; cv=none; b=Y0f32sOW23Ld4ZlxUeleiyv9LRzdSCOAI7ga2h/T3G8ShHv6yLZLIOypsfrtQGHPQ+8X0f/+O45VfSgMsSVRAvgH6VRCCJSX8LW0ayywH9fapvmkLu+aVn4AYt0sF4vypdB75Zs9HfQCDvTlJNMDS27QhvW86gtLlazB8d/NyRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730096900; c=relaxed/simple;
	bh=2gon24p5GKFjS5wVcV1nqPzoPhNXK2c0jaXS6Qy8cVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NYPkg6zutubDJsGu04xOzolrkZvb/niyXlPEBurCfHSVP84GI8CYBm6q+bxqfnvLWw6bpbuiaqdVoytx2ZSn7knB48HAioV33U4rkbDCxGqz5WlsqoGRZxJ140BDK0Uc9vdM/N4+Sp6IjXBzOoy3PQeMi+qEzz/iNT1q7jBtc68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WPs5e9/C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WPs5e9/C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC31AC4CEC3;
	Mon, 28 Oct 2024 06:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730096900;
	bh=2gon24p5GKFjS5wVcV1nqPzoPhNXK2c0jaXS6Qy8cVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WPs5e9/CpgtNhF1psDO6RhvmUzCBrGX6klu+ElT7+nPT1UBwVqSSirqm37I6ydrRL
	 W9MwEXf4LyEErYqiC2b50G+Ag9qMi57pqIG/frW63AwbOZHzZtHqiCC/ieKXHNlBVI
	 lIeom2D9r4xKjZPGkj60+LUaKcuqMo6AGMk35nbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Murad Masimov <m.masimov@maxima.ru>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 07/80] ALSA: hda/cs8409: Fix possible NULL dereference
Date: Mon, 28 Oct 2024 07:24:47 +0100
Message-ID: <20241028062252.825896113@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062252.611837461@linuxfoundation.org>
References: <20241028062252.611837461@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Murad Masimov <m.masimov@maxima.ru>

[ Upstream commit c9bd4a82b4ed32c6d1c90500a52063e6e341517f ]

If snd_hda_gen_add_kctl fails to allocate memory and returns NULL, then
NULL pointer dereference will occur in the next line.

Since dolphin_fixups function is a hda_fixup function which is not supposed
to return any errors, add simple check before dereference, ignore the fail.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 20e507724113 ("ALSA: hda/cs8409: Add support for dolphin")
Signed-off-by: Murad Masimov <m.masimov@maxima.ru>
Link: https://patch.msgid.link/20241010221649.1305-1-m.masimov@maxima.ru
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_cs8409.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/patch_cs8409.c b/sound/pci/hda/patch_cs8409.c
index abf4eef9afa08..7285220c36f01 100644
--- a/sound/pci/hda/patch_cs8409.c
+++ b/sound/pci/hda/patch_cs8409.c
@@ -1237,8 +1237,9 @@ void dolphin_fixups(struct hda_codec *codec, const struct hda_fixup *fix, int ac
 		kctrl = snd_hda_gen_add_kctl(&spec->gen, "Line Out Playback Volume",
 					     &cs42l42_dac_volume_mixer);
 		/* Update Line Out kcontrol template */
-		kctrl->private_value = HDA_COMPOSE_AMP_VAL_OFS(DOLPHIN_HP_PIN_NID, 3, CS8409_CODEC1,
-				       HDA_OUTPUT, CS42L42_VOL_DAC) | HDA_AMP_VAL_MIN_MUTE;
+		if (kctrl)
+			kctrl->private_value = HDA_COMPOSE_AMP_VAL_OFS(DOLPHIN_HP_PIN_NID, 3, CS8409_CODEC1,
+					       HDA_OUTPUT, CS42L42_VOL_DAC) | HDA_AMP_VAL_MIN_MUTE;
 		cs8409_enable_ur(codec, 0);
 		snd_hda_codec_set_name(codec, "CS8409/CS42L42");
 		break;
-- 
2.43.0



