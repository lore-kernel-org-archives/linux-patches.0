Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 687863815E1;
	Fri,  4 Sep 2026 05:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500082; cv=none; b=HqJYtZTyMlwfdeNZEC+JaohKTZEwuZbt+9Ii3SDvyL8FDQiJxQ7rKxQxOVe6rHpiB61YFRRWfiiwfmcUyZRf7GXrWPseG2AOyzs/v/NjQDLO98jtns77Q0CwjLOPSlfsMnTlxR2Lgya2JYDjY3I7Vo13rtnGTgE7J+Gol9Zllso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500082; c=relaxed/simple;
	bh=3KAo5Y7ORIRDTRUA+1SwDXsgrop1j4+J+7JTQbzUYK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lgt4msLWmNWrtz79UFkh6FfSltWO+MlLS1ECA+9INGrTh8L0B4BIWkbKlqAJSwrxWD2SQePD1NTu6WDOVthuJDHtmtHhzdGQaJVvokQr2h4JHhr3PVygk1ADm3Yebb8KRrlE0Sp54U7qngFp08HwqZr+DwUgtXmrUuMp3RL72IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S9Hb/d6f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S9Hb/d6f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C3451F00A3E;
	Fri,  4 Sep 2026 05:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500081;
	bh=LC3qfYsBfxDnmxrg4ibZ8Q6F4TXq5X4vNoNnJSjqdfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S9Hb/d6f+hhrcyeGEdW+A8KKMMqnegu9NyU+zGiQg0yNnNc3ss/v1gc3GpSWGMm0X
	 Nn1nGdTvtLlopAfKPpJEN/EGlqL5m0GU9vaMzGFvu7rFheMAYZuRYk7/yo0B6mAkvK
	 ymp8L7NimyK+atT7LptiZAkv4Jrg6p+Z+izmytnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.2 645/713] ALSA: virmidi: Check card index validity at probe
Date: Fri,  4 Sep 2026 07:00:13 +0200
Message-ID: <20260904045818.290589564@linuxfoundation.org>
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

commit b65d5182ecd6b7a24a83d980a0d06e809ef876c5 upstream.

virmidi driver blindly trusts that the given devptr->id value is
within the proper card index range at probe.  It's OK for the devices
the driver itself creates at the module probe time, but if the device
is bound manually via sysfs interface, this could be -1 as "none", and
this leads to OOB access for index[] and other parameters.

Add a sanity check for the card index and warn/correct it if it's a
value out of the range.

Cc: stable@vger.kernel.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260806153227.1460166-5-tiwai@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/drivers/virmidi.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/sound/drivers/virmidi.c
+++ b/sound/drivers/virmidi.c
@@ -75,6 +75,12 @@ static int snd_virmidi_probe(struct plat
 	int idx, err;
 	int dev = devptr->id;
 
+	if (dev < 0 || dev >= SNDRV_CARDS) {
+		dev_warn(&devptr->dev,
+			 "Invalid card index %d, using default 0\n", dev);
+		dev = 0;
+	}
+
 	err = snd_devm_card_new(&devptr->dev, index[dev], id[dev], THIS_MODULE,
 				sizeof(struct snd_card_virmidi), &card);
 	if (err < 0)


