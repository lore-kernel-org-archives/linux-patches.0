Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049361;
	b=Xlhy6E/32yonGa19FwJcFTij6IsN8GED6q9FyeFVx0SAfVIUcUVdiByzvaod23UQsGLA
	 7nhz4ur1VLkufpsAvGl1/oPgooybsodccYQLoi5+byGWc8f0mkqip1gVsjsff/rFp4NwX
	 1JKs/w9kaR5T5GrZEhEPS7/21GL725Kt2X4HKvAZ1zwOiwkL9vwMbdt9gj9fs4WxMj9CN
	 KVmrm3zPo16uRE2fKCGyBFSoF/r9hQAfb6cPiR319m7ITJynWhfJXPKuT6FMTr2Ysj6ve
	 B2AibP6nzc6jzR+qqTEzKhZjkQJCGHJcZC8t3mpOd8IpC2c15jHUk3NiTJ3ZEt9G7TQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049361;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4nUKVU4kFXsYoAicY4H86uBrj0F8CW3IjAiUTu/8yxc=;
	b=JT0MlzBsA2csEz1o0hNHEVPuNALLhY8M0txX2V495v2iO1CLMNlocSMQcAeEkzgO2yZP
	 ais88Ju/rKqaZ02Bn52aCN9H9L98AhcX/cEuYeJ3+U6GwOvdJvavfTYkC09tXp2FSu5tu
	 ti//8P9fM4FtbmBTT4xilAaaF0yiXTMYAla1L8xggep+M4gLHPElv2LnuJaX82X0DiFg7
	 f//A1Ft57Ajwlql/MaIED81kKqvQBojX/9BK8o6mPE4xliX6xu5cqvFw6rnKLH9pWUxkB
	 spYNB9mYvpVaDgv6kjvsZFdRxTVrmYQa+wJko0IbcyZF86Pqnvki6AaXYNq4qIVwbYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZunmkYb3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4201A606A31C;
	Thu, 19 Nov 2026 00:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZunmkYb3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87EE91F000C5;
	Thu, 19 Nov 2026 00:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049361;
	bh=4nUKVU4kFXsYoAicY4H86uBrj0F8CW3IjAiUTu/8yxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZunmkYb3xho9Qpy9Dk4jvvwC6WaVGGYB6yWOgfC7FQp0Lu1u8KUOI40Vp9HrqOPPv
	 2WS4MRQtGB3c1ovMt/qfjIEgHC9yNW0q578zKF07329CIiujhKrEPq8CUclNpWCj7d
	 SZ052zK7GaN28i3dKYI+5Fayw30a9mU1a8ZN/wMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2325/2857] ALSA: info: Use guard() for locking
Date: Wed, 18 Nov 2026 15:55:59 +0100
Message-ID: <20261118150325.250907383@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 4b72362b1228d9aad684e4fcaa422d9562066fe1 ]

We can simplify the code gracefully with new guard() macro and co for
automatic cleanup of locks.

Only the code refactoring, and no functional changes.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20240227085306.9764-7-tiwai@suse.de
Stable-dep-of: a3e8eec7692e ("ALSA: info: Fix memory leak at card removal")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/info.c     | 93 ++++++++++++++-----------------------------
 sound/core/info_oss.c | 10 ++---
 2 files changed, 33 insertions(+), 70 deletions(-)

diff --git a/sound/core/info.c b/sound/core/info.c
index e2f302e55bbb2..1f5b8a3d9e3b6 100644
--- a/sound/core/info.c
+++ b/sound/core/info.c
@@ -105,17 +105,15 @@ static loff_t snd_info_entry_llseek(struct file *file, loff_t offset, int orig)
 {
 	struct snd_info_private_data *data;
 	struct snd_info_entry *entry;
-	loff_t ret = -EINVAL, size;
+	loff_t size;
 
 	data = file->private_data;
 	entry = data->entry;
-	mutex_lock(&entry->access);
-	if (entry->c.ops->llseek) {
-		ret = entry->c.ops->llseek(entry,
-					   data->file_private_data,
-					   file, offset, orig);
-		goto out;
-	}
+	guard(mutex)(&entry->access);
+	if (entry->c.ops->llseek)
+		return entry->c.ops->llseek(entry,
+					    data->file_private_data,
+					    file, offset, orig);
 
 	size = entry->size;
 	switch (orig) {
@@ -126,21 +124,18 @@ static loff_t snd_info_entry_llseek(struct file *file, loff_t offset, int orig)
 		break;
 	case SEEK_END:
 		if (!size)
-			goto out;
+			return -EINVAL;
 		offset += size;
 		break;
 	default:
-		goto out;
+		return -EINVAL;
 	}
 	if (offset < 0)
-		goto out;
+		return -EINVAL;
 	if (size && offset > size)
 		offset = size;
 	file->f_pos = offset;
-	ret = offset;
- out:
-	mutex_unlock(&entry->access);
-	return ret;
+	return offset;
 }
 
 static ssize_t snd_info_entry_read(struct file *file, char __user *buffer,
@@ -238,10 +233,10 @@ static int snd_info_entry_open(struct inode *inode, struct file *file)
 	struct snd_info_private_data *data;
 	int mode, err;
 
-	mutex_lock(&info_mutex);
+	guard(mutex)(&info_mutex);
 	err = alloc_info_private(entry, &data);
 	if (err < 0)
-		goto unlock;
+		return err;
 
 	mode = file->f_flags & O_ACCMODE;
 	if (((mode == O_RDONLY || mode == O_RDWR) && !entry->c.ops->read) ||
@@ -257,14 +252,11 @@ static int snd_info_entry_open(struct inode *inode, struct file *file)
 	}
 
 	file->private_data = data;
-	mutex_unlock(&info_mutex);
 	return 0;
 
  error:
 	kfree(data);
 	module_put(entry->module);
- unlock:
-	mutex_unlock(&info_mutex);
 	return err;
 }
 
@@ -306,7 +298,6 @@ static ssize_t snd_info_text_entry_write(struct file *file,
 	struct snd_info_buffer *buf;
 	loff_t pos;
 	size_t next;
-	int err = 0;
 
 	if (!entry->c.text.write)
 		return -EIO;
@@ -317,34 +308,24 @@ static ssize_t snd_info_text_entry_write(struct file *file,
 	/* don't handle too large text inputs */
 	if (next > 16 * 1024)
 		return -EIO;
-	mutex_lock(&entry->access);
+	guard(mutex)(&entry->access);
 	buf = data->wbuffer;
 	if (!buf) {
 		data->wbuffer = buf = kzalloc(sizeof(*buf), GFP_KERNEL);
-		if (!buf) {
-			err = -ENOMEM;
-			goto error;
-		}
+		if (!buf)
+			return -ENOMEM;
 	}
 	if (next > buf->len) {
 		char *nbuf = kvzalloc(PAGE_ALIGN(next), GFP_KERNEL);
-		if (!nbuf) {
-			err = -ENOMEM;
-			goto error;
-		}
+		if (!nbuf)
+			return -ENOMEM;
 		kvfree(buf->buffer);
 		buf->buffer = nbuf;
 		buf->len = PAGE_ALIGN(next);
 	}
-	if (copy_from_user(buf->buffer + pos, buffer, count)) {
-		err = -EFAULT;
-		goto error;
-	}
+	if (copy_from_user(buf->buffer + pos, buffer, count))
+		return -EFAULT;
 	buf->size = next;
- error:
-	mutex_unlock(&entry->access);
-	if (err < 0)
-		return err;
 	*offset = next;
 	return count;
 }
@@ -369,10 +350,10 @@ static int snd_info_text_entry_open(struct inode *inode, struct file *file)
 	struct snd_info_private_data *data;
 	int err;
 
-	mutex_lock(&info_mutex);
+	guard(mutex)(&info_mutex);
 	err = alloc_info_private(entry, &data);
 	if (err < 0)
-		goto unlock;
+		return err;
 
 	data->rbuffer = kzalloc(sizeof(*data->rbuffer), GFP_KERNEL);
 	if (!data->rbuffer) {
@@ -386,15 +367,12 @@ static int snd_info_text_entry_open(struct inode *inode, struct file *file)
 		err = single_open(file, snd_info_seq_show, data);
 	if (err < 0)
 		goto error;
-	mutex_unlock(&info_mutex);
 	return 0;
 
  error:
 	kfree(data->rbuffer);
 	kfree(data);
 	module_put(entry->module);
- unlock:
-	mutex_unlock(&info_mutex);
 	return err;
 }
 
@@ -549,7 +527,7 @@ int snd_info_card_register(struct snd_card *card)
  */
 void snd_info_card_id_change(struct snd_card *card)
 {
-	mutex_lock(&info_mutex);
+	guard(mutex)(&info_mutex);
 	if (card->proc_root_link) {
 		proc_remove(card->proc_root_link);
 		card->proc_root_link = NULL;
@@ -558,7 +536,6 @@ void snd_info_card_id_change(struct snd_card *card)
 		card->proc_root_link = proc_symlink(card->id,
 						    snd_proc_root->p,
 						    card->proc_root->name);
-	mutex_unlock(&info_mutex);
 }
 
 /*
@@ -574,12 +551,11 @@ void snd_info_card_disconnect(struct snd_card *card)
 	if (card->proc_root)
 		proc_remove(card->proc_root->p);
 
-	mutex_lock(&info_mutex);
+	guard(mutex)(&info_mutex);
 	if (card->proc_root)
 		snd_info_clear_entries(card->proc_root);
 	card->proc_root_link = NULL;
 	card->proc_root = NULL;
-	mutex_unlock(&info_mutex);
 }
 
 /*
@@ -703,9 +679,8 @@ snd_info_create_entry(const char *name, struct snd_info_entry *parent,
 	entry->parent = parent;
 	entry->module = module;
 	if (parent) {
-		mutex_lock(&parent->access);
+		guard(mutex)(&parent->access);
 		list_add_tail(&entry->list, &parent->children);
-		mutex_unlock(&parent->access);
 	}
 	return entry;
 }
@@ -775,9 +750,8 @@ void snd_info_free_entry(struct snd_info_entry * entry)
 		return;
 	if (entry->p) {
 		proc_remove(entry->p);
-		mutex_lock(&info_mutex);
+		guard(mutex)(&info_mutex);
 		snd_info_clear_entries(entry);
-		mutex_unlock(&info_mutex);
 	}
 
 	/* free all children at first */
@@ -786,9 +760,8 @@ void snd_info_free_entry(struct snd_info_entry * entry)
 
 	p = entry->parent;
 	if (p) {
-		mutex_lock(&p->access);
+		guard(mutex)(&p->access);
 		list_del(&entry->list);
-		mutex_unlock(&p->access);
 	}
 	kfree(entry->name);
 	if (entry->private_free)
@@ -804,15 +777,13 @@ static int __snd_info_register(struct snd_info_entry *entry)
 	if (snd_BUG_ON(!entry))
 		return -ENXIO;
 	root = entry->parent == NULL ? snd_proc_root->p : entry->parent->p;
-	mutex_lock(&info_mutex);
+	guard(mutex)(&info_mutex);
 	if (entry->p || !root)
-		goto unlock;
+		return 0;
 	if (S_ISDIR(entry->mode)) {
 		p = proc_mkdir_mode(entry->name, entry->mode, root);
-		if (!p) {
-			mutex_unlock(&info_mutex);
+		if (!p)
 			return -ENOMEM;
-		}
 	} else {
 		const struct proc_ops *ops;
 		if (entry->content == SNDRV_INFO_CONTENT_DATA)
@@ -821,15 +792,11 @@ static int __snd_info_register(struct snd_info_entry *entry)
 			ops = &snd_info_text_entry_ops;
 		p = proc_create_data(entry->name, entry->mode, root,
 				     ops, entry);
-		if (!p) {
-			mutex_unlock(&info_mutex);
+		if (!p)
 			return -ENOMEM;
-		}
 		proc_set_size(p, entry->size);
 	}
 	entry->p = p;
- unlock:
-	mutex_unlock(&info_mutex);
 	return 0;
 }
 
diff --git a/sound/core/info_oss.c b/sound/core/info_oss.c
index ebc714b2f46b3..0dbbb80055700 100644
--- a/sound/core/info_oss.c
+++ b/sound/core/info_oss.c
@@ -29,20 +29,17 @@ int snd_oss_info_register(int dev, int num, char *string)
 		return -ENXIO;
 	if (snd_BUG_ON(num < 0 || num >= SNDRV_CARDS))
 		return -ENXIO;
-	mutex_lock(&strings);
+	guard(mutex)(&strings);
 	if (string == NULL) {
 		x = snd_sndstat_strings[num][dev];
 		kfree(x);
 		x = NULL;
 	} else {
 		x = kstrdup(string, GFP_KERNEL);
-		if (x == NULL) {
-			mutex_unlock(&strings);
+		if (x == NULL)
 			return -ENOMEM;
-		}
 	}
 	snd_sndstat_strings[num][dev] = x;
-	mutex_unlock(&strings);
 	return 0;
 }
 EXPORT_SYMBOL(snd_oss_info_register);
@@ -53,7 +50,7 @@ static int snd_sndstat_show_strings(struct snd_info_buffer *buf, char *id, int d
 	char *str;
 
 	snd_iprintf(buf, "\n%s:", id);
-	mutex_lock(&strings);
+	guard(mutex)(&strings);
 	for (idx = 0; idx < SNDRV_CARDS; idx++) {
 		str = snd_sndstat_strings[idx][dev];
 		if (str) {
@@ -64,7 +61,6 @@ static int snd_sndstat_show_strings(struct snd_info_buffer *buf, char *id, int d
 			snd_iprintf(buf, "%i: %s\n", idx, str);
 		}
 	}
-	mutex_unlock(&strings);
 	if (ok < 0)
 		snd_iprintf(buf, " NOT ENABLED IN CONFIG\n");
 	return ok;
-- 
2.53.0



