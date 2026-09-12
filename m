Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6125E379ED2;
	Sat, 12 Sep 2026 19:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241606; cv=none; b=FQNdFCpzM3uBrlx0EDAheofc/UUT57RL+QMC4/0GVAP05gGVV0bUpliecLthbvnrC3byT0eZsHPeYa4Gxd6YkIhvxEk9bFi/C0ZupkR4j1IUcHOs2zA3ZRGFKOurJWdIOkEoOFTPls8BAo7+w0PTpTU6ygG2uY3RlcdgxaNLO3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241606; c=relaxed/simple;
	bh=ykqVH6cFlCCUSfncLmlDx+s7XrU+Ypc4PltLd2Jqi28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ya4pM7byksv4wO1sXOj2M9tLAvQZ4jBiy3V/W7xy11zjjAq6geBqXRsoXmUrb5cfg0QOZ2DBOX8K3BBBieKbKzd4bmgs5gRT2G3ffMgNwgDuNm+uKAyG9VlJ2ucBgIXxMqnZfiCqM+cdtUZlhBV3lo3Ll+peuVIkN0EeHWw9Bqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GVYGP29V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GVYGP29V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 151041F000FF;
	Sat, 12 Sep 2026 19:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241605;
	bh=tiNSkNmUIPBi/+O/s3Lyop5rVa/wOelaNVh0xfhgvcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GVYGP29VH+RtlTNBjJCDQqz0YLKLmrV04/ttOPz3+M38j3AR0HlsQ7W3Nrq0RLARE
	 t1fDfeHMYUTZJ6JdInFWHDmuk3E4G35peNp4UtiqjAuzcCaRcjJS1oVP1P46ByG08T
	 IEQ3tAZV+3zlMjuc2P7GBpwtkaugmnsQH8i+pZ2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 170/798] ALSA: mts64: Check card index validity at probe
Date: Sat, 12 Sep 2026 08:56:38 +0200
Message-ID: <20260912065520.918005247@linuxfoundation.org>
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
@@ -920,6 +920,12 @@ static int snd_mts64_probe(struct platfo
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


