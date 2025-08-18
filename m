Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 861F330E83F;
	Mon, 18 Aug 2025 13:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522913; cv=none; b=fDzvZk4kYl01tf9jN0J0q4gB0D5UFZlFyvI+Vo1DLlKlE0XrqKwkqwCIJH1tv1Y44SuTUrlGHaf9jwJ40Wr2FTKFNUoq6WweeLDRpvZU5yfRGGJiGb4Gp/IZ4dD2noqIQKnlKPbUyAFPNg6TDz+6PMY3ynAUyas5EqCiu4PrhSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522913; c=relaxed/simple;
	bh=rLrSth7dxHJS6CSsjYEbutHM1V2bpLCd8lKxRf1JD/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mB9sotqBMnZDoEublgiCY3/Jx2TOgSrNyXOyQmgpZ7IVusQPpY+UcIbQ/ssbYmlm604iQsU8qLXLXJpUd2F0Jq0cFgGLHZBaRNe9D5Sdl5NmOSy/dzv27mw6wIUHZJ5QZ0pEGYGj3y+Z/Ot+kBKiASyATp/Koybi4FmoJP5zLLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uL4kot4t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uL4kot4t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E85CBC4CEF1;
	Mon, 18 Aug 2025 13:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522913;
	bh=rLrSth7dxHJS6CSsjYEbutHM1V2bpLCd8lKxRf1JD/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uL4kot4t2ZT37JNT5FPgTKGy6F9KiRBpZH8s+A14WkzJKt/1yyv4eyKnoj6dD3X0Q
	 iJf5HtksihjoPJFUJdp9eOLJp71PmEvId+9r4OTM9i73bjKCctaWGWp9WkbBhgCawf
	 WDsfa0c8H2Qr+kM8t1t67Ej8ePCIXnwubCEOAViQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Youngjun Lee <yjjuny.lee@samsung.com>
Subject: [PATCH 6.15 006/515] ALSA: usb-audio: Validate UAC3 cluster segment descriptors
Date: Mon, 18 Aug 2025 14:39:52 +0200
Message-ID: <20250818124458.576772869@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -880,7 +889,7 @@ snd_usb_get_audioformat_uac3(struct snd_
 	u64 badd_formats = 0;
 	unsigned int num_channels;
 	struct audioformat *fp;
-	u16 cluster_id, wLength;
+	u16 cluster_id, wLength, cluster_wLength;
 	int clock = 0;
 	int err;
 
@@ -1008,6 +1017,16 @@ snd_usb_get_audioformat_uac3(struct snd_
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


