Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A527618DF68;
	Mon, 28 Oct 2024 06:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097597; cv=none; b=jDTugB9dt8MjddZHPiSFoHWy5rQvvN9nbfiX2RhyDCLwwqL31Tiikds4nn5rzrCr41nUBll8wurKINaab7fSHqi0l+KKz4aX7HlG0NoYMhGdmd4CwRJxBqg7ihc++kN7Ru370am6e6TzdG9Qpz42g3U2ViRWBaDNscBwjYTgXqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097597; c=relaxed/simple;
	bh=lWMV+jzZacoBFR1wI2JwTvsJVoEp0+YrepVzi9LAKW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rNshKvGkJnuQdzIiKgKabHj9TeBRCKF9VffaX6SMBZpkTD79fJLkrj4lPJ25y+Ye45utHA4L2QrGmcvWrg+Ld9mcK9kZGOR3f0m/MRC/4ybALY/EbeNeh9sF1pigCrqMDkN0+eXRcfV2sf3yRGABd2efB0jS9XFSLtb57CC6v9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d3qPsiwh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d3qPsiwh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46928C4CEC3;
	Mon, 28 Oct 2024 06:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097597;
	bh=lWMV+jzZacoBFR1wI2JwTvsJVoEp0+YrepVzi9LAKW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d3qPsiwhT76C/hMQKD6yVQN/o1CZp5+u0bHoj2OCbdT91vLYOcMVT3xJeXoSOZEnW
	 YZ3nfEUcMlmpaWlM5BoCDo3U/N08/8Vdrk6TYCsKVmUOcTsPeLXJlZNLjyyBms6M+O
	 /gBUo+9SrvzSyOd8139v42g9SErlk7tbLFkL/fAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Murad Masimov <m.masimov@maxima.ru>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 027/208] ALSA: hda/cs8409: Fix possible NULL dereference
Date: Mon, 28 Oct 2024 07:23:27 +0100
Message-ID: <20241028062307.325354615@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e41316e2e9833..892223d9e64ab 100644
--- a/sound/pci/hda/patch_cs8409.c
+++ b/sound/pci/hda/patch_cs8409.c
@@ -1411,8 +1411,9 @@ void dolphin_fixups(struct hda_codec *codec, const struct hda_fixup *fix, int ac
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



