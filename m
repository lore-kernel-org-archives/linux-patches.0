Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF15346FC3;
	Fri,  4 Sep 2026 06:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501679; cv=none; b=Y84GNQzLoiiEZMDwm3At9/wpZVUTTCDHbnZjbW8tqGr7X+YDLKqZCLVKA/NUk4iqkjX4hLNtJZp3dKfBuS+VVXIHRz6zGx6c2fX3rHdMUoDiPCmu184HaNmixRA36aI12f5qZ3yyKtAfJuJPt+f3jYTZEL9lMIGdeIuZj5a7YRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501679; c=relaxed/simple;
	bh=iTqy2lYOUKbbrr6HVvCjWYTZkI11tnCUKehDpm1e8ck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nMolLkco1sA0BN0yCIW6YU5cglI/PaiReMuwiZHG6W9S1rJnJeEawXibS7tpPT0JWPKbZKTPCTSrRWR82pXsn6CH4FDuccu/HTM2gYtZvTHaMLtVzXFb471+EoHG0oQIGGum5CI858gSaJYZ3yheJo/pTxWEtIb2XUjAZnxGKLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ExL015Qr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ExL015Qr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B76481F00A3D;
	Fri,  4 Sep 2026 06:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501678;
	bh=AV+dcKL2Ay1F6kI8N50OYNI3P/kUXESmrnMChWNv+Qk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ExL015QrAdJBn1fDQt2KZ0EH3/BMEXw/JoA0TZhZ7arnm0wUyoa/DcSRZ8g8btIsy
	 fN6/5Cj4JwSDD2eWQJRvNO4J9kPJUt4avyoVV0rByYwFza6ZmIivUF35YHn39YAKi4
	 6QANYc3Va+UltpwM7iP30bsP2XD7SkhsCGPPCnD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 495/552] ALSA: virmidi: Check card index validity at probe
Date: Fri,  4 Sep 2026 07:00:52 +0200
Message-ID: <20260904045801.881077132@linuxfoundation.org>
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

commit b65d5182ecd6b7a24a83d980a0d06e809ef876c5 upstream.

virmidi driver blindly trusts that the given devptr->id value is
within the proper card index range at probe.  It's OK for the devices
the driver itself creates at the module probe time, but if the device
is bound manually via sysfs interface, this could be -1 as "none", and
this leads to OOB access for index[] and other parameters.

Add a sanity check for the card index and warn/correct it if it's a
value out of the range.

Cc: stable@vger.kernel.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260806153227.1460166-5-tiwai@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/drivers/virmidi.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/sound/drivers/virmidi.c
+++ b/sound/drivers/virmidi.c
@@ -75,6 +75,12 @@ static int snd_virmidi_probe(struct plat
 	int idx, err;
 	int dev = devptr->id;
 
+	if (dev < 0 || dev >= SNDRV_CARDS) {
+		dev_warn(&devptr->dev,
+			 "Invalid card index %d, using default 0\n", dev);
+		dev = 0;
+	}
+
 	err = snd_devm_card_new(&devptr->dev, index[dev], id[dev], THIS_MODULE,
 				sizeof(struct snd_card_virmidi), &card);
 	if (err < 0)


