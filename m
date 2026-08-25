Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF1E45FFCB;
	Tue, 25 Aug 2026 13:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665129; cv=none; b=V2F+x9AVSFbUJUdEv3eQvgg1Ie6eEhdj5E4yioTLF2IZAy7/MLnifywhbN6uugfl41XIZ7hF3gcCi7WnPB3i3w/LU8RJUHU1dyLUeGPepEBeZ6cj0iLOLysRX1ck0+QbB2bJ5nAgDiSYg+DQ0CMh1HnX9Ckx5cpFbfHJna4WrW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665129; c=relaxed/simple;
	bh=ZoZcyuDtg7UoETxCOihSxTZZKB5OVsrZCdXCIZ3FlVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y/kszQv3dSbPW3k49BVKNkZlU5vqYmwaYFzvnspZ4r7wzeCHyxGLr23NZUc5AW2kj1nYE9lSquEY9mDLxu8zfrmZuShQsVkpxQIct4nuhwqO3xvMVFs2ABzyZR8bH4lErzJeCE+ncl7l8p+nflcM8me0dNeAMtzLyfBQdcrA73s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2ROoAOe0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2ROoAOe0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CF1A1F000E9;
	Tue, 25 Aug 2026 13:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665127;
	bh=jcc5OH1DIL0W/AhaXgPckMWZ2ri87xdg8wntENTbxx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2ROoAOe0AScjcgbZygwnjqlzJb4US9GOUCOz35mSAR6uAp9AdCXnHb05q2wP+pa3r
	 /85aYr7CyNF2O2Z4Pq+klL4cbfUJiS22kDUGmz4+0onncG7waHLVVYMdEQNaFTuKps
	 IjoOZShJRrIKR5ZsGiIHfikOh/Nfd00mqQHWnGuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2fb5d1f7cc4c1f132bcc@syzkaller.appspotmail.com,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 17/94] ALSA: dummy: Check card index validity at probe
Date: Tue, 25 Aug 2026 15:25:13 +0200
Message-ID: <20260825132542.570056507@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.887883084@linuxfoundation.org>
References: <20260825132541.887883084@linuxfoundation.org>
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


