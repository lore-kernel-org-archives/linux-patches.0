Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1585C2FFDEA;
	Sat, 12 Sep 2026 13:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220952; cv=none; b=pEABgVthu/b+LSM9W3G7joYhkVRWxUpk2OIOXm7sRmvpo2NNOUeSq2p5llRB78d862vO8sanPRjl/8HVz3eKUiGJRc4N8UqUlXvm+xQq3GgWrRBIsnokvC4lWlQbnQ7oQ1HObd3GYAHJZblCFWH5ksxrhZHCVo5qttbiJMp367U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220952; c=relaxed/simple;
	bh=s2/0dqXYGSWSvcLm1nprckOnv8gEs2Y8S393TlTU36g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WXnYEp3BVT1CqKYptdUTs1vsjT87o9XhbZUc4EQVg7653p4LAFIwRKhinSVXIAN5BNRHX5PnYAN7G91lz+ApUW8n8EIQzlDsWyQZ+gf+I9dRkwtb3FpoaWLuBQfkhxsJK/hhZbdt9A2bHusVuJ23yLZv90WZfc06lMfErSQa9AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VN9DUpsf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VN9DUpsf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AECD1F000FF;
	Sat, 12 Sep 2026 13:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220950;
	bh=naPYaS8piSBbdRrDybtUYKc1xHz/esJBTdTLdeG+bGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VN9DUpsfL0XUS60eMwHUKL5ZA9Od+elStU3JvRFU87jfIkmoyU4h2WGwcTdbyc2ww
	 t9WklikCCS9mbAJV83liJy/Hicomm+skQiwhXE1ZlzOfR1JD+soYcTC7JUQyNIWvFa
	 wrqx5L9/AdjZYfQxD/LFBlUUiHNU8JuxEYTibq4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 0282/1424] ALSA: portman2x4: Check card index validity at probe
Date: Sat, 12 Sep 2026 08:45:14 +0200
Message-ID: <20260912065613.598305877@linuxfoundation.org>
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
@@ -705,6 +705,12 @@ static int snd_portman_probe(struct plat
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


