Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BDB2378838;
	Fri,  4 Sep 2026 06:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501793; cv=none; b=g1FBP1/jmuXXtO1Yr09hTJhDlgPRVQFwIqPOuuyO2NGHR14EVkXBxg5laD6P33n4l8RRN9ul3g+xtta6/a8oKn0uhmZngs05pcROmXCmy846iNQ1J4w/fBPkZUa4ZE3ioii1sIJHa/5quFd92RMK4N/4piY/jHSW0YKZlZleZIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501793; c=relaxed/simple;
	bh=x/qBFy62N68FSNtLWNjgf8uElZ3ZqxPaQ1swKzTsaOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ql8JQ/reDPV2EToQ9PJ6GKOrgJjzJ2LC4Oc97PrcEdjdXcNuCw4XskDgcF8X4uHHRqRfo2rZKCrhg+Xltl3V12RsfWmZIu5HOHmR0jpZAVyGL37z3I6mIETU+mpqkNDRm4Vy4Wke1Y8u3Sjnq5jFzvPxVobZCK3hK7A2i+bqj5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qt1ixB5/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qt1ixB5/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BF1D1F00A3D;
	Fri,  4 Sep 2026 06:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501792;
	bh=KM2kfkaX7C54krvi79N3fLX0zF8wVj32uankVc/kSCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qt1ixB5/7Tv7w576+cQntzEXhueWbjKv8Tb/8Th5TYDf+5R8Zozmu0oTartHW7KYj
	 1nFCs2adDUBNAvVO81mfRdaHbQ4HqWPIpkdfThEY7W/eRR0mJDrjQDMjZti4tNdrKY
	 +pOEC7vrxMRnPfLR/CvRfo7eh9w7nnmzLl9SHIoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 491/552] ALSA: mts64: Check card index validity at probe
Date: Fri,  4 Sep 2026 07:00:48 +0200
Message-ID: <20260904045801.794275142@linuxfoundation.org>
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
@@ -900,6 +900,12 @@ static int snd_mts64_probe(struct platfo
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


