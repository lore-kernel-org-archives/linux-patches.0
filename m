Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2FCC2D0C94;
	Sat, 12 Sep 2026 19:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241824; cv=none; b=OGyCDc+w0XJtLBXRxxjY7B8/QNRQhCwLA4HRGy+g+RFixUDNyZoPwpYFWeyzTJtSon0SMAWiAlI90c5DEbDNNrQ6XLKtR0/vb/9YzPGz5lBpnXDOrMLY8G9QqVzB0YeJnEBxAqCkNwGptiVJB8wcAbt9s0OLAD+yqaxqKGJyBu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241824; c=relaxed/simple;
	bh=MQPr45Il4qKAg9pGlpX0bVDBRX+sWWkyViXqF4YrEQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ImzhlCgSg7naf4jy/2MuxpvlgGaL7EQ/lJCPDZdScMtE7ywg+wpkNkgGhne1+4JGg6UdRNIOGe+MPY9pmUoVQnDbb7ro3ETQZDmkcdMkdsSLV394qcfVlx/wTRrdeFmYgKH5jiS97R7kJZWaW1DEL1n100ruMGQW+DW5R6eUiOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FwnhvT/G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FwnhvT/G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADC041F000FF;
	Sat, 12 Sep 2026 19:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241822;
	bh=ibUss5tKJ+FAumImcHS8ADRwTejH3ei0dBKlk2e5JQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FwnhvT/GVI482XZb63nEQG6AAGtbgr/lSw+jm5vQ7Tac/KE1S3ELwhSKyncPoEQY9
	 m199rabnFlcAyc3TsaZo3bHQWK45Y8N4E51OEmZ38HN7ySz4SvMuINQty8nVqUe+Kh
	 0BZ/f3Hv1MTuWNuO5GbPuzAcCG5zr99qB8sXRWVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.10 215/798] media: usbtv: keep device alive while ALSA card exists
Date: Sat, 12 Sep 2026 08:57:23 +0200
Message-ID: <20260912065522.041948334@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


