Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D400041D22E;
	Fri,  4 Sep 2026 06:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502934; cv=none; b=douZ94Se5drFxZ1drGkfohJ+Y+Rr9woEMban6CqsYTx9vroPKSqKxv8vGn4OVv7xulM3gZklSkcrGE2EnDQlu3+r/ujCGdsND2cHpplIRxPHONf0/FgRS+ZK2qDuFf3+0d7WJXooq8RlbARQoITXYBoxpQoApAcRRxvSuLVPuD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502934; c=relaxed/simple;
	bh=E6tCuyRc0dAYhxPB/rwJGQX9RCLmD0EwnPRIPl+0oOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WgKi2oGuF7oea6a2+zBzNMnTtkU1v0z57hCRewIZ8RIkrskTNN+OmlVdwebPjMiSjE58TarAtmtMkcIcDawC4HSfyQkY3SSE7Zh6wXXNhTkCu3EqvYpGKvLLQ9o8iyqBad5jN0sB5C6Eu/SvD0soqSoag+GBvB6mIxrbm+lnm+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nzTDL0hx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nzTDL0hx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6B7B1F00A3D;
	Fri,  4 Sep 2026 06:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502933;
	bh=QTaqhRkacVDv8U2lJgazVVf6eOMvTgsPU4Jx3JfGu5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nzTDL0hxeKQu5f6qKgnkCSZx+3qRh7Bw0Jm9Kc8Vfyt9SQA8QXdSfBY52ieqI1Kgd
	 0Tmx5a3RMLN2VYsGsmglP9HX9QGvUW9wzdFRpjyjmQ/vqEVW46k61DHgRHQP6WON0P
	 X75R4lugYQYfgiEvrjlmtFZkekg7OTLdyCk5FePE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 364/403] ALSA: mpu401: Check card index validity at probe
Date: Fri,  4 Sep 2026 07:02:47 +0200
Message-ID: <20260904045743.085808146@linuxfoundation.org>
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
 		dev_err(&devptr->dev, "specify port\n");
 		return -EINVAL;


