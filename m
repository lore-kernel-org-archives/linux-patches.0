Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE4635AC09;
	Fri, 15 May 2026 16:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860942; cv=none; b=CrIUYgRlghUy1IXjg4WXe/9XAvM/2SKqRdjSRZ+UjwcSiJzhQtHaNcT0n8HlHR1ThCn8AeLfrRbLBQBVgLgSsu9RVif54XmliifSKLccjkxEjXQ/u0WKtwBMObZbgq9k4l68zIJpR+2K7NpJ9ylpCF9Ad8tKb/Mh9ep2V+sIeHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860942; c=relaxed/simple;
	bh=LwTfH/mUUMh3HCPORWFYAQTwlWxruDrnOJijDKN0cVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XC0G/j9azFMepXVONQDwhJs2+TtuVSjifYnNFS5v8YiI5zTJ/xyBh/Flb0CZUfeHbsK8p/ZD+Anm58VL7QEolEvD1is4aKGmAR4+2wGG+Uxt+IwvdCGUGqK9Zy5uQf1CQL1bNqRv1CLfvqyVjH+eYih5ta9YDPQwhVzLQOsdDwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vn2LondH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vn2LondH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5CBEC2BCB0;
	Fri, 15 May 2026 16:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860942;
	bh=LwTfH/mUUMh3HCPORWFYAQTwlWxruDrnOJijDKN0cVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vn2LondHaUT3X9pfTprSpzsDT/IwsFREb/MfiXKLZbXd70E5y20lfPTdSwDZM+dSp
	 r6cxo/JoObRBkf9jDNRIETHLUIUEOWbJoK1cNwigs8oNNpwMWfdGkCv2IHbClwDfSf
	 JnLPqH/aFDjwmRotyFDTYW4HZ406Qr3BWgZhxxgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 138/474] ALSA: caiaq: Dont abort when no input device is available
Date: Fri, 15 May 2026 17:44:07 +0200
Message-ID: <20260515154718.016519877@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


