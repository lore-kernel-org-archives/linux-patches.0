Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92BF92AD3C;
	Sat, 12 Sep 2026 16:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232060; cv=none; b=NID+BFw8YSVJcsP9Wok/KSFgxiZUlbXQ+0402H+qhh6sODqPH3m0Vrxn2VfwFp5kSLESzM+AbyC5kBwujtlF7BPFqs/MGn94xe2GFGxtK+fdhxcXojTpKJsT/LwUCLOQnDCIWYcqsg9J4db3kARzw5SJbXXmyeoDHMUBzyLhS80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232060; c=relaxed/simple;
	bh=eBbkeUEFXpLy1mw803H/Posu+pCCG5bF+BmZHZC/rdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VEME3C00O8+9lSWshkpbiHd/3HtSfvYa9nEzBuhDHdF9g/7945DF98Gq7gCYXnpGkGbrMaizUOll7pXAgEtXxvzo4fmC/wIcdHALPrsEeVyNuZCbeIVzKg09+mmXlWahNrHEvE6dlRSe60p4YuSsv7pMEsAiPrhfVcOHB4PDYW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P/c8sA37; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P/c8sA37"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A9B61F000FF;
	Sat, 12 Sep 2026 16:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232058;
	bh=VIiY5yZ3ZrVl4O6Wlk4Sseud5Wd4SQNdERua4MBD2sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P/c8sA37ligS8xjH+ELTV3OjYkQOI25u89eoEZLV1gNarLDG0lVMSqSqaaNQLJpu1
	 fwj58lh0JI1YIeOUW9jfy7anFO0x05hZtSXiLSSxp/JUc6Tfy+lKs65rLAKSVGVWQR
	 2fbMDdmp5xcfnlk+i/R7RGJqC1CJZOY/bTvMNMF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1125/1191] ALSA: control: Introduce unlocked version for snd_ctl_find_*() helpers
Date: Sat, 12 Sep 2026 09:04:13 +0200
Message-ID: <20260912065613.420421313@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit b1e055f67611daf098e27e8731386eeb5257bde3 ]

For reducing the unnecessary use of controls_rwsem in the drivers,
this patch adds a new variant for snd_ctl_find_*() helpers:
snd_ctl_find_id_locked() and snd_ctl_find_numid_locked() look for a
kctl element inside the card->controls_rwsem -- that is, doing the
very same as what snd_ctl_find_id() and snd_ctl_find_numid() did until
now.  snd_ctl_find_id() and snd_ctl_find_numid() remain same,
i.e. still unlocked version, but they will be switched to locked
version once after all callers are replaced.

The patch also replaces the calls of snd_ctl_find_id() and
snd_ctl_find_numid() in a few places; all of those are places where we
know that the functions are called properly with controls_rwsem held.
All others are without rwsem (although they should have been).

After this patch, we'll turn on the locking in snd_ctl_find_id() and
snd_ctl_find_numid() to be more race-free.

Link: https://lore.kernel.org/r/20230718141304.1032-10-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 74e3b979ce8b ("ALSA: control: Don't add invalid kcontrols to LED layer")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/control.h     |  4 ++-
 sound/core/control.c        | 69 +++++++++++++++++++++++++++----------
 sound/core/control_compat.c |  2 +-
 sound/core/control_led.c    |  2 +-
 sound/core/oss/mixer_oss.c  | 10 +++---
 sound/pci/emu10k1/emufx.c   |  2 +-
 6 files changed, 61 insertions(+), 28 deletions(-)

diff --git a/include/sound/control.h b/include/sound/control.h
index e61b749bf2041..42e8dbb22d8e9 100644
--- a/include/sound/control.h
+++ b/include/sound/control.h
@@ -140,7 +140,9 @@ int snd_ctl_remove_id(struct snd_card * card, struct snd_ctl_elem_id *id);
 int snd_ctl_rename_id(struct snd_card * card, struct snd_ctl_elem_id *src_id, struct snd_ctl_elem_id *dst_id);
 void snd_ctl_rename(struct snd_card *card, struct snd_kcontrol *kctl, const char *name);
 int snd_ctl_activate_id(struct snd_card *card, struct snd_ctl_elem_id *id, int active);
-struct snd_kcontrol *snd_ctl_find_numid(struct snd_card * card, unsigned int numid);
+struct snd_kcontrol *snd_ctl_find_numid_locked(struct snd_card *card, unsigned int numid);
+struct snd_kcontrol *snd_ctl_find_numid(struct snd_card *card, unsigned int numid);
+struct snd_kcontrol *snd_ctl_find_id_locked(struct snd_card *card, const struct snd_ctl_elem_id *id);
 struct snd_kcontrol *snd_ctl_find_id(struct snd_card *card, const struct snd_ctl_elem_id *id);
 
 int snd_ctl_create(struct snd_card *card);
diff --git a/sound/core/control.c b/sound/core/control.c
index 54b9aa5dd9865..9b739a515fdfa 100644
--- a/sound/core/control.c
+++ b/sound/core/control.c
@@ -470,7 +470,7 @@ static int __snd_ctl_add_replace(struct snd_card *card,
 	if (id.index > UINT_MAX - kcontrol->count)
 		return -EINVAL;
 
-	old = snd_ctl_find_id(card, &id);
+	old = snd_ctl_find_id_locked(card, &id);
 	if (!old) {
 		if (mode == CTL_REPLACE)
 			return -EINVAL;
@@ -622,7 +622,7 @@ int snd_ctl_remove_id(struct snd_card *card, struct snd_ctl_elem_id *id)
 	int ret;
 
 	down_write(&card->controls_rwsem);
-	kctl = snd_ctl_find_id(card, id);
+	kctl = snd_ctl_find_id_locked(card, id);
 	if (kctl == NULL) {
 		up_write(&card->controls_rwsem);
 		return -ENOENT;
@@ -651,7 +651,7 @@ static int snd_ctl_remove_user_ctl(struct snd_ctl_file * file,
 	int idx, ret;
 
 	down_write(&card->controls_rwsem);
-	kctl = snd_ctl_find_id(card, id);
+	kctl = snd_ctl_find_id_locked(card, id);
 	if (kctl == NULL) {
 		ret = -ENOENT;
 		goto error;
@@ -692,7 +692,7 @@ int snd_ctl_activate_id(struct snd_card *card, struct snd_ctl_elem_id *id,
 	int ret;
 
 	down_write(&card->controls_rwsem);
-	kctl = snd_ctl_find_id(card, id);
+	kctl = snd_ctl_find_id_locked(card, id);
 	if (kctl == NULL) {
 		ret = -ENOENT;
 		goto unlock;
@@ -738,7 +738,7 @@ int snd_ctl_rename_id(struct snd_card *card, struct snd_ctl_elem_id *src_id,
 	struct snd_kcontrol *kctl;
 
 	down_write(&card->controls_rwsem);
-	kctl = snd_ctl_find_id(card, src_id);
+	kctl = snd_ctl_find_id_locked(card, src_id);
 	if (kctl == NULL) {
 		up_write(&card->controls_rwsem);
 		return -ENOENT;
@@ -791,7 +791,7 @@ snd_ctl_find_numid_slow(struct snd_card *card, unsigned int numid)
 #endif /* !CONFIG_SND_CTL_FAST_LOOKUP */
 
 /**
- * snd_ctl_find_numid - find the control instance with the given number-id
+ * snd_ctl_find_numid_locked - find the control instance with the given number-id
  * @card: the card instance
  * @numid: the number-id to search
  *
@@ -801,9 +801,9 @@ snd_ctl_find_numid_slow(struct snd_card *card, unsigned int numid)
  * (if the race condition can happen).
  *
  * Return: The pointer of the instance if found, or %NULL if not.
- *
  */
-struct snd_kcontrol *snd_ctl_find_numid(struct snd_card *card, unsigned int numid)
+struct snd_kcontrol *
+snd_ctl_find_numid_locked(struct snd_card *card, unsigned int numid)
 {
 	if (snd_BUG_ON(!card || !numid))
 		return NULL;
@@ -813,10 +813,26 @@ struct snd_kcontrol *snd_ctl_find_numid(struct snd_card *card, unsigned int numi
 	return snd_ctl_find_numid_slow(card, numid);
 #endif
 }
+EXPORT_SYMBOL(snd_ctl_find_numid_locked);
+
+/**
+ * snd_ctl_find_numid - find the control instance with the given number-id
+ * @card: the card instance
+ * @numid: the number-id to search
+ *
+ * Finds the control instance with the given number-id from the card.
+ *
+ * Return: The pointer of the instance if found, or %NULL if not.
+ */
+struct snd_kcontrol *snd_ctl_find_numid(struct snd_card *card,
+					unsigned int numid)
+{
+	return snd_ctl_find_numid_locked(card, numid);
+}
 EXPORT_SYMBOL(snd_ctl_find_numid);
 
 /**
- * snd_ctl_find_id - find the control instance with the given id
+ * snd_ctl_find_id_locked - find the control instance with the given id
  * @card: the card instance
  * @id: the id to search
  *
@@ -826,17 +842,16 @@ EXPORT_SYMBOL(snd_ctl_find_numid);
  * (if the race condition can happen).
  *
  * Return: The pointer of the instance if found, or %NULL if not.
- *
  */
-struct snd_kcontrol *snd_ctl_find_id(struct snd_card *card,
-				     const struct snd_ctl_elem_id *id)
+struct snd_kcontrol *snd_ctl_find_id_locked(struct snd_card *card,
+					    const struct snd_ctl_elem_id *id)
 {
 	struct snd_kcontrol *kctl;
 
 	if (snd_BUG_ON(!card || !id))
 		return NULL;
 	if (id->numid != 0)
-		return snd_ctl_find_numid(card, id->numid);
+		return snd_ctl_find_numid_locked(card, id->numid);
 #ifdef CONFIG_SND_CTL_FAST_LOOKUP
 	kctl = xa_load(&card->ctl_hash, get_ctl_id_hash(id));
 	if (kctl && elem_id_matches(kctl, id))
@@ -851,6 +866,22 @@ struct snd_kcontrol *snd_ctl_find_id(struct snd_card *card,
 
 	return NULL;
 }
+EXPORT_SYMBOL(snd_ctl_find_id_locked);
+
+/**
+ * snd_ctl_find_id - find the control instance with the given id
+ * @card: the card instance
+ * @id: the id to search
+ *
+ * Finds the control instance with the given id from the card.
+ *
+ * Return: The pointer of the instance if found, or %NULL if not.
+ */
+struct snd_kcontrol *snd_ctl_find_id(struct snd_card *card,
+				     const struct snd_ctl_elem_id *id)
+{
+	return snd_ctl_find_id_locked(card, id);
+}
 EXPORT_SYMBOL(snd_ctl_find_id);
 
 static int snd_ctl_card_info(struct snd_card *card, struct snd_ctl_file * ctl,
@@ -1165,7 +1196,7 @@ static int snd_ctl_elem_info(struct snd_ctl_file *ctl,
 	int result;
 
 	down_read(&card->controls_rwsem);
-	kctl = snd_ctl_find_id(card, &info->id);
+	kctl = snd_ctl_find_id_locked(card, &info->id);
 	if (kctl == NULL)
 		result = -ENOENT;
 	else
@@ -1204,7 +1235,7 @@ static int snd_ctl_elem_read(struct snd_card *card,
 	int ret;
 
 	down_read(&card->controls_rwsem);
-	kctl = snd_ctl_find_id(card, &control->id);
+	kctl = snd_ctl_find_id_locked(card, &control->id);
 	if (kctl == NULL) {
 		ret = -ENOENT;
 		goto unlock;
@@ -1281,7 +1312,7 @@ static int snd_ctl_elem_write(struct snd_card *card, struct snd_ctl_file *file,
 	int result;
 
 	down_write(&card->controls_rwsem);
-	kctl = snd_ctl_find_id(card, &control->id);
+	kctl = snd_ctl_find_id_locked(card, &control->id);
 	if (kctl == NULL) {
 		up_write(&card->controls_rwsem);
 		return -ENOENT;
@@ -1362,7 +1393,7 @@ static int snd_ctl_elem_lock(struct snd_ctl_file *file,
 	if (copy_from_user(&id, _id, sizeof(id)))
 		return -EFAULT;
 	down_write(&card->controls_rwsem);
-	kctl = snd_ctl_find_id(card, &id);
+	kctl = snd_ctl_find_id_locked(card, &id);
 	if (kctl == NULL) {
 		result = -ENOENT;
 	} else {
@@ -1390,7 +1421,7 @@ static int snd_ctl_elem_unlock(struct snd_ctl_file *file,
 	if (copy_from_user(&id, _id, sizeof(id)))
 		return -EFAULT;
 	down_write(&card->controls_rwsem);
-	kctl = snd_ctl_find_id(card, &id);
+	kctl = snd_ctl_find_id_locked(card, &id);
 	if (kctl == NULL) {
 		result = -ENOENT;
 	} else {
@@ -1900,7 +1931,7 @@ static int snd_ctl_tlv_ioctl(struct snd_ctl_file *file,
 	container_size = header.length;
 	container = buf->tlv;
 
-	kctl = snd_ctl_find_numid(file->card, header.numid);
+	kctl = snd_ctl_find_numid_locked(file->card, header.numid);
 	if (kctl == NULL)
 		return -ENOENT;
 
diff --git a/sound/core/control_compat.c b/sound/core/control_compat.c
index d8a86d1a99d6e..c0e553637764f 100644
--- a/sound/core/control_compat.c
+++ b/sound/core/control_compat.c
@@ -173,7 +173,7 @@ static int get_ctl_type(struct snd_card *card, struct snd_ctl_elem_id *id,
 	int err;
 
 	down_read(&card->controls_rwsem);
-	kctl = snd_ctl_find_id(card, id);
+	kctl = snd_ctl_find_id_locked(card, id);
 	if (! kctl) {
 		up_read(&card->controls_rwsem);
 		return -ENOENT;
diff --git a/sound/core/control_led.c b/sound/core/control_led.c
index 6d81a6a59f29a..0f35f77af1bfe 100644
--- a/sound/core/control_led.c
+++ b/sound/core/control_led.c
@@ -251,7 +251,7 @@ static int snd_ctl_led_set_id(int card_number, struct snd_ctl_elem_id *id,
 	card = snd_card_ref(card_number);
 	if (card) {
 		down_write(&card->controls_rwsem);
-		kctl = snd_ctl_find_id(card, id);
+		kctl = snd_ctl_find_id_locked(card, id);
 		if (kctl) {
 			ioff = snd_ctl_get_ioff(kctl, id);
 			vd = &kctl->vd[ioff];
diff --git a/sound/core/oss/mixer_oss.c b/sound/core/oss/mixer_oss.c
index c8291869ef906..abc99ae333282 100644
--- a/sound/core/oss/mixer_oss.c
+++ b/sound/core/oss/mixer_oss.c
@@ -524,7 +524,7 @@ static struct snd_kcontrol *snd_mixer_oss_test_id(struct snd_mixer_oss *mixer, c
 	id.iface = SNDRV_CTL_ELEM_IFACE_MIXER;
 	strscpy(id.name, name, sizeof(id.name));
 	id.index = index;
-	return snd_ctl_find_id(card, &id);
+	return snd_ctl_find_id_locked(card, &id);
 }
 
 static void snd_mixer_oss_get_volume1_vol(struct snd_mixer_oss_file *fmixer,
@@ -540,7 +540,7 @@ static void snd_mixer_oss_get_volume1_vol(struct snd_mixer_oss_file *fmixer,
 	if (numid == ID_UNKNOWN)
 		return;
 	down_read(&card->controls_rwsem);
-	kctl = snd_ctl_find_numid(card, numid);
+	kctl = snd_ctl_find_numid_locked(card, numid);
 	if (!kctl) {
 		up_read(&card->controls_rwsem);
 		return;
@@ -579,7 +579,7 @@ static void snd_mixer_oss_get_volume1_sw(struct snd_mixer_oss_file *fmixer,
 	if (numid == ID_UNKNOWN)
 		return;
 	down_read(&card->controls_rwsem);
-	kctl = snd_ctl_find_numid(card, numid);
+	kctl = snd_ctl_find_numid_locked(card, numid);
 	if (!kctl) {
 		up_read(&card->controls_rwsem);
 		return;
@@ -645,7 +645,7 @@ static void snd_mixer_oss_put_volume1_vol(struct snd_mixer_oss_file *fmixer,
 	if (numid == ID_UNKNOWN)
 		return;
 	down_read(&card->controls_rwsem);
-	kctl = snd_ctl_find_numid(card, numid);
+	kctl = snd_ctl_find_numid_locked(card, numid);
 	if (!kctl) {
 		up_read(&card->controls_rwsem);
 		return;
@@ -688,7 +688,7 @@ static void snd_mixer_oss_put_volume1_sw(struct snd_mixer_oss_file *fmixer,
 	if (numid == ID_UNKNOWN)
 		return;
 	down_read(&card->controls_rwsem);
-	kctl = snd_ctl_find_numid(card, numid);
+	kctl = snd_ctl_find_numid_locked(card, numid);
 	if (!kctl) {
 		up_read(&card->controls_rwsem);
 		return;
diff --git a/sound/pci/emu10k1/emufx.c b/sound/pci/emu10k1/emufx.c
index 4ca65f425f39c..413da7cc4c188 100644
--- a/sound/pci/emu10k1/emufx.c
+++ b/sound/pci/emu10k1/emufx.c
@@ -765,7 +765,7 @@ static int snd_emu10k1_verify_controls(struct snd_emu10k1 *emu,
 			continue;
 		gctl_id = (struct snd_ctl_elem_id *)&gctl->id;
 		down_read(&emu->card->controls_rwsem);
-		if (snd_ctl_find_id(emu->card, gctl_id)) {
+		if (snd_ctl_find_id_locked(emu->card, gctl_id)) {
 			up_read(&emu->card->controls_rwsem);
 			err = -EEXIST;
 			goto __error;
-- 
2.53.0



