Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AD473D6489;
	Mon,  4 May 2026 13:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777902914; cv=none; b=bLBM4DInB3V4jXiSoRwfGoUDVIHHgYKXc8sSapHG/R0eRQhXR0WyR78LuTvVrC8oV7XT2uAYTcstK02gPCbTQ9AOmL+hXgZan3irZljyQIzw/boKgR2JomHzlb4ViEFdk1ttrnaPNEWrPIAGuIycK3azUusFnAjDkr9nHPQ5bXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777902914; c=relaxed/simple;
	bh=2HFhRXKxo6e2Sp63S9oXME2MIPQDzJGCVsLPXCKmECA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S8FwX2BL8UGtekXZxMcc03/QunleRoCFWNJjGYzYqrvR4Tuq9hccmV9ajs9q8VIJ6VX1x/ziYkn2edwlJYv+PfIVNUS8+cA8gMYJaENNFR4Q5IvGu9F0N63bC14E/N6w/fNWG+XG2YkbhaEANjTYl80KC0YHNS7vuEhVERUTID4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zu11dD35; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zu11dD35"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31A01C2BCB8;
	Mon,  4 May 2026 13:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777902914;
	bh=2HFhRXKxo6e2Sp63S9oXME2MIPQDzJGCVsLPXCKmECA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zu11dD35wFIbbLS7APWsF/xkJJPepLn1IHMPbCy8Ubw1NSA1ZSYgtGZ02uDZt2fy9
	 ngHjSV7KcnanvQ/glDmzzkMohvoIQJgik8uyCJsnV6hqg15lK3urJnSMrAAMnie2Vv
	 GUDIBzoG9t3VpkWwON14lcFxvdhBWQYFz9zshyGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.0 007/307] ALSA: usb-audio: Evaluate packsize caps at the right place
Date: Mon,  4 May 2026 15:48:12 +0200
Message-ID: <20260504135143.103591494@linuxfoundation.org>
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

commit 52521e8398839105ef8eb22b3f0993f9b0d11a57 upstream.

We introduced the upper bound checks of the packet sizes by the
ep->maxframesize for avoiding the URB submission errors.  However, the
check was applied at an incorrect place in the function
snd_usb_endpoint_set_params() where ep->maxframesize isn't defined
yet; the value is defined at a bit later position.  So this ended up
with a failure at the first run while the second run works.

For fixing it, move the check at the correct place, right after the
calculation of ep->maxframesize in the same function.

Fixes: 7fe8dec3f628 ("ALSA: usb-audio: Cap the packet size pre-calculations")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=221292
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20260410143220.1676344-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/endpoint.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -1379,9 +1379,6 @@ int snd_usb_endpoint_set_params(struct s
 		return -EINVAL;
 	}
 
-	ep->packsize[0] = min(ep->packsize[0], ep->maxframesize);
-	ep->packsize[1] = min(ep->packsize[1], ep->maxframesize);
-
 	/* calculate the frequency in 16.16 format */
 	ep->freqm = ep->freqn;
 	ep->freqshift = INT_MIN;
@@ -1408,6 +1405,9 @@ int snd_usb_endpoint_set_params(struct s
 	ep->maxframesize = ep->maxpacksize / ep->cur_frame_bytes;
 	ep->curframesize = ep->curpacksize / ep->cur_frame_bytes;
 
+	ep->packsize[0] = min(ep->packsize[0], ep->maxframesize);
+	ep->packsize[1] = min(ep->packsize[1], ep->maxframesize);
+
 	err = update_clock_ref_rate(chip, ep);
 	if (err >= 0) {
 		ep->need_setup = false;


