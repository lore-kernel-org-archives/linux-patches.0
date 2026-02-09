Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4893F1AF0AF;
	Mon,  9 Feb 2026 14:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647685; cv=none; b=H6DLq3iOfPdlgUKV3MLz62j+aMqUOe/7hG6TLbUIcpYZV9/ORo4qcZjhQBt4SSi62ctb87CTRhheZnV60di9GjJUFWPvVXbLY9z5gu/Y6g2e2qGsYuuI8wJGnEta5RIKrrejUlV5UyxqBF23N77eVyBmH2lCujDrEOJszB/R9gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647685; c=relaxed/simple;
	bh=hR29LyBVHcxXF/YwHgakP61LjpU9vTn5lRiHVDIy3sQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tE4ImZoaKPOgEKU8e5WekhUjgMl4FDFagFgtjS55WWng7JwtO8Lx64mh6eRsl9ezI0hZbLdWYjXrQFDFLDMtN0HIftWiRQ+j9Xym/iFZp/uCeUct4QMEf+BgF0iJP+lQ+cW9qy4TwOwORGTdODYbvBwZc1JLKQgDfwzWN1F1V/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ms3+G8Ew; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ms3+G8Ew"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8083BC116C6;
	Mon,  9 Feb 2026 14:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647684;
	bh=hR29LyBVHcxXF/YwHgakP61LjpU9vTn5lRiHVDIy3sQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ms3+G8EwZIccLNkvGXnFSco784Qv/T1FShKSZypht6dD3StueT+CWyXDRkUC79saD
	 uqXDK0BvXmb6H3VX1nMfSuDvFX8sJI8ljZcmgIDl7SE3ex3T3Kj/960YRoqInXQP93
	 4+eLR6pmDNuzJvE+gm8JnAyXt6cA4i4t3zMVjqPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 174/175] ALSA: usb-audio: Use the right limit for PCM OOB check
Date: Mon,  9 Feb 2026 15:24:07 +0100
Message-ID: <20260209142326.735964474@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

commit 70b4db7d258118a7464f039112a74ddb49a95b06 upstream.

The recent fix commit for addressing the OOB access of PCM URB data
buffer caused a regression on Behringer UMC2020HD device, resulting in
choppy sound.  The fix used ep->max_urb_frames for the upper limit
check, and this is no right value to be referred.

Use the actual buffer size (ctx->buffer_size) as the upper limit
instead, which also avoids the regression on the device above.

Fixes: ef5749ef8b30 ("ALSA: usb-audio: Prevent excessive number of frames")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=220997
Link: https://patch.msgid.link/20260121082025.718748-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/pcm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -1553,7 +1553,8 @@ static int prepare_playback_urb(struct s
 
 		for (i = 0; i < ctx->packets; i++) {
 			counts = snd_usb_endpoint_next_packet_size(ep, ctx, i, avail);
-			if (counts < 0 || frames + counts >= ep->max_urb_frames)
+			if (counts < 0 ||
+			    (frames + counts) * stride > ctx->buffer_size)
 				break;
 			/* set up descriptor */
 			urb->iso_frame_desc[i].offset = frames * stride;


