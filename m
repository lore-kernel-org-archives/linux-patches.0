Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 093DD3939B1;
	Sat, 12 Sep 2026 18:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237129; cv=none; b=EVYWYErqe01QXLErUGVwRO8w06rbqm7c6vp01HqCc2PGmKAvtLdxyiUyS/CuakAkI7Qj8O2y8gfgbdPVH0LUcmhUMcOKipI7KusmKnqyJkW144CHjolenG0/tH7Jc+iMqX8tEHzBVntDVGwC4RlHVSo+lHPNBvHkxsQ+k6iSdqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237129; c=relaxed/simple;
	bh=hvgNpRuPqorbiRPTsJRU50vjNIS1d2yfnniEeOWhwKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q30xHwqs2yPXngwq6O406WHL389qk+zYmDwvjk3dZAd3hsK2KIQB0Q1MVCpC4T1JiOdaHzKxf2RyCcepFnefZbGMq9WfFMu+Ceacr8bgYV+KkejKBQK5HXOoyM5+QjMaZnXoDCExeH2JyG/k5HAQVveml72Wp6TJEKz9VLdKi2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ON/RLaKG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ON/RLaKG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8A151F000FF;
	Sat, 12 Sep 2026 18:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237127;
	bh=RRqgrmJrTRqrGmqhCa14gSmpppoEYizEa6gTkCWnM1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ON/RLaKGosd6hCSJ6HrF4U0UyyHfvUw2FZUNCxVkBJJ/cRciMfcMU+CWI7eg7Ni0U
	 oPlTL1asEB7ZlN+64zDrJRnei1NFnuSnk0vhobCFXncKMfbw5/ZHg7tnb/4Q58tQ9F
	 LuBxY3h+qhhjUiciwNUTVaQkyQd487gsGCM7uKaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 196/935] ALSA: virmidi: Check card index validity at probe
Date: Sat, 12 Sep 2026 08:53:46 +0200
Message-ID: <20260912065531.310659432@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


