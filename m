Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0F12F260C;
	Sat, 12 Sep 2026 18:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237124; cv=none; b=PR/TEfVC22bSiSbhO/Pw7dwfpNCZBUrHY78n10mOH42KRGLgbkCvx+YgwaYlq5ZLq520t9PYML0CZzB9xGp/aW8q/SZiCsjeaH6ORFdluPSCrZS+cN+06BOlG/CmuYObVfJ1JL/d4lTKQcSHRJtmomjfMDtE6WFddRz2+8xEmO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237124; c=relaxed/simple;
	bh=FANH+TOSyBI4/cKP0kwJVxKlPIAfHdi72jz+9zpfgVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qnlYrB0vD/+c5zPD2bhruDQ6/X5lxZhpd5FT0OdTMRqSWaC5PI4Bgl0rGOXpQaIrtyh5pcOrwZhLNIR0TlIl+hUuY2avDftZWZY4/hpu2aXMyaCCbcA5HIVvr3q7cFXFjGr+cIgjYvj1sYNvDP8zjeE3kERkLgtkVGR2eSig7Ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mCukOZ1e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mCukOZ1e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 234E91F000FF;
	Sat, 12 Sep 2026 18:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237123;
	bh=NZJoFGPTJbprBdQ95pQs3eRAp1TcAk9M0r7R/9JwOfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mCukOZ1evQveKAVFyUu8UoU/Aw/7xFxK6pRKpqFmwJzUtv0c20RIzwhHTnTPsLXID
	 oF27HnB56SSyfqsTm17GSytdgMUkz5upLp5WryovyJzJvVVcvN9E0ysP1n2HQ5rFta
	 CmVQwdkbFvdtfqh+OvWL+kEtledXHxaASdWvWWF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 195/935] ALSA: serial-u16550: Check card index validity at probe
Date: Sat, 12 Sep 2026 08:53:45 +0200
Message-ID: <20260912065531.288220812@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


