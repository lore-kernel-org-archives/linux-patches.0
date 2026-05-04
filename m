Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E6E3DEAFF;
	Mon,  4 May 2026 14:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903601; cv=none; b=EoxZKCagh2ifWDaJh8e1A9BNGI04Tm+JnKeC/6o2RuV3JlM0HPWIWI2upcrv3/7v0TCRLLm8aOt2beAmDpuRVuHZ1zM3AHqZrHfZLTmlLEK8XHIzCukrmByfTxzNz2RJg1WbUgwCaq/eqKdoBC088yQNckp2bLJzYA42HWcAV3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903601; c=relaxed/simple;
	bh=Y7YciMM7tyAYb1cliwhw3iaQZEprmjPa9HtLwvWcw9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nTuZ1D+uBxo41HdKbXuNzwqYlEN2oKn4xHQTBfRE7z8Ut4jokjYQWzVoq8PCHxuUxj9bX0vQCJm72F9IEmUjLftH7pfrUPv8wj+hlkh6aDzbWbg7hfBDvGdzumtIEt5n9CYCk4D4M0gxPn0m5gCRdQ0szWyStYivmPWHDcQvCz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FQPTFGQO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FQPTFGQO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90BB0C2BCB8;
	Mon,  4 May 2026 14:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903600;
	bh=Y7YciMM7tyAYb1cliwhw3iaQZEprmjPa9HtLwvWcw9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FQPTFGQOrlYC1EVo2eGu3uVS4XWJRcZpWSzo3SNGMYMSFx+uiyorGu6pLtTgNvJbr
	 R2qrFvCEtXhF85SHg5kaxCe9vhnUh60FDLhDg1K0YUKBVvdjuj3HpvW/xndJndTBZu
	 4DJXtaXNJ2QEMs7gysZhyCDzz0ry0sUPDvge54RE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.0 297/307] ALSA: caiaq: Dont abort when no input device is available
Date: Mon,  4 May 2026 15:53:02 +0200
Message-ID: <20260504135153.960189669@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
 


