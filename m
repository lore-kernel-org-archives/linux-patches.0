Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1350F44AB8E;
	Tue, 21 Jul 2026 21:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668199; cv=none; b=syt/YmKcBikoPNbG8GmYllfRmRzZXG3cmoS3NbKzyvGth3PUGZP3nr7GDfXhDQz/U2H+77u/qmiee3TbSFYbyneNQqOA4muBnUIGOaSUDkTk1wfxoYKdUy1xI5XO5v4PeZi+dfJULuzSaBBvmXgl4goKqVxfEx7DyyGGzqIne68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668199; c=relaxed/simple;
	bh=N4W1pq4N0FSSHc4+qHLPVO7WjvscEzQoaBrqPEidn2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bTadr/uNop3hULAZgm6COiyNq/EXza47pd5nqGsMwmlmRwJWRejYs8oDadIR8e0Bn7wZ6KJbrb8aGt4ROB/TRt9fqUR7o+96pg4TJYZCH97qiUO7CoFUiIKiYtv4I7v9i4rqSo17Lvp1Nn6u27ett/EeaBYmrSoM9dcYya5aLAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hiKv0r/r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hiKv0r/r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A93E1F000E9;
	Tue, 21 Jul 2026 21:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668198;
	bh=jr/jmtda/xzZDKe30LFq4XViuZzH2JvfyFlpA0ajt3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hiKv0r/rgQ3pKyvuecpB6m1CAH1pzBNt9eAlKMnktmOWB/w0/9Ik5Yhtlk3ZVYkWS
	 kQ0J1YkM692IFinKUciFDRVBJuMDctuQXHqK9rrN853qKV5ck5thOLJoD56iXxR/iH
	 XASG+JUQznlZ42XJX8VKR0HFkV8T+vDyAlVKn0tA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 0084/1067] ALSA: usb-audio: Update Babyface Pro control caches only after successful writes
Date: Tue, 21 Jul 2026 17:11:25 +0200
Message-ID: <20260721152426.456501858@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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
@@ -2950,12 +2950,14 @@ static int snd_bbfpro_ctl_put(struct snd
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
@@ -3040,11 +3042,13 @@ static int snd_bbfpro_vol_put(struct snd
 
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


