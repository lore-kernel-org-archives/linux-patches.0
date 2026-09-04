Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBF4E408035;
	Fri,  4 Sep 2026 05:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500077; cv=none; b=KGSTBsylGFTO72xD1ZkWGl7XyeJLSFO6sOj0a5+pQ0xApSLdkdSl3JxBEnMPOTVtS7qUCMKeWgiiOnIyKmZsbrlkBf9gfAEfnwu7YHTKTUCbPVrYC9XU3oTPy3Uws++4xoY6UN4zUZqhVHflROXsgRMSPZejsGtr/XqONRTv+Cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500077; c=relaxed/simple;
	bh=HwdOaFXD9PjibIj7BmGIzSLGQLTm7+28lBdSLx1UzJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ECJD0hD5qNJlPWFyksb5yALKiaE41pFoGx3fwM5tTzc39OHIAvqcw4ZLPkynwfa2nU9LIti9EZuKUveVndJxB0xk0KDUymPhSM6ENQ6OVWFoQSGorLR4ZUtQlbcXgmpCHM0JDbnaY2Y7d96HNn/t7t0YSrJnjwpUDxT4Crt4r+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cEYP0kLO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cEYP0kLO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6D651F00A3D;
	Fri,  4 Sep 2026 05:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500075;
	bh=TNh3dtUZlaI1eLOm0sbaR+u4Bmpqvf/kO7eeotOvF7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cEYP0kLO7SEoQUtNrEtgv7nzQ4LYPXQ28js43592iL6NUG7/vVFLjXZw2etDUYMii
	 mDuoqrPFZYWWO6Z5VOazJ0BjhqDy5NMfOSuOvZvHIwn+eVE8yIX26ihDGFjUzkMKLI
	 LyKfnraVXqmV8pJnEULt41u78rA4ZWd/xhmv/Zkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.2 643/713] ALSA: portman2x4: Check card index validity at probe
Date: Fri,  4 Sep 2026 07:00:11 +0200
Message-ID: <20260904045818.244420405@linuxfoundation.org>
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
@@ -697,6 +697,12 @@ static int snd_portman_probe(struct plat
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


