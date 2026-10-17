Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E0623A8753;
	Sat, 17 Oct 2026 17:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257493; cv=none; b=D0qmcxK6+svOSbqxD5UoEpkjXso5G1fta7o78OqYu8bOcaz0rAFMlz0FrlnHKvzjgwMqAgbk2fnmRFP0lylPcTTtK0xRRkbQXsTlXBL0KrcvytYKab8qhNOZLIVEo3qFaE8zu+3zQ/xOix0FWUCq1teS4+dsTNpfMpUUjW2WKcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257493; c=relaxed/simple;
	bh=MNRwf1WM0VI/Mo/9Xrw4pA06sMUCsrBd+yxex5XBLRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fe6mLE96M5yWWecSdHT8sIevxYrrLzQb3twVDLcZkVQ1DpUW7deMmMZsbdTQRQIXNSgKqWFx22J5K6sGEFTAcErbHbaBF8JgSpD7STjwlK17zlib9Yi4vAJYwjiBjeMYghkoP3/FCmJkw28y/ScKiXxY3pm1c5hBjZ4oVsoBv00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z1hR3cbo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z1hR3cbo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 675E51F000C5;
	Sat, 17 Oct 2026 17:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257491;
	bh=VEAbhIVJuj2JvF0f+XdlCyWwQjqp9b9OZEWNW+v+ehM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z1hR3cboAm2cbYBbjAlxEyDec4vVtdwFyXDXnNSGSoIninMjrfs/k6TUPnkcA9KVZ
	 U99e5D6imCZxaoG5spH6AUVHV1nP19qrE03BAdK9HWCoZge8tEnSXmZGD5leIcEB1m
	 E+AkAWnGab5YQ+WtLqJtxceH67AiBN4i49K9AoJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0577/1674] ALSA: mixer: oss: Add card disconnect checkpoints
Date: Sat, 17 Oct 2026 17:47:29 +0200
Message-ID: <20261017160445.903005750@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

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
Assisted-by: LLM
[ Backport to 6.6.y: Replace upstream scoped controls_rwsem release with
  explicit unlocks or existing unlock labels on the added shutdown exits.
  ]
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/oss/mixer_oss.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/sound/core/oss/mixer_oss.c b/sound/core/oss/mixer_oss.c
index abc99ae333282..ecb4af6709598 100644
--- a/sound/core/oss/mixer_oss.c
+++ b/sound/core/oss/mixer_oss.c
@@ -540,6 +540,10 @@ static void snd_mixer_oss_get_volume1_vol(struct snd_mixer_oss_file *fmixer,
 	if (numid == ID_UNKNOWN)
 		return;
 	down_read(&card->controls_rwsem);
+	if (card->shutdown) {
+		up_read(&card->controls_rwsem);
+		return;
+	}
 	kctl = snd_ctl_find_numid_locked(card, numid);
 	if (!kctl) {
 		up_read(&card->controls_rwsem);
@@ -579,6 +583,10 @@ static void snd_mixer_oss_get_volume1_sw(struct snd_mixer_oss_file *fmixer,
 	if (numid == ID_UNKNOWN)
 		return;
 	down_read(&card->controls_rwsem);
+	if (card->shutdown) {
+		up_read(&card->controls_rwsem);
+		return;
+	}
 	kctl = snd_ctl_find_numid_locked(card, numid);
 	if (!kctl) {
 		up_read(&card->controls_rwsem);
@@ -645,6 +653,10 @@ static void snd_mixer_oss_put_volume1_vol(struct snd_mixer_oss_file *fmixer,
 	if (numid == ID_UNKNOWN)
 		return;
 	down_read(&card->controls_rwsem);
+	if (card->shutdown) {
+		up_read(&card->controls_rwsem);
+		return;
+	}
 	kctl = snd_ctl_find_numid_locked(card, numid);
 	if (!kctl) {
 		up_read(&card->controls_rwsem);
@@ -688,6 +700,10 @@ static void snd_mixer_oss_put_volume1_sw(struct snd_mixer_oss_file *fmixer,
 	if (numid == ID_UNKNOWN)
 		return;
 	down_read(&card->controls_rwsem);
+	if (card->shutdown) {
+		up_read(&card->controls_rwsem);
+		return;
+	}
 	kctl = snd_ctl_find_numid_locked(card, numid);
 	if (!kctl) {
 		up_read(&card->controls_rwsem);
@@ -833,6 +849,10 @@ static int snd_mixer_oss_get_recsrc2(struct snd_mixer_oss_file *fmixer, unsigned
 		goto __free_only;
 	}
 	down_read(&card->controls_rwsem);
+	if (card->shutdown) {
+		err = -ENODEV;
+		goto __unlock;
+	}
 	kctl = snd_mixer_oss_test_id(mixer, "Capture Source", 0);
 	if (! kctl) {
 		err = -ENOENT;
@@ -886,6 +906,10 @@ static int snd_mixer_oss_put_recsrc2(struct snd_mixer_oss_file *fmixer, unsigned
 		goto __free_only;
 	}
 	down_read(&card->controls_rwsem);
+	if (card->shutdown) {
+		err = -ENODEV;
+		goto __unlock;
+	}
 	kctl = snd_mixer_oss_test_id(mixer, "Capture Source", 0);
 	if (! kctl) {
 		err = -ENOENT;
@@ -937,6 +961,10 @@ static int snd_mixer_oss_build_test(struct snd_mixer_oss *mixer, struct slot *sl
 	int err;
 
 	down_read(&card->controls_rwsem);
+	if (card->shutdown) {
+		up_read(&card->controls_rwsem);
+		return -ENODEV;
+	}
 	kcontrol = snd_mixer_oss_test_id(mixer, name, index);
 	if (kcontrol == NULL) {
 		up_read(&card->controls_rwsem);
@@ -1069,6 +1097,10 @@ static int snd_mixer_oss_build_input(struct snd_mixer_oss *mixer,
 	if (snd_mixer_oss_build_test_all(mixer, ptr, &slot))
 		return 0;
 	down_read(&mixer->card->controls_rwsem);
+	if (mixer->card->shutdown) {
+		up_read(&mixer->card->controls_rwsem);
+		return -ENODEV;
+	}
 	kctl = NULL;
 	if (!ptr->index)
 		kctl = snd_mixer_oss_test_id(mixer, "Capture Source", 0);
-- 
2.53.0



