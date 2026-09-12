Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E29493264D4;
	Sat, 12 Sep 2026 13:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220937; cv=none; b=ovRNTVm7nwD4bgzLPVLDjiv+uTlEitEWAPFf5NB1/YpMecJiaco0+Py2eFbzIUKB9NFnTHEY/HJuFxfTWJS2wdw4Bz3kTZMCBue3mr2OMmLj81obHUzpN9BsX1gWRobh2JRMur+3b7iMOvyUR6abfHGGHjPvQBWV0euPE+Q1cCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220937; c=relaxed/simple;
	bh=hOG/bQb9+3mO3s0nTCZhvdZIaRkL7yIBUEiAXNm3S8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uav9851f20V4Q04RtuasNPEbQdzkTvZzbdlpToBdRJShhE13t/x5CKkjpac6yy2E24NxCKx/wi8cXnr7PwiYqRwmUdV9K0hAXJBUfBsk/lz1nLxKxIrswaUQjH4mwds5IZwIf5exwPbQpxE2/D24uOkzLTyoPYUru9VcY2fOamA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lzx47FFe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lzx47FFe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B949F1F000FF;
	Sat, 12 Sep 2026 13:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220935;
	bh=oi1xBiAfoWca84zAswGfQ+sJ1igOu6p8fJ72YpRwonA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lzx47FFe1ObLF1RuLm6Uy6Tr9hYMbViATzeNqAIWMes+SZBPp/Zu5zpN92OswbQ15
	 YgTAUfikrPfqjLY9WcSDHr80qlGGnqsgReT12F5i0YnB4lMPEuUHvXOf8HXGL6E9mL
	 /Jxdq6Q8oSPIUMVqS0uyyJg+32+IjZ3DdHQ1uVDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 0280/1424] ALSA: mts64: Check card index validity at probe
Date: Sat, 12 Sep 2026 08:45:12 +0200
Message-ID: <20260912065613.552668817@linuxfoundation.org>
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

commit d18a260720f86a5f8b5fcfefc4ba2e9dd01c10f8 upstream.

Although mts64 driver has a check of the given devptr->id value, it
doesn't check for a negative id, which is often given as "none" or
such value when bound via sysfs.  This may lead to OOB access for
index[] and other parameters.

Add a sanity check for the card index and warn/correct it if it's a
value out of the range.

Cc: stable@vger.kernel.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260806153227.1460166-6-tiwai@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/drivers/mts64.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/sound/drivers/mts64.c
+++ b/sound/drivers/mts64.c
@@ -919,6 +919,12 @@ static int snd_mts64_probe(struct platfo
 	p = platform_get_drvdata(pdev);
 	platform_set_drvdata(pdev, NULL);
 
+	if (dev < 0) {
+		dev_warn(&pdev->dev,
+			 "Invalid card index %d, using default 0\n", dev);
+		dev = 0;
+	}
+
 	if (dev >= SNDRV_CARDS)
 		return -ENODEV;
 	if (!enable[dev]) 


