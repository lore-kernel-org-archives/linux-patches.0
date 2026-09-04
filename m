Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA7E3410D36;
	Fri,  4 Sep 2026 06:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501801; cv=none; b=Vjv3byRewJunS8YAhw2UzxafNmJQQgsAEYKcc8lc330/ITJsQYcbH/104O2+MKmUTn8nmcjQTcXNPCbX/LSEdu4Y7gLiWJpmu9+5ooyQiEmAQcqwf+0n2PEkwvQQztAgJmrFEJWaqnExIthR5Jy1GL31SQ6vV8rr2qANcj5Yxpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501801; c=relaxed/simple;
	bh=lzM7BBm8TuZ2uZDWOZDtNxEouGdE/E7AqchtdexsKpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LQYwOgnkZuuG0z5UVnHFS3TGN0VkazcbwF4f6pcI718zhqE/ilWTKuL91aC+FFtQ2zzSIx2JzQjf1C7fKZgwmaXB/7MMuTqe6+aJ74DV/zPAqqpx7bysT0nSetCEWBawb/C5hVJQ/3zJ5IyuCibBuUbSSH9UoKoKbqwf7WuxICY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rLzd0G/j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rLzd0G/j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 174C41F00A3D;
	Fri,  4 Sep 2026 06:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501800;
	bh=9xKSZtJ4Er8HAzhhbvEJfdudbHiWOPE6FnVLYMojzrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rLzd0G/jhm0c9Dv6FcrM6QQMjBFqxEYMndC1AuvKawqLfWZ58NBkiIHjOJxJe3k54
	 da3j0O9yhSBrYtXzy/bAa4y9v3gMUyHjWEYHdqDmWR0B8ld6q2OMkzL5pvWEF/T6Qn
	 Vc6CxTic+xEcfLvxuDdr3RXZSG+nuO1SGxQZrnOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 494/552] ALSA: serial-u16550: Check card index validity at probe
Date: Fri,  4 Sep 2026 07:00:51 +0200
Message-ID: <20260904045801.858489959@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


