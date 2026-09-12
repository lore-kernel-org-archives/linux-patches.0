Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7A87331203;
	Sat, 12 Sep 2026 15:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227639; cv=none; b=cvV5sok4VX5y/+G82oi3uzxNtokP7qoGQK84yeRF+WoyKIu2KSskTtmNCaWpr4fLC5PZFQoJqBWjyMi7TYPtTRxonPjsZnwdjMvg/xI4wwuYxeCQrXmTZ1JJXbN1Hu5EP7CMb/TvXve60hJ5bHOT4tbLif1OSufmGTZ+fzJtkhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227639; c=relaxed/simple;
	bh=uFbNFvSpnmZAt0kYrBQAg8gb1mUx47xttlGRNKdwO1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X4XpnxRJBcHLEnvZOXIjT0jtSWEyH/wXd+VLM990wY31ZSnbsYTFCAAIQFk8TfUPBHl9pNEheLPZkFKRlkhR5yAEGKHNGRYgUua9DvTzIBIc1yQbLjXD8ciBf8N0Ub5QiYTJJq4IYHPGuGnf//1JAsNcGsSfpzOLE8c897ltmOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1SSbGwWU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1SSbGwWU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC4731F000FF;
	Sat, 12 Sep 2026 15:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227638;
	bh=5iSPlg64rOQhvaVpOriqKqv9A3deAlrY519nvXVqVlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1SSbGwWUAJ7ER3yyg2G9B1IsTiu3O9s3dXLq8S8kvznvu3J2hKx4TNAaT0O8xoUcj
	 z2k8TDpPU69TrZO9fpJBrlhFoeq2irrSmg7AzXCYCQaUt9UyMBwsJcM0uiOF1NAFe6
	 GfhhBiqhA4ps3Mk7MGOFRmWj/bH7htHsZMA/Fpcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 0221/1191] ALSA: aloop: Check card index validity at probe
Date: Sat, 12 Sep 2026 08:49:09 +0200
Message-ID: <20260912065553.177187300@linuxfoundation.org>
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

commit 819b106a9fd2ef3fd8abf898b9a8e4524eca8f48 upstream.

aloop driver blindly trusts that the given devptr->id value is within
the proper card index range at probe.  It's OK for the devices the
driver itself creates at the module probe time, but if the device is
bound manually via sysfs interface, this could be -1 as "none", and
this leads to OOB access for index[] and other parameters.

Add a sanity check for the card index and warn/correct it if it's a
value out of the range.

Cc: stable@vger.kernel.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260806153227.1460166-2-tiwai@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/drivers/aloop.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/sound/drivers/aloop.c
+++ b/sound/drivers/aloop.c
@@ -1739,6 +1739,12 @@ static int loopback_probe(struct platfor
 	int dev = devptr->id;
 	int err;
 
+	if (dev < 0 || dev >= SNDRV_CARDS) {
+		dev_warn(&devptr->dev,
+			 "Invalid card index %d, using default 0\n", dev);
+		dev = 0;
+	}
+
 	err = snd_devm_card_new(&devptr->dev, index[dev], id[dev], THIS_MODULE,
 				sizeof(struct loopback), &card);
 	if (err < 0)


