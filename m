Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019419;
	b=NWsJmUBj9J2iqNYqL2z1Jo5t5p+m6QsIGV12VKqHMdgMC5yV3ohIx97JEOFte1gmKws9
	 2RELf9fES5OKeiVtJx9AIAZtQ1xInqOnoP+qMnCI3Uv/xq7ixmqMtW+PfT19tc86ffRXC
	 +SVFcLmVrz6ExU01opI+vGeY8ajDxpzqB5vUzT/bOcxo61lbXwaEjbdHORAL7HxH+7PDE
	 xp42SEE6RtJ86kJLGnE/MT5MOsI9E1w/YkJYbojcH7orMIztf6oyTfNIJyNheeLHBLuDO
	 qiwzJqDlCMz5JhCKhGmRNbqI5EzCsNtmkosXMMndH6s+ybw+1rwD6gXBGn06Qwl84jQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019419;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6t099kNeIx9N8iodwrcr2BIoFfRIQnooSqX0+s9tCzk=;
	b=WL29yn0+R17pDQGSSZ+QsUkaW9jpphR/tBjo28QZXk7SVaAL4iwNFyON2HRE1vru3qFF
	 ydPBE/o34PkFDBkE3matXbu4WBLzpRZoFsfUD4bWgEinus4fx8tlz5cN/oYsEHL9ak7TQ
	 SZeZo06B8GCHHwDhiISPIxqHy2/JjdaE/UXLSNvb/u2X6jHEj44uT9DAchVH0NgFhdAAw
	 F7e3Dzi6heGPJFh+JBqj4lvlCFz0nJZ6umLjLCR1FdC+ijJDXmI3v1yfKjE0FNGtf3J4S
	 fpRGZSLQRbA1hzU81m5Tdt+HxPHGhx96sQ4l88Al2u3yyHe4N42UEyrJpeGN9+PZIUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SbAlRD2G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0C060A6F6A;
	Wed, 18 Nov 2026 16:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SbAlRD2G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFFC91F01834;
	Wed, 18 Nov 2026 16:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019419;
	bh=6t099kNeIx9N8iodwrcr2BIoFfRIQnooSqX0+s9tCzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SbAlRD2GijYULo4LYJp/CbQ1iK0++h/A0JXlnDa0QFr015zJgDJW+Op9yC5m5FPdg
	 BZdinl/qQkGekFeqa1OoaKvSPTy0YMHOA82iqadjCyCXrHautxBcbwE7E+Fu3zfMe1
	 EKUs6uyqKUrEoYUu7YAaHVSCBuLGi6EWxrevYnTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1589/2651] ALSA: hda: Stop unsol event and jack polling at hda-ext device removal, too
Date: Wed, 18 Nov 2026 15:47:09 +0100
Message-ID: <20261118150345.115291142@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 66530fbe5252eef5e5386a894804c62e10ecfdea ]

In the recent commit f3607b6952ca ("ALSA: hda: Stop unsol events and
jack polling before codec unbind"), we applied the workaround to stop
pending works at the hda codec driver removal, but it was applied
after the bypass for hda-ext ops hdev_detach.  Basically the same
issue is seen for hda-ext stuff, so it's safer to apply the workaround
at the beginning of hda_codec_driver_remove().

Along with it, the clearance of unsol_disabled flag is moved to the
beginning of hda_codec_driver_probe(), too; otherwise hda-ext
hdev_attach() might miss the unsol event handling when the code gets
re-bound.

Fixes: f3607b6952ca ("ALSA: hda: Stop unsol events and jack polling before codec unbind")
Link: https://patch.msgid.link/20261009133341.440917-5-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/common/bind.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/sound/hda/common/bind.c b/sound/hda/common/bind.c
index d12359970e74d..957feace0f58e 100644
--- a/sound/hda/common/bind.c
+++ b/sound/hda/common/bind.c
@@ -92,6 +92,9 @@ static int hda_codec_driver_probe(struct device *dev)
 	bool probed = false;
 	int err;
 
+	/* unsol events are still blocked until registered */
+	codec->core.unsol_disabled = false;
+
 	if (codec->bus->core.ext_ops) {
 		if (WARN_ON(!codec->bus->core.ext_ops->hdev_attach))
 			return -EINVAL;
@@ -101,9 +104,6 @@ static int hda_codec_driver_probe(struct device *dev)
 	if (WARN_ON(!codec->preset))
 		return -EINVAL;
 
-	/* unsol events are still blocked until registered */
-	codec->core.unsol_disabled = false;
-
 	err = snd_hda_codec_set_name(codec, codec->preset->name);
 	if (err < 0)
 		goto error;
@@ -161,16 +161,16 @@ static int hda_codec_driver_remove(struct device *dev)
 	struct hda_codec *codec = dev_to_hda_codec(dev);
 	struct hda_codec_driver *driver = hda_codec_to_driver(codec);
 
+	/* stop asynchronous jack handling before freeing driver resources */
+	snd_hdac_device_disable_unsol(&codec->core);
+	cancel_delayed_work_sync(&codec->jackpoll_work);
+
 	if (codec->bus->core.ext_ops) {
 		if (WARN_ON(!codec->bus->core.ext_ops->hdev_detach))
 			return -EINVAL;
 		return codec->bus->core.ext_ops->hdev_detach(&codec->core);
 	}
 
-	/* stop asynchronous jack handling before freeing driver resources */
-	snd_hdac_device_disable_unsol(&codec->core);
-	cancel_delayed_work_sync(&codec->jackpoll_work);
-
 	snd_hda_codec_disconnect_pcms(codec);
 	snd_hda_jack_tbl_disconnect(codec);
 	snd_refcount_sync(&codec->pcm_ref);
-- 
2.53.0



