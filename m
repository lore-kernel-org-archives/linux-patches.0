Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026283;
	b=eiuBMZmcbJ/s6nXWcOn7hOU79O3fU0Jvi5VYb0DuXhHpXYspqUK+bkkHWSJ+tgOi+Vg6
	 qg2FtblVjNeN3Ee36EsE41VJNGExqGVi9NWwdP/KrG2/dDdni729iGq+1xg+yBf8RND9o
	 CqSUWg/fWTBz5MO35PhEUdIN7BSMJQAAqTYolfxs4QdOeDe5PpAMkpwW4UZyRX8DZDQWZ
	 jsDZHAD2+lihvrR5+wIWPNtb8lb9bzJFHOk7tPcji9qIuMuxIcy5YGa6/IgjpMm3wwlqi
	 gkUwCd1911ejQazNplBDIOOSPG1vTgNMiV7qMtPy4pAnntK9O2EprY2O+gaA+FDf+4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026283;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=0kG3I0U4lICnZN0d+T3uIut3IgAGOlMQq6k4AjcVyPc=;
	b=Vj4eK8v63EDIphCIezbBDxX1fU0eAGZ/AOkxS8o7JgrMomOD47O4PjAulndUsBNaWRZv
	 TqggfSijJDZzWdQbRwoz6Di3b8eeWRfgeP7+5/e+hjYcgU2+0Ii9H+/JF03ll04uMqdWS
	 EE8E3tjQEaoVaSWSKwItDw5S1rUOZV9niL8QTDhG3bgdilsj3W2uzK1LtQtyPl10SWnSI
	 A/+KUOkAnbPSqHfMbWHE+wK2Ac7ZHydggtgMYsQRrqRQxFEcDfdGvd7pmB1Zwr15snVyX
	 +mLr9KGcOWEK1IFKHqUBDMdaDISWXKlspeSC2lHsVwlZRx8DwHa/iuVibHv91+kZkiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mHHsvNG8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6361B606A32A;
	Wed, 18 Nov 2026 18:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mHHsvNG8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B12971F000C4;
	Wed, 18 Nov 2026 18:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026283;
	bh=0kG3I0U4lICnZN0d+T3uIut3IgAGOlMQq6k4AjcVyPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mHHsvNG8UH+E5x/cYUZV1YvEK5Dzr5h0mITHrVVLGK+oAyBjZWGLraZSgh4AH1JcB
	 SyZYrAXAgRjv8cSTxqcHHC70XJqcZhNkqVxw8fXpO67s9M4Gwchl4a0iizNIUKmFoZ
	 Gzke/hspOGwroxo2jvuBFl2JTz/GIcPbGWMqZWd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ali=20Ahmet=20Memi=C5=9F?= <aliamemis@disroot.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1338/2151] ALSA: control_led: Fix deadlock between sysfs writes and card disconnect
Date: Wed, 18 Nov 2026 15:51:13 +0100
Message-ID: <20261118150210.795488031@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ali Ahmet Memiş <aliamemis@disroot.org>

[ Upstream commit 682d6bb5f783adea7fa2a5b05166bff01b338081 ]

snd_ctl_led_disconnect() removes the ctl-led sysfs files while
holding card->controls_rwsem. device_unregister() waits for running
sysfs callbacks which can deadlock when a concurrent write causes
the attach or detach callback to wait for controls_rwsem.

Break kernfs active protection in the attach, detach and list
callbacks and hold a module reference instead.

Fixes: a135dfb5de15 ("ALSA: led control - add sysfs kcontrol LED marking layer")
Signed-off-by: Ali Ahmet Memiş <aliamemis@disroot.org>
Link: https://patch.msgid.link/20261011180627.1594051-1-aliamemis@disroot.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/control_led.c | 62 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 57 insertions(+), 5 deletions(-)

diff --git a/sound/core/control_led.c b/sound/core/control_led.c
index f76a2f7ac7366..415b186561152 100644
--- a/sound/core/control_led.c
+++ b/sound/core/control_led.c
@@ -563,12 +563,43 @@ static ssize_t set_led_id(struct snd_ctl_led_card *led_card, const char *buf, si
 	return count;
 }
 
+/*
+ * snd_ctl_led_disconnect() removes these files with card->controls_rwsem
+ * held. so don't let the removal wait for a callback that takes it.
+ */
+static struct kernfs_node *snd_ctl_led_sysfs_enter(struct device *dev,
+						   struct device_attribute *attr)
+{
+	struct kernfs_node *kn;
+
+	if (!try_module_get(THIS_MODULE))
+		return NULL;
+	kn = sysfs_break_active_protection(&dev->kobj, &attr->attr);
+	if (!kn)
+		module_put(THIS_MODULE);
+	return kn;
+}
+
+static void snd_ctl_led_sysfs_exit(struct kernfs_node *kn)
+{
+	sysfs_unbreak_active_protection(kn);
+	module_put(THIS_MODULE);
+}
+
 static ssize_t attach_store(struct device *dev,
 			    struct device_attribute *attr,
 			    const char *buf, size_t count)
 {
 	struct snd_ctl_led_card *led_card = container_of(dev, struct snd_ctl_led_card, dev);
-	return set_led_id(led_card, buf, count, true);
+	struct kernfs_node *kn;
+	ssize_t ret;
+
+	kn = snd_ctl_led_sysfs_enter(dev, attr);
+	if (!kn)
+		return -ENODEV;
+	ret = set_led_id(led_card, buf, count, true);
+	snd_ctl_led_sysfs_exit(kn);
+	return ret;
 }
 
 static ssize_t detach_store(struct device *dev,
@@ -576,7 +607,15 @@ static ssize_t detach_store(struct device *dev,
 			    const char *buf, size_t count)
 {
 	struct snd_ctl_led_card *led_card = container_of(dev, struct snd_ctl_led_card, dev);
-	return set_led_id(led_card, buf, count, false);
+	struct kernfs_node *kn;
+	ssize_t ret;
+
+	kn = snd_ctl_led_sysfs_enter(dev, attr);
+	if (!kn)
+		return -ENODEV;
+	ret = set_led_id(led_card, buf, count, false);
+	snd_ctl_led_sysfs_exit(kn);
+	return ret;
 }
 
 static ssize_t reset_store(struct device *dev,
@@ -594,10 +633,8 @@ static ssize_t reset_store(struct device *dev,
 	return count;
 }
 
-static ssize_t list_show(struct device *dev,
-			 struct device_attribute *attr, char *buf)
+static ssize_t snd_ctl_led_list(struct snd_ctl_led_card *led_card, char *buf)
 {
-	struct snd_ctl_led_card *led_card = container_of(dev, struct snd_ctl_led_card, dev);
 	struct snd_ctl_led_ctl *lctl;
 	size_t l = 0;
 	struct snd_card *card __free(snd_card_unref) =
@@ -620,6 +657,21 @@ static ssize_t list_show(struct device *dev,
 	return l;
 }
 
+static ssize_t list_show(struct device *dev,
+			 struct device_attribute *attr, char *buf)
+{
+	struct snd_ctl_led_card *led_card = container_of(dev, struct snd_ctl_led_card, dev);
+	struct kernfs_node *kn;
+	ssize_t ret;
+
+	kn = snd_ctl_led_sysfs_enter(dev, attr);
+	if (!kn)
+		return -ENODEV;
+	ret = snd_ctl_led_list(led_card, buf);
+	snd_ctl_led_sysfs_exit(kn);
+	return ret;
+}
+
 static DEVICE_ATTR_WO(attach);
 static DEVICE_ATTR_WO(detach);
 static DEVICE_ATTR_WO(reset);
-- 
2.53.0



