Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B4B318C343;
	Tue, 10 Sep 2024 09:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961508; cv=none; b=i/EPEFIxtoR1ByzLnf5EPweNvKdjcGW1dza5mUWhXpGT0DakCD0VTEJ53HusCVxyKOYbawf4A+SXpgpa9yBTCQEiuqran4Tpv6j2r/mvAKXxFYBikBgTvH1KJo9o9MIROK/d/deVS3bRJ2sz+RIWtUvsm7GhFyQAEPWLUnIV8h0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961508; c=relaxed/simple;
	bh=Efu5F3YYDWsWflBZ3g3TyCsIdjU1hbVt8GhUZ4hvuFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CSz97wfJKtK8BmetFWtHf1qf6Bh06Yj72iSIgLZVyVjMz10eRTqxU7VEiw3rIIz9Eud78W2BRX5DSTnCLQ7rYiIar8Ds7dhf7xXmcTCxYjW7vm3N+1vffU4maKTLYG6IAFQMr00AFdYb+ImAHXq7IMfbMrRV5oAcwGxD9gPVdIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s/u+qlm5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s/u+qlm5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C078DC4CECC;
	Tue, 10 Sep 2024 09:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961508;
	bh=Efu5F3YYDWsWflBZ3g3TyCsIdjU1hbVt8GhUZ4hvuFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s/u+qlm5DPW5jFfqrZQe6mECWfUpENiOrFltD7kWGW9/qrtVQTG+mvTcAoshLTZsL
	 dcLd4LqXlFu3GZG+SZLxzQKOKn9x3slaO/PsxWKWWTAh/pC45v/mCJxt4vMDUOVACr
	 TPWGRRdMCG5+EDTsRklG+vT51u02/Taf3Y0dYrxA=
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
Subject: [PATCH 6.10 093/375] ALSA: control: Apply sanity check of input values for user elements
Date: Tue, 10 Sep 2024 11:28:10 +0200
Message-ID: <20240910092625.371947000@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index fb0c60044f7b..1dd2337e2930 100644
--- a/sound/core/control.c
+++ b/sound/core/control.c
@@ -1480,12 +1480,16 @@ static int snd_ctl_elem_user_get(struct snd_kcontrol *kcontrol,
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



