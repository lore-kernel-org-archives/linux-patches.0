Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E3EF43B490;
	Tue, 21 Jul 2026 22:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673162; cv=none; b=DAnOZzUxuFNP3Hek3RzS5BSGDsILvNTa6XrTQHmR/tOsw0eUVjyguCTpjyOa/ZjrSqElZX132kNQkXxMz32kGmpc1YhVodkI3P0N0xI/lzbKi03iMoqvAd39ZQun+W38iJzPTPXgliHAWCW6l3L6CyodA4CdoHmWy59C9fYtaww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673162; c=relaxed/simple;
	bh=E5vLD4GjYnWR7vma/NbZJHMhf+DiG51/35Gnxl/Sbuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PCAjosQY3MLoPS01JGEgNVuQIvHXUxWXfegtvij57EorRsyHxI7Co/0jeluJf14YdqO2ZHrdSZbYdU17+0JQMmB6XC4SERhcZF4LlzijJzBmKdYgKDNTLjO2mdkZ996K5guxwYzUFVzbAT5vOe+8wKhKjIzfRsUQPN+6+KNRdzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nmTd5sUS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nmTd5sUS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4EE61F000E9;
	Tue, 21 Jul 2026 22:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673161;
	bh=C1Is7I9azV3L6zGq1r2eYXFOBEoVOR1FEahzKtCHRAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nmTd5sUSHgaJb4IWm4u/x1laH5JzUVawruD+3cXmFmdpg/F7O/WSrAe7bNF/QVHfF
	 Pnej5u/LM6B6NCmm2LiODFNrR7CYPyqLekokuSEDkj7u2QBGh8zXxIqYERUPkRXJpy
	 My4SdVtLViQa6TGapfETlfwWpX/qfLYzDesB+N1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 058/699] ALSA: usb-audio: Update Babyface Pro control caches only after successful writes
Date: Tue, 21 Jul 2026 17:16:57 +0200
Message-ID: <20260721152357.014805365@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

commit d8f802ccf1fdbeb89d62748d6a0d0fbd442c8127 upstream.

snd_bbfpro_ctl_put() and snd_bbfpro_vol_put()
cache the requested packed control state in
kcontrol->private_value before issuing the USB write.

Their get and resume paths use that cached value directly,
so a failed write can leave the driver reporting and later
replaying a setting the hardware never accepted.

Update the cached state only after a successful USB write.

Fixes: 3e8f3bd04716 ("ALSA: usb-audio: RME Babyface Pro mixer patch")
Cc: stable@vger.kernel.org
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260429-alsa-usb-quirks-cache-rollback-v1-2-01b35c688b80@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer_quirks.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -2791,12 +2791,14 @@ static int snd_bbfpro_ctl_put(struct snd
 	if (val == old_value)
 		return 0;
 
+	err = snd_bbfpro_ctl_update(mixer, reg, idx, val);
+	if (err < 0)
+		return err;
+
 	kcontrol->private_value = reg
 		| ((idx & SND_BBFPRO_CTL_IDX_MASK) << SND_BBFPRO_CTL_IDX_SHIFT)
 		| ((val & SND_BBFPRO_CTL_VAL_MASK) << SND_BBFPRO_CTL_VAL_SHIFT);
-
-	err = snd_bbfpro_ctl_update(mixer, reg, idx, val);
-	return err < 0 ? err : 1;
+	return 1;
 }
 
 static int snd_bbfpro_ctl_resume(struct usb_mixer_elem_list *list)
@@ -2881,11 +2883,13 @@ static int snd_bbfpro_vol_put(struct snd
 
 	new_val = uvalue & SND_BBFPRO_MIXER_VAL_MASK;
 
+	err = snd_bbfpro_vol_update(mixer, idx, new_val);
+	if (err < 0)
+		return err;
+
 	kcontrol->private_value = idx
 		| (new_val << SND_BBFPRO_MIXER_VAL_SHIFT);
-
-	err = snd_bbfpro_vol_update(mixer, idx, new_val);
-	return err < 0 ? err : 1;
+	return 1;
 }
 
 static int snd_bbfpro_vol_resume(struct usb_mixer_elem_list *list)


