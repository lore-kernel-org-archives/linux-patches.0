Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 193CA2EF652;
	Sat, 30 May 2026 18:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165847; cv=none; b=d9/JhEDvl+w7jJICP7C3HCP9Elhbj0gNvywmxwghbDutnC9QyYguZFPc2OQv9QZnIE9Sl1MP2qKu+aDcDBCKmJrer8NChhQL5GPJ9qq2quRC9zCaO6whVQOjRfIV/NowFbdLaFrlU4YXLgAuRCX0vtAkDmJJLyCu7TFSkDEpdlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165847; c=relaxed/simple;
	bh=jJHijRtJf6xUO++I1z639w1Pr0gpapoGQmumB/3A2mc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=griFRvW0TYS4DH6Go+LEYSgm4BBq0nllmY5AmjoDKVRLyRvHpLUUra6nL5hJ8iN/Pkkuv4fOfGUG2rTbpW2KsMQdVx4Sn+xezSHKbKjCgZU/7O0PMYe//J9R2Bbv7GhGRkRsHttyn7AzBNzPvpM3i8Ow51UdsbmUaWfsRwQecOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RibSi9ZO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RibSi9ZO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DF2C1F00893;
	Sat, 30 May 2026 18:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165845;
	bh=8kzJIfiQQ9p0Lmdf6DIb9vnfwBfegFVFjadew+DRNAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RibSi9ZOX8OTUdjZ3vrGaPUMB2EeYNzS97054TxC7naF6MNNBpgJ/CaelLXhVtqtP
	 /yE7G1GXL/Y/WGeTF/yGo7pelAFldbYpemQ5yqz4W0zPEU86dJBrpiW7Jf1kdsMTOm
	 mfMfSze8SQBUqTP7TftKhJ0kJUch5lsuem8qsg6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 199/589] ALSA: caiaq: Dont abort when no input device is available
Date: Sat, 30 May 2026 18:01:20 +0200
Message-ID: <20260530160230.149431226@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit b32ae47a2b0a1fb4bd4942242847966d9b178222 upstream.

The previous fix to handle the error from setup_card() caused a
regression for the models that have no dedicated input device;
snd_usb_caiaq_input_init() just returns -EINVAL, and we treat it as a
fatal error although it should be ignored.

As a regression fix, change the error code to -ENODEV, and ignore this
error in the callee, to continue probing.

Fixes: 28abd224db4a ("ALSA: caiaq: Handle probe errors properly")
Cc: <stable@vger.kernel.org>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=221423
Link: https://patch.msgid.link/20260427145642.6637-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/caiaq/device.c |    2 +-
 sound/usb/caiaq/input.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/sound/usb/caiaq/device.c
+++ b/sound/usb/caiaq/device.c
@@ -380,7 +380,7 @@ static int setup_card(struct snd_usb_cai
 
 #ifdef CONFIG_SND_USB_CAIAQ_INPUT
 	ret = snd_usb_caiaq_input_init(cdev);
-	if (ret < 0) {
+	if (ret < 0 && ret != -ENODEV) {
 		dev_err(dev, "Unable to set up input system (ret=%d)\n", ret);
 		return ret;
 	}
--- a/sound/usb/caiaq/input.c
+++ b/sound/usb/caiaq/input.c
@@ -804,7 +804,7 @@ int snd_usb_caiaq_input_init(struct snd_
 
 	default:
 		/* no input methods supported on this device */
-		ret = -EINVAL;
+		ret = -ENODEV;
 		goto exit_free_idev;
 	}
 


