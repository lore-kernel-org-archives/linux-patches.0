Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5115A37F30B;
	Sat, 12 Sep 2026 19:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241616; cv=none; b=mgcBsYU+KiGUUIK6sVlTidFA0v4d23evpdUOlGhy5UUgTU64Rl239kEB+BH/qFhfIGYV1XOg05cTkNOfFH1Ml2I4q1Xs2J7gXpIkq1P5+FE08kWwgyJ9tCSOX6f1oLYXbDtPco+ieKBuLno1i9roO1yLMMevN2/tOtYSPdZyUJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241616; c=relaxed/simple;
	bh=kSzUTzQz8VA3/2nnIYX3KCiYJ0+pADJym+KFHf68zvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uGyEgp/J8q8I8Eu4FuL/VMDaDdxLPMhMHiQS67911uXpC3cgrIEZrYLL9XcnSIKT1XYsoLbz4CEmQFDcYeFikS7Ki6zIkKtxnOI2r789HSX/7X/GX7cWS4R5WgHY+LNwUPoid3sgZ25iXJCqanWsvUJ8myTAwvk1o2nu+vHl5Uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y1y4/Txv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y1y4/Txv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5706A1F000FF;
	Sat, 12 Sep 2026 19:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241615;
	bh=BU+u9yonxlZTgb/VP278yzLe77Kgm2eLAPgtOPo/lSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y1y4/TxvHmf7+oJDltF/sSTJixkWnXtGM8drWK3IO37XZ9Xr+dmFkdz3MBPersT8N
	 qT8Hh9SavdI7n2Uz7+80prAysDoWoBaBELG124xn1AfCF0CPZMetkI4b8HdndJ3ci3
	 BjG9/aNedJyFcZlgROMc9n1MojCED6zq0JTHguDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 172/798] ALSA: serial-u16550: Check card index validity at probe
Date: Sat, 12 Sep 2026 08:56:40 +0200
Message-ID: <20260912065520.962458882@linuxfoundation.org>
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
@@ -889,6 +889,12 @@ static int snd_serial_probe(struct platf
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


