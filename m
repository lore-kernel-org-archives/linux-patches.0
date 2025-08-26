Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C5B537F8;
	Tue, 26 Aug 2025 12:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212547; cv=none; b=ZFVYP7vqWg/D52+WOpadfC0X17MfZFC4Z3nN5VCMAI12ldPLQNr0n8brCXoOj4NDfzTfdK2i605YxxkmBj1D0NXKwKMFazGzAtORXYTgPgQkqq8ei1t+mUQ9gEzbLVR7qTauRWy30q2E+nJqzAog4rHiE6TpaR2Z6nDa0Aw+PU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212547; c=relaxed/simple;
	bh=KWHfTOi74J/6GAvDd+n7ggN4a8MVhcSKI+eD1OQI9Bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pdn7G4CxKi84nUpGdBHpvHbjzS34hVPINvC4DsIWM8hvzfCfEqMc3XCv6YR6ZdDgPy2PcfDJu3cgp4jxyg0Ag05VoEJYlbdO0hdxKdVCcVBTB0Scv5svaNKns3Vi8D4d7o67uIZW3evsfRGUV5EHRLV1B8Rd1fVD1m8ey2od5Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hNvOmpDv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hNvOmpDv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A7C0C4CEF1;
	Tue, 26 Aug 2025 12:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212545;
	bh=KWHfTOi74J/6GAvDd+n7ggN4a8MVhcSKI+eD1OQI9Bk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hNvOmpDv/lPrcvC22HbJb5QWbNYdOHOBuUKAkbuAspODVXLdhbUh5VbAVTWpQKzQW
	 QsRknFQ30W7frszn3ZsE7l9HvgBcboMpQurDZDWeQZLt2zZC2fXFSFpIkCM33KI+A1
	 It2T0y0dH1n5jdFPKLG9liIDKuM9Wt8hvFkxCFKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Youngjun Lee <yjjuny.lee@samsung.com>
Subject: [PATCH 6.6 003/587] ALSA: usb-audio: Validate UAC3 cluster segment descriptors
Date: Tue, 26 Aug 2025 13:02:32 +0200
Message-ID: <20250826110953.033925460@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
User-Agent: quilt/0.68
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

commit ecfd41166b72b67d3bdeb88d224ff445f6163869 upstream.

UAC3 class segment descriptors need to be verified whether their sizes
match with the declared lengths and whether they fit with the
allocated buffer sizes, too.  Otherwise malicious firmware may lead to
the unexpected OOB accesses.

Fixes: 11785ef53228 ("ALSA: usb-audio: Initial Power Domain support")
Reported-and-tested-by: Youngjun Lee <yjjuny.lee@samsung.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20250814081245.8902-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/stream.c |   25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

--- a/sound/usb/stream.c
+++ b/sound/usb/stream.c
@@ -341,20 +341,28 @@ snd_pcm_chmap_elem *convert_chmap_v3(str
 
 	len = le16_to_cpu(cluster->wLength);
 	c = 0;
-	p += sizeof(struct uac3_cluster_header_descriptor);
+	p += sizeof(*cluster);
+	len -= sizeof(*cluster);
 
-	while (((p - (void *)cluster) < len) && (c < channels)) {
+	while (len > 0 && (c < channels)) {
 		struct uac3_cluster_segment_descriptor *cs_desc = p;
 		u16 cs_len;
 		u8 cs_type;
 
+		if (len < sizeof(*p))
+			break;
 		cs_len = le16_to_cpu(cs_desc->wLength);
+		if (len < cs_len)
+			break;
 		cs_type = cs_desc->bSegmentType;
 
 		if (cs_type == UAC3_CHANNEL_INFORMATION) {
 			struct uac3_cluster_information_segment_descriptor *is = p;
 			unsigned char map;
 
+			if (cs_len < sizeof(*is))
+				break;
+
 			/*
 			 * TODO: this conversion is not complete, update it
 			 * after adding UAC3 values to asound.h
@@ -456,6 +464,7 @@ snd_pcm_chmap_elem *convert_chmap_v3(str
 			chmap->map[c++] = map;
 		}
 		p += cs_len;
+		len -= cs_len;
 	}
 
 	if (channels < c)
@@ -876,7 +885,7 @@ snd_usb_get_audioformat_uac3(struct snd_
 	u64 badd_formats = 0;
 	unsigned int num_channels;
 	struct audioformat *fp;
-	u16 cluster_id, wLength;
+	u16 cluster_id, wLength, cluster_wLength;
 	int clock = 0;
 	int err;
 
@@ -1003,6 +1012,16 @@ snd_usb_get_audioformat_uac3(struct snd_
 			iface_no, altno);
 		kfree(cluster);
 		return ERR_PTR(-EIO);
+	}
+
+	cluster_wLength = le16_to_cpu(cluster->wLength);
+	if (cluster_wLength < sizeof(*cluster) ||
+	    cluster_wLength > wLength) {
+		dev_err(&dev->dev,
+			"%u:%d : invalid Cluster Descriptor size\n",
+			iface_no, altno);
+		kfree(cluster);
+		return ERR_PTR(-EIO);
 	}
 
 	num_channels = cluster->bNrChannels;


