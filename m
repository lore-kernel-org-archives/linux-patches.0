Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454193845D8;
	Sat, 12 Sep 2026 19:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241601; cv=none; b=hIUMJ0EeJ2udqCp82qF14L2mq6wUIq981EURVl19bh8im9Gj/v06sprR6SGRhJuF/sYIzO3+iW3rAkB+zF0NguwJv+90D7B2bCmCQRCaBrFS8sJrzBmZashHGFNhAruO4J+pIAEOJVMIbFeYE/3sQ0f1nAYirIMQikfwzHcL8F0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241601; c=relaxed/simple;
	bh=O3699ny5c/qLm+R4oPD4gjYD8YBHjOxsIV/v/FgNDCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fWuwV4us8xyYYIK93N9XX5eCSxrjBiV8AKM2sDF1uVJdOQv6sA9Y+JiIgVfBg9caQUf3tBMcphQ49L0WKbuC1d8emC2CPeccChKfx7vhVjVlcbGrVDqGhwMJdA+9wrZzndw+uiDiDv1r1f6rkCOJqEumJY3lGCSx6m2LMGMIzjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lXduUCsF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lXduUCsF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 303591F000FF;
	Sat, 12 Sep 2026 19:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241600;
	bh=kr9sXjs+MMeyBART8SC2ykjZu/GDe47UbXXyfz2Bl1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lXduUCsF/HfJMbhF2nTkFSH/4o4fty+wKQhlcxCaPO7K6/zGVPyHJ1dskwgQdHd9f
	 vvx2NNWjlHOH1owqHE07QdC4legoQarvSGMBECul65/Sc5zGDTB8B93Er3sELi40gu
	 k/k9a9OmAPKd4DrGNA7O/xzevSUBY+oWLXNwCIEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 169/798] ALSA: mpu401: Check card index validity at probe
Date: Sat, 12 Sep 2026 08:56:37 +0200
Message-ID: <20260912065520.895323122@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -93,6 +93,12 @@ static int snd_mpu401_probe(struct platf
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


