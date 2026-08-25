Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76BD63749F4;
	Tue, 25 Aug 2026 13:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664817; cv=none; b=G51hN5qAA07ks4CORQTssYWU9S01MyDDiI8WJCfIdEuRiDrUChMgmC//rNAUHctQ6z6jpVDoTG2aDTPzzSFq+F6hNxN0Os7/XJMZJq5DadJ6u2uNPzspKQjFoUa+ZKr5iZaQM922zl2eWumWNDvMwh9ZReDEDuESbqUUq7xfMUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664817; c=relaxed/simple;
	bh=fHBmI3sdPvfrZu99auBGvmD2ZpgusecIiQUX4XRwcHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kNP4lYwscr2yLCoJkkq4U5CgWsZ9wKkam77253dLRb7jeY+0z/9mPlEWFWsfWICtHkxo9GSKuSjZ/Zu5vW4ok0THXIGnB8u9o4DS32NDHGLuVXzuxPvcb4++vav3jQcc10TwQn7ja4vXEz21rbE1cZ2TMhTupDY0r43CQF6nV78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tAsg+Btk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tAsg+Btk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDEAB1F000E9;
	Tue, 25 Aug 2026 13:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787664816;
	bh=8aRnaGE0E7KI+DlDKVAfXatbNcAzC/WHvZSRJPuCxCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tAsg+BtkLOloTcFSYacrVjI1wIYKkucMiPPpmpCQHeahQxt2JXQu995u9D8NAU79d
	 HtvNhGf0Nw2cQZp1zWrTU1RftKRZ9m3XHDyWIK4qZVNZ2NI9sz//9G218xVWobl1Yy
	 v8xNq4rk3E/WkDD8W73R2tNm4LCvj3MUIckKVk3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2fb5d1f7cc4c1f132bcc@syzkaller.appspotmail.com,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.1 015/101] ALSA: dummy: Check card index validity at probe
Date: Tue, 25 Aug 2026 15:24:53 +0200
Message-ID: <20260825132542.597200995@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.986300899@linuxfoundation.org>
References: <20260825132541.986300899@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 02442d5fe8ee365a084b055d4fa81a0c1abfc3fd upstream.

snd_dummy_probe() blindly trusts that the given devptr->id value is
within the proper card index range.  It's OK for the devices the
driver itself creates at the module probe time, but if the device is
bound manually via sysfs interface, this could be -1 as "none", and
this leads to OOB access for index[] and other parameters.

Add a sanity check for the card index and warn/correct it if it's a
value out of the range.

Reported-by: syzbot+2fb5d1f7cc4c1f132bcc@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/6a73bd4d.01d0871a.3a0d52.0005.GAE@google.com
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20260806100433.1287393-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/drivers/dummy.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/sound/drivers/dummy.c
+++ b/sound/drivers/dummy.c
@@ -1017,6 +1017,12 @@ static int snd_dummy_probe(struct platfo
 	int idx, err;
 	int dev = devptr->id;
 
+	if (dev < 0 || dev >= SNDRV_CARDS) {
+		dev_warn(&devptr->dev,
+			 "Invalid card index %d, using default 0\n", dev);
+		dev = 0;
+	}
+
 	err = snd_devm_card_new(&devptr->dev, index[dev], id[dev], THIS_MODULE,
 				sizeof(struct snd_dummy), &card);
 	if (err < 0)


