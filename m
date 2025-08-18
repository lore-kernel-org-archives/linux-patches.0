Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E057335BA3;
	Mon, 18 Aug 2025 13:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524684; cv=none; b=mhgKJmOqUk80VnRSjdTWHuWHXoTl3g4sFnY5qpcaj+1ie2Xcykbz82FJvPXAFDQ29M/Aog+d7hJu4kBAIy1+somlW3xgjqujjwxCi+NVIm0/JWVAIpRQk+dymow8OSq4cVDC1MAJm/kMPyN3e6yN62z483DM4hPI1eTh0miZ5Ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524684; c=relaxed/simple;
	bh=OaY6H0IuElB/YQQBpjG7E2jEdiCj1zcDQRVKNsc/FCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N0iArs3VSsUVGjGYqCna05a6OXEvlTC3fEfbNFHdgMLNcAJkLKGkzSoI+k+s7Wgaox08Jo9o7iV601YhuXJIA+yxo0zgR5T1Si8Zrxr8VtvHUst58Vkwnh8bgkueHJzWnOx42k/ss076gsrZHbkN9NlkVDfUsljOcyRUPQ/ZzjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WeG86AJe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WeG86AJe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8F4EC4CEEB;
	Mon, 18 Aug 2025 13:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524684;
	bh=OaY6H0IuElB/YQQBpjG7E2jEdiCj1zcDQRVKNsc/FCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WeG86AJe/dIqD1vFv/Kl4WoMudMSRaDeELjgf5Z7z/NJyqgFxpENbJSeB8XAo8MBc
	 eE+XMk9UrJwrCI6ewBjaXof8MfBSUov2BglQd/baHW+rzxZK7CfsTro4XddQdnhb9k
	 OwC63xRyeXSbOhgqTYLtNyubIe89e9XR/Z3PUY+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Youngjun Lee <yjjuny.lee@samsung.com>
Subject: [PATCH 6.16 007/570] ALSA: usb-audio: Validate UAC3 cluster segment descriptors
Date: Mon, 18 Aug 2025 14:39:54 +0200
Message-ID: <20250818124506.070067094@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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


