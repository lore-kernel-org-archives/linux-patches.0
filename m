Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B3013C09ED;
	Tue, 12 May 2026 17:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608476; cv=none; b=MufX0vd9bd4L7ksNESzSx5zr6ytimIKchj1fjxwPIjJCEjej+hTo6isn/2kIHXI3PT1X9Kw/bFzjbWkAsIQ+M1Udby/QLsik2g1I/n+vQGe9eroPn8H6MA2o2trpu29FvicFyL3KMQuK5niXgvcvlwA5qlKbv5+FT+9GA8NNOuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608476; c=relaxed/simple;
	bh=Y3xMXFxj6WQkq8diArAWpdmci2Ejq7hvpqo7ltpx3ag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c7AJa8Xk5ZjKuuNGFeCz1OQKz50w5VhzZFBAQT6/4itqMMX1hH2Jo9aeg8UaVJhgNwkfkt9ZEJJJI4dlP20evPr0bbwfMuZyDnmm8S8A9UX7jTQbwdY7FOuQwJkP88v0TZ3/h4jYV30s5zxnMHoF5W/utLmHP1zwJ1ub3prLOOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VwlwAk04; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VwlwAk04"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32240C2BCB0;
	Tue, 12 May 2026 17:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608476;
	bh=Y3xMXFxj6WQkq8diArAWpdmci2Ejq7hvpqo7ltpx3ag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VwlwAk04S0NuWLzxgvj6gDgJqmpkk0xc4Afp39aAxHmokIq4lsfOqh2g4dySDaYWI
	 8+cQUdfRCBQQ2qfiwNDn5pIbna2SklOX7EyS7qEye7wEu8rynSzoIOdaUrvLN/mKmW
	 +mGRnihLAtoOMcEikh3J3MPBPN18ZU4ejz/Tu5pY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeungJu Cheon <suunj1331@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 095/270] sound: ua101: fix division by zero at probe
Date: Tue, 12 May 2026 19:38:16 +0200
Message-ID: <20260512173940.461048725@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

From: SeungJu Cheon <suunj1331@gmail.com>

commit d1f73f169c1014463b5060e3f60813e13ddc7b87 upstream.

Add a missing sanity check for bNrChannels in detect_usb_format()
to prevent a division by zero in playback_urb_complete() and
capture_urb_complete().

USB core does not validate class-specific descriptor fields such
as bNrChannels, so drivers must verify them before use. If a
device provides bNrChannels = 0, frame_bytes becomes zero and is
later used as a divisor in the URB completion handlers, leading
to a kernel crash.

Fixes: 63978ab3e3e9 ("sound: add Edirol UA-101 support")
Cc: stable@vger.kernel.org
Signed-off-by: SeungJu Cheon <suunj1331@gmail.com>
Link: https://patch.msgid.link/20260426111239.103296-1-suunj1331@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/misc/ua101.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/sound/usb/misc/ua101.c
+++ b/sound/usb/misc/ua101.c
@@ -974,6 +974,13 @@ static int detect_usb_format(struct ua10
 
 	ua->capture.channels = fmt_capture->bNrChannels;
 	ua->playback.channels = fmt_playback->bNrChannels;
+	if (!ua->capture.channels || !ua->playback.channels) {
+		dev_err(&ua->dev->dev,
+			"invalid channel count: capture %u, playback %u\n",
+			ua->capture.channels, ua->playback.channels);
+		return -EINVAL;
+	}
+
 	ua->capture.frame_bytes =
 		fmt_capture->bSubframeSize * ua->capture.channels;
 	ua->playback.frame_bytes =


