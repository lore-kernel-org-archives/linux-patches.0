Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D6131E106;
	Sat, 12 Sep 2026 13:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220932; cv=none; b=jprcRvhkW692qAOTJAQsInlAp4OWhrpaFUl/d0lkoMfzGw/iaVla6pUKlNXRtC8wlVTJgF62134a9jWF3Vm930YujTdm1p3r00kO59cHeogbnhwFW+Qlz9+LZMvpYxAIX0Kv/m3xVVmm3lW+Mp/Oa2bdiiMjP9sRRq5g5hA7oYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220932; c=relaxed/simple;
	bh=0Fh84jt2nvTtmVkUXXpJREszRGMSxFZV+MLN/ZaRsos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rYm4jH0TYBfTqjupuFkm6CquL/Kcz5SnmuW43qOI8bl12qKXNnhwuIGNdysCAPqv2KRXUR8kIl0dtzNzXxZTRlhIuLg/y/nVRddtppiZaOiOnaiGpHc5T0w4L3bZzn4kdg0SK8tK01sNidwbwi8zTT01XS7OV+kJ8GQY60W+WDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZlRWP788; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZlRWP788"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF6531F000FF;
	Sat, 12 Sep 2026 13:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220930;
	bh=MBtLH+3dTkS9vT8iTHpuskFZszllSguuf/6sntJnx7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZlRWP7887GPuWzrYs1o1UHTOFS2NWiV5hppHONOQdS79MkpBCzvyrm08Y/N1iMZfo
	 j9/Gvmw/Y3asgfITMtJ9moTnylPZR/VqPHPx+N04SIkPdDHM0NWVGL0SF0Suq9wMjV
	 USqxO1H6cwZ3kSPrsvw4rPqnTVe4ai897L4eov8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 0279/1424] ALSA: mpu401: Check card index validity at probe
Date: Sat, 12 Sep 2026 08:45:11 +0200
Message-ID: <20260912065613.529661463@linuxfoundation.org>
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


