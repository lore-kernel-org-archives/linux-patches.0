Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F402E92B3;
	Sat, 30 May 2026 16:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160323; cv=none; b=tcKqpfHGeq92SMqn9/7SNE6G9cJ8lQwEo8MfxxFww+egFd8Sd39SXqF3EUpcDUawfLQi5pPcAWOWBgMIpnYIwh2g5m+l8LeD+ILMiAuzFqgZojixfx8cK+XQ4bH0Lt49rrSZEXAFxTKpEwzVntpQe4rOocr65DAVpjc1A1BM2C8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160323; c=relaxed/simple;
	bh=wyezjWNchmOb6DWxMynh7H2fX8NP7slkeSjkOVRGWNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hqjcfmU7VLG0OwQi4gSBjqG5gYFqGQ1P5mqj0g9diHUwLp32fqcLjdSournzro2L098px0NkL4nV7rtkVDHPWSfsqLPKzfNrtywK26IRjkQ/Pv+legbYRQFia+p/2OHQKvpKpYVO3w6EC3NlpZ/nixh2Np4hupV8pV4Q6QJU0fU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bCr0ibh/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bCr0ibh/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 650181F00893;
	Sat, 30 May 2026 16:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160322;
	bh=2EimBkK//SqMm+VixKPdRXMYqCSNOpumQlJjbkfFZAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bCr0ibh/mfhT6ksW/jKQ1p7r/m4XYCETgVFdM3JID40YCbCx/c05FWd16rBcau9JU
	 l/V5MpAMEdr6ZkrYzHkNpxwy41HKd7gNpiDzR6y9x8KUcyrxJx79NvuxGV071WU0UD
	 gFQvjKxxOGMVT2G/E88KCVe9t6vSZ62KlG7B5IdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 273/969] ALSA: caiaq: Dont abort when no input device is available
Date: Sat, 30 May 2026 17:56:37 +0200
Message-ID: <20260530160308.019966249@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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
@@ -366,7 +366,7 @@ static int setup_card(struct snd_usb_cai
 
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
 


