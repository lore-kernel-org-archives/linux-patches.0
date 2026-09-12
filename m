Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD6E331203;
	Sat, 12 Sep 2026 15:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227668; cv=none; b=fCmG7QJLXRS/C7PcZFKFThbAPpO6ot7F2ZrfaXp5o/l1vxVjRonnzjr/tqSZGtInqmhzZn8u3PqdRlt+SUiDYsHm2lcOLqztEJ5bl9sj8qr0Tu261uTnMjQrCMkDXerE/nyEQVb4jyBKPaWaCKLk4zEfi/3IeWP4DoqZAR/nj9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227668; c=relaxed/simple;
	bh=h1CzZYHpRYqC5sgXb6STUmXb+gFq11zs3f2BJ+DZ/HI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PQ0GXeMsodjRqmfA4MN5P16xQQiFaq7PjKwQzE40UKUaz/RWQoZbagBalbd6JIULdyFC+8QFK204U02WpGaxNkeDGTdPqOzT4iaViPm1y9Tc66fkGWETe4DM2BwAc9JsnGaNpF7+W6x/+Q7TJ26+TDz4bwTPxSd1D/hdOrcpbYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=azuuDFHf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="azuuDFHf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0854B1F000FF;
	Sat, 12 Sep 2026 15:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227667;
	bh=jwBFmEsDX8NkV2HUVEkhV9nRXILLFlX6yYtn5poDsdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=azuuDFHfAY7OBblxqt4yuqI1viz7uV1emuLu06vujPoBANxclFzp8BhGxDtRTw3Gi
	 nF2++R6BhDv8wcC8mrbXRwvgEeUOMQlQX9Z6nGgbUO1ppyLpso753WJOcCObPrpiJm
	 HF+XkVChqKQZmyxi2aTNHJivLUId92wSqlaN8APo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 0227/1191] ALSA: serial-u16550: Check card index validity at probe
Date: Sat, 12 Sep 2026 08:49:15 +0200
Message-ID: <20260912065553.309078990@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

commit e0fb960b227fcdebe22e4f26c9486d60943c0424 upstream.

serial-u16550 driver blindly trusts that the given devptr->id value is
within the proper card index range at probe.  It's OK for the devices
the driver itself creates at the module probe time, but if the device
is bound manually via sysfs interface, this could be -1 as "none", and
this leads to OOB access for index[] and other parameters.

Add a sanity check for the card index and warn/correct it if it's a
value out of the range.

Cc: stable@vger.kernel.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260806153227.1460166-4-tiwai@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/drivers/serial-u16550.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/sound/drivers/serial-u16550.c
+++ b/sound/drivers/serial-u16550.c
@@ -863,6 +863,12 @@ static int snd_serial_probe(struct platf
 	int err;
 	int dev = devptr->id;
 
+	if (dev < 0 || dev >= SNDRV_CARDS) {
+		dev_warn(&devptr->dev,
+			 "Invalid card index %d, using default 0\n", dev);
+		dev = 0;
+	}
+
 	switch (adaptor[dev]) {
 	case SNDRV_SERIAL_SOUNDCANVAS:
 		ins[dev] = 1;


