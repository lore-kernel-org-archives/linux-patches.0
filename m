Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C189192D8E;
	Tue, 10 Sep 2024 10:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962825; cv=none; b=AKW+Byk5tqnTXNAAzJE0b4l2zLBDB9/kfIC+7DogDfWbdk9Bh7dA5fOIqfb4zDoduQqK0P1mBye+hmc14+aPFcnyzhX52YknQXeCX+fcsdkP64Hrtxp3bs/mGVFPOEhOYwvvpY6+8o/Fmzdk4zHINyh3H1Q97DKSSgL7kdyVbqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962825; c=relaxed/simple;
	bh=ihI0pEvX6qb1KNwTVs8fGhGmSAgSb7PNnK5YXprGLKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q8jC2nlr+8FZrJ4dK6q4ZSGPKNxROL/pIUSYcpM31ZraEQrlXUkrfM+VnkUxOFp4opB0fFVGXiefecQiL6TkwwM5tKXIxyyxRtQUrIkgn8/j9hPBo4fNKhl1yLHlcdmphQFmOUq00z2NQ1esjoGtKUvR+HuCjJm+Bh6rEgfDR9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Etwe+0+d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Etwe+0+d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 141C5C4CEC3;
	Tue, 10 Sep 2024 10:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962825;
	bh=ihI0pEvX6qb1KNwTVs8fGhGmSAgSb7PNnK5YXprGLKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Etwe+0+dVs0u+JQoN6/k0+01yc+twZruF9sdu+g88tL06D8jWEDEMQ87BiONCzBzS
	 BZ+QuC4hsA1eR0Kg9Dz+9JkIDwdJXwyC3m+dnLCC45Zl2Zv9Ap3hQH2jja4h3Ow7EC
	 74Cpr6vDFgSJyQ8GIFj57Z5+yeDrof1KY9ev1glA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Jaroslav Kysela <perex@perex.cz>,
	Mark Brown <broonie@kernel.org>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 042/192] ALSA: control: Apply sanity check of input values for user elements
Date: Tue, 10 Sep 2024 11:31:06 +0200
Message-ID: <20240910092559.733901739@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 50ed081284fe2bfd1f25e8b92f4f6a4990e73c0a ]

Although we have already a mechanism for sanity checks of input values
for control writes, it's not applied unless the kconfig
CONFIG_SND_CTL_INPUT_VALIDATION is set due to the performance reason.
Nevertheless, it still makes sense to apply the same check for user
elements despite of its cost, as that's the only way to filter out the
invalid values; the user controls are handled solely in ALSA core
code, and there is no corresponding driver, after all.

This patch adds the same input value validation for user control
elements at its put callback.  The kselftest will be happier with this
change, as the incorrect values will be bailed out now with errors.

For other normal controls, the check is applied still only when
CONFIG_SND_CTL_INPUT_VALIDATION is set.

Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
Closes: https://lore.kernel.org/r/1d44be36-9bb9-4d82-8953-5ae2a4f09405@molgen.mpg.de
Reviewed-by: Jaroslav Kysela <perex@perex.cz>
Reviewed-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/20240616073454.16512-4-tiwai@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/control.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/sound/core/control.c b/sound/core/control.c
index 82aa1af1d1d8..92266c97238d 100644
--- a/sound/core/control.c
+++ b/sound/core/control.c
@@ -1477,12 +1477,16 @@ static int snd_ctl_elem_user_get(struct snd_kcontrol *kcontrol,
 static int snd_ctl_elem_user_put(struct snd_kcontrol *kcontrol,
 				 struct snd_ctl_elem_value *ucontrol)
 {
-	int change;
+	int err, change;
 	struct user_element *ue = kcontrol->private_data;
 	unsigned int size = ue->elem_data_size;
 	char *dst = ue->elem_data +
 			snd_ctl_get_ioff(kcontrol, &ucontrol->id) * size;
 
+	err = sanity_check_input_values(ue->card, ucontrol, &ue->info, false);
+	if (err < 0)
+		return err;
+
 	change = memcmp(&ucontrol->value, dst, size) != 0;
 	if (change)
 		memcpy(dst, &ucontrol->value, size);
-- 
2.43.0



