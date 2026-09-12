Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1D5F327204;
	Sat, 12 Sep 2026 13:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220922; cv=none; b=GBSedEerSKpKQwYqAzZ1JXwDpqjfqFABRlfJ7+cJJtEMFP2IJEcL3Gadurg6118O+MTLovCMfOuTZOQ5ZH8aKwpxLc/M9ffIAxqMtrzV8+Pho3OBb0aYolWGbMdFEZVufedRjhBpqqHgOql8muMiidPIpe49qh1M9rbbKvnhb/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220922; c=relaxed/simple;
	bh=IogfDEE3yeYs9u9qybl/wV7RvfOWwI9as7X+2NVmpWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gIt71AZv0QAtOPjaM6gDjIGGd5Gk4xyA8yTCQYInxcD2nF4b3PMw+MExAqhPY67oRL45kzyufVvfnvLiW2n8X3fW4dcNQKBq17YRFd6oorXa4HSz6Yx2y0INjF2q8m3skAMleUnK5T9TPw8LAafHdwbw0pV1q4CjFnwCtj3ebLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yJq69APk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yJq69APk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E7D21F00893;
	Sat, 12 Sep 2026 13:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220921;
	bh=+KFqXLuZwEtu/0MQOV2bvLpqSEgFO+ZI6mMC0Byb9pA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yJq69APkN7Q6nnfnCkJToupK0t21zg6R+yyUaOuzkDWU+zTMo3SNjtKNdTTACWcXD
	 UyvSrdTbQT9E5D3ipChXgWExn0UMSlCWBOIkK+9HWokrsqo2QbpcipK8gyPSl9X+xN
	 CBMlzPxy7T5UiSEogAuqHpWv6aKYRjsr+cJDqFhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 0277/1424] ALSA: aloop: Check card index validity at probe
Date: Sat, 12 Sep 2026 08:45:09 +0200
Message-ID: <20260912065613.483986205@linuxfoundation.org>
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
@@ -1739,6 +1739,12 @@ static int loopback_probe(struct platfor
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


