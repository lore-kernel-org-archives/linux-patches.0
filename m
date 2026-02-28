Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03F97313E31
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301066; cv=none; b=cI9Nh+eRCfHlzN2YWevjDah7t1XY7QSMAveNDPFqnyFO+4I+FqOI7zu2tJNClPtiPdfbJhMFajybNPucryVMVsYTBj1t50HHPYMwxq+cNV/tQ0cn9GyVHr14Rh1uvmM6EtwjigLGVfftTir7cVgwlN5AAvAlFAFOUnOmSYE2u20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301066; c=relaxed/simple;
	bh=8NYj5MqQRfE49UHoasW3T3ZjMCJflVO/gNWxdPgZLp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P27PABPkbCW2eurDJV79AyLfX9NMfkbhgB8/VGVbfOmZcCW2ssu2ECZ+ccZAVLdftliJcRNcm1f+wDQtHcsp02DQokPvpvxdhDfQFmYV1JIpvuwU/Oycv0qpPdCylGnfq2sMS8WRAE9lxlRHHsvUmVkp2XxdL4MqYH9XO4RtGx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hsjYY5j2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hsjYY5j2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C245C19423;
	Sat, 28 Feb 2026 17:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301065;
	bh=8NYj5MqQRfE49UHoasW3T3ZjMCJflVO/gNWxdPgZLp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hsjYY5j2nbUednmUq0QRhG/aljrFPzggemtxR3KV2pMHwysmSai2dRrAMoppj+OE+
	 No53v1oLOKihshr2kE9LILqYjUlSC7OPqbLniVtdmpJ0rcLbU+5ikdc2t1/z7b+VH7
	 kD7KzlEO2E5wcfdPq89F7+LAYb7ZlaZdCy+/fCuw6yDmHWJuVhg9f/i3LKSVWNd5Q4
	 kGUM9/oOT9CJuHxcPpJRkTjTBUeBN+700R2sMzQZqa03tHHUc9fKoMt2R1EdicG2K1
	 hZ/W1YPSKLGa4QpN9uk4IYjrulW4RL0g1jywc29vXRYEPtT+BujNRc9fGSTitZ01hb
	 sRjc6Hi8/5rBQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 209/752] ALSA: mixer: oss: Add card disconnect checkpoints
Date: Sat, 28 Feb 2026 12:38:40 -0500
Message-ID: <20260228174750.1542406-209-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 084d5d44418148662365eced3e126ad1a81ee3e2 ]

ALSA OSS mixer layer calls the kcontrol ops rather individually, and
pending calls might be not always caught at disconnecting the device.

For avoiding the potential UAF scenarios, add sanity checks of the
card disconnection at each entry point of OSS mixer accesses.  The
rwsem is taken just before that check, hence the rest context should
be covered by that properly.

Link: https://patch.msgid.link/20260209121212.171430-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/oss/mixer_oss.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/sound/core/oss/mixer_oss.c b/sound/core/oss/mixer_oss.c
index e839a4bb93f81..aa98caaaea3c5 100644
--- a/sound/core/oss/mixer_oss.c
+++ b/sound/core/oss/mixer_oss.c
@@ -525,6 +525,8 @@ static void snd_mixer_oss_get_volume1_vol(struct snd_mixer_oss_file *fmixer,
 	if (numid == ID_UNKNOWN)
 		return;
 	guard(rwsem_read)(&card->controls_rwsem);
+	if (card->shutdown)
+		return;
 	kctl = snd_ctl_find_numid(card, numid);
 	if (!kctl)
 		return;
@@ -558,6 +560,8 @@ static void snd_mixer_oss_get_volume1_sw(struct snd_mixer_oss_file *fmixer,
 	if (numid == ID_UNKNOWN)
 		return;
 	guard(rwsem_read)(&card->controls_rwsem);
+	if (card->shutdown)
+		return;
 	kctl = snd_ctl_find_numid(card, numid);
 	if (!kctl)
 		return;
@@ -618,6 +622,8 @@ static void snd_mixer_oss_put_volume1_vol(struct snd_mixer_oss_file *fmixer,
 	if (numid == ID_UNKNOWN)
 		return;
 	guard(rwsem_read)(&card->controls_rwsem);
+	if (card->shutdown)
+		return;
 	kctl = snd_ctl_find_numid(card, numid);
 	if (!kctl)
 		return;
@@ -655,6 +661,8 @@ static void snd_mixer_oss_put_volume1_sw(struct snd_mixer_oss_file *fmixer,
 	if (numid == ID_UNKNOWN)
 		return;
 	guard(rwsem_read)(&card->controls_rwsem);
+	if (card->shutdown)
+		return;
 	kctl = snd_ctl_find_numid(card, numid);
 	if (!kctl)
 		return;
@@ -792,6 +800,8 @@ static int snd_mixer_oss_get_recsrc2(struct snd_mixer_oss_file *fmixer, unsigned
 	if (uinfo == NULL || uctl == NULL)
 		return -ENOMEM;
 	guard(rwsem_read)(&card->controls_rwsem);
+	if (card->shutdown)
+		return -ENODEV;
 	kctl = snd_mixer_oss_test_id(mixer, "Capture Source", 0);
 	if (!kctl)
 		return -ENOENT;
@@ -835,6 +845,8 @@ static int snd_mixer_oss_put_recsrc2(struct snd_mixer_oss_file *fmixer, unsigned
 	if (uinfo == NULL || uctl == NULL)
 		return -ENOMEM;
 	guard(rwsem_read)(&card->controls_rwsem);
+	if (card->shutdown)
+		return -ENODEV;
 	kctl = snd_mixer_oss_test_id(mixer, "Capture Source", 0);
 	if (!kctl)
 		return -ENOENT;
@@ -878,6 +890,8 @@ static int snd_mixer_oss_build_test(struct snd_mixer_oss *mixer, struct slot *sl
 	int err;
 
 	scoped_guard(rwsem_read, &card->controls_rwsem) {
+		if (card->shutdown)
+			return -ENODEV;
 		kcontrol = snd_mixer_oss_test_id(mixer, name, index);
 		if (kcontrol == NULL)
 			return 0;
@@ -1002,6 +1016,8 @@ static int snd_mixer_oss_build_input(struct snd_mixer_oss *mixer,
 	if (snd_mixer_oss_build_test_all(mixer, ptr, &slot))
 		return 0;
 	guard(rwsem_read)(&mixer->card->controls_rwsem);
+	if (mixer->card->shutdown)
+		return -ENODEV;
 	kctl = NULL;
 	if (!ptr->index)
 		kctl = snd_mixer_oss_test_id(mixer, "Capture Source", 0);
-- 
2.51.0

