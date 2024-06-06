Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB99719EEAD;
	Thu,  6 Jun 2024 14:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683554; cv=none; b=FspIVrRCgfE0su/D5Tijqmx90Kv1Ktzo6gy9DjJSmzmK4K5FCcG8q2LmQE1cPQAlO34sVZ7zkwabrRuKscEgZsOmdPWYt6SQ+p9Hqvi0sg6UujDrVZDIhYmExbsgA0aSpeljGSMILy4LGhBZtY9zt7SSFJ4ErHOZqHAs+OtrKMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683554; c=relaxed/simple;
	bh=j5Mu52WztLpT1SdPIpEY5iyVvS63cIEyKxOYtzQB33U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CYxNaEQPaRjIDTqxAvWHkDnbmt+za0y2jSyVHtyBbQlCf7WxZw+J5hHR31CKXcqnSontnsrP6j0c0vt2phDktS3KQSbQesHQu3E1R2kdVf0HZOFj5+i2VmVWaVwzVKP5ZEhRqrxCNijN0jk/hEvByqThzBLK5Vy1q4DhBRvrAYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pEpuTonY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pEpuTonY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CAA0C32786;
	Thu,  6 Jun 2024 14:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683554;
	bh=j5Mu52WztLpT1SdPIpEY5iyVvS63cIEyKxOYtzQB33U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pEpuTonYp5vpWJRwKJ27eDfaISxKhcRemcaX+iATiJAvWBXZY2emSkJw2s6PL+scd
	 g3kM3i+vf4x0UqB87S+btt9up9xfSuhldu1WtghMgrkPJbwngOS94OXW40LaOnx2/A
	 y8zdsqrWyQw/mM2P7uIyy9lJIDU3s2doeuWVmauM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 445/473] ALSA: core: Remove debugfs at disconnection
Date: Thu,  6 Jun 2024 16:06:14 +0200
Message-ID: <20240606131714.435306904@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 495000a38634e640e2fd02f7e4f1512ccc92d770 ]

The card-specific debugfs entries are removed at the last stage of
card free phase, and it's performed after synchronization of the
closes of all opened fds.  This works fine for most cases, but it can
be potentially problematic for a hotplug device like USB-audio.  Due
to the nature of snd_card_free_when_closed(), the card free isn't
called immediately after the driver removal for a hotplug device, but
it's left until the last fd is closed.  It implies that the card
debugfs entries also remain.  Meanwhile, when a new device is inserted
before the last close and the very same card slot is assigned, the
driver tries to create the card debugfs root again on the very same
path.  This conflicts with the remaining entry, and results in the
kernel warning such as:
  debugfs: Directory 'card0' with parent 'sound' already present!
with the missing debugfs entry afterwards.

For avoiding such conflicts, remove debugfs entries at the device
disconnection phase instead.  The jack kctl debugfs entries get
removed in snd_jack_dev_disconnect() instead of each kctl
private_free.

Fixes: 2d670ea2bd53 ("ALSA: jack: implement software jack injection via debugfs")
Link: https://lore.kernel.org/r/20240524151256.32521-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/init.c |  9 +++++----
 sound/core/jack.c | 21 ++++++++++++++-------
 2 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/sound/core/init.c b/sound/core/init.c
index 83e45efed61ed..3f08104e9366b 100644
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -541,6 +541,11 @@ int snd_card_disconnect(struct snd_card *card)
 		synchronize_irq(card->sync_irq);
 
 	snd_info_card_disconnect(card);
+#ifdef CONFIG_SND_DEBUG
+	debugfs_remove(card->debugfs_root);
+	card->debugfs_root = NULL;
+#endif
+
 	if (card->registered) {
 		device_del(&card->card_dev);
 		card->registered = false;
@@ -602,10 +607,6 @@ static int snd_card_do_free(struct snd_card *card)
 		dev_warn(card->dev, "unable to free card info\n");
 		/* Not fatal error */
 	}
-#ifdef CONFIG_SND_DEBUG
-	debugfs_remove(card->debugfs_root);
-	card->debugfs_root = NULL;
-#endif
 	if (card->release_completion)
 		complete(card->release_completion);
 	if (!card->managed)
diff --git a/sound/core/jack.c b/sound/core/jack.c
index 191357d619131..bd795452e57bf 100644
--- a/sound/core/jack.c
+++ b/sound/core/jack.c
@@ -37,11 +37,15 @@ static const int jack_switch_types[SND_JACK_SWITCH_TYPES] = {
 };
 #endif /* CONFIG_SND_JACK_INPUT_DEV */
 
+static void snd_jack_remove_debugfs(struct snd_jack *jack);
+
 static int snd_jack_dev_disconnect(struct snd_device *device)
 {
-#ifdef CONFIG_SND_JACK_INPUT_DEV
 	struct snd_jack *jack = device->device_data;
 
+	snd_jack_remove_debugfs(jack);
+
+#ifdef CONFIG_SND_JACK_INPUT_DEV
 	guard(mutex)(&jack->input_dev_lock);
 	if (!jack->input_dev)
 		return 0;
@@ -383,10 +387,14 @@ static int snd_jack_debugfs_add_inject_node(struct snd_jack *jack,
 	return 0;
 }
 
-static void snd_jack_debugfs_clear_inject_node(struct snd_jack_kctl *jack_kctl)
+static void snd_jack_remove_debugfs(struct snd_jack *jack)
 {
-	debugfs_remove(jack_kctl->jack_debugfs_root);
-	jack_kctl->jack_debugfs_root = NULL;
+	struct snd_jack_kctl *jack_kctl;
+
+	list_for_each_entry(jack_kctl, &jack->kctl_list, list) {
+		debugfs_remove(jack_kctl->jack_debugfs_root);
+		jack_kctl->jack_debugfs_root = NULL;
+	}
 }
 #else /* CONFIG_SND_JACK_INJECTION_DEBUG */
 static int snd_jack_debugfs_add_inject_node(struct snd_jack *jack,
@@ -395,7 +403,7 @@ static int snd_jack_debugfs_add_inject_node(struct snd_jack *jack,
 	return 0;
 }
 
-static void snd_jack_debugfs_clear_inject_node(struct snd_jack_kctl *jack_kctl)
+static void snd_jack_remove_debugfs(struct snd_jack *jack)
 {
 }
 #endif /* CONFIG_SND_JACK_INJECTION_DEBUG */
@@ -406,7 +414,6 @@ static void snd_jack_kctl_private_free(struct snd_kcontrol *kctl)
 
 	jack_kctl = kctl->private_data;
 	if (jack_kctl) {
-		snd_jack_debugfs_clear_inject_node(jack_kctl);
 		list_del(&jack_kctl->list);
 		kfree(jack_kctl);
 	}
@@ -499,8 +506,8 @@ int snd_jack_new(struct snd_card *card, const char *id, int type,
 		.dev_free = snd_jack_dev_free,
 #ifdef CONFIG_SND_JACK_INPUT_DEV
 		.dev_register = snd_jack_dev_register,
-		.dev_disconnect = snd_jack_dev_disconnect,
 #endif /* CONFIG_SND_JACK_INPUT_DEV */
+		.dev_disconnect = snd_jack_dev_disconnect,
 	};
 
 	if (initial_kctl) {
-- 
2.43.0



