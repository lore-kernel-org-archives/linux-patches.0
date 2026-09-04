Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B863815E1;
	Fri,  4 Sep 2026 05:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500192; cv=none; b=DsxtcopcycVeGazW3LQLSSqwDr8Hl6ACd+pboVPEsdkbJO4oO28+cgrwyfXiwE9ADXwwljVzurKrRS6+7jzWwU6KipcXDWci2UOb92Ff2/n9GYuS7gjx8uegktk4joMkGntxGe9BHuVG6nkJZTNfgE8dkzoCtmk5jj2UEcs2wmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500192; c=relaxed/simple;
	bh=lHsvZVmMd0R5A87pe5SbBTPIUN+sxZJwGr1qhUaM0MM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ortNrWWjb52AhYZy3zOn1u+0VKYy8tmPzlwYT30li5WmL2MJGzkVk/rlifJUj+tPMHRlLQCEojVnScYtt4ZyjvzQbbs+4jB0Uv5rf+PZZtA5Gp4XmgN8SunqnNp7aJYWPnJCYkoMhG/WkwiKc9rwFHmgsOiHAQCTiZq48b/Fpog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wss+WSi7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wss+WSi7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 391CB1F00A3D;
	Fri,  4 Sep 2026 05:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500191;
	bh=4S18ZXF2EU4O84VFzS8qbKik73Sv3kfLsbluuiKIWbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wss+WSi7LQfP6Vt1ZjXQj4ynl92PDcR2tAOfh3kondr2MJwxeCsUPVXhEP/xs4tTd
	 iIZbOPr5zY532M+KFIEsDaynXKQ75AA2LAAY2KVu51YL9VEDKu2HwR0PFGwal0bfqB
	 bRoS3y0SRUeAR9DYsSDpS/aBt/JkTW1hCgYk7Q+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.2 640/713] ALSA: mpu401: Check card index validity at probe
Date: Fri,  4 Sep 2026 07:00:08 +0200
Message-ID: <20260904045818.177369312@linuxfoundation.org>
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


