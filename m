Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A3C1412294;
	Fri,  4 Sep 2026 05:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500164; cv=none; b=gO7Xr8KjBwBd1oaHmFkAGMGCRS61DH6Xak6bvvKORRPYF3dUHE+PgioQIjMZJ5ozlYagIKfkXqmSWzZs+DxvLtcKPsnF6guQR88uETN6mU3zAbr+Bs7GO45OZjLUkq8BNRU2GsfQBn7Yu7IfuRKYYr5b3SAYPnYcpMiZuWmv8aM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500164; c=relaxed/simple;
	bh=hAD/TnDuFdZ4DNIrrrEqPxlD6ze4AU6hLJ092lAPV3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b5GeB/m59adkhsJRsTh673DOabnSI4K5XOjsyFnPydc5IZ8DiDfKSSHD2U4qKQVEpTNa2FAHG/p66BzAZ4CxxDVzj1f40asP6Ibpe7+ECT1620b7U0pd0SJbpavtPyD2y1UL+8MrMc3UJg3DZHwhiU0+PQv/CJSyspua8YDsz4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MTlcw//Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MTlcw//Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D45421F00A3D;
	Fri,  4 Sep 2026 05:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500163;
	bh=E/lf6fSuFftNdQUcwxyD0OdoREEsgTAqwuqyLgZHkWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MTlcw//Zk9iF1l4/hbvj44ppKoy1ZhM4ksT757uajcFL5E21XK1KduTAFyhj91C9s
	 +SnQML+yztCiWQa8ppkOvl6hvQIJmWHj5t/oV5CzaUjrf4ueU8GxEsCsxyJThjtXGq
	 htyQtdtaLLPhluwwZprmC2WXItvLM6lzhuInU3sQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.2 636/713] ALSA: aloop: Check card index validity at probe
Date: Fri,  4 Sep 2026 07:00:04 +0200
Message-ID: <20260904045818.086434860@linuxfoundation.org>
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
@@ -1802,6 +1802,12 @@ static int loopback_probe(struct platfor
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


