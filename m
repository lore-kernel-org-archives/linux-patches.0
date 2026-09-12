Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56279331203;
	Sat, 12 Sep 2026 15:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227650; cv=none; b=GzRdOPHsbRBKxNUG7qVMrHmUdhvmVQe8OZzsQKTO+aldZFvsTjYugfulgtQi4GsH6M1zu+N8HJfCTSJkcz+vkY9/QrFh9pZ01fea0oAlJo4hNX97FprvoX/t8eUYzOA4RhqS+B27sX2mQ/gl4TFkCdhIm53VfOte/q31Ry1uBKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227650; c=relaxed/simple;
	bh=Wnb+21Nq+tfHqTXvyR0B5ay+dLGKkkdKImXe8Rbfz3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mW2Kw5m8YJfUIwLFQdBY1MjSmxwVSbwW1P3y2rywByKL1aBmwBFrHzDZk7LDd1GNlRkKoPQHAe1GJp3kxjrM7C4Bj1ccpdkue8+DbDJFq6MXuI3PRvtIEQXpf5jwI+LzOrFh2x9bTCqjj+4/wXcCM6gfCSavnr8btFagfC964Fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FVZ2mB0j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FVZ2mB0j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F03241F00893;
	Sat, 12 Sep 2026 15:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227648;
	bh=dM0Q1Qg5IazQ2FNu+zVVk7Gd+6nkA6XWKzXsaV3Cf+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FVZ2mB0j8bDa4Ksjo7HtPyCXfu/ki1Baz8+cTBxaBMlXvA2sTwJUSBbbOW9AMejgo
	 NGnmSuUw17JU7JsX2jCWB7Ri5NsepCmjXVMQya/QmE8c6Nnk8GLM7Ds0V9XT/Bj9oJ
	 ULXLfwIpr/fVU1nx5ThXl43LW3V8a5Fw2X3NcfDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 0223/1191] ALSA: mpu401: Check card index validity at probe
Date: Sat, 12 Sep 2026 08:49:11 +0200
Message-ID: <20260912065553.220934625@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit f7dcecb92ed192ff5fcf842918fb1aaea84b5bdd upstream.

mpu401 driver blindly trusts that the given devptr->id value is within
the proper card index range at probe.  It's OK for the devices the
driver itself creates at the module probe time, but if the device is
bound manually via sysfs interface, this could be -1 as "none", and
this leads to OOB access for index[] and other parameters.

Add a sanity check for the card index and warn/correct it if it's a
value out of the range.

Cc: stable@vger.kernel.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260806153227.1460166-3-tiwai@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/drivers/mpu401/mpu401.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/sound/drivers/mpu401/mpu401.c
+++ b/sound/drivers/mpu401/mpu401.c
@@ -89,6 +89,12 @@ static int snd_mpu401_probe(struct platf
 	int err;
 	struct snd_card *card;
 
+	if (dev < 0 || dev >= SNDRV_CARDS) {
+		dev_warn(&devptr->dev,
+			 "Invalid card index %d, using default 0\n", dev);
+		dev = 0;
+	}
+
 	if (port[dev] == SNDRV_AUTO_PORT) {
 		snd_printk(KERN_ERR "specify port\n");
 		return -EINVAL;


