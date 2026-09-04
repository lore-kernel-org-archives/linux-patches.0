Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7667341A4F8;
	Fri,  4 Sep 2026 06:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788503008; cv=none; b=tnNWPRn36uXecfA5FF8lCWVlCRYKDRk3N3Ksg6Rx3fBcpEPswf+yf698SvdD0KFxEMkOaSt2NayD9FcZTASW9DvFio4+NLcnwOyMsAZqiliuea8qwCNhaqZuFcq5OybRuovu2MleXSiwloLcDfYcQ+dHyDJf9aG2foqVUME6Un4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788503008; c=relaxed/simple;
	bh=EuoVzAuH+eP/I7JMF2PSZUr1tNaXTy5ItkGbTIfssGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WrcaYA70+n57dQbWhl7dwZ2BXUC4yYCsiZkFp6AfAkVKPXAUZwa/1vA9O9hauXNiIT4PXYKH+xN2bQuQ+hVUxZdyMrj+jNX2vHwFWispH6YcBKNvWg5zSsg4efZldLkC7lJT1giXT6NwDLvGqKfkVd02sUien4lwT/62PK1Jy6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EdBWOdl1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EdBWOdl1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D184F1F00A3E;
	Fri,  4 Sep 2026 06:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788503007;
	bh=YbH6UfrKwrfuSktjIjKOWHQ6Tg7cHtH6ljFyOERPDbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EdBWOdl1SRnLxLBT/TiCFJCjOdOtDVZBpcwF59R2MaM5Yh048rRT2QE8plxHG22++
	 mMXygIJGI2fKj/PgpYWdld2/20wwLPAb4DrgtlIutn9d8qUvWMkKQzyN9yJrjb3Wap
	 j0QWyjv8Vy0eYIKvmpLRNtgpT+3fChZxofKd26Tg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 368/403] ALSA: serial-u16550: Check card index validity at probe
Date: Fri,  4 Sep 2026 07:02:51 +0200
Message-ID: <20260904045743.171277166@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -864,6 +864,12 @@ static int snd_serial_probe(struct platf
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


