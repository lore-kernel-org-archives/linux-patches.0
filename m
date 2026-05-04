Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E29571A6827;
	Mon,  4 May 2026 14:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904337; cv=none; b=rFitCNJ0717NLNkRT0VqBu+7YNwSW9rvGuE/5gwBcVvViZ+TNO+uCQPLdiTbJyFVCKWRhW87OxIHtdG1X9eQDa8Ll5tgWpCuHN02vpbPn3ILAYOVQrAsENcTnjHAtGJImzzgJ56lMbj6glbEffMFnq7RZ4WEnxTVxqvvLwQ9fdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904337; c=relaxed/simple;
	bh=Cyz69mHecCJ+nM+8yjpJMVxRC4pgqA8sBhcDVGGNFbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GRLkXF6AgeRgyWN3HLWK8iVtHInDq1ch00f2kIlsAFOvpsIBcbxQ9+JHOUTmvrqm7RvwMdhxzVF8dihJXiRNINbx8/EgAFpmrlCYqWdnwQtGVAIxXvqY8ygTLYbTnkNHBbSu364COgXW/RD7RRrzQm5is5o/UB3LnHwW1uRkjEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wW1swDM1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wW1swDM1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7764EC2BCB8;
	Mon,  4 May 2026 14:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904336;
	bh=Cyz69mHecCJ+nM+8yjpJMVxRC4pgqA8sBhcDVGGNFbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wW1swDM1Ft/cW4lMOmE/A5ZKzxHK6lP0tjvDbi3hPH9hRiEGhqLL5qZU5M60ruNAy
	 rAypd+PdRZF/oh+bES8PFWJ73vNZOFFzMfozSaqIZdH5VSo/ZQ/3oN3gHfy/x7Fw6A
	 CXtOTUbjrPDdsJSi4RPEQfFf5r157mwJSJxsouSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 266/275] ALSA: caiaq: Dont abort when no input device is available
Date: Mon,  4 May 2026 15:53:26 +0200
Message-ID: <20260504135152.920388951@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 


