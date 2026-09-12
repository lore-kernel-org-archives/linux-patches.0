Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D55439FCC5;
	Sat, 12 Sep 2026 18:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237094; cv=none; b=lEL0bT1tjHvduR4HRy99bg5qYTEU7GZT1OcdC5iUlrjyXOAy8q/2bZHxKrXJDQDpN6rXYABKj4aAETlzWwlPiMhctF3lRn/B27K0smZ0yiQC2xY11QSLXnxSTrU2WwBaKcycxgTsFJbmNM98XsAcv0HZ+CAnIA2jtAn+mVt2Ak4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237094; c=relaxed/simple;
	bh=5bocik+ak85UcilmJx6Czeki8y/6b/x90zn73HmWKxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RACMEn99Vc22TbCpJ+iByYIIj+iTHR2Oq1aKgmxSy5JY+Pweqzcn+36/CJUvwvE92ZB7GcF7jBd5fomp4bfMgIWH4N+GXElql6L50cFdiyAPIN+pGvJLp2QkH4OPaGngUWP67TjS3ZhuwXtiuHBeTIa0/PQwLKq9WUWUk9gf0Ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0+C+PGZh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0+C+PGZh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09AE11F000FF;
	Sat, 12 Sep 2026 18:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237093;
	bh=2O1vmsw8+gaMMElZd4IlGrBDLguWfp+L4vshOIj7XL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0+C+PGZh0bXapT7hOn6aFgBv4aO3V+I85aWbFpVyYPM5v29/2o8lNA6wO7NS+tXGG
	 XCe0iZ/UAfbAyVYn/OLGAkNPeyIW/cfHrY5UO0qq9/5rl+7rVMhBiSOAZd2ibz2WLv
	 m4iWlPbIwJCqTKpmiZI9B1080LLhwdjjIETUtvw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 189/935] ALSA: aloop: Check card index validity at probe
Date: Sat, 12 Sep 2026 08:53:39 +0200
Message-ID: <20260912065531.151789701@linuxfoundation.org>
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

commit 819b106a9fd2ef3fd8abf898b9a8e4524eca8f48 upstream.

aloop driver blindly trusts that the given devptr->id value is within
the proper card index range at probe.  It's OK for the devices the
driver itself creates at the module probe time, but if the device is
bound manually via sysfs interface, this could be -1 as "none", and
this leads to OOB access for index[] and other parameters.

Add a sanity check for the card index and warn/correct it if it's a
value out of the range.

Cc: stable@vger.kernel.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260806153227.1460166-2-tiwai@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/drivers/aloop.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/sound/drivers/aloop.c
+++ b/sound/drivers/aloop.c
@@ -1746,6 +1746,12 @@ static int loopback_probe(struct platfor
 	int dev = devptr->id;
 	int err;
 
+	if (dev < 0 || dev >= SNDRV_CARDS) {
+		dev_warn(&devptr->dev,
+			 "Invalid card index %d, using default 0\n", dev);
+		dev = 0;
+	}
+
 	err = snd_devm_card_new(&devptr->dev, index[dev], id[dev], THIS_MODULE,
 				sizeof(struct loopback), &card);
 	if (err < 0)


