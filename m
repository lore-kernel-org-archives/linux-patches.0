Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A4C23395D;
	Thu, 16 Jul 2026 14:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210601; cv=none; b=jPT7OWKvUYJJSbVVbSwsSn8Bc+F8ufxQ4DilIZtCVbWaq82zFfhvHzuGZd3T4GP+PPaxFEa7Q5F2zTv5RDA2oQR84U8c+/adX+UMRXBRAeA2dXWSqcOlCNuPHhnfJgxui49Q6xv11kUPhAyoDdkOnFQNx0zeeHXVC5zwgKWwbI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210601; c=relaxed/simple;
	bh=Ufqor2p6clWCMaEhlkTXVgFvGt8D3mJr4438FcgV8Ks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cQKYU3kDuR+wyn8bqGma8SsBQwy8rmaJArfT0yjizvMn5vAEG41OI4LIGXP1kZewzC2VLiVT5Z9K+wtyblBG3z0WIYnWQf2E3civZArQAhll5N6khA3ZzezDT7YhKchjUpphQqcQIPaooJE/XfqN2D+m0kcCy5VZx0bUMHHEmqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ECE5RSp8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ECE5RSp8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA8441F000E9;
	Thu, 16 Jul 2026 14:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210600;
	bh=xsKQFYx0qCrFlVHe9FtogbBOTNtd4YPeKFmh6XHaEBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ECE5RSp8jkOxg21uMj4udjvCih4S6kLtbwoKZYhD3T8dJAmEvNCZrrf/kS6H8C4iE
	 mZj7ZSx3votxS0TkR0zfkZjZZ0GRpzZpZZ7/cCLr/91B6ovfnvOgawabjMKYD/iKgp
	 0ZiSZt+Fak9C7xGOWcPB94lUis8HXipxVYUjXrCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WenTao Liang <vulab@iscas.ac.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 109/480] ALSA: us144mkii: capture_urb_complete: redundant usb_anchor_urb corrupts anchor list on each resubmission
Date: Thu, 16 Jul 2026 15:27:36 +0200
Message-ID: <20260716133047.067251823@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: WenTao Liang <vulab@iscas.ac.cn>

commit 5cff1529a2f9b3461a7f5a6e36a86682fc290534 upstream.

In capture_urb_complete(), usb_anchor_urb() is called on every
completion callback, but the URB is already anchored from the
initial submission in tascam_trigger_start(). Each redundant call
corrupts the anchor's doubly-linked list and inflates the URB
refcount. When usb_kill_anchored_urbs() traverses the list during
stream stop / suspend / disconnect, the corrupted list leads to
use-after-free.

Remove the redundant usb_anchor_urb() from the resubmit path.

Cc: stable@vger.kernel.org
Fixes: c1bb0c13e430 ("ALSA: usb-audio: us144mkii: Implement audio capture and decoding")
Signed-off-by: WenTao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260627042949.61767-1-vulab@iscas.ac.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/usx2y/us144mkii_capture.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/usb/usx2y/us144mkii_capture.c
+++ b/sound/usb/usx2y/us144mkii_capture.c
@@ -302,7 +302,6 @@ void capture_urb_complete(struct urb *ur
 	}
 
 	usb_get_urb(urb);
-	usb_anchor_urb(urb, &tascam->capture_anchor);
 	ret = usb_submit_urb(urb, GFP_ATOMIC);
 	if (ret < 0) {
 		dev_err_ratelimited(tascam->card->dev,
@@ -312,6 +311,7 @@ void capture_urb_complete(struct urb *ur
 		usb_put_urb(urb);
 		atomic_dec(
 			&tascam->active_urbs); /* Decrement on failed resubmission */
+		return;
 	}
 out:
 	usb_put_urb(urb);


