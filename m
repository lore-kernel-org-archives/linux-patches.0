Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60618242D65;
	Sat, 12 Sep 2026 15:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227673; cv=none; b=kn1LzRYiKopcLI02y2OoLQksmMZeuqsW6iEjT4L1A5vDDeWrgEnmY2OacdH0hGrPXVOy+bd/CMhgxLwt31vT9eWuOMeV78yRsWYMlAMjX13+zDIWkOGPjMRHuO2IXCI+JmfpQaI8cLhvK8J8pxc0MSx3/BEUwMkXw3Yj9DGXZo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227673; c=relaxed/simple;
	bh=xA8ZsZFoAKcptWCvGiKf3mvTsX731a+7Dkuo1jbjJOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ia1FxFsdph5Sod9DcIGnEhTauLgxT74yJlkFwwoY3khiuo0rnmgA0jxTtY3J7REFdfZu4uE3pchP44hilazheLydmzcmcx/cDmfFAqjd0bCl2gghMBeX/aW8TPY2ZKtgu/DD20zRAOtl0TeLGvYamOh+zEtdZPYgURTQDn0kRoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xxJvDJhk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xxJvDJhk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1391C1F000FF;
	Sat, 12 Sep 2026 15:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227672;
	bh=WAoPZBjI+pHLlgryVpF0bHUpA5Lc5k6uv4TFXSmG/mE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xxJvDJhkoVdcvX3iEn7lBWtCBel/oN9MsWKVcsEdv+JU30ZpTDfnOkna2WYONwB9K
	 JUjJ68ZEY2Z93XPfSK37J353LvINdtdNqtOIYk5xoszfRFnEi+mkkKNCnKINXiU5Pv
	 AV+roPsJ4Gx7Bwlo3Yc8ocrvByncOOxOtJDllmdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 0228/1191] ALSA: virmidi: Check card index validity at probe
Date: Sat, 12 Sep 2026 08:49:16 +0200
Message-ID: <20260912065553.330827364@linuxfoundation.org>
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


