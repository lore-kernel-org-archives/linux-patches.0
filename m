Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCABA3E2AD7;
	Wed, 30 Sep 2026 18:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793909; cv=none; b=ZoZGuXFb/SBrtnGa8qfODt06Q7oo93GIAY3HBCF6a7w8L24+KV7PhEM/JkBHE7IAPpIROer6kADwjwGVL1flMB+r7fup433pPDGPh2yogCwKBajqs36RMVjgCCl9q1OKx/N7rTW74zKxunfy6UrDthpy+BdWnZ2ZiO4N+Jx7deQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793909; c=relaxed/simple;
	bh=LGKs7QXuPjM1PJ/jKP/YJZR0b4T4j1LDfUfraUcKMSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LrQYJSSbQtlYx4T/xNUHkAdJnivRXF2wVmwwuH9x8b/tCAzu9kaNzb1bke5vY257+jpDnk5kYYowo7Rw+Cf/papPRHgWfLuuzt9W3CXT11VeAipDk3DyWygs2z/U7ASn6Ne05CznRUp7L4pyiTe0vBFvfHiSQ96VAbkYANzZERU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hcLHS3DV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hcLHS3DV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8982C1F000FF;
	Wed, 30 Sep 2026 18:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793907;
	bh=t9SsJzlCluhFRCKeXtpJGojxa2k6y3B/AOQc2806LCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hcLHS3DVoG7dOOuW1HM9+8CMGARRerrJzz5JN9D4OflgammeZ+Kg6sI8AiZ1bUZmi
	 aASeKXcbCgsycoHvo749T7uSeHMj+olefyhXROglbahZJ0nqLi/ITlkqaYeIJnetYE
	 eB+VcJbqfTXfLtm7bXP+r8+/dlIngsiMIXJayME4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0007/1193] ALSA: usb-audio: Propagate write errors in generic mixer put callbacks
Date: Wed, 30 Sep 2026 17:11:31 +0200
Message-ID: <20260930152434.472345134@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8c4fb5be3dba9..0a729ec282179 100644
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
@@ -2343,7 +2348,9 @@ static int mixer_ctl_procunit_put(struct snd_kcontrol *kcontrol,
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
@@ -2707,7 +2714,9 @@ static int mixer_ctl_selector_put(struct snd_kcontrol *kcontrol,
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



