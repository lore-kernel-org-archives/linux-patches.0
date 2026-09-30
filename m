Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0B8502795;
	Wed, 30 Sep 2026 15:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782356; cv=none; b=m/tIwLwwpsE33A0zLZ5ZjJtY7R8hkLHhWFQcl9g7RxSudsj9fGEINOx6voSvhrCMCFtUs9gO/lPy6YLH35aPbAnCfmJZj7QiOTxvaH14NdWxGjRlIsXUb1CREmT2e/zOY3IiEIorGpW+fu85R55X/ja226AAW9RfmdGnxL33syo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782356; c=relaxed/simple;
	bh=VXN7w6GjrSxEHIciIadgXBROsSsFooGL3bBi3aRZNIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ouYkr/44WM6U23Op8QumAmVUaJkmmZrkW/O3y3Nq5GW2kbjhjTYUEWAJixLqe5vlq4rInjWOCgtMUd9YGZpW+fdG7Elj2FW6PWoMn3GwvLO6nJ67VUpOtIumsvxyoW+BcBwkPjbUKJYwjszQMUwhxstq7HABPOSq8LTKcP+ihUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bSCCG6Up; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bSCCG6Up"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 484C61F000FF;
	Wed, 30 Sep 2026 15:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782345;
	bh=OJqAr2wN6wGGetI0BkjwLMmHiCzLSFvT4mWpQ6k75xs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bSCCG6Up9xt9DkXgYl0jTgg73VMShB6YE2zLtWl1Nq+7AkZHN4dv37Uqnfe3RYMEO
	 o9PJr6FHma/KcurzEWCT0eLokYVaCgu9c4Uypz8YAoLJTdTHRIherw6GW6LFINBtNC
	 7L+MHZJxr2P1gt/8i1zbYp3GFikGLwN3Q5QlUa98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 002/595] ALSA: usb-audio: Propagate write errors in generic mixer put callbacks
Date: Wed, 30 Sep 2026 17:18:15 +0200
Message-ID: <20260930152347.762010466@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7f64199139d31..7c3f9ab4a9f20 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -1419,7 +1419,10 @@ static int mixer_ctl_feature_put(struct snd_kcontrol *kcontrol,
 			val = ucontrol->value.integer.value[cnt];
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
@@ -1432,7 +1435,9 @@ static int mixer_ctl_feature_put(struct snd_kcontrol *kcontrol,
 		val = ucontrol->value.integer.value[0];
 		val = get_abs_value(cval, val);
 		if (val != oval) {
-			snd_usb_set_cur_mix_value(cval, 0, 0, val);
+			err = snd_usb_set_cur_mix_value(cval, 0, 0, val);
+			if (err < 0)
+				return filter_error(cval, err);
 			changed = 1;
 		}
 	}
@@ -2264,7 +2269,9 @@ static int mixer_ctl_procunit_put(struct snd_kcontrol *kcontrol,
 	val = ucontrol->value.integer.value[0];
 	val = get_abs_value(cval, val);
 	if (val != oval) {
-		set_cur_ctl_value(cval, cval->control << 8, val);
+		err = set_cur_ctl_value(cval, cval->control << 8, val);
+		if (err < 0)
+			return filter_error(cval, err);
 		return 1;
 	}
 	return 0;
@@ -2626,7 +2633,9 @@ static int mixer_ctl_selector_put(struct snd_kcontrol *kcontrol,
 	val = ucontrol->value.enumerated.item[0];
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



