Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F6434F497;
	Sat, 12 Sep 2026 19:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240628; cv=none; b=oRRw3cDnbQJABr/dACskEbXXMxrAmGEBW52t4kIATwOE93b/U+JvHaJlhqrqlPK9qY/TBUmvKU8n4zK3VfeQfl8JmLCYBng1eqR2RqkytIZMHd2WJTDJ/k9KEbYNNNb2yEsVaJL489l/EyXrQcIPNujJ/KEI2mQvcwlV8rkbkxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240628; c=relaxed/simple;
	bh=w7PLMo9ZBXwRdx6H+qgAh7yRiubiz+WTpLZeP6Zqvrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=npwBUO/xcL9X7Qc1cGOb0AhDa+AOKTXPmZR1c+FzgVygYSl1/fE113kQ6sSf2rqVheBiIKBI4atuatB9aFpB4zpCpAXKl6FBSw31zGEjXUvg0h0hSdpONkcv6ZQSDTxci0LMJfKUivIyphbnnFhR0bpEbeb3suFeFJ0hG8Ob7vQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EihJW2vL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EihJW2vL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 161121F000FF;
	Sat, 12 Sep 2026 19:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240627;
	bh=+RJu5YO+Yq9NX3ujS8V/bt1WJksuzchODTOsfEaUcKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EihJW2vLT68dEAsTRyR0NCM2BgO7eCVl2kvQtCqd0dKqB8wxjeLEBu5AeKmwipkyD
	 6msy56jTvSrzayzUApOusR7+pE6+4nzBe49zVe/chCICgDthZLJq8lmVvOLl73VwVJ
	 CpSId2j7rzOk5rNOwImDQX+DgOrgdcur7jb1VtDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 865/935] ALSA: control: Use automatic cleanup of kfree()
Date: Sat, 12 Sep 2026 09:04:55 +0200
Message-ID: <20260912065546.660594991@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 1052d988226948493eb9730b3424308972eca5f4 ]

There are common patterns where a temporary buffer is allocated and
freed at the exit, and those can be simplified with the recent cleanup
mechanism via __free(kfree).

A caveat is that some allocations are memdup_user() and they return an
error pointer instead of NULL.  Those need special cares and the value
has to be cleared with no_free_ptr() at the allocation error path.

Other than that, the conversions are straightforward.

No functional changes, only code refactoring.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20240222111509.28390-3-tiwai@suse.de
Stable-dep-of: d736eba9c453 ("ALSA: ice1712: Fix the card leak at probe error with the auto-cleanup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/control.c        | 23 +++++--------
 sound/core/control_compat.c | 69 ++++++++++++++-----------------------
 2 files changed, 34 insertions(+), 58 deletions(-)

diff --git a/sound/core/control.c b/sound/core/control.c
index 69dc5e06cc37b..59f8533b54036 100644
--- a/sound/core/control.c
+++ b/sound/core/control.c
@@ -722,7 +722,7 @@ EXPORT_SYMBOL(snd_ctl_find_id);
 static int snd_ctl_card_info(struct snd_card *card, struct snd_ctl_file * ctl,
 			     unsigned int cmd, void __user *arg)
 {
-	struct snd_ctl_card_info *info;
+	struct snd_ctl_card_info *info __free(kfree) = NULL;
 
 	info = kzalloc(sizeof(*info), GFP_KERNEL);
 	if (! info)
@@ -736,11 +736,8 @@ static int snd_ctl_card_info(struct snd_card *card, struct snd_ctl_file * ctl,
 	strscpy(info->mixername, card->mixername, sizeof(info->mixername));
 	strscpy(info->components, card->components, sizeof(info->components));
 	up_read(&snd_ioctl_rwsem);
-	if (copy_to_user(arg, info, sizeof(struct snd_ctl_card_info))) {
-		kfree(info);
+	if (copy_to_user(arg, info, sizeof(struct snd_ctl_card_info)))
 		return -EFAULT;
-	}
-	kfree(info);
 	return 0;
 }
 
@@ -1127,12 +1124,10 @@ static int snd_ctl_elem_read_user(struct snd_card *card,
 
 	result = snd_ctl_elem_read(card, control);
 	if (result < 0)
-		goto error;
+		return result;
 
 	if (copy_to_user(_control, control, sizeof(*control)))
-		result = -EFAULT;
- error:
-	kfree(control);
+		return -EFAULT;
 	return result;
 }
 
@@ -1183,23 +1178,21 @@ static int snd_ctl_elem_write(struct snd_card *card, struct snd_ctl_file *file,
 static int snd_ctl_elem_write_user(struct snd_ctl_file *file,
 				   struct snd_ctl_elem_value __user *_control)
 {
-	struct snd_ctl_elem_value *control;
+	struct snd_ctl_elem_value *control __free(kfree) = NULL;
 	struct snd_card *card;
 	int result;
 
 	control = memdup_user(_control, sizeof(*control));
 	if (IS_ERR(control))
-		return PTR_ERR(control);
+		return PTR_ERR(no_free_ptr(control));
 
 	card = file->card;
 	result = snd_ctl_elem_write(card, file, control);
 	if (result < 0)
-		goto error;
+		return result;
 
 	if (copy_to_user(_control, control, sizeof(*control)))
-		result = -EFAULT;
- error:
-	kfree(control);
+		return -EFAULT;
 	return result;
 }
 
diff --git a/sound/core/control_compat.c b/sound/core/control_compat.c
index edff063e088d2..232d085c6879a 100644
--- a/sound/core/control_compat.c
+++ b/sound/core/control_compat.c
@@ -79,61 +79,56 @@ struct snd_ctl_elem_info32 {
 static int snd_ctl_elem_info_compat(struct snd_ctl_file *ctl,
 				    struct snd_ctl_elem_info32 __user *data32)
 {
-	struct snd_ctl_elem_info *data;
+	struct snd_ctl_elem_info *data __free(kfree) = NULL;
 	int err;
 
 	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (! data)
 		return -ENOMEM;
 
-	err = -EFAULT;
 	/* copy id */
 	if (copy_from_user(&data->id, &data32->id, sizeof(data->id)))
-		goto error;
+		return -EFAULT;
 	/* we need to copy the item index.
 	 * hope this doesn't break anything..
 	 */
 	if (get_user(data->value.enumerated.item, &data32->value.enumerated.item))
-		goto error;
+		return -EFAULT;
 
 	err = snd_ctl_elem_info(ctl, data);
 	if (err < 0)
-		goto error;
+		return err;
 	/* restore info to 32bit */
-	err = -EFAULT;
 	/* id, type, access, count */
 	if (copy_to_user(&data32->id, &data->id, sizeof(data->id)) ||
 	    copy_to_user(&data32->type, &data->type, 3 * sizeof(u32)))
-		goto error;
+		return -EFAULT;
 	if (put_user(data->owner, &data32->owner))
-		goto error;
+		return -EFAULT;
 	switch (data->type) {
 	case SNDRV_CTL_ELEM_TYPE_BOOLEAN:
 	case SNDRV_CTL_ELEM_TYPE_INTEGER:
 		if (put_user(data->value.integer.min, &data32->value.integer.min) ||
 		    put_user(data->value.integer.max, &data32->value.integer.max) ||
 		    put_user(data->value.integer.step, &data32->value.integer.step))
-			goto error;
+			return -EFAULT;
 		break;
 	case SNDRV_CTL_ELEM_TYPE_INTEGER64:
 		if (copy_to_user(&data32->value.integer64,
 				 &data->value.integer64,
 				 sizeof(data->value.integer64)))
-			goto error;
+			return -EFAULT;
 		break;
 	case SNDRV_CTL_ELEM_TYPE_ENUMERATED:
 		if (copy_to_user(&data32->value.enumerated,
 				 &data->value.enumerated,
 				 sizeof(data->value.enumerated)))
-			goto error;
+			return -EFAULT;
 		break;
 	default:
 		break;
 	}
-	err = 0;
- error:
-	kfree(data);
-	return err;
+	return 0;
 }
 
 /* read / write */
@@ -169,7 +164,7 @@ static int get_ctl_type(struct snd_card *card, struct snd_ctl_elem_id *id,
 			int *countp)
 {
 	struct snd_kcontrol *kctl;
-	struct snd_ctl_elem_info *info;
+	struct snd_ctl_elem_info *info __free(kfree) = NULL;
 	int err;
 
 	down_read(&card->controls_rwsem);
@@ -193,7 +188,6 @@ static int get_ctl_type(struct snd_card *card, struct snd_ctl_elem_id *id,
 		err = info->type;
 		*countp = info->count;
 	}
-	kfree(info);
 	return err;
 }
 
@@ -289,7 +283,7 @@ static int copy_ctl_value_to_user(void __user *userdata,
 static int ctl_elem_read_user(struct snd_card *card,
 			      void __user *userdata, void __user *valuep)
 {
-	struct snd_ctl_elem_value *data;
+	struct snd_ctl_elem_value *data __free(kfree) = NULL;
 	int err, type, count;
 
 	data = kzalloc(sizeof(*data), GFP_KERNEL);
@@ -299,21 +293,18 @@ static int ctl_elem_read_user(struct snd_card *card,
 	err = copy_ctl_value_from_user(card, data, userdata, valuep,
 				       &type, &count);
 	if (err < 0)
-		goto error;
+		return err;
 
 	err = snd_ctl_elem_read(card, data);
 	if (err < 0)
-		goto error;
-	err = copy_ctl_value_to_user(userdata, valuep, data, type, count);
- error:
-	kfree(data);
-	return err;
+		return err;
+	return copy_ctl_value_to_user(userdata, valuep, data, type, count);
 }
 
 static int ctl_elem_write_user(struct snd_ctl_file *file,
 			       void __user *userdata, void __user *valuep)
 {
-	struct snd_ctl_elem_value *data;
+	struct snd_ctl_elem_value *data __free(kfree) = NULL;
 	struct snd_card *card = file->card;
 	int err, type, count;
 
@@ -324,15 +315,12 @@ static int ctl_elem_write_user(struct snd_ctl_file *file,
 	err = copy_ctl_value_from_user(card, data, userdata, valuep,
 				       &type, &count);
 	if (err < 0)
-		goto error;
+		return err;
 
 	err = snd_ctl_elem_write(card, file, data);
 	if (err < 0)
-		goto error;
-	err = copy_ctl_value_to_user(userdata, valuep, data, type, count);
- error:
-	kfree(data);
-	return err;
+		return err;
+	return copy_ctl_value_to_user(userdata, valuep, data, type, count);
 }
 
 static int snd_ctl_elem_read_user_compat(struct snd_card *card,
@@ -366,49 +354,44 @@ static int snd_ctl_elem_add_compat(struct snd_ctl_file *file,
 				   struct snd_ctl_elem_info32 __user *data32,
 				   int replace)
 {
-	struct snd_ctl_elem_info *data;
-	int err;
+	struct snd_ctl_elem_info *data __free(kfree) = NULL;
 
 	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (! data)
 		return -ENOMEM;
 
-	err = -EFAULT;
 	/* id, type, access, count */ \
 	if (copy_from_user(&data->id, &data32->id, sizeof(data->id)) ||
 	    copy_from_user(&data->type, &data32->type, 3 * sizeof(u32)))
-		goto error;
+		return -EFAULT;
 	if (get_user(data->owner, &data32->owner))
-		goto error;
+		return -EFAULT;
 	switch (data->type) {
 	case SNDRV_CTL_ELEM_TYPE_BOOLEAN:
 	case SNDRV_CTL_ELEM_TYPE_INTEGER:
 		if (get_user(data->value.integer.min, &data32->value.integer.min) ||
 		    get_user(data->value.integer.max, &data32->value.integer.max) ||
 		    get_user(data->value.integer.step, &data32->value.integer.step))
-			goto error;
+			return -EFAULT;
 		break;
 	case SNDRV_CTL_ELEM_TYPE_INTEGER64:
 		if (copy_from_user(&data->value.integer64,
 				   &data32->value.integer64,
 				   sizeof(data->value.integer64)))
-			goto error;
+			return -EFAULT;
 		break;
 	case SNDRV_CTL_ELEM_TYPE_ENUMERATED:
 		if (copy_from_user(&data->value.enumerated,
 				   &data32->value.enumerated,
 				   sizeof(data->value.enumerated)))
-			goto error;
+			return -EFAULT;
 		data->value.enumerated.names_ptr =
 			(uintptr_t)compat_ptr(data->value.enumerated.names_ptr);
 		break;
 	default:
 		break;
 	}
-	err = snd_ctl_elem_add(file, data, replace);
- error:
-	kfree(data);
-	return err;
+	return snd_ctl_elem_add(file, data, replace);
 }  
 
 enum {
-- 
2.53.0



