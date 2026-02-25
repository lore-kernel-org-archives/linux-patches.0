Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4838118DB2A;
	Wed, 25 Feb 2026 01:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983096; cv=none; b=Qep5MzoMX6/m8LhBlOeRMwwZ7PQboIYd9hxnpohHSG0kBABTObKfe8AG7D4sPWsWS7wpOVfdNM696w+R+BhSAFfi8Vcm1mfNMQU/g44CYYkt0GvJgfAslur7i89Pkwosedm45f4CvnmSJx4Q0APP4/om0BvhsP7OlDBpNeul2E0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983096; c=relaxed/simple;
	bh=nIRV7csro24heMZsoVoHeR8jw8U6Oujtxw9rWXQXwz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ec49zssVGLSVBHJEAACogrRLkNQB/vAWrvTInzDOdCOxHclHHTOPzynQHYU3IR6gmD3pKB3hBPKRDcZLU8lt5sVMihPWJHDceFupiCPyw9IkkntvRP9H3SAvU7ERXiZ8MYtPfgVKBIUNZfhbLq+OgXBv9+0AcqMYTSyGM6UWDac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ado9QL3b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ado9QL3b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08B10C19423;
	Wed, 25 Feb 2026 01:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983096;
	bh=nIRV7csro24heMZsoVoHeR8jw8U6Oujtxw9rWXQXwz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ado9QL3bV9t8cJPBp+zBNDIJJD2s3pRqeZ1MIVIkbNESoRsB6XabK4r0L5wcIAx4H
	 aMqdDDvuJG+K6SKwF7lPUrK5zyNhEjGksSu5vvCcLkZ/2K8ceyJtpSLyxzecoZTPyp
	 X8YJuy2w0KJ7VUJ0gO8HYWIO7jIEvi4XyhSMG+ws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 214/781] ALSA: control: Relax __free() variable declarations
Date: Tue, 24 Feb 2026 17:15:23 -0800
Message-ID: <20260225012404.963073411@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 7b4721ca3159bce6338dbdf9188b785083571ed4 ]

We used to have a variable declaration with __free() initialized with
NULL.  This was to keep the old coding style rule, but recently it's
relaxed and rather recommends to follow the new rule to declare in
place of use for __free() -- which avoids potential deadlocks or UAFs
with nested cleanups.

Although the current code has no bug, per se, let's follow the new
standard and move the declaration to the place of assignment (or
directly assign the allocated result) instead of NULL initializations.

Fixes: 7dba48a474e6 ("ALSA: control_led: Use guard() for locking")
Fixes: 1052d9882269 ("ALSA: control: Use automatic cleanup of kfree()")
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20251216140634.171890-3-tiwai@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/control.c        | 12 ++++++------
 sound/core/control_compat.c | 21 +++++++++++----------
 sound/core/control_led.c    | 12 ++++++------
 3 files changed, 23 insertions(+), 22 deletions(-)

diff --git a/sound/core/control.c b/sound/core/control.c
index 9c3fd5113a617..486d1bc4dac27 100644
--- a/sound/core/control.c
+++ b/sound/core/control.c
@@ -867,9 +867,9 @@ EXPORT_SYMBOL(snd_ctl_find_id);
 static int snd_ctl_card_info(struct snd_card *card, struct snd_ctl_file * ctl,
 			     unsigned int cmd, void __user *arg)
 {
-	struct snd_ctl_card_info *info __free(kfree) = NULL;
+	struct snd_ctl_card_info *info __free(kfree) =
+		kzalloc(sizeof(*info), GFP_KERNEL);
 
-	info = kzalloc(sizeof(*info), GFP_KERNEL);
 	if (! info)
 		return -ENOMEM;
 	scoped_guard(rwsem_read, &snd_ioctl_rwsem) {
@@ -1244,10 +1244,10 @@ static int snd_ctl_elem_read(struct snd_card *card,
 static int snd_ctl_elem_read_user(struct snd_card *card,
 				  struct snd_ctl_elem_value __user *_control)
 {
-	struct snd_ctl_elem_value *control __free(kfree) = NULL;
 	int result;
+	struct snd_ctl_elem_value *control __free(kfree) =
+		memdup_user(_control, sizeof(*control));
 
-	control = memdup_user(_control, sizeof(*control));
 	if (IS_ERR(control))
 		return PTR_ERR(control);
 
@@ -1320,11 +1320,11 @@ static int snd_ctl_elem_write(struct snd_card *card, struct snd_ctl_file *file,
 static int snd_ctl_elem_write_user(struct snd_ctl_file *file,
 				   struct snd_ctl_elem_value __user *_control)
 {
-	struct snd_ctl_elem_value *control __free(kfree) = NULL;
 	struct snd_card *card;
 	int result;
+	struct snd_ctl_elem_value *control __free(kfree) =
+		memdup_user(_control, sizeof(*control));
 
-	control = memdup_user(_control, sizeof(*control));
 	if (IS_ERR(control))
 		return PTR_ERR(control);
 
diff --git a/sound/core/control_compat.c b/sound/core/control_compat.c
index 6459809ed3648..b8988a4bcd9b5 100644
--- a/sound/core/control_compat.c
+++ b/sound/core/control_compat.c
@@ -80,10 +80,10 @@ static int snd_ctl_elem_info_compat(struct snd_ctl_file *ctl,
 				    struct snd_ctl_elem_info32 __user *data32)
 {
 	struct snd_card *card = ctl->card;
-	struct snd_ctl_elem_info *data __free(kfree) = NULL;
 	int err;
+	struct snd_ctl_elem_info *data __free(kfree) =
+		kzalloc(sizeof(*data), GFP_KERNEL);
 
-	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (! data)
 		return -ENOMEM;
 
@@ -169,14 +169,15 @@ static int get_ctl_type(struct snd_card *card, struct snd_ctl_elem_id *id,
 			int *countp)
 {
 	struct snd_kcontrol *kctl;
-	struct snd_ctl_elem_info *info __free(kfree) = NULL;
 	int err;
 
 	guard(rwsem_read)(&card->controls_rwsem);
 	kctl = snd_ctl_find_id(card, id);
 	if (!kctl)
 		return -ENOENT;
-	info = kzalloc(sizeof(*info), GFP_KERNEL);
+
+	struct snd_ctl_elem_info *info __free(kfree) =
+		kzalloc(sizeof(*info), GFP_KERNEL);
 	if (info == NULL)
 		return -ENOMEM;
 	info->id = *id;
@@ -280,10 +281,10 @@ static int copy_ctl_value_to_user(void __user *userdata,
 static int __ctl_elem_read_user(struct snd_card *card,
 				void __user *userdata, void __user *valuep)
 {
-	struct snd_ctl_elem_value *data __free(kfree) = NULL;
 	int err, type, count;
+	struct snd_ctl_elem_value *data __free(kfree) =
+		kzalloc(sizeof(*data), GFP_KERNEL);
 
-	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (data == NULL)
 		return -ENOMEM;
 
@@ -314,11 +315,11 @@ static int ctl_elem_read_user(struct snd_card *card,
 static int __ctl_elem_write_user(struct snd_ctl_file *file,
 				 void __user *userdata, void __user *valuep)
 {
-	struct snd_ctl_elem_value *data __free(kfree) = NULL;
 	struct snd_card *card = file->card;
 	int err, type, count;
+	struct snd_ctl_elem_value *data __free(kfree) =
+		kzalloc(sizeof(*data), GFP_KERNEL);
 
-	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (data == NULL)
 		return -ENOMEM;
 
@@ -378,9 +379,9 @@ static int snd_ctl_elem_add_compat(struct snd_ctl_file *file,
 				   struct snd_ctl_elem_info32 __user *data32,
 				   int replace)
 {
-	struct snd_ctl_elem_info *data __free(kfree) = NULL;
+	struct snd_ctl_elem_info *data __free(kfree) =
+		kzalloc(sizeof(*data), GFP_KERNEL);
 
-	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (! data)
 		return -ENOMEM;
 
diff --git a/sound/core/control_led.c b/sound/core/control_led.c
index e33dfcf863cf1..c7641d5084e7d 100644
--- a/sound/core/control_led.c
+++ b/sound/core/control_led.c
@@ -245,12 +245,12 @@ DEFINE_FREE(snd_card_unref, struct snd_card *, if (_T) snd_card_unref(_T))
 static int snd_ctl_led_set_id(int card_number, struct snd_ctl_elem_id *id,
 			      unsigned int group, bool set)
 {
-	struct snd_card *card __free(snd_card_unref) = NULL;
 	struct snd_kcontrol *kctl;
 	struct snd_kcontrol_volatile *vd;
 	unsigned int ioff, access, new_access;
+	struct snd_card *card __free(snd_card_unref) =
+		snd_card_ref(card_number);
 
-	card = snd_card_ref(card_number);
 	if (!card)
 		return -ENXIO;
 	guard(rwsem_write)(&card->controls_rwsem);
@@ -302,13 +302,13 @@ static void snd_ctl_led_clean(struct snd_card *card)
 
 static int snd_ctl_led_reset(int card_number, unsigned int group)
 {
-	struct snd_card *card __free(snd_card_unref) = NULL;
 	struct snd_ctl_led_ctl *lctl, *_lctl;
 	struct snd_ctl_led *led;
 	struct snd_kcontrol_volatile *vd;
 	bool change = false;
+	struct snd_card *card __free(snd_card_unref) =
+		snd_card_ref(card_number);
 
-	card = snd_card_ref(card_number);
 	if (!card)
 		return -ENXIO;
 
@@ -598,11 +598,11 @@ static ssize_t list_show(struct device *dev,
 			 struct device_attribute *attr, char *buf)
 {
 	struct snd_ctl_led_card *led_card = container_of(dev, struct snd_ctl_led_card, dev);
-	struct snd_card *card __free(snd_card_unref) = NULL;
 	struct snd_ctl_led_ctl *lctl;
 	size_t l = 0;
+	struct snd_card *card __free(snd_card_unref) =
+		snd_card_ref(led_card->number);
 
-	card = snd_card_ref(led_card->number);
 	if (!card)
 		return -ENXIO;
 	guard(rwsem_read)(&card->controls_rwsem);
-- 
2.51.0



