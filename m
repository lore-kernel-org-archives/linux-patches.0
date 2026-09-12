Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A7DF345EB9;
	Sat, 12 Sep 2026 15:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227663; cv=none; b=exNHJPdE3e8fv4jgkHUhEooYVEy26MWKXHpj7bGWN8eAEVsAey1cNS85ouzAhgX0SBSrJdBrc9yG5QIb+hxMQDgxCSRowhHP2sFxx4DfgP385ClvhOFbzw0ru1B8HGUDqFYSOkqltXELlaKqN/JyBAQEPzaZXK5k5R1hHCL+TF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227663; c=relaxed/simple;
	bh=pXHX8zOtJ27jPuBMu4rGI6zZdiKGgxm2dDu2O5QPAR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ooonhqMWC2F33a3r4Hvu2VMQ7rQaXxQ6TlM20kbUB8MI6SFRE3n72IYHcDjbLW39u7dgkqQ7W7efaT121nHW1qTXiDXdu/+FvbuKyqFOth3UATA1PIbolIHK/Dy9j7DKEVJcBlOjId5aE7rxFSBUJ5YKxwJXfbMlwkIk0pNJAr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X/VG506D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X/VG506D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EAE41F000FF;
	Sat, 12 Sep 2026 15:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227662;
	bh=B2Wa7tU0lYV1YYi5h6zluWOwnZDkBchXU8BvAdt5Pck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X/VG506D/fBz6RU5GoiKjNwCDAC0lY7/21eYW3zmuGql0+Pbaz7p0ij9TUh7wdg78
	 9gLu/Pygi+ZUnfdnP20x5HADFRY279aPWlRLeANa8yViHvitqnuly47x1Ah1q4s6p7
	 s+tRrWN5V+IjNIoTY6INb+IyG7U0awtFMUYReAVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 0226/1191] ALSA: portman2x4: Check card index validity at probe
Date: Sat, 12 Sep 2026 08:49:14 +0200
Message-ID: <20260912065553.287251967@linuxfoundation.org>
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
@@ -715,6 +715,12 @@ static int snd_portman_probe(struct plat
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


