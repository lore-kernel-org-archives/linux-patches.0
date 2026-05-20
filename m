Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52EDA3FE663;
	Wed, 20 May 2026 18:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302889; cv=none; b=SrkmtX741yGwyLst//KvCR2z0dQIz3k6KvuIwStgKG7BRKq/PsgB9O4iLd9iEuM7idUeXoGWDY52HKseHCrQc8GLEMufc+7ZaNySpNze6nZ6hWkICgh9c++S+GpkgscEG+ais5qmjtmobqm9fU4siH5z8h2W3xUaWV3OMmkZ+EU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302889; c=relaxed/simple;
	bh=Ow3/5qBmyyFfjlB6YwTW8syOJcg641E+WsCN8xz7/To=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YgXzcRo3BBVMop5n2uyrMPDKsLB9H1PCecnCgLgbO3cpbQxjVB/ciJ3SwLzHB08gmsWH5rTBcUsQEQmbg05uPjXgOuDb0lZS1ZqmTj/yKaR1U12NAqAy24ZiYzQwHWF1QKPcJIt+atEUE11pPzYqsGlvjj5lyo3GMwIBAucFVmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uaVUscxA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uaVUscxA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B83F31F000E9;
	Wed, 20 May 2026 18:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302888;
	bh=FiBimF/sRSBieXuaBIX8y0LlfAc6xXKVLVNwX6h/0CU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uaVUscxAWU4CVb+ZzrvWkJShrDI9CjwyfHSjbde3X4gMNfWoBQC9CsmoGb7qTHUIj
	 EGIq53clXOLWzQ2uvApmxqhaEmr2w/plwlalo8bnX1ox0yD6YbmbBrDpZixcaA4NnP
	 OBhszefL01MGvy4SrC8EuIQliQSvxpVhW5KfshVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 396/508] ALSA: usb-audio: Fix potential leak of pd at parsing UAC3 streams
Date: Wed, 20 May 2026 18:23:39 +0200
Message-ID: <20260520162107.195565487@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit c39f0bc03f84ba64c9144c95714df1dc36150f6d ]

At parsing UAC3 streams, we allocate a PD object at each time, and
either assign or free it.  But there is a case where the PD object may
be leaked; namely, in __snd_usb_parse_audio_interface() loop, when an
audioformat shares the same endpoint with others, it's put to a link
and returns from snd_usb_add_audio_stream(), but the PD is forgotten
afterwards.  Overall, the treatment of PD object in the parser code is
a bit flaky, and we should be more careful about the object ownership.

This patch tries to fix the above case and improve the code a bit.
The pd object is now managed with the auto-cleanup in the loop, and
the ownership is updated when the pd object gets assigned to the
stream, which guarantees the release of the leftover object.

Fixes: 7edf3b5e6a45 ("ALSA: usb-audio: AudioStreaming Power Domain parsing")
Link: https://patch.msgid.link/20260427151508.12544-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks.c |  2 +-
 sound/usb/stream.c | 58 ++++++++++++++++++----------------------------
 sound/usb/stream.h |  3 ++-
 3 files changed, 25 insertions(+), 38 deletions(-)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 847878438b8b7..ed625d5bbe9ab 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -122,7 +122,7 @@ static int add_audio_stream_from_fixed_fmt(struct snd_usb_audio *chip,
 
 	snd_usb_audioformat_set_sync_ep(chip, fp);
 
-	err = snd_usb_add_audio_stream(chip, stream, fp);
+	err = snd_usb_add_audio_stream(chip, stream, fp, NULL);
 	if (err < 0)
 		return err;
 
diff --git a/sound/usb/stream.c b/sound/usb/stream.c
index 920a718f91e68..f964082da3a63 100644
--- a/sound/usb/stream.c
+++ b/sound/usb/stream.c
@@ -79,7 +79,7 @@ static void snd_usb_audio_pcm_free(struct snd_pcm *pcm)
 static void snd_usb_init_substream(struct snd_usb_stream *as,
 				   int stream,
 				   struct audioformat *fp,
-				   struct snd_usb_power_domain *pd)
+				   struct snd_usb_power_domain **pdptr)
 {
 	struct snd_usb_substream *subs = &as->substream[stream];
 
@@ -105,10 +105,11 @@ static void snd_usb_init_substream(struct snd_usb_stream *as,
 	if (fp->channels > subs->channels_max)
 		subs->channels_max = fp->channels;
 
-	if (pd) {
-		subs->str_pd = pd;
+	if (pdptr && *pdptr) {
+		subs->str_pd = *pdptr;
+		*pdptr = NULL; /* assigned */
 		/* Initialize Power Domain to idle status D1 */
-		snd_usb_power_domain_set(subs->stream->chip, pd,
+		snd_usb_power_domain_set(subs->stream->chip, subs->str_pd,
 					 UAC3_PD_STATE_D1);
 	}
 
@@ -486,11 +487,14 @@ snd_pcm_chmap_elem *convert_chmap_v3(struct uac3_cluster_header_descriptor
  * if not, create a new pcm stream. note, fp is added to the substream
  * fmt_list and will be freed on the chip instance release. do not free
  * fp or do remove it from the substream fmt_list to avoid double-free.
+ *
+ * pdptr is optional and can be NULL.  When it's non-NULL and the PD gets
+ * assigned to the stream, *pdptr is cleared to NULL upon return.
  */
-static int __snd_usb_add_audio_stream(struct snd_usb_audio *chip,
-				      int stream,
-				      struct audioformat *fp,
-				      struct snd_usb_power_domain *pd)
+int snd_usb_add_audio_stream(struct snd_usb_audio *chip,
+			     int stream,
+			     struct audioformat *fp,
+			     struct snd_usb_power_domain **pdptr)
 
 {
 	struct snd_usb_stream *as;
@@ -523,7 +527,7 @@ static int __snd_usb_add_audio_stream(struct snd_usb_audio *chip,
 		err = snd_pcm_new_stream(as->pcm, stream, 1);
 		if (err < 0)
 			return err;
-		snd_usb_init_substream(as, stream, fp, pd);
+		snd_usb_init_substream(as, stream, fp, pdptr);
 		return add_chmap(as->pcm, stream, subs);
 	}
 
@@ -551,7 +555,7 @@ static int __snd_usb_add_audio_stream(struct snd_usb_audio *chip,
 	else
 		strcpy(pcm->name, "USB Audio");
 
-	snd_usb_init_substream(as, stream, fp, pd);
+	snd_usb_init_substream(as, stream, fp, pdptr);
 
 	/*
 	 * Keep using head insertion for M-Audio Audiophile USB (tm) which has a
@@ -569,21 +573,6 @@ static int __snd_usb_add_audio_stream(struct snd_usb_audio *chip,
 	return add_chmap(pcm, stream, &as->substream[stream]);
 }
 
-int snd_usb_add_audio_stream(struct snd_usb_audio *chip,
-			     int stream,
-			     struct audioformat *fp)
-{
-	return __snd_usb_add_audio_stream(chip, stream, fp, NULL);
-}
-
-static int snd_usb_add_audio_stream_v3(struct snd_usb_audio *chip,
-				       int stream,
-				       struct audioformat *fp,
-				       struct snd_usb_power_domain *pd)
-{
-	return __snd_usb_add_audio_stream(chip, stream, fp, pd);
-}
-
 static int parse_uac_endpoint_attributes(struct snd_usb_audio *chip,
 					 struct usb_host_interface *alts,
 					 int protocol, int iface_no)
@@ -1102,8 +1091,7 @@ snd_usb_get_audioformat_uac3(struct snd_usb_audio *chip,
 		}
 	}
 
-	if (pd)
-		*pd_out = pd;
+	*pd_out = pd;
 
 	return fp;
 }
@@ -1118,7 +1106,6 @@ static int __snd_usb_parse_audio_interface(struct snd_usb_audio *chip,
 	struct usb_interface_descriptor *altsd;
 	int i, altno, err, stream;
 	struct audioformat *fp = NULL;
-	struct snd_usb_power_domain *pd = NULL;
 	bool set_iface_first;
 	int num, protocol;
 
@@ -1160,6 +1147,12 @@ static int __snd_usb_parse_audio_interface(struct snd_usb_audio *chip,
 		if (snd_usb_apply_interface_quirk(chip, iface_no, altno))
 			continue;
 
+		/* pd may be allocated at snd_usb_get_audioformat_uac3() and
+		 * assigned at snd_usb_add_audio_stream(); otherwise it'll be
+		 * freed automatically by cleanup at each loop.
+		 */
+		struct snd_usb_power_domain *pd __free(kfree) = NULL;
+
 		/*
 		 * Roland audio streaming interfaces are marked with protocols
 		 * 0/1/2, but are UAC 1 compatible.
@@ -1215,23 +1208,16 @@ static int __snd_usb_parse_audio_interface(struct snd_usb_audio *chip,
 			*has_non_pcm = true;
 		if ((fp->fmt_type == UAC_FORMAT_TYPE_I) == non_pcm) {
 			audioformat_free(fp);
-			kfree(pd);
 			fp = NULL;
-			pd = NULL;
 			continue;
 		}
 
 		snd_usb_audioformat_set_sync_ep(chip, fp);
 
 		dev_dbg(&dev->dev, "%u:%d: add audio endpoint %#x\n", iface_no, altno, fp->endpoint);
-		if (protocol == UAC_VERSION_3)
-			err = snd_usb_add_audio_stream_v3(chip, stream, fp, pd);
-		else
-			err = snd_usb_add_audio_stream(chip, stream, fp);
-
+		err = snd_usb_add_audio_stream(chip, stream, fp, &pd);
 		if (err < 0) {
 			audioformat_free(fp);
-			kfree(pd);
 			return err;
 		}
 
diff --git a/sound/usb/stream.h b/sound/usb/stream.h
index d92e18d5818fe..61b9a133da018 100644
--- a/sound/usb/stream.h
+++ b/sound/usb/stream.h
@@ -7,7 +7,8 @@ int snd_usb_parse_audio_interface(struct snd_usb_audio *chip,
 
 int snd_usb_add_audio_stream(struct snd_usb_audio *chip,
 			     int stream,
-			     struct audioformat *fp);
+			     struct audioformat *fp,
+			     struct snd_usb_power_domain **pdptr);
 
 #endif /* __USBAUDIO_STREAM_H */
 
-- 
2.53.0



