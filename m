Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A684CCDC7;
	Fri,  4 Sep 2026 05:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500195; cv=none; b=R/fK8o6qB9xBH3+Jh6RTFHJC8uyw2Q2ksMFf+d2Gm81zJQfIWurp4fV3Gmrprma1bBy1soVI5w7Z3Q7PNEfe4BugcygbxcyEG8iZFL78bNu0b/8fv3QcvPar8VIVaXmefEDdyu8pvWbs3lfqkDIsUh3KUEndUNtEsrl/A3ePf/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500195; c=relaxed/simple;
	bh=VAD2R5qQTU5ZFd9UdRILFBRCf1Lb3xxXYkuQIVY8y64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QPvzRAUGlQ/kzN4JPXnQIEMwv6ct9a+LkW2+gIOr/8S+C3mYvZN5s+KoJtoa4ZQDjPY7pl9MFWRylAr6v5AJdO/Twnk8JAwECTym33VIoC10QmC9bId9sNtlSB01wYhG7ynvopNIHiplkiyL9VUgtJXs6QPE+LmTC9HIT7VMBlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mzbu/GZO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mzbu/GZO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E4FA1F00A3D;
	Fri,  4 Sep 2026 05:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500194;
	bh=gRBQE7UN0uGDnxnwpagj8ykHJAnYYo8nBIO3+saReUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mzbu/GZO+zHR3YET19Xx0StteZilZCD+i/gvVUvuiic7sLPNjxrDgr+ky3InbqYAM
	 W9cs6y3KN5an94izvnWBZSxBI22VDRi5p6zSMoPx2MqFBWq7IYvrVhGUfHhJF0zb0Y
	 xeDbTUPLHXe14wfbWqeIXr7lmEbIlgZTH0enphDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.2 641/713] ALSA: mts64: Check card index validity at probe
Date: Fri,  4 Sep 2026 07:00:09 +0200
Message-ID: <20260904045818.199147170@linuxfoundation.org>
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


