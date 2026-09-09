Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF44275AFD;
	Wed,  9 Sep 2026 13:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961670; cv=none; b=aBzIVE8Mzi3QeF/3bAMlx13lFB6beMAq/AotMNxm/Z5z73dDqmCzrR5RfNZpamr+lzahr4qP9hfQ56LypjykyNoByFwyRSuH87zajwy/QUiy4Lbt2iAclp3wYe2CXZdPBUK0/mDsecZ2+9JtP+aV3aek0Qo205575E6NxUur4P0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961670; c=relaxed/simple;
	bh=M7uMxMzYLSaZY+9jjFC6GahXhnjQOe2sxBSxPSMj4a0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L/S4Iao6EbkC2MR6kZBtYIKDl4EN/dpp/W9494QfrPa6I3XWKf6t/llOU/mKtL77AIdWcWGjT0VV4iXgUsD3x7/vs8GccPUiP39Gn7sJsD+DeiNI6oyUjTdX0nkGl7uASWVcAqKyYgGYbWb7VHyXVseEMLd1ZrXBfandapw+PrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GbE/AXkJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GbE/AXkJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 274E61F00A3A;
	Wed,  9 Sep 2026 13:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961669;
	bh=dd7//T+TRdaEPdW2hWiom7c+B7qnh9T9NLuVlQcqIWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GbE/AXkJhS32S3sImh3+XltuwSUcrRp1b0EegNWoH9UnEJ+QCcGqbqrHEPnzSMFYe
	 F0GWAiE6HZONbjKzT3hSPuGPGg5RX24MK+o9/zwg4Bd6xLO0ngsjROtEeb6yomMx7k
	 qwaWXxDt1pz77VLbAjaSiuB3Cb4gXojML8l8mMIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.2 028/556] media: usbtv: keep device alive while ALSA card exists
Date: Wed,  9 Sep 2026 15:35:08 +0200
Message-ID: <20260909134231.496351220@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


