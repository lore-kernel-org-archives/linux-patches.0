Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4D2497396;
	Thu, 17 Sep 2026 16:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660913; cv=none; b=jRqfIL+/YKVi8IHO7FG1WZkupFp+ewby3QiMGi4OtouqqqSR0xnFo2GysLEyJRJCowcfm6RTJsW79GJcw7twnc7Yi0BjU9uvj+KZbPwKKgVRFMfB+5h1SWeb4ttWzu58a57N0CLpEAQ2GwXNTIU07swf0qXAN0JsX6bWWBjzXHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660913; c=relaxed/simple;
	bh=QAGM7rTFuHtpDVqYXL1Aie1cvxFBnHmEB+nzdVB2NzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gYe7fGaAT6Vchv74ggsvo1S27OBlu58VlubIRbd1pibk1RCr7i5+YocCWDvTCnmdf1bWZrkXIA5iRoYgcCA6lB9IER7mpfhHF9r7Cb5XU8CrpAF0x3yK2uNvrScs8evnh81tPTs0Sha+jKU01RNnAmEHypgOCxwJbfMQcqBFPe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=exjGrTba; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="exjGrTba"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 857B41F000FF;
	Thu, 17 Sep 2026 16:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660912;
	bh=N6MVjtFdssAc9sKlTscjETP6E8ukTalqw+tgCAx1IUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=exjGrTbagxoZTjflrRl6L8kr3DtCo5O2XEjfyTp7gNoh5nwSSEEIJsRNa/AXSJz9V
	 aEm5bdzWlrtr4cYILxBeTB5GOxoNv6Rzmlb4JWuxP3VeUxcZuLXcHf84fBWW4zj41B
	 hZorV6M3C+VHTrv9n1auDErgpcj2OBI3Ldx10WKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0020/1250] ALSA: usb-audio: Propagate write errors in generic mixer put callbacks
Date: Thu, 17 Sep 2026 15:56:55 +0100
Message-ID: <20260917151552.476682379@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 2e65afd18bd3c..72bd94b44ce34 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -1469,7 +1469,10 @@ static int mixer_ctl_feature_put(struct snd_kcontrol *kcontrol,
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
@@ -1484,7 +1487,9 @@ static int mixer_ctl_feature_put(struct snd_kcontrol *kcontrol,
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
@@ -2350,7 +2355,9 @@ static int mixer_ctl_procunit_put(struct snd_kcontrol *kcontrol,
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
@@ -2714,7 +2721,9 @@ static int mixer_ctl_selector_put(struct snd_kcontrol *kcontrol,
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



