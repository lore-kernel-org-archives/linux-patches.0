Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A29343F23DB;
	Fri,  4 Sep 2026 06:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501707; cv=none; b=ME4g7RMkrmIP8VCdn0T2bhrevSU04Llt/3qRWhcem/RoP4uPz3R80hiwu9cLHnmLITNDaFlCrgqGiTjADBVAe4Cl/vYDMHNom4lL+COlxIcql84F4LPhWootsisrwwHHKpHQdCGWa/fevjoDs3x4INyeCicRfVHWXVMRpMrS6rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501707; c=relaxed/simple;
	bh=0AmNBxqChLjs9qItcasXBm+x5GANtWlsdEjrQOZML9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pywMqfv2L1ArQQWgqqMfSybgi2W/hzh1Q+ACUum+ihb+Vt29xCzr1T9jPRRg290Xt/QP/n7rODOjm5k5ewBhDQRavdeqyuBBA0l+qSZdrvZmDrY9Ov6Dm4rQ4o1jw3WOPRHLr/QBGRc69ylqoGiR83Rg/M/B23AnyAHJV9O5bWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XRyJ8C5k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XRyJ8C5k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 090841F00A3D;
	Fri,  4 Sep 2026 06:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501706;
	bh=Hfm1PLW3QyccLfsX+u+E4gxq/TTsE3eHhzvHFEFS0BE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XRyJ8C5kLfwVXZbQdBrk7QGm2CHh2gBjBgUDjGMgb+eJD08J+3jcAghsqL5M1OMxq
	 avLGvunpVKKdBBGkHzQKDW72ksVr3Z5Dtf0iwJJwvo8nToWn2U7W6fpOWu6Z3g1VtG
	 X6MT4TmabQG9A8JPsxH/rmEXMjQEgsFi7OeYK86g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 487/552] ALSA: aloop: Check card index validity at probe
Date: Fri,  4 Sep 2026 07:00:44 +0200
Message-ID: <20260904045801.709918571@linuxfoundation.org>
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
@@ -1805,6 +1805,12 @@ static int loopback_probe(struct platfor
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


