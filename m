Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E86D31E0ED;
	Mon, 18 Aug 2025 12:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521528; cv=none; b=uVEUeIh8qjZ3TKninLV/upn/OiigRBydRduNEyBCrG0pfUnyFV+JFYhgkQbTc0VcgHT6oIABGc32OByMsHbG4piB73uj+vtlA71QlJleT/1ILVBpga6E6B+ogP//CpPxBYF5lMuErgurFbo1EGQiCYIJRWMV38XTEIqsVqPSxho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521528; c=relaxed/simple;
	bh=wWJwqylklMevDmtbMYDMzneU2dQs7hprHYhzXl6h+Gc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K25vhEz2caYsAY2AvdoxDpFHiK28anonnJGmpIz6WKQ8j5czuHS78JHy066WsPt3tLyNuE8AnBAg5DPq4TaDFEPHPXvuG3APQCE8X7XdpxpSa8DMXbt7dex+HkgRxja023A4lR/dwWYo853AtG1+Y0e9+5BQCtLWs0xHh4iqHOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MtbvTbuL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MtbvTbuL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF588C4CEEB;
	Mon, 18 Aug 2025 12:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521528;
	bh=wWJwqylklMevDmtbMYDMzneU2dQs7hprHYhzXl6h+Gc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MtbvTbuLi5ibOcHatRQ5mOiRed8fsx3UwhXjOlaKvCDMhA/RQ+tGXek0epxx9B23X
	 ZEezMH4banNQ2iUQCdWLHF9tJe3QdkKf2PGXBQ8eOb35m0b8jFg/l9grrXijR7+X+t
	 aePVFKtY80uJDC9ODnBXrmabVZod+/Ca5U4+8Aeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Youngjun Lee <yjjuny.lee@samsung.com>
Subject: [PATCH 6.12 003/444] ALSA: usb-audio: Validate UAC3 cluster segment descriptors
Date: Mon, 18 Aug 2025 14:40:29 +0200
Message-ID: <20250818124449.013637433@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


