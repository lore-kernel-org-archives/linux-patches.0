Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7DD2185E71;
	Wed,  3 Jul 2024 10:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003623; cv=none; b=orXhi6z7yzkJcRiMJHfeqG7wcni/uyfwNJg/vocyIcQ0ksXILHj4ap/aAkPdpa7VWs2J3buTDZUTt3Y8adNdMKtUMk1mpgv4HG1+Rz/mx/rjtat4oAEW8Frjxr+mfzJRDgTxeG+C9gvSP/v3ZQytcjdjVs+/Y5S2MIk+4i6xFmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003623; c=relaxed/simple;
	bh=OABvjchr7e7G1ERV3JIcKs+bp5KjxF3CbKIUnIcsDhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=otH6UKm29m7jEq+mRysvwojEoE526DVai3iGlI8rrnCSp10o32jFlr9gpw/twKcRdQ0V04L/nDzUsvTDp3QEOczB2Eeyj5Z8CuXtov/34AW4hMAf4iF00LcDx5IJi7Sx4kCU6Bc3lzZ2DXH3CBKi5um48Zf02c7X2xqceFRfEAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WiJonDGJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WiJonDGJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F91BC2BD10;
	Wed,  3 Jul 2024 10:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003622;
	bh=OABvjchr7e7G1ERV3JIcKs+bp5KjxF3CbKIUnIcsDhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WiJonDGJrxCdRWfQtRlnWgSUiTX8wlmXtImCf2/D/JL6jJ2f7cV8qJ2Akkokx4nEg
	 FyoO8BFM5kDJ8dTxXTZn1+ZoLVboSK/U7b9xVb0wxLcDYjmei+y2ygRyAzK+5Ogdwk
	 lHfKqOf6vpa1MdS4TeUjISq1xLsh2AVWqvBrxjUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oswald Buddenhagen <oswald.buddenhagen@gmx.de>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 109/139] ALSA: emux: improve patch ioctl data validation
Date: Wed,  3 Jul 2024 12:40:06 +0200
Message-ID: <20240703102834.557094901@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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
index 31a4ea94830e0..235b16af6083d 100644
--- a/sound/synth/emux/soundfont.c
+++ b/sound/synth/emux/soundfont.c
@@ -710,7 +710,6 @@ load_data(struct snd_sf_list *sflist, const void __user *data, long count)
 	struct snd_soundfont *sf;
 	struct soundfont_sample_info sample_info;
 	struct snd_sf_sample *sp;
-	long off;
 
 	/* patch must be opened */
 	if ((sf = sflist->currsf) == NULL)
@@ -719,12 +718,16 @@ load_data(struct snd_sf_list *sflist, const void __user *data, long count)
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
@@ -751,7 +754,7 @@ load_data(struct snd_sf_list *sflist, const void __user *data, long count)
 		int  rc;
 		rc = sflist->callback.sample_new
 			(sflist->callback.private_data, sp, sflist->memhdr,
-			 data + off, count - off);
+			 data, count);
 		if (rc < 0) {
 			sf_sample_delete(sflist, sf, sp);
 			return rc;
@@ -962,10 +965,12 @@ load_guspatch(struct snd_sf_list *sflist, const char __user *data,
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



