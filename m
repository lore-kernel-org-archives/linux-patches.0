Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A2432BF24;
	Sat, 30 May 2026 17:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163196; cv=none; b=EgVpnxrC+mhag1Pr2leT5T0qQeNMAR01rD03CvjOqg7aTdKf2y1DlDuwgcQDa7vixZ68Yr/sntEhamilW2Mh+H2U+ZH/pi4/aL5Yc+N6X2/15EF+0H7bsjc2bOVkbVt6+oepJfTYTA0SZJTs4Spsn571ECzWojh+8jbx2eTXais=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163196; c=relaxed/simple;
	bh=tTHzxbezt1XmT1znHhywdtxytlHcsABJD3apDNdvSVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cgo4qRx7GTaf9sEGz8EI6Bat3EmB5hb2hhKoRM1gBwoCxBcC59FvmRuSQ2fy732xyghXIK2SOSZwc7RVB4H/h5FxID2/ZDVDkElZZmLX+/YbNrxWlpIa8sGZH/OXVyZW5ApRCkCv1Obn8SjUvcmLPZAfQklgabCGecDzQ5mm/PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e5SpNO84; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e5SpNO84"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 192C91F00893;
	Sat, 30 May 2026 17:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163195;
	bh=1dyhMiGNEGMwa9UnYg6MYBOEDL5v6yAtDvBtWS/62IE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e5SpNO84+Scw/+S5/2TI5UpIv/jatAj9VKnrIDfOhGTzJv29d8ru45I/S4dXF+Ve2
	 UaSCHHTTiQaQPZr1QRimkTCd8pYxRWh8hFVdAe7XhAFmOl41YKdceVMXxpBct3wwfn
	 rAqNLfy6xOhzsIgBvcYoqkTWhnca2hq628HCWAsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 185/776] ALSA: usb-audio: Evaluate packsize caps at the right place
Date: Sat, 30 May 2026 17:58:19 +0200
Message-ID: <20260530160245.282426875@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1388,9 +1388,6 @@ int snd_usb_endpoint_set_params(struct s
 		goto unlock;
 	}
 
-	ep->packsize[0] = min(ep->packsize[0], ep->maxframesize);
-	ep->packsize[1] = min(ep->packsize[1], ep->maxframesize);
-
 	/* calculate the frequency in 16.16 format */
 	ep->freqm = ep->freqn;
 	ep->freqshift = INT_MIN;
@@ -1417,6 +1414,9 @@ int snd_usb_endpoint_set_params(struct s
 	ep->maxframesize = ep->maxpacksize / ep->cur_frame_bytes;
 	ep->curframesize = ep->curpacksize / ep->cur_frame_bytes;
 
+	ep->packsize[0] = min(ep->packsize[0], ep->maxframesize);
+	ep->packsize[1] = min(ep->packsize[1], ep->maxframesize);
+
 	err = update_clock_ref_rate(chip, ep);
 	if (err >= 0) {
 		ep->need_setup = false;


