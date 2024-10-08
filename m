Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC4F33981;
	Tue,  8 Oct 2024 12:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389961; cv=none; b=FTWLtPwjElmqohbzg+eVIDOh95x7vZg8yAzGoKnwlD4mDQAx0JFvzRenWdZ9PSQLz6ry7R6iNbczMSdqhvlauP2BVcJEKtOLsx/ytmEXzZYkqzURmCyZ5uNaKc4yjhfVtdbWmILWCW0LiIzyMrNnQSht9GHV42BNqq/+ck4u/vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389961; c=relaxed/simple;
	bh=3xujjn0HuqAyhmggnmSdUCO8AZ2DeIifai3GP1p8Xyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kYunbbCrb251d65QT0pmklI5PT4gW6rZUCXlnpdXPNRwUzQ6bRYR3U1mXmAJsOczcn2+U5255ttFOYSjvGS8IDCssBsL5LgO5uJA1QLIPBRKk8B598fg0ISd3dk5BNdO5kVDlpEtd/PH6jf7Cvt+ZL8VGt6gVzpufxK9zRLfGxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OOqTMutD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OOqTMutD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E069C4CEC7;
	Tue,  8 Oct 2024 12:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389961;
	bh=3xujjn0HuqAyhmggnmSdUCO8AZ2DeIifai3GP1p8Xyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OOqTMutDGbv77e+OKTIQmg9+CrS5BlT6iK9+ujsl7rRhX+P0eSt486B7dVC+s6oGG
	 uZl9S+PToyFeZJXfPATgY7NAwq8xoismGHsRzZGsDvPBXW6o3RNGtKrgyF6eOULpCj
	 Agc1R7yOy22urSoQhMuCQ3odnn25hWuxVFtlVcf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 148/482] ALSA: control: Take power_ref lock primarily
Date: Tue,  8 Oct 2024 14:03:31 +0200
Message-ID: <20241008115654.132051870@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

[ Upstream commit fcc62b19104a67b9a2941513771e09389b75bd95 ]

The code path for kcontrol accesses have often nested locks of both
card's controls_rwsem and power_ref, and applies in that order.
However, what could take much longer is the latter, power_ref; it
waits for the power state of the device, and it pretty much depends on
the user's action.

This patch swaps the locking order of those locks to a more natural
way, namely, power_ref -> controls_rwsem, in order to shorten the time
of possible nested locks.  For consistency, power_ref is taken always
in the top-level caller side (that is, *_user() functions and the
ioctl handler itself).

Link: https://patch.msgid.link/20240729160659.4516-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/control.c | 54 ++++++++++++++++++++++++++++----------------
 1 file changed, 34 insertions(+), 20 deletions(-)

diff --git a/sound/core/control.c b/sound/core/control.c
index 1dd2337e29300..2151f19b432fd 100644
--- a/sound/core/control.c
+++ b/sound/core/control.c
@@ -1164,9 +1164,7 @@ static int __snd_ctl_elem_info(struct snd_card *card,
 #ifdef CONFIG_SND_DEBUG
 	info->access = 0;
 #endif
-	result = snd_power_ref_and_wait(card);
-	if (!result)
-		result = kctl->info(kctl, info);
+	result = kctl->info(kctl, info);
 	snd_power_unref(card);
 	if (result >= 0) {
 		snd_BUG_ON(info->access);
@@ -1205,12 +1203,17 @@ static int snd_ctl_elem_info(struct snd_ctl_file *ctl,
 static int snd_ctl_elem_info_user(struct snd_ctl_file *ctl,
 				  struct snd_ctl_elem_info __user *_info)
 {
+	struct snd_card *card = ctl->card;
 	struct snd_ctl_elem_info info;
 	int result;
 
 	if (copy_from_user(&info, _info, sizeof(info)))
 		return -EFAULT;
+	result = snd_power_ref_and_wait(card);
+	if (result)
+		return result;
 	result = snd_ctl_elem_info(ctl, &info);
+	snd_power_unref(card);
 	if (result < 0)
 		return result;
 	/* drop internal access flags */
@@ -1254,10 +1257,7 @@ static int snd_ctl_elem_read(struct snd_card *card,
 
 	if (!snd_ctl_skip_validation(&info))
 		fill_remaining_elem_value(control, &info, pattern);
-	ret = snd_power_ref_and_wait(card);
-	if (!ret)
-		ret = kctl->get(kctl, control);
-	snd_power_unref(card);
+	ret = kctl->get(kctl, control);
 	if (ret < 0)
 		return ret;
 	if (!snd_ctl_skip_validation(&info) &&
@@ -1282,7 +1282,11 @@ static int snd_ctl_elem_read_user(struct snd_card *card,
 	if (IS_ERR(control))
 		return PTR_ERR(no_free_ptr(control));
 
+	result = snd_power_ref_and_wait(card);
+	if (result)
+		return result;
 	result = snd_ctl_elem_read(card, control);
+	snd_power_unref(card);
 	if (result < 0)
 		return result;
 
@@ -1297,7 +1301,7 @@ static int snd_ctl_elem_write(struct snd_card *card, struct snd_ctl_file *file,
 	struct snd_kcontrol *kctl;
 	struct snd_kcontrol_volatile *vd;
 	unsigned int index_offset;
-	int result;
+	int result = 0;
 
 	down_write(&card->controls_rwsem);
 	kctl = snd_ctl_find_id_locked(card, &control->id);
@@ -1315,9 +1319,8 @@ static int snd_ctl_elem_write(struct snd_card *card, struct snd_ctl_file *file,
 	}
 
 	snd_ctl_build_ioff(&control->id, kctl, index_offset);
-	result = snd_power_ref_and_wait(card);
 	/* validate input values */
-	if (IS_ENABLED(CONFIG_SND_CTL_INPUT_VALIDATION) && !result) {
+	if (IS_ENABLED(CONFIG_SND_CTL_INPUT_VALIDATION)) {
 		struct snd_ctl_elem_info info;
 
 		memset(&info, 0, sizeof(info));
@@ -1329,7 +1332,6 @@ static int snd_ctl_elem_write(struct snd_card *card, struct snd_ctl_file *file,
 	}
 	if (!result)
 		result = kctl->put(kctl, control);
-	snd_power_unref(card);
 	if (result < 0) {
 		up_write(&card->controls_rwsem);
 		return result;
@@ -1358,7 +1360,11 @@ static int snd_ctl_elem_write_user(struct snd_ctl_file *file,
 		return PTR_ERR(no_free_ptr(control));
 
 	card = file->card;
+	result = snd_power_ref_and_wait(card);
+	if (result < 0)
+		return result;
 	result = snd_ctl_elem_write(card, file, control);
+	snd_power_unref(card);
 	if (result < 0)
 		return result;
 
@@ -1827,7 +1833,7 @@ static int call_tlv_handler(struct snd_ctl_file *file, int op_flag,
 		{SNDRV_CTL_TLV_OP_CMD,   SNDRV_CTL_ELEM_ACCESS_TLV_COMMAND},
 	};
 	struct snd_kcontrol_volatile *vd = &kctl->vd[snd_ctl_get_ioff(kctl, id)];
-	int i, ret;
+	int i;
 
 	/* Check support of the request for this element. */
 	for (i = 0; i < ARRAY_SIZE(pairs); ++i) {
@@ -1845,11 +1851,7 @@ static int call_tlv_handler(struct snd_ctl_file *file, int op_flag,
 	    vd->owner != NULL && vd->owner != file)
 		return -EPERM;
 
-	ret = snd_power_ref_and_wait(file->card);
-	if (!ret)
-		ret = kctl->tlv.c(kctl, op_flag, size, buf);
-	snd_power_unref(file->card);
-	return ret;
+	return kctl->tlv.c(kctl, op_flag, size, buf);
 }
 
 static int read_tlv_buf(struct snd_kcontrol *kctl, struct snd_ctl_elem_id *id,
@@ -1962,16 +1964,28 @@ static long snd_ctl_ioctl(struct file *file, unsigned int cmd, unsigned long arg
 	case SNDRV_CTL_IOCTL_SUBSCRIBE_EVENTS:
 		return snd_ctl_subscribe_events(ctl, ip);
 	case SNDRV_CTL_IOCTL_TLV_READ:
-		scoped_guard(rwsem_read, &ctl->card->controls_rwsem)
+		err = snd_power_ref_and_wait(card);
+		if (err < 0)
+			return err;
+		scoped_guard(rwsem_read, &card->controls_rwsem)
 			err = snd_ctl_tlv_ioctl(ctl, argp, SNDRV_CTL_TLV_OP_READ);
+		snd_power_unref(card);
 		return err;
 	case SNDRV_CTL_IOCTL_TLV_WRITE:
-		scoped_guard(rwsem_write, &ctl->card->controls_rwsem)
+		err = snd_power_ref_and_wait(card);
+		if (err < 0)
+			return err;
+		scoped_guard(rwsem_write, &card->controls_rwsem)
 			err = snd_ctl_tlv_ioctl(ctl, argp, SNDRV_CTL_TLV_OP_WRITE);
+		snd_power_unref(card);
 		return err;
 	case SNDRV_CTL_IOCTL_TLV_COMMAND:
-		scoped_guard(rwsem_write, &ctl->card->controls_rwsem)
+		err = snd_power_ref_and_wait(card);
+		if (err < 0)
+			return err;
+		scoped_guard(rwsem_write, &card->controls_rwsem)
 			err = snd_ctl_tlv_ioctl(ctl, argp, SNDRV_CTL_TLV_OP_CMD);
+		snd_power_unref(card);
 		return err;
 	case SNDRV_CTL_IOCTL_POWER:
 		return -ENOPROTOOPT;
-- 
2.43.0



