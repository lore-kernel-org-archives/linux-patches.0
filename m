Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFBE6418348;
	Fri,  4 Sep 2026 06:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788503020; cv=none; b=tYSA/eyb6YofvCozEwLGZdjMJBMhYYxjm/apCHBAjrZrQGYiZE6P9sRKji6jJIHE+f7FfnZ0pdf2yVqMi0mxfvd6dBTkNACpIOrB9sFU3VdQ8XQ++Rd5cdutyc4cXjsqfzgz5/rOE/D+uRT6YSiVeIG1ClgyVDT6fxjzldth8I8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788503020; c=relaxed/simple;
	bh=ggYho2v6Vi7S9IqpO9L1zxzjMZRclyVc+ZgH7Tlyg/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZfYGlta5jPzMrrCe7TFJN2WBBVHZap15oDiE/tWzbnA3+OS6bU9BpHqiOCYz/IMwtLpDJCA1hCBFzA3Nu/XjLwarGUuMeTKTqxwbe04OA3T7fd0oTz6+lSBkL++5INwJRIFq8gYk3BR0hEQhnY0io/2Ydd0lHUtKLOy9nqFalbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j3tA5/I5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j3tA5/I5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 545041F00A3E;
	Fri,  4 Sep 2026 06:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788503018;
	bh=Vwhe2JYT/N4RlkyGot/kZhgGOvf5y6VsagoGcvUhBvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j3tA5/I5M//BRPGniS7OwhMMrV0I8mLPVCrodBO9HgLonkcdxEo5+yJFQ9prZVqGJ
	 +0zWYC2bRAQZ3G//sdQIAJXEAXBJf4kXuIPXCuuHUMT78ujjrYAODl5k153wX89jZ0
	 25OtvMXL0eF9l0OkCw+Nbts8ipf365FQx05MHyNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 362/403] ALSA: aloop: Check card index validity at probe
Date: Fri,  4 Sep 2026 07:02:45 +0200
Message-ID: <20260904045743.042304377@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1822,6 +1822,12 @@ static int loopback_probe(struct platfor
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


