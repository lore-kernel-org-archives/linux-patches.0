Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA68172BAE;
	Tue, 10 Sep 2024 10:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964164; cv=none; b=Ha2bCmeXc19wCowdxC1n9XvxCTipZ/j0n7vtvfzDi5nWFwa30x0fblRY/U7wBuPAvsUDbNFtEmOnhzeJe0j2PYlpY0sVDHwADxHPliG074g5VUxYl1hKd5fbdFkNxOfGFPXvOf8F03LZOcW+2iRjOwVePLZCkjkaUD5x/oW5Vzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964164; c=relaxed/simple;
	bh=kw6Sgq4NNDV08TwYDdoAGbSG1DKCLET9ItgvWSX7qVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aa6waKYvkE0RCiBZjMM79EmJSpprRhM6IwimkGcb0dygOdp5CLAy5YmlwJgUhgs5b5e7Owqe3vWbaNFtqcoHLiv9SxJ7EVf7+rKRkyuyQe2x3xwt/RZ5V1zWy5Q89GuWGYMCeydPN4RMtr4yO9gnXQ0oAEuNYkwosw6FchUSIpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PCrdzDWU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PCrdzDWU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0395CC4CEC3;
	Tue, 10 Sep 2024 10:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964164;
	bh=kw6Sgq4NNDV08TwYDdoAGbSG1DKCLET9ItgvWSX7qVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PCrdzDWUQjUw6OwtYv6ilV4QTvWYEVGgL82OM+gshldC634lRpXrRt9J6nDEf020r
	 FwM8TpR2dFYka3r9SZmRiLkdUYpiYMit4EEgIk2wTCGxqMOFO185q1JRM78/zns1lG
	 UCrq/Y5D7wqo1OUB1gIu8iIHokFkd2ig9vumszng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 062/269] ALSA: hda: Add input value sanity checks to HDMI channel map controls
Date: Tue, 10 Sep 2024 11:30:49 +0200
Message-ID: <20240910092610.406414639@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 6278056e42d953e207e2afd416be39d09ed2d496 ]

Add a simple sanity check to HD-audio HDMI Channel Map controls.
Although the value might not be accepted for the actual connection, we
can filter out some bogus values beforehand, and that should be enough
for making kselftest happier.

Reviewed-by: Jaroslav Kysela <perex@perex.cz>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/20240616073454.16512-7-tiwai@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/hdmi_chmap.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/sound/hda/hdmi_chmap.c b/sound/hda/hdmi_chmap.c
index 5d8e1d944b0a..7b276047f85a 100644
--- a/sound/hda/hdmi_chmap.c
+++ b/sound/hda/hdmi_chmap.c
@@ -753,6 +753,20 @@ static int hdmi_chmap_ctl_get(struct snd_kcontrol *kcontrol,
 	return 0;
 }
 
+/* a simple sanity check for input values to chmap kcontrol */
+static int chmap_value_check(struct hdac_chmap *hchmap,
+			     const struct snd_ctl_elem_value *ucontrol)
+{
+	int i;
+
+	for (i = 0; i < hchmap->channels_max; i++) {
+		if (ucontrol->value.integer.value[i] < 0 ||
+		    ucontrol->value.integer.value[i] > SNDRV_CHMAP_LAST)
+			return -EINVAL;
+	}
+	return 0;
+}
+
 static int hdmi_chmap_ctl_put(struct snd_kcontrol *kcontrol,
 			      struct snd_ctl_elem_value *ucontrol)
 {
@@ -764,6 +778,10 @@ static int hdmi_chmap_ctl_put(struct snd_kcontrol *kcontrol,
 	unsigned char chmap[8], per_pin_chmap[8];
 	int i, err, ca, prepared = 0;
 
+	err = chmap_value_check(hchmap, ucontrol);
+	if (err < 0)
+		return err;
+
 	/* No monitor is connected in dyn_pcm_assign.
 	 * It's invalid to setup the chmap
 	 */
-- 
2.43.0



