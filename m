Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026099;
	b=F/6UdYzS8MDkVdHTDeFVkO2BXQViAEk05ckv6pGmNkshrdYp+et9h/5/4KECWBwL4LQG
	 txhgZ87/ah0wYTrcO+VMNnc3NxPwsXoUhbP26tZs10tgd63w0tbs7fLfK5rcw8uIBNMTS
	 pqRUnt5IjmoBacclnymuPHIbBUPaI9V/MMxjBbM84Ksp9o788dGbc5YAQbgLPwGbOzA/w
	 2+SrNSrVH7ZDMiGBdmHCd5Zwz+BWkN/c4xjqF8PWexkTBt25JsnQrwsgxyyAY0Hp/EiIz
	 UTC2pf9t4ID+930nSPhgqYRGGDkdlBcJehktvHeWj5TAjkYgCjTQckqfeFY5Lg2rYkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026099;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EwSgXk65h6eNUWxVFhWh4edYw78/NQErKTGmWgcyUI0=;
	b=4bfbsal022T9lBcN1tahZtCvdiKrbGOuJRFsrKqJzzOGSckaoZFOMXZHc+B6yFEFTl8n
	 RTPpbRWoQ5QiPSuRbxCM1/0YvkEa1yg2Oijgk9lSs8GBFT20PYrqqDCAP7OsArpIYGyHh
	 1KiV6Z4yu6fdhiYNIudBmZlvCo1g/Xynqs2M1dwJN3x59ZnZj/3c89jAE4JqA7bQP3KDq
	 6ZfYWVptxZnLQg+mp7vQj+yDJ2qToqnRr6P3+VsVKGQtQ1iA450efxsDzzQcE2rzZPKeB
	 so3MjxNU8Ut6QhbapaTxW8mkY/W5Ly4CUXx+XCefSjD6AWDDcQUGNoG48WTf2VMrgDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ieZzpxaC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 705AC606A320;
	Wed, 18 Nov 2026 18:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ieZzpxaC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C608D1F000C4;
	Wed, 18 Nov 2026 18:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026099;
	bh=EwSgXk65h6eNUWxVFhWh4edYw78/NQErKTGmWgcyUI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ieZzpxaCreY+Lh99ECpB/ywUHxOMUvBtUxVuRx1RGISVQQezFoWpCp+x73ivjiunb
	 REtMI67VygXbedM5B7uaCbsiKkf15gVTu1XjH2uMrFeTXCTDd3BCAkyqPCOpkQ7Q00
	 lr0r6GHMEwP+7tlwWNxmdW4XjgvesAJ7U6d3vh4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1314/2151] ALSA: hda: Stop unsol event and jack polling at hda-ext device removal, too
Date: Wed, 18 Nov 2026 15:50:49 +0100
Message-ID: <20261118150209.962532609@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 3e9bde54cf0f2..c7c2adf3396c1 100644
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
 	if (!refcount_dec_and_test(&codec->pcm_ref))
-- 
2.53.0



