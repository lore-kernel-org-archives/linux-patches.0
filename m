Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3ED933A70A;
	Tue, 25 Aug 2026 13:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664573; cv=none; b=In0Etq39zQDyS0LUdUGeUupXgx9nx+Q2R++RdTW5CCtjvuPqtTjUXi3mPxHXqpH9C0QssjV7Mv2mPcZaHcKDukDzlG6BlwJ/MeJ+YLu+WLvebzZaooS2D46UlMRgqL2zZ7rHxVhI38BUkFI5epk1Nnq1DTBKAcHbWe/t+Tw7pAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664573; c=relaxed/simple;
	bh=WHGWampotgrMMPrt6CVOcy2W8NIPxzuERflrOMWUONA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LQqze1+u60mxnrB+ss7m9GIXwRj3qL68yVNA6420S1v4iy8zW8LYpt3CpeWRLzL05bv5/Zs6BiLeXJwzIsmIMs8A97f/oAD6EbF2VHAIIeJ60ZsQEenh3ClJDO122DVpRgtJ+s4dZwMH7U+KNxMS0zvPLZ2OXrSuy61Dnbpc6ME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cWaYobx6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cWaYobx6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2EB41F000E9;
	Tue, 25 Aug 2026 13:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787664571;
	bh=DFi7WImCITBuVCy0qKzJFEIkiseN8P933n4jW2G3j0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cWaYobx65D40BfbkU6ZRCV3Mi4JfdWLI2mJ1hcVKFu5q13Ufe/hcb4DqahWbl0EI5
	 Ao5EY610iS6eD4xoe2/Q53mBgth7CKWSGxtdiIJe7zXFXx6dn3Sp82TQ2W1j7atJUm
	 4/4YDLj4mlGfeMEFGkZ/QGhLL7gRqvuWve+0edBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2fb5d1f7cc4c1f132bcc@syzkaller.appspotmail.com,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.2 16/82] ALSA: dummy: Check card index validity at probe
Date: Tue, 25 Aug 2026 15:25:03 +0200
Message-ID: <20260825132542.167167735@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.560541185@linuxfoundation.org>
References: <20260825132541.560541185@linuxfoundation.org>
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


