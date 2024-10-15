Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C881C57B1;
	Tue, 15 Oct 2024 12:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994046; cv=none; b=INWVVG+4buxNtJRQsr7ss9lUzagNHMIvojYrLnMLdaKtv062DCF1V6I0hpzM2Qzal2TIlx5TgZ5Q26TKDcAsK7+w37oh5QkifjqARZtBIT+y/C11zQ35SyvIIrjiLDE3VjOwN9WjUozYxMjzMGEchmW/2njS1UtU3cYr6Y+LgXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994046; c=relaxed/simple;
	bh=N6DWO6LvL9I4/U8Qs+T43DWi4KQbodkK3RIQMotoZRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nsxpnvvaBbhBY31Vp9VVF5PFoO91jQGj3R75/os2wFV8w2lnCzExxuNzRdFbARxwQju6voXaP9YpfEvhZqievUPxv6WhUHFTHQ1HEmprVu7ixJNOc2rk3KO9lEBH4hIZKc3PphIdSKkaHDgoWZQkAyxSI8of4lFDYtHUqmX5roQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IgQLsZQG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IgQLsZQG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 481FAC4CEC6;
	Tue, 15 Oct 2024 12:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994046;
	bh=N6DWO6LvL9I4/U8Qs+T43DWi4KQbodkK3RIQMotoZRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IgQLsZQGMG3WIep3lpt3lsoVo5+mJ3ALwu3tOh97F1Au4iZHZu0QBO2ihohJWOize
	 eS6CWY947AgdHiFSlTZp/iYXNPlvGzqF6wL/P6bAUucNxz9OrFjZXWr8GUEqaf8HqM
	 dVjygU7iUxrT3ieHEHmc6+Veqb4VAip17ShMRx9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	coverity-bot <keescook@chromium.org>,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	Harshvardhan Jha <harshvardhan.j.jha@oracle.com>
Subject: [PATCH 5.15 584/691] ALSA: usb-audio: Fix possible NULL pointer dereference in snd_usb_pcm_has_fixed_rate()
Date: Tue, 15 Oct 2024 13:28:52 +0200
Message-ID: <20241015112503.519282155@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jaroslav Kysela <perex@perex.cz>

commit 92a9c0ad86d47ff4cce899012e355c400f02cfb8 upstream.

The subs function argument may be NULL, so do not use it before the NULL check.

Fixes: 291e9da91403 ("ALSA: usb-audio: Always initialize fixed_rate in snd_usb_find_implicit_fb_sync_format()")
Reported-by: coverity-bot <keescook@chromium.org>
Link: https://lore.kernel.org/alsa-devel/202301121424.4A79A485@keescook/
Signed-off-by: Jaroslav Kysela <perex@perex.cz>
Link: https://lore.kernel.org/r/20230113085311.623325-1-perex@perex.cz
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Harshvardhan Jha <harshvardhan.j.jha@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/pcm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -160,11 +160,12 @@ find_substream_format(struct snd_usb_sub
 bool snd_usb_pcm_has_fixed_rate(struct snd_usb_substream *subs)
 {
 	const struct audioformat *fp;
-	struct snd_usb_audio *chip = subs->stream->chip;
+	struct snd_usb_audio *chip;
 	int rate = -1;
 
 	if (!subs)
 		return false;
+	chip = subs->stream->chip;
 	if (!(chip->quirk_flags & QUIRK_FLAG_FIXED_RATE))
 		return false;
 	list_for_each_entry(fp, &subs->fmt_list, list) {


