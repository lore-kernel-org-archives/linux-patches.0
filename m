Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048504;
	b=p9/umc32FhGLFQ98kdszC4w2PTd5J7Qkf44WTioGrvCtZO/IZQ6f23ZAADXPYCCEgxYt
	 fU+gj6o1tVwUr6fTCv3aKlXOuq7liJZOHJLnZALLcdDqyH++V4w8iDj8FDJVp8zOo9V2E
	 Q37L2Ugc1mUp6KjVXgJh0neXe1CP+WdkhRnU5e+PiHgcHnb/LnPSrq3ELCJ4mQ/iPvWzg
	 8S1r3A4G5aBQWyz4oisbTGneCAHgbr6ONYabZC4PHdIXbvSKdKtMxzjZYRRkfiuUIBpHo
	 Iku/eQfyIPRw0XONAuGxng6q/QBvmiuv2SZKdQjsfgmF2sHqYmCjtOqceRQA72bP4Ag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048504;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QXaS3gesVTCy/VT5zBf4otNJKwnTya2TDNYjrNETCDc=;
	b=0MUSwLkuJ7iSWbxgvxDEs0mIls8/hmSk+pkTANcYDwcALa1bq8Obd++Mpxn+Teg9kMkp
	 EUYCfEh9VP2VH/owQzcGcjGixqsD0hiVrigZ8yL8m+xkKaKZBhi2qfvXGjTfcDhtYMj/K
	 rDbP05ngHeDwFcuK+EcjMllNAEpMpKgHiHd3rYcE7llWU4pvddb1E0fUrfz9WzzQQrRcQ
	 eARH7keqg1+iH/Wf+1VdKVQGBrGDmhLsFxCKz8HWiWR+95Fnq8sg+IuwYvFsM47RrAY0J
	 22/yNdGGljlRladaPUxezaS5BJ+1gZYpDagCHYHb4ajenMoVUoZS2mVPhWhh+2TMu0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fG0xcjZA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C59F606A31C;
	Thu, 19 Nov 2026 00:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fG0xcjZA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 839011F000C6;
	Thu, 19 Nov 2026 00:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048504;
	bh=QXaS3gesVTCy/VT5zBf4otNJKwnTya2TDNYjrNETCDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fG0xcjZAf2nfpPkVI8P7o6g8Qx2+WfGCWsSgY/4NorvTX7zDbtGG2wuGUfZgkWi89
	 L0ugJgpmsaNN8V21LgvrypJy4jJLEWblYbJp/bJoJFS7D4G2WIYMqGHHzK4FSpOpjt
	 LGGEci4LUELLZ14vb0Jwdv2PhxQZH2wppoV0XLgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2017/2857] swim: Recalibrate when drive is probed
Date: Wed, 18 Nov 2026 15:50:51 +0100
Message-ID: <20261118150314.025170384@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Finn Thain <fthain@linux-m68k.org>

[ Upstream commit ba087774a1493ade524f8a783461fa8be9c75039 ]

Track zero recalibration can be slow and is normally done only once i.e.
during system POST or boot-up. Recalibrate once after the drive is probed
rather than every time the device is opened. Don't register the drive if
recalibration fails. Park the heads before ejecting.

Fixes: 8852ecd97488 ("m68k: mac - Add SWIM floppy support")
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Tested-by: Stan Johnson <userm57@yahoo.com>
Link: https://patch.msgid.link/119e799afcc00d6bd4a479c31e0c960cb1a1d71b.1788513997.git.fthain@linux-m68k.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim.c | 37 +++++++++++++++++--------------------
 1 file changed, 17 insertions(+), 20 deletions(-)

diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index f2ca35ed0ff0c..0d738368da44e 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -412,6 +412,7 @@ static inline int swim_track00(struct swim __iomem *base)
 	if (swim_readbit(base, TRACK_ZERO))
 		return 0;
 
+	pr_err("swim: track zero recalibration failed\n");
 	return -1;
 }
 
@@ -456,6 +457,7 @@ static int floppy_eject(struct floppy_state *fs)
 	struct swim __iomem *base = fs->swd->base;
 
 	swim_drive(base, fs->location);
+	swim_track(fs, 40);
 	swim_motor(base, OFF);
 	swim_eject(base);
 	swim_drive(base, NO_DRIVE);
@@ -596,13 +598,6 @@ static void setup_medium(struct floppy_state *fs)
 		struct floppy_struct *g;
 		fs->disk_in = 1;
 		fs->write_protected = swim_readbit(base, WRITE_PROT);
-
-		if (swim_track00(base))
-			printk(KERN_ERR
-				"SWIM: cannot move floppy head to track 0\n");
-
-		swim_track00(base);
-
 		fs->type = swim_readbit(base, TWOMEG_MEDIA) ?
 			HD_MEDIA : DD_MEDIA;
 		fs->head_number = swim_readbit(base, SINGLE_SIDED) ? 1 : 2;
@@ -610,7 +605,6 @@ static void setup_medium(struct floppy_state *fs)
 		fs->total_secs = g->size;
 		fs->secpercyl = g->head * g->sect;
 		fs->secpertrack = g->sect;
-		fs->track = 0;
 	} else {
 		fs->disk_in = 0;
 	}
@@ -762,24 +756,33 @@ static const struct block_device_operations floppy_fops = {
 	.check_events	 = floppy_check_events,
 };
 
-static int swim_add_floppy(struct swim_priv *swd, enum drive_location location)
+static void swim_add_floppy(struct swim_priv *swd, enum drive_location location)
 {
 	struct floppy_state *fs = &swd->unit[swd->floppy_count];
 	struct swim __iomem *base = swd->base;
 
-	fs->location = location;
+	swim_drive(base, location);
+	if (!swim_readbit(base, DRIVE_PRESENT) ||
+	    swim_readbit(base, ONEMEG_DRIVE))
+		goto out;
+	if (swim_readbit(base, DISK_IN))
+		swim_motor(base, ON);
+	if (swim_track00(base))
+		goto out;
 
-	swim_motor(base, OFF);
+	fs->location = location;
 
 	fs->type = HD_MEDIA;
 	fs->head_number = 2;
 
 	fs->ref_count = 0;
 	fs->ejected = 1;
+	fs->track = 0;
 
 	swd->floppy_count++;
 
-	return 0;
+out:
+	swim_motor(base, OFF);
 }
 
 static const struct blk_mq_ops swim_mq_ops = {
@@ -821,14 +824,8 @@ static int swim_floppy_init(struct swim_priv *swd)
 
 	/* scan floppy drives */
 
-	swim_drive(base, INTERNAL_DRIVE);
-	if (swim_readbit(base, DRIVE_PRESENT) &&
-	    !swim_readbit(base, ONEMEG_DRIVE))
-		swim_add_floppy(swd, INTERNAL_DRIVE);
-	swim_drive(base, EXTERNAL_DRIVE);
-	if (swim_readbit(base, DRIVE_PRESENT) &&
-	    !swim_readbit(base, ONEMEG_DRIVE))
-		swim_add_floppy(swd, EXTERNAL_DRIVE);
+	swim_add_floppy(swd, INTERNAL_DRIVE);
+	swim_add_floppy(swd, EXTERNAL_DRIVE);
 	swim_drive(base, NO_DRIVE);
 
 	/* register floppy drives */
-- 
2.53.0



