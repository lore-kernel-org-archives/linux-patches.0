Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C23D131E84B;
	Sat, 12 Sep 2026 15:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227887; cv=none; b=Gnyah8rW+N9Ctb2tpbXdfUTHv0jEKi+t0Zp5ovXt+2JMBY5qfFmOIuuSJQ9dKiuu2gBOSw1KrHcnN95VO8xGlAoRtgOC4EqII1HO740U0KmhYilFMxyCGzcDb+GmV3+gKEzzpKVecm1AkExUP+zX8eIoDw0tofvUuN5YnlNB0e4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227887; c=relaxed/simple;
	bh=Xp0gASJD6GtOwxnWypWbVHZitfTQbZTo3PTAr5aJFq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C92gmX5tlv/LneWgxisbITh5ZaR1xiFU6+NcjtKIFEp2BQ1f8W0onhjO/yqgimVw7r29HeZyKuidlZCQ88UEyAy7E6MiW6lCQ/cVFnVK+7MV2EIvrs9hq5GW56Gg2hLa81a5yj2gab1O0Vf4FW4xh9HBLCGHrWP/Y0SBZcVcwB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bJ3DnUou; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bJ3DnUou"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 630BB1F000FF;
	Sat, 12 Sep 2026 15:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227886;
	bh=Dgk2JvvQP8B6kKD+OKUNKwCcR3cH4N4/tCYgZgZGoqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bJ3DnUous5BAz2OG64ribI8Yfzkl3wAHLRU6+7kmfb5rC+JlIX/rl7liU/v5npwa/
	 XFdhUYGIWm2Hq0BJQ6PtCUXQIWdEE11A1tJk3oDW35xlkFiHUQ0HvfGK7K4QNYUaVl
	 OYtgQHwcD2PfwcShPWSNozbXRpXL5SjWLHuLdiwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.1 0272/1191] media: usbtv: keep device alive while ALSA card exists
Date: Sat, 12 Sep 2026 08:50:00 +0200
Message-ID: <20260912065554.334242003@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuangpeng Bai <shuangpeng.kernel@gmail.com>

commit fc530fe168bb2b745a93f553ad21fc25fd9cba3d upstream.

The ALSA PCM callbacks store the driver state in pcm->private_data. An
open PCM file can outlive USB disconnect because usbtv_audio_free() uses
snd_card_free_when_closed(). The disconnect path can then drop the V4L2
device reference and free struct usbtv before ALSA releases the substream,
so a later close dereferences freed memory in snd_usbtv_pcm_close().

Take a V4L2 device reference for the ALSA card and drop it from the card
private_free callback. This keeps struct usbtv valid until ALSA has closed
the remaining files and freed the card.

Closes: https://lore.kernel.org/r/178144969601.60470.4852887710381872458@gmail.com
Fixes: 63ddf68de52e ("[media] usbtv: add audio support")
Cc: stable@vger.kernel.org
Signed-off-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/usbtv/usbtv-audio.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/media/usb/usbtv/usbtv-audio.c
+++ b/drivers/media/usb/usbtv/usbtv-audio.c
@@ -317,6 +317,13 @@ static const struct snd_pcm_ops snd_usbt
 	.pointer = snd_usbtv_pointer,
 };
 
+static void usbtv_audio_card_free(struct snd_card *card)
+{
+	struct usbtv *usbtv = card->private_data;
+
+	v4l2_device_put(&usbtv->v4l2_dev);
+}
+
 int usbtv_audio_init(struct usbtv *usbtv)
 {
 	int rv;
@@ -331,6 +338,10 @@ int usbtv_audio_init(struct usbtv *usbtv
 	if (rv < 0)
 		return rv;
 
+	v4l2_device_get(&usbtv->v4l2_dev);
+	card->private_data = usbtv;
+	card->private_free = usbtv_audio_card_free;
+
 	strscpy(card->driver, usbtv->dev->driver->name, sizeof(card->driver));
 	strscpy(card->shortname, "usbtv", sizeof(card->shortname));
 	snprintf(card->longname, sizeof(card->longname),


