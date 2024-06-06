Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB56B1C95E4;
	Thu,  6 Jun 2024 14:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683737; cv=none; b=h/heLOhAa6Y80AGSW8ax7HsSQlOm72K3gqHnAsAlS+TlBz+syVxBx7iWTCMBON+dj4B9swamN3SvC1FL3ZegA3aJkbEzBCBXheB8r+8/vMt60ArV7IykWY+yIhexqIxrTYUEtZAB++jivnmToVGyVZKHcJOxC4nulkw89LfSC2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683737; c=relaxed/simple;
	bh=+H755cjcBu7yxDQhLPEcO0lFzd1qc/9+KW5bNCfDoQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I+wPor4fk3UnLVL/nerhsfwCPAYASKNNRbiJHbBYVdlmfMNs7jlUeRsWbAwumMG3ohPk7K749+yR0qyy1pn4HXWvsZawwbvTBgdBjJ32zXTbbQrcRkjtH872k/MtUiCV/9hSCSEfMYp+VFMUvp9JPvNlWHIcL0D1/9koOAHxTx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EJiMHdf5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EJiMHdf5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51833C2BD10;
	Thu,  6 Jun 2024 14:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683737;
	bh=+H755cjcBu7yxDQhLPEcO0lFzd1qc/9+KW5bNCfDoQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EJiMHdf5vLEX37Wzl4vHV99h8XgvZKfOCO4KEJNsZk6N6xf7qL/fDA1g1QN60UggJ
	 7TGHdVk9qqtQ68uG5d5AyU7mDnDA1dnnhwlrOyr0CCLwNK2++6zsAnPKVEjn1Y1oNK
	 2WOYk/hPPNFQgaOFchkOdlVdWYEQlFchQzVKBzsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 693/744] ALSA: jack: Use guard() for locking
Date: Thu,  6 Jun 2024 16:06:05 +0200
Message-ID: <20240606131754.711788090@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 7234795b59f7b0b14569ec46dce56300a4988067 ]

We can simplify the code gracefully with new guard() macro and co for
automatic cleanup of locks.

Only the code refactoring, and no functional changes.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20240227085306.9764-11-tiwai@suse.de
Stable-dep-of: 495000a38634 ("ALSA: core: Remove debugfs at disconnection")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/jack.c | 25 +++++++------------------
 1 file changed, 7 insertions(+), 18 deletions(-)

diff --git a/sound/core/jack.c b/sound/core/jack.c
index e0f034e7275cd..e08b2c4fbd1a5 100644
--- a/sound/core/jack.c
+++ b/sound/core/jack.c
@@ -42,11 +42,9 @@ static int snd_jack_dev_disconnect(struct snd_device *device)
 #ifdef CONFIG_SND_JACK_INPUT_DEV
 	struct snd_jack *jack = device->device_data;
 
-	mutex_lock(&jack->input_dev_lock);
-	if (!jack->input_dev) {
-		mutex_unlock(&jack->input_dev_lock);
+	guard(mutex)(&jack->input_dev_lock);
+	if (!jack->input_dev)
 		return 0;
-	}
 
 	/* If the input device is registered with the input subsystem
 	 * then we need to use a different deallocator. */
@@ -55,7 +53,6 @@ static int snd_jack_dev_disconnect(struct snd_device *device)
 	else
 		input_free_device(jack->input_dev);
 	jack->input_dev = NULL;
-	mutex_unlock(&jack->input_dev_lock);
 #endif /* CONFIG_SND_JACK_INPUT_DEV */
 	return 0;
 }
@@ -92,11 +89,9 @@ static int snd_jack_dev_register(struct snd_device *device)
 	snprintf(jack->name, sizeof(jack->name), "%s %s",
 		 card->shortname, jack->id);
 
-	mutex_lock(&jack->input_dev_lock);
-	if (!jack->input_dev) {
-		mutex_unlock(&jack->input_dev_lock);
+	guard(mutex)(&jack->input_dev_lock);
+	if (!jack->input_dev)
 		return 0;
-	}
 
 	jack->input_dev->name = jack->name;
 
@@ -121,7 +116,6 @@ static int snd_jack_dev_register(struct snd_device *device)
 	if (err == 0)
 		jack->registered = 1;
 
-	mutex_unlock(&jack->input_dev_lock);
 	return err;
 }
 #endif /* CONFIG_SND_JACK_INPUT_DEV */
@@ -586,14 +580,9 @@ EXPORT_SYMBOL(snd_jack_new);
 void snd_jack_set_parent(struct snd_jack *jack, struct device *parent)
 {
 	WARN_ON(jack->registered);
-	mutex_lock(&jack->input_dev_lock);
-	if (!jack->input_dev) {
-		mutex_unlock(&jack->input_dev_lock);
-		return;
-	}
-
-	jack->input_dev->dev.parent = parent;
-	mutex_unlock(&jack->input_dev_lock);
+	guard(mutex)(&jack->input_dev_lock);
+	if (jack->input_dev)
+		jack->input_dev->dev.parent = parent;
 }
 EXPORT_SYMBOL(snd_jack_set_parent);
 
-- 
2.43.0



