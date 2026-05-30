Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3126530EF7D;
	Sat, 30 May 2026 17:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163610; cv=none; b=RPdMUTsNAjAaOjMbSEPjqqtH5jSaIxZb5DB97s2uOEYA+F8OLZXUtfD/Hj0graWMpui+4jku8M/QUF0l8NveqdLeRoCMD9c4bKz7sIvIYcN8bVZbOpF2NEhFFGmSytlruPmPehoE7HJtaZFtg2aFtK2S7vpgWOl+9oLaqq6tBbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163610; c=relaxed/simple;
	bh=IVf59HmkctsbkKjNovB+8THHT7wWRRhTK8mDZiMfvMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LezGY3YgZmJp2rr0vr992SZr8/nHn+6qeb4azlLwymRpn3IV1PkzPFVBTMN4zz2CJpnRuVrzZaO9MgqAtHQoHMOtG2h9IcPcNQLN2Rqpvzx6kJSYS3N/66X5lzKc573a/Djmj2jUNL09kfnGk3ENZK1pvRqxxptfVwNvFWDbRoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BXnGVbrL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BXnGVbrL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 760531F00893;
	Sat, 30 May 2026 17:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163609;
	bh=n8kZG0Dim0Y05762bIabJZpARB4Q2V7a1omT7HOnFlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BXnGVbrLAONFKZnH73e9REXyxRUe88bpHiPtiHCwtcdvkT1sYY21GobmhIkprfVbR
	 9HXDuGG/tvAuhrFryIU/S/A3eOq84HECE18eElXuCVU6vCbFmPJOXpeflf2y6E6ujr
	 EiuPV3fL/gZu1YDVGbjKPYOqczUH/17XRbrXx8DY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeungJu Cheon <suunj1331@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 310/776] sound: ua101: fix division by zero at probe
Date: Sat, 30 May 2026 18:00:24 +0200
Message-ID: <20260530160248.579689985@linuxfoundation.org>
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


