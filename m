Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D59F1DF246;
	Tue,  8 Oct 2024 12:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392126; cv=none; b=EbhrzvbEAapexYhD3mfkpNkE1+uY9IQ/eRLnVXMeAQYo9+bdzmXClLSwBxmGWVy+ZTQGpi8niB+WbEV3vXbR0TbgC/bIkMPAfH/cK30B7LryJ3yC/7s3oHiwVsW4ZUJ/9S7ulg+5cfkoZh5mP0X3CAFfdvLeh0LGy+aeXl5s7D0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392126; c=relaxed/simple;
	bh=LT/cM9ViST+UyDd5YpmlChibMFql2S2U6B17e0DQMWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JPbgNC7a1zpjTRx0gW/wdUc5D3hQekli7vrqpx1lGuV89fjHSAaX6ctxpl88EratcuCDo+amRMbkGr/cVWq2coU363/q1J6NShmPGbfcoXcHnXiWTvZuktbKvKCMvoG5as1uLI1lSzKF1y7KRKDTIlPjV4bs7G+Gqxt7qM6eEiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oppn6aNO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oppn6aNO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14AD5C4CEC7;
	Tue,  8 Oct 2024 12:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392126;
	bh=LT/cM9ViST+UyDd5YpmlChibMFql2S2U6B17e0DQMWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oppn6aNOI4mFQEhI/EDBGkytOm+wRVU+AWB/owXixlCsnBiOIFhja0EAs4AB3uRoV
	 zY6p6rSCBHxWXL3vnLswFlylvcUHtX7UVDIS+zCb1x1129dQs6ARxsRhnVUsNeKRrF
	 gLTUmhiy+8KhANUB1D/pEM4qNiKhTzR/H3Ju9jHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 324/558] ALSA: control: Fix power_ref lock order for compat code, too
Date: Tue,  8 Oct 2024 14:05:54 +0200
Message-ID: <20241008115715.056009422@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit a1066453b5e49a28523f3ecbbfe4e06c6a29561c ]

In the previous change for swapping the power_ref and controls_rwsem
lock order, the code path for the compat layer was forgotten.
This patch covers the remaining code.

Fixes: fcc62b19104a ("ALSA: control: Take power_ref lock primarily")
Link: https://patch.msgid.link/20240808163128.20383-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/control_compat.c | 45 ++++++++++++++++++++++++++++++-------
 1 file changed, 37 insertions(+), 8 deletions(-)

diff --git a/sound/core/control_compat.c b/sound/core/control_compat.c
index 934bb945e702a..ff0031cc7dfb8 100644
--- a/sound/core/control_compat.c
+++ b/sound/core/control_compat.c
@@ -79,6 +79,7 @@ struct snd_ctl_elem_info32 {
 static int snd_ctl_elem_info_compat(struct snd_ctl_file *ctl,
 				    struct snd_ctl_elem_info32 __user *data32)
 {
+	struct snd_card *card = ctl->card;
 	struct snd_ctl_elem_info *data __free(kfree) = NULL;
 	int err;
 
@@ -95,7 +96,11 @@ static int snd_ctl_elem_info_compat(struct snd_ctl_file *ctl,
 	if (get_user(data->value.enumerated.item, &data32->value.enumerated.item))
 		return -EFAULT;
 
+	err = snd_power_ref_and_wait(card);
+	if (err < 0)
+		return err;
 	err = snd_ctl_elem_info(ctl, data);
+	snd_power_unref(card);
 	if (err < 0)
 		return err;
 	/* restore info to 32bit */
@@ -175,10 +180,7 @@ static int get_ctl_type(struct snd_card *card, struct snd_ctl_elem_id *id,
 	if (info == NULL)
 		return -ENOMEM;
 	info->id = *id;
-	err = snd_power_ref_and_wait(card);
-	if (!err)
-		err = kctl->info(kctl, info);
-	snd_power_unref(card);
+	err = kctl->info(kctl, info);
 	if (err >= 0) {
 		err = info->type;
 		*countp = info->count;
@@ -275,8 +277,8 @@ static int copy_ctl_value_to_user(void __user *userdata,
 	return 0;
 }
 
-static int ctl_elem_read_user(struct snd_card *card,
-			      void __user *userdata, void __user *valuep)
+static int __ctl_elem_read_user(struct snd_card *card,
+				void __user *userdata, void __user *valuep)
 {
 	struct snd_ctl_elem_value *data __free(kfree) = NULL;
 	int err, type, count;
@@ -296,8 +298,21 @@ static int ctl_elem_read_user(struct snd_card *card,
 	return copy_ctl_value_to_user(userdata, valuep, data, type, count);
 }
 
-static int ctl_elem_write_user(struct snd_ctl_file *file,
-			       void __user *userdata, void __user *valuep)
+static int ctl_elem_read_user(struct snd_card *card,
+			      void __user *userdata, void __user *valuep)
+{
+	int err;
+
+	err = snd_power_ref_and_wait(card);
+	if (err < 0)
+		return err;
+	err = __ctl_elem_read_user(card, userdata, valuep);
+	snd_power_unref(card);
+	return err;
+}
+
+static int __ctl_elem_write_user(struct snd_ctl_file *file,
+				 void __user *userdata, void __user *valuep)
 {
 	struct snd_ctl_elem_value *data __free(kfree) = NULL;
 	struct snd_card *card = file->card;
@@ -318,6 +333,20 @@ static int ctl_elem_write_user(struct snd_ctl_file *file,
 	return copy_ctl_value_to_user(userdata, valuep, data, type, count);
 }
 
+static int ctl_elem_write_user(struct snd_ctl_file *file,
+			       void __user *userdata, void __user *valuep)
+{
+	struct snd_card *card = file->card;
+	int err;
+
+	err = snd_power_ref_and_wait(card);
+	if (err < 0)
+		return err;
+	err = __ctl_elem_write_user(file, userdata, valuep);
+	snd_power_unref(card);
+	return err;
+}
+
 static int snd_ctl_elem_read_user_compat(struct snd_card *card,
 					 struct snd_ctl_elem_value32 __user *data32)
 {
-- 
2.43.0



