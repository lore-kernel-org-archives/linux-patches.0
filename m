Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4663428505E;
	Thu, 16 Jul 2026 14:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211804; cv=none; b=o9NNsK+9Wf462ocXWrOOuSShUzQ2HTqov54WP4nfoEyf6fy68VFq+beQEPIJNfveQToKIM/gTIgZ10zqOn6jO7ZorHUFVkwBynQCvV7vvuB0T1EPIorR0qNmFtajOIyYQgl8dg7f93C5UkCfLMkqdsgy9VuGigCb6cQkcQ7up/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211804; c=relaxed/simple;
	bh=doV2ocj3kpB+54HneNQMAjTjVnXYt74cDmQjVcgb+vg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LI6UMXCqPxJi0m2DO5sUaWuunKGexhNhJaoFRHE+mDjbyVYhgC0b7J/pfCtHRLY/Z4TMQs8bN4p7CSW9jueLNiOqjVZwZJDv5y2YaHDysN9wtNfFcU9W9sDpnM9p/5fmadQcsS2J2KvUwQzHXrEwGsXDXnKeEmVibcQHYFyp8Lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F9THDR6Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F9THDR6Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB5631F000E9;
	Thu, 16 Jul 2026 14:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211803;
	bh=JB9XMvCYi6ckeE6X8aqkXwKcfaiyre6DIPFOxWWs/0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F9THDR6YkmEFyGVw2uHdkMmRcBIic44Frw8zX6ZR4dKcYw10U0fKvJcy+rTPIMUU5
	 X18BtWMrup6tZtk38CQ0yHWqJ7X1E/VYxg3hGeKxE28HM2WVW1c/MdkOc4pEVh3EsI
	 aGhocwYR7F81C1YqAKuqPlhJvc1fNy9o01ODCK6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 085/349] ALSA: usb-audio: Update Babyface Pro control caches only after successful writes
Date: Thu, 16 Jul 2026 15:30:19 +0200
Message-ID: <20260716133035.216642271@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2958,12 +2958,14 @@ static int snd_bbfpro_ctl_put(struct snd
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
@@ -3156,11 +3158,13 @@ static int snd_bbfpro_vol_put(struct snd
 
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


