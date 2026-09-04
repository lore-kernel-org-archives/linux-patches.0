Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D343B19BC;
	Fri,  4 Sep 2026 05:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500079; cv=none; b=UL2k6ELTYPtV4EbdbpczDMnfIbrDyPNlUfntGEWYpz6V06B3k8UbQ/ThJGSq9mJb2GEyeachro3clAnYmhAM0BYm8hKBHogPGcWD6Dvd4+YoZ63acXiMUDyC/B53f9qI6GFo8uedkOnGXX/wn+cT8wNjkukTrMxeCfMAo3c5rnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500079; c=relaxed/simple;
	bh=EDnWPE+gX5ddaDmj3gk9YiZzrInlbpsFi6BtlCC8jPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SlPnJAWw29ps5Jd4R5csOyr3irgZqCmhBtdXbQ9y1T1cp5WRBe/lrxZ372gtKsPa0wuD2+7h909tBf51volrN/ZU6LPVPvwCRIRHmdDnDoUpJA9g3hDBi1Ns8q7mCfuuHh4J+BqKN3wsl4ci6I9XZINzMKUsxvZPokOg2o0CSoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BhrRdYww; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BhrRdYww"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C30D51F00A3D;
	Fri,  4 Sep 2026 05:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500078;
	bh=3WB1uTo07m+aSra39i0s/hMSu7v3aTcl1UCAb+ZDaz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BhrRdYwwrb4q7EER0wtCDOnc7rsl5UtyBPROYgjzOuFwhGmVynpQKMtmyiuuA1kb/
	 bvo0SLQ6NBnIe4qyt47h79AiB9rkqDx3Bllg0EEqPwbtLnIBV4QUjQNbn70Aj0Tb22
	 RhPsefnpkRgZYPB4oDyLIbV9bLVVamwp17Kma/nM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.2 644/713] ALSA: serial-u16550: Check card index validity at probe
Date: Fri,  4 Sep 2026 07:00:12 +0200
Message-ID: <20260904045818.268928430@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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
@@ -846,6 +846,12 @@ static int snd_serial_probe(struct platf
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


