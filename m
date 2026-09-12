Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7083B3C10;
	Sat, 12 Sep 2026 18:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237104; cv=none; b=fAlIARS6PtP4AMKl2JoqQzUpq5v4PNhu0uPsMVUPui85SJ4IPiycR2/HDsVBjSRcaSftmaPKxNLAiDSRDM3eNUMxmKulz1FqcYKZs4iQpqiub54vbK2utsrsz48GlMQS9L6FPjkiJ3aUnNi2RI71mlxREU+vHif+gAy+FCf631k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237104; c=relaxed/simple;
	bh=QvKtYvCTE1ZVVyZircEWwa9Oqiz7yKW01kAH/nxEg0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=myZ4KKHeHmsVKFa38FwQY4KfJLJNPwNm6wTCYQ/rpUgqJn+w0Ta0QE0WeYXlZRTPedeOROMui2XXVu3DhrFkmVRjGEno5pe+zDKyO4F/EV5UdSjQhdDRqsmpFCo3LdHM2r6cvxf4Mn/mIiB4mGRDUgm77oDwT4hhImjzVQN9jdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bk5/rtn+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bk5/rtn+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AA991F000FF;
	Sat, 12 Sep 2026 18:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237103;
	bh=63nCvoJhhJZLEPulsaDyGDuFFiis0VP0BjYp0Nf0lM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bk5/rtn+ZUyEpuk9CtMOZnrkyY4G3S6+DhQhQsekE/KGmlPtkXqugpd0lOLswZd0S
	 c+cc3YFB9V4dM0x7sJFoTCpYb+aFRjxJERuZGBYgErLya/pWWWgSqj6H9FNtQGMHvQ
	 hQovvCRCinIx8T5t8IOXL2Ksm74MCsR/LVIbbGFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 191/935] ALSA: mpu401: Check card index validity at probe
Date: Sat, 12 Sep 2026 08:53:41 +0200
Message-ID: <20260912065531.198606472@linuxfoundation.org>
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


