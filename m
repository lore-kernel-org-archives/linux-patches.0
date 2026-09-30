Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA0D85218B1;
	Wed, 30 Sep 2026 17:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790631; cv=none; b=tXsQphgwN6a/RfNUlqdSQKIjs/NBHlGc5Jv8b6MGSVf7/Omp+8a29Wz9NQFx6J4NfUQxhd6qI+lQO5M3SjZYk0mwU9fok6d9yvTrzskr8vFlDDaIYpAApocS3+C/iN9IJ2JDqTpfsK8zEDTiXZFZHQKUglECka6IhvZdq1p5zrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790631; c=relaxed/simple;
	bh=16pgzUWCGYskSh/ZbI7r8/EoGlfv20iqpGZRJyXfLlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CbSLlYX7+HtL6rmw7S48xmwnflfH0DYKXQkbDskdlnSk3QtFHunP3Lbf71jtUMiznxkvE26g2iWi0+bplRuGhGUrjOB0BnaMR9QBeVoGcRdpHJnyT9rQ0+WREe0DWxRvj164rr1wypworOs+wGyhAwq8EyUbEPyfsbwrEPHDon8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BZt6R4B2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BZt6R4B2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1272A1F000FF;
	Wed, 30 Sep 2026 17:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790630;
	bh=96m6Byi7qLfxOzXdBg9Pe3yxktgCrBtawcv4aBhj1n4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BZt6R4B2+Tne3socHLmaqgXuls4zmrhKF9r6nnLDB01aU4pqJMgoJsdhJuUtEhlV3
	 xMD4a5TqkbxlL8vUWlxp9o05mg9hSMgvlk4AHVrJZk7AXOgIKbLdCtYHP9qRjV5tXK
	 8LR2ScR8+Sdpyk1r2GpUeofcIOhx4buVgvHd4ETI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 002/752] ALSA: usb-audio: Propagate write errors in generic mixer put callbacks
Date: Wed, 30 Sep 2026 17:17:52 +0200
Message-ID: <20260930152358.192823600@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

[ Upstream commit 87a6f2fa6e6c69bb649fa327635a0bd977724603 ]

mixer_ctl_feature_put(), mixer_ctl_procunit_put(), and
mixer_ctl_selector_put() ignore failures from their SET_CUR helper
routines and report the control as changed whenever the requested
value differs from the current one.

If the device rejects the write, userspace still sees success although
the hardware state did not change. Propagate write failures instead,
using filter_error() so ignore_ctl_error keeps the same semantics as
the existing get paths.

Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260419-usb-write-error-propagation-v1-1-5a3bd4a673ae@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index 85759bf58209b..fa2c740249e33 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -1453,7 +1453,10 @@ static int mixer_ctl_feature_put(struct snd_kcontrol *kcontrol,
 				return -EINVAL;
 			val = get_abs_value(cval, val);
 			if (oval != val) {
-				snd_usb_set_cur_mix_value(cval, c + 1, cnt, val);
+				err = snd_usb_set_cur_mix_value(cval, c + 1,
+								cnt, val);
+				if (err < 0)
+					return filter_error(cval, err);
 				changed = 1;
 			}
 			cnt++;
@@ -1468,7 +1471,9 @@ static int mixer_ctl_feature_put(struct snd_kcontrol *kcontrol,
 			return -EINVAL;
 		val = get_abs_value(cval, val);
 		if (val != oval) {
-			snd_usb_set_cur_mix_value(cval, 0, 0, val);
+			err = snd_usb_set_cur_mix_value(cval, 0, 0, val);
+			if (err < 0)
+				return filter_error(cval, err);
 			changed = 1;
 		}
 	}
@@ -2335,7 +2340,9 @@ static int mixer_ctl_procunit_put(struct snd_kcontrol *kcontrol,
 		return -EINVAL;
 	val = get_abs_value(cval, val);
 	if (val != oval) {
-		set_cur_ctl_value(cval, cval->control << 8, val);
+		err = set_cur_ctl_value(cval, cval->control << 8, val);
+		if (err < 0)
+			return filter_error(cval, err);
 		return 1;
 	}
 	return 0;
@@ -2699,7 +2706,9 @@ static int mixer_ctl_selector_put(struct snd_kcontrol *kcontrol,
 		return -EINVAL;
 	val = get_abs_value(cval, val);
 	if (val != oval) {
-		set_cur_ctl_value(cval, cval->control << 8, val);
+		err = set_cur_ctl_value(cval, cval->control << 8, val);
+		if (err < 0)
+			return filter_error(cval, err);
 		return 1;
 	}
 	return 0;
-- 
2.53.0



