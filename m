Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 528B941A4F8;
	Fri,  4 Sep 2026 06:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788503011; cv=none; b=lB3R5blFTuGe88btEAcM8UrIbx5lpsr2pNq2IKmbHC9QFyVdNb6ce5gc//RLDOwfNd5SJ97Ig8pCeM+3zjelNTw7kRtpTOezYFVEMRkzx/79mSqyVPqdx8HhqEMuks3n2osQyryxN23GVyCKFq4zGoD+cTOx4ppUXW2OEFobdCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788503011; c=relaxed/simple;
	bh=7rqSiEAqNXaUi5Qlzis+4B7OUgNwU1C4E40GY89VYuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B59WVQvVGLE7HmP3v5G5EOf+8QxnCxbebTCO5PzV156aZz6iyV+pgOHKHgkxaOZ5ehIHVE9Ro4CyBBtkdg6JZVe9HPqHRG69fQ8wUohFzh9Myxr3/S6993XuLvbKPNnzoPXa2KnHcvRR15RqVNtkXKN4vVjdLUdKG2gf4woW5v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l4DCHsUT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l4DCHsUT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACBDB1F00A3E;
	Fri,  4 Sep 2026 06:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788503010;
	bh=QjorQYxiDwKl4kK+jQ85vWpJ7fFUqS+e8WBA0biRKuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l4DCHsUTDv2WrB1srdIn1xglGuq4+OsTsOA4T96KFAVqW39nT8EFlYKeiJIbKbXfz
	 HKdOF9LkWrefXFjxtk7CqJTTvqWyI7viijSUxtZQQZAP8gWZH5EKZXBPcBqEwqdJlm
	 5JPNq34tOiR9njEj3SCIB5iYXLmIwee6Cvejn5TY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 369/403] ALSA: virmidi: Check card index validity at probe
Date: Fri,  4 Sep 2026 07:02:52 +0200
Message-ID: <20260904045743.192412391@linuxfoundation.org>
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


