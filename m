Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D564A400DE8;
	Fri,  4 Sep 2026 06:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501798; cv=none; b=nAINf1RDTLmjCtnHBHz1lyckE7d5onmemlEDz985x+YF3vAr41h09aLVRE4el8znivz9aRJG3mXYoM22xmnOJpOXTiMTP9QWqqoCv8VC0ZeXi21mLFa8viWM/KrieX4BujDn/BYdpmm1w9pFAcK6BBy2PaMj8WVoOiNHQvbY8Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501798; c=relaxed/simple;
	bh=mP8ldL/SvD/jOs7XIuT+AZpWWMsagKx3ITohFQ2qOVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fAYSYDYSCAL6zYL1jIgecUidcsNH3ErIwDnttzzQ0bEbjetcE2/e+FKpg4iWGqJbOFnjG/Ew6ja4IyCq2Se1i1I5WTKl0cyDbaczlhvvHjfqo4S4LOUxU9k3okDBS6u9lWFRsOYUokmcjI1Ep3AEo6e7D/2YDw9HNSBSfskcrw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T0F2XYFu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T0F2XYFu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33C4E1F00A3E;
	Fri,  4 Sep 2026 06:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501797;
	bh=rJs5OX2q3EP1LkqQyjqKDFIZeMtq5QYfF5IzqeMZc6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T0F2XYFu2k1yk5PEO8sEk2iFP+zr5uNqtll/luf924jGwb38MBMk14Gq07zSUJVrO
	 Zhc2/yoKSmj3cYLQJYL4QSXAORFUJ9FECnhvfb5hCO48dIZNl++DfFCDq9ldmSoUrz
	 Rk3mWOZbiLr6SUepXaCLnTZw5YpOTOFUWBvyt1DQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 493/552] ALSA: portman2x4: Check card index validity at probe
Date: Fri,  4 Sep 2026 07:00:50 +0200
Message-ID: <20260904045801.836684159@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 3690ef20469d5959378260e2752f2314a2572913 upstream.

Although portman2x4 driver has a check of the given devptr->id value,
it doesn't check for a negative id, which is often given as "none" or
such value when bound via sysfs.  This may lead to OOB access for
index[] and other parameters.

Add a sanity check for the card index and warn/correct it if it's a
value out of the range.

Cc: stable@vger.kernel.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260806153227.1460166-7-tiwai@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/drivers/portman2x4.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/sound/drivers/portman2x4.c
+++ b/sound/drivers/portman2x4.c
@@ -697,6 +697,12 @@ static int snd_portman_probe(struct plat
 	p = platform_get_drvdata(pdev);
 	platform_set_drvdata(pdev, NULL);
 
+	if (dev < 0) {
+		dev_warn(&pdev->dev,
+			 "Invalid card index %d, using default 0\n", dev);
+		dev = 0;
+	}
+
 	if (dev >= SNDRV_CARDS)
 		return -ENODEV;
 	if (!enable[dev]) 


