Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FDCD385D85;
	Tue, 12 May 2026 17:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778607900; cv=none; b=il8Ur4zzceg3jwVDYTFAse6BCcgTKyBEDgWJ00V+kIQYE9vcBez9pkNUYNB1NPEFD1iq1qMZ7EQ6LR1y7AwWsEhXDBrS33KGd5cSKDXbRGy13INybHqc/bQoetXV+thEtzmSQUbzsr9lx2bnEwcExapK9MCX4Lo4v3eNz3EZeF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778607900; c=relaxed/simple;
	bh=APTNtsFHkrmrEVqRkzzRfLicMMRLEhWvAl1sIBp0aWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZA0A6i5IOsS+ahLcqaUvsoy7vPE1IllrZM9gy9Uh5kfuRa1RJreW+BlRWR7hKnDIAUU3+NJov64eD4GkQQBDwYvMXjJKGmO1zEjd2BEpMnPP5nLlCngmii06Bm2cYKF16mdz6X17fkSmb4n7EoeehoC/jROZyEgG/MYzkjFxK8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HHB0a4cN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HHB0a4cN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 367A9C2BCB0;
	Tue, 12 May 2026 17:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778607900;
	bh=APTNtsFHkrmrEVqRkzzRfLicMMRLEhWvAl1sIBp0aWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HHB0a4cNFvccBTLq5wRegknkNI2mTXP9OhL+79tIt8qucSDHrYsl0pjd9QS08RmLR
	 TQMC2czMzI9o9pXYGSMEHbjjjD9FFA791BEyfPzy7rcdftXqI5VWL2d9vlikxOSpqU
	 LBdG0KFHT5I/v9AjOP6RCeu7FUeWS5eoXwI1KMds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeungJu Cheon <suunj1331@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 079/206] sound: ua101: fix division by zero at probe
Date: Tue, 12 May 2026 19:38:51 +0200
Message-ID: <20260512173934.524585496@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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
@@ -994,6 +994,13 @@ static int detect_usb_format(struct ua10
 
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


