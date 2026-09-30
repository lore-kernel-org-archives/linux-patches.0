Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 623C34F93B9;
	Wed, 30 Sep 2026 16:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784055; cv=none; b=SkzBHVwX9Qe4FOJ33ktpDfmdw7WxQ2c2FRpFogMOziGoduoGi2IbHxOmDOENGag5/KL7ME675Kfgu46NOpI4N0igSkoAuja+DujsbNpEHdUQKy9HLhRw1Hcic0BcstHsC80NkwmrDoqvglm82Qr/GvA8xGi3HeaE8TmF47j/KL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784055; c=relaxed/simple;
	bh=1eBWHCdO5u2oX1lFRfHxvHgNNHnmuaLNWrWQYsLmOKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cbejTHnxR+sRtAK/mYJCgKv4yGF5ayyr+5nx8nVfeaObc9+c3BJL3ThsiekAfkiMtJJ0WJsg1M0yFMnmnCkrDMFjfJPK1h9ycSb8sV36+omjhts1rpak4z7Q98p5V9cD2iWANl543fTZ6AkoHikKM9mqV2dkJ7Iw3LFa2QI/EqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AU5yWTTp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AU5yWTTp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A884B1F000FF;
	Wed, 30 Sep 2026 16:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784051;
	bh=PvDOIn74+7REaajKhMwf47TiedZATPtVGiRenBJKR4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AU5yWTTp3ECIpmZrTkrNasX2w/spCG4d6IQdElZeJ0bP/l9p1tdof4MUn12JVMvoX
	 mwO6pRJGh5hpv6EuCaMfBmUWmeRre9d/w/U68apXLkp8XovPXNL4iC6tMwNsy2rVj9
	 GkIXOa7k1bhoExCCpep+4NG+j78Mpz6ozh0OaPbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 003/982] ALSA: usb-audio: Propagate write errors in generic mixer put callbacks
Date: Wed, 30 Sep 2026 17:12:19 +0200
Message-ID: <20260930152416.854463680@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 21543ed58453b..45a4a8c7a697d 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -1463,7 +1463,10 @@ static int mixer_ctl_feature_put(struct snd_kcontrol *kcontrol,
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
@@ -1478,7 +1481,9 @@ static int mixer_ctl_feature_put(struct snd_kcontrol *kcontrol,
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
@@ -2345,7 +2350,9 @@ static int mixer_ctl_procunit_put(struct snd_kcontrol *kcontrol,
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
@@ -2709,7 +2716,9 @@ static int mixer_ctl_selector_put(struct snd_kcontrol *kcontrol,
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



