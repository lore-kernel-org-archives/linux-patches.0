Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D22116F8F5;
	Wed,  3 Jul 2024 11:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005019; cv=none; b=XEUTeQCNxluY9QIaszdDbqHsSGxKa1h0eOIMeyIDJUI8L3LifJ3Oa+bBDs25OMdgkZvclFeQYy2vOBHSB9yG3erqw5cTGwONLuq3kftlk+cZWGtDOs2me3yB0Qdoorzzzg8dXQjP79UyfwrRLicdCWqUT/ysLoBbyxGs/Q1oJWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005019; c=relaxed/simple;
	bh=vcGfLFLVAxtSD/Zuq76jI/KPoE/dVOF3x+UTUSp3IEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ntB6h9OsnE1VzyFwuXSDdhMAuBwGqnA1tp/WDyNQNrAvX0r2yB5dwUjH6P7AhxIgTTgWwN2rDqRqms92dji6Aw78/JG6+LbplNZ/iN8/fnvmH/k7C3dgdZEvQ3QX9ai0XjyrnXNJLHt9Kg1oAwndtzI2+y/Dd3aAZBVxvr+wrtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ebTd4Tfm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ebTd4Tfm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4883C2BD10;
	Wed,  3 Jul 2024 11:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005019;
	bh=vcGfLFLVAxtSD/Zuq76jI/KPoE/dVOF3x+UTUSp3IEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ebTd4TfmPiO+qZ+VMPfdP2SZkxze7OAsFqjefuNlyhLd+FESrfpUnilndaiaRL5hN
	 5XQ0cMQGvAHcwRB4k8dfk2oeZn5L+v+Pp5AVvijpQ85KhQElIauQgRVOC0a28/OzKH
	 hEO9A4GBm1p7GW2txb9C26lMxPQqEvTYCY8LCyFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oswald Buddenhagen <oswald.buddenhagen@gmx.de>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 234/290] ALSA: emux: improve patch ioctl data validation
Date: Wed,  3 Jul 2024 12:40:15 +0200
Message-ID: <20240703102912.991117399@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oswald Buddenhagen <oswald.buddenhagen@gmx.de>

[ Upstream commit 89b32ccb12ae67e630c6453d778ec30a592a212f ]

In load_data(), make the validation of and skipping over the main info
block match that in load_guspatch().

In load_guspatch(), add checking that the specified patch length matches
the actually supplied data, like load_data() already did.

Signed-off-by: Oswald Buddenhagen <oswald.buddenhagen@gmx.de>
Message-ID: <20240406064830.1029573-8-oswald.buddenhagen@gmx.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/synth/emux/soundfont.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/sound/synth/emux/soundfont.c b/sound/synth/emux/soundfont.c
index 9ebc711afa6b5..18b2d84926563 100644
--- a/sound/synth/emux/soundfont.c
+++ b/sound/synth/emux/soundfont.c
@@ -697,7 +697,6 @@ load_data(struct snd_sf_list *sflist, const void __user *data, long count)
 	struct snd_soundfont *sf;
 	struct soundfont_sample_info sample_info;
 	struct snd_sf_sample *sp;
-	long off;
 
 	/* patch must be opened */
 	if ((sf = sflist->currsf) == NULL)
@@ -706,12 +705,16 @@ load_data(struct snd_sf_list *sflist, const void __user *data, long count)
 	if (is_special_type(sf->type))
 		return -EINVAL;
 
+	if (count < (long)sizeof(sample_info)) {
+		return -EINVAL;
+	}
 	if (copy_from_user(&sample_info, data, sizeof(sample_info)))
 		return -EFAULT;
+	data += sizeof(sample_info);
+	count -= sizeof(sample_info);
 
-	off = sizeof(sample_info);
-
-	if (sample_info.size != (count-off)/2)
+	// SoundFont uses S16LE samples.
+	if (sample_info.size * 2 != count)
 		return -EINVAL;
 
 	/* Check for dup */
@@ -738,7 +741,7 @@ load_data(struct snd_sf_list *sflist, const void __user *data, long count)
 		int  rc;
 		rc = sflist->callback.sample_new
 			(sflist->callback.private_data, sp, sflist->memhdr,
-			 data + off, count - off);
+			 data, count);
 		if (rc < 0) {
 			sf_sample_delete(sflist, sf, sp);
 			return rc;
@@ -951,10 +954,12 @@ load_guspatch(struct snd_sf_list *sflist, const char __user *data,
 	}
 	if (copy_from_user(&patch, data, sizeof(patch)))
 		return -EFAULT;
-	
 	count -= sizeof(patch);
 	data += sizeof(patch);
 
+	if ((patch.len << (patch.mode & WAVE_16_BITS ? 1 : 0)) != count)
+		return -EINVAL;
+
 	sf = newsf(sflist, SNDRV_SFNT_PAT_TYPE_GUS|SNDRV_SFNT_PAT_SHARED, NULL);
 	if (sf == NULL)
 		return -ENOMEM;
-- 
2.43.0



