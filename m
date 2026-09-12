Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037542FFDEA;
	Sat, 12 Sep 2026 13:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220957; cv=none; b=b0RAWMSWe+JRj/DTtYUyvNrwhTFJ44VmlzlFpdsp+NfhjB01+ssB6w2vAGOKRlRGR6tvaaVvpONPlaIZArDSbPUNV9y2lc2lGrR1ILT73n8Bq/DxY9Ecgdy6l66seBv2FQEZ/fXx49VVXHBUFus7gjJBU5GMgt9z/mDIr68bdhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220957; c=relaxed/simple;
	bh=PEYOcCALEbxoTGstGCrLDzYq0vdYqPKIBsKACZ+ukwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a/UxOb3mz8HuhySYlEwoO+CK8unm+5l+rAMh3ZtDwjsefjV7+UhHFJCW8omv+sZgOWPKb7VviY6kga/P/1a2Mjn31NOVEHXqiJiT823/XtXpOSZm0MK9YikVBlIlQEOS7e2EamkQV5k4Tq5FfHzwOy0dudPsbT1DNbtOvVjVuCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qw3RdbnS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qw3RdbnS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1D321F000FF;
	Sat, 12 Sep 2026 13:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220955;
	bh=XrWrIo23dy8+hpUc6lOQdvlVNQPTFfLbG+1Mw1l+5nM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qw3RdbnSNcb/qoKHi4BwpE+6cmQDPBxtwT9ISaPVvEN9GBEuzanOFbFBwHsTsFShH
	 lPjCjhJH17k+zosniDumvscdxF0l82tC958TwU3mLKpaPY6fgnN1rzmd6bdf7KyVTa
	 VJcNWwT5ZEXH+aC4LALOvm7bO1NAW8yLp8JZLn+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 0283/1424] ALSA: serial-u16550: Check card index validity at probe
Date: Sat, 12 Sep 2026 08:45:15 +0200
Message-ID: <20260912065613.620473050@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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


