Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 187C131578E;
	Fri,  7 Aug 2026 14:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114174; cv=none; b=OAxH1smjsiUsLB4cA0ss1bjqfWGrEDvjsq+vqi5cvmp9lZAZ+OA2gh2381ccyhhRbSWlaxl0wnbYQ4aoJPC806A0fiONyy6ob1ueombBG/9WNFmogUdEpXQArVrjDv2oBLvvHjghHhnqWYPdEfAcOt/x9GOIrDzsy9jW/j8dmFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114174; c=relaxed/simple;
	bh=+qYkNmXTB1BjKU4GtWzWWF+vz1KMnlMvdq14JTKy9Pk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y1y6WrQlY/oZnU95bVNC5R3X6Rah5KpheDY2kST4oq9bx4Ibg2M5mnWnAOlfWwT6W3H2ezAymAqZ5ecVVv2dNdNfEeyQ2H97lVfFu5MuLTImuxsdeeywebibjelXaITFJhRiochh9igOYYqq+JT6gfrVPfInrgc5DTPzFvRiRn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=isrC17EN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="isrC17EN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 680B41F000E9;
	Fri,  7 Aug 2026 14:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114172;
	bh=bSYKFAwePGLLjPBsW7tXFHd4z82lBs+ODtiSrOAfPf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=isrC17ENj2mFtSpUfALfAAijYe73UTPf7fMzY5mu8Ui2lfCl1vdCxOUi26S/JNVkF
	 Pi6mfWlMd/HnkiwZs3NngXMfWLaVwLwenXMquEOFSSzFcO1bBo/itGZcqqEnPk+ttl
	 YjLrjmkzRgw+aJCb7AStGgPd70Q0RLyY0c/cvAfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sonali Pradhan <sonalipradhan@google.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 168/337] ALSA: usb-audio: Fix DMA buffer out-of-bounds write when fill_max is set
Date: Fri,  7 Aug 2026 16:36:11 +0200
Message-ID: <20260807143422.200218869@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sonali Pradhan <sonalipradhan@google.com>

commit d0199ae1666ff9ae2d1d568d64c3430d4c47f0e5 upstream.

When a USB audio endpoint requests full packet transfers via the fill_max
descriptor flag, data_ep_set_params() promotes ep->curpacksize to
ep->maxpacksize. However, maxsize is left at the original sample-rate
derived value.

Since u->buffer_size is allocated as maxsize * packets, the resulting
DMA buffer is far too small for the requested transfer length. When the
USB host controller streams up to curpacksize bytes per packet, it writes
past the end of the buffer via DMA, corrupting kernel heap memory.

Update maxsize to curpacksize when fill_max is set so that the allocated
DMA buffer size matches the actual transfer request size.

[ changed to reassign maxsize only when ep->fill_max is set -- tiwai ]

Fixes: 8fdff6a319e7 ("ALSA: snd-usb: implement new endpoint streaming model")
Cc: stable@vger.kernel.org
Assisted-by: Jetski:Gemini-3.6-Flash
Signed-off-by: Sonali Pradhan <sonalipradhan@google.com>
Link: https://patch.msgid.link/20260728201716.2347726-1-sonalipradhan@google.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/endpoint.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -1188,10 +1188,12 @@ static int data_ep_set_params(struct snd
 				<< (16 - ep->datainterval);
 	}
 
-	if (ep->fill_max)
+	if (ep->fill_max) {
 		ep->curpacksize = ep->maxpacksize;
-	else
+		maxsize = ep->curpacksize;
+	} else {
 		ep->curpacksize = maxsize;
+	}
 
 	if (snd_usb_get_speed(chip->dev) != USB_SPEED_FULL) {
 		packs_per_ms = 8 >> ep->datainterval;


