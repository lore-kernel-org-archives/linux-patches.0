Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E787246444;
	Tue, 10 Sep 2024 09:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961022; cv=none; b=tZzUVQAAmoDggKRJid0rtGsCVrhJxT9FaNUiOj6DdfisYlQQq7IFTDgvimNNqnL8uU09wYhYPy1DiEVPArbf/xgnvOzOQfdvyEb1QA2SAB6W+7PEYkd/W/O9KVk7XM2iTJ1k2XPikPHx4UuZo5icog4h3AMjvAsyvS91n49ogFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961022; c=relaxed/simple;
	bh=4RQvCVcYNcI4nNjjkVTnanfvL/yDeeNpXcdey3q9u9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EcwOHvaDH0adpYE7XM+hBhg2uLGwq2iH8mHplx2B6hN6qTBy0guKJ7VJLGrsaCJ3vwCFEFTsA0Sa0/MHS3P4fC94xNt1XGiCKe61xsSgAtct1H4YGB417fwbPgiwactdgALp3fowLXVcer8UHbrbbvFqDpebJ5aI3qurjlj97FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nc3p4gyJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nc3p4gyJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F1A6C4CEC3;
	Tue, 10 Sep 2024 09:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961021;
	bh=4RQvCVcYNcI4nNjjkVTnanfvL/yDeeNpXcdey3q9u9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nc3p4gyJlS/y1NGjXGOQxkQmrZEabmOUQ1AEmxMAZ0iZ4nDRmXYtmnVvR/HZNc4se
	 So3j6Ut3CQNp2dPR3XLaqBGF2qJOeLYRE9pUMMp3Drb8RBFqalKaS/1Okw+a2nmgXW
	 Z1NNmQtvkIb6ubby831rGJcHT3BNT336S9x+tfUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 26/96] ALSA: hda: Add input value sanity checks to HDMI channel map controls
Date: Tue, 10 Sep 2024 11:31:28 +0200
Message-ID: <20240910092542.607009783@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092541.383432924@linuxfoundation.org>
References: <20240910092541.383432924@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index acbe61b8db7b..4463992d2102 100644
--- a/sound/hda/hdmi_chmap.c
+++ b/sound/hda/hdmi_chmap.c
@@ -752,6 +752,20 @@ static int hdmi_chmap_ctl_get(struct snd_kcontrol *kcontrol,
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
@@ -763,6 +777,10 @@ static int hdmi_chmap_ctl_put(struct snd_kcontrol *kcontrol,
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



