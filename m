Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE44320CD3;
	Sat, 12 Sep 2026 13:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220961; cv=none; b=LL4yZIP/8oODBSwI3Z0Een3+1gU+CG8f0URszN4vtQOsdd/g3s9pbQ41ua2s3DofcMtclxJOjmciaQLhONf8b1tRxkTgkfh8uDTr7IO0jre8d6Nh/XLsYBr1OvdMv+BGiNKZK2H7ZXASaZRdnG7XepIiEBCkCfoAlPfRcuioSf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220961; c=relaxed/simple;
	bh=DeuEz7OSmCoSLMgjojTRaOJkybCN5HzyBmhSbxzZoCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tJbHW6u1M0OtoY3Nn4C2rRcgP5IWFFj++36jFQOEbhhbpaQy9RXKvOoz9D2X+e5GSLZds8nPM0qdUfziznYsUbAC7PmBO6pIfMrgZEm+xjOg+dItrJCUow7/cX1hU09p8jjagTD5Vt0RycYaMNimr5D3ARai458ehMaUAdya2gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aRiaSHut; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aRiaSHut"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF5891F000FF;
	Sat, 12 Sep 2026 13:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220960;
	bh=h99OBfB3p54uFqtKo8JApSkhsAAo/zGaFfLqUGvsCXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aRiaSHutapTT715tbhnmDzlQy3ushH1YON8weR2XRRLmdBqFSI2b8zbzlBZpHTTXi
	 r1jaCcLV8USsj4mQ9uf8iAWOPX5pe6i4SBDf8SA96wIhYHY4QCXk/8TE6triDZyl0+
	 axEL1d6KjVWjDTaGEbdpEU4a/M1v1O/1PJpUmyus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 0284/1424] ALSA: virmidi: Check card index validity at probe
Date: Sat, 12 Sep 2026 08:45:16 +0200
Message-ID: <20260912065613.642836337@linuxfoundation.org>
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


