Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 650612931EE;
	Sat, 12 Sep 2026 15:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227655; cv=none; b=jKaSH2zCfV6qrBGTIQs0083BcK1899vh/nolwqqCJu7XCH/kwKO4vrwUuCmqG+2rsC6ftCeaEeEAtOsuoz7U4478ydWv4CWkNHnt8mmRttR4amjMCgKRlTYAxLamGF1C8iKUIdp5Q30VVlYbIySDoQr6QySutNwExEf1yAqaYC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227655; c=relaxed/simple;
	bh=chhElMLPHCh/6X+0vb/cyky0R03PsZD6+35B5Lhw2vc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=heS/07HQ5JUbH8IyRZDs5WA4vIf4MhbOcu2L+HF1MN7EPrZsp/Cvst8UUVe7OQuK4dHMvULdnegLrcm3InHzWcslJ0mFpt3HRkBqytG3p3MPE0W/guawF6yHnFKu8kExxcvuD5HQuiJwVYSEXjMoZ6EegxKOJQRvdVcBLPM9JGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GG+N6tyY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GG+N6tyY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA6F11F000FF;
	Sat, 12 Sep 2026 15:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227653;
	bh=6jS8oU8e+xiXmq7THGfUAOrDOxXkxwtagXezfFCswLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GG+N6tyYYUHxvOQlBJpFWJYZeglA06PkyeE2+84OCMAn73d7DHumEiKvFV4yhN+O4
	 Y6R/p+A5uFsyQBTVF1OhVoj34CR2uwd1iwOcR0HlKXPWLxKebNQ/GOT85DH8foBiwA
	 qyftWlDftP75MpF0M6+GGLcrc2ku9rhAf0XnKwGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 0224/1191] ALSA: mts64: Check card index validity at probe
Date: Sat, 12 Sep 2026 08:49:12 +0200
Message-ID: <20260912065553.243897813@linuxfoundation.org>
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

commit d18a260720f86a5f8b5fcfefc4ba2e9dd01c10f8 upstream.

Although mts64 driver has a check of the given devptr->id value, it
doesn't check for a negative id, which is often given as "none" or
such value when bound via sysfs.  This may lead to OOB access for
index[] and other parameters.

Add a sanity check for the card index and warn/correct it if it's a
value out of the range.

Cc: stable@vger.kernel.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260806153227.1460166-6-tiwai@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/drivers/mts64.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/sound/drivers/mts64.c
+++ b/sound/drivers/mts64.c
@@ -919,6 +919,12 @@ static int snd_mts64_probe(struct platfo
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


