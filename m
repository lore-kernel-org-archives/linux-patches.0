Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063086;
	b=MxK98KNCqYkBbvgQERhzHclC9tIQr4eePVZBqL4/Zds+eGnsZ8Xaj2rlpIGKUJ3PNeZV
	 xr3DFkp2MQ4AYMnBzl6W3cs0eYxB6ZjI8uqQs9CDlU6EG1S2/8M1D9Tb7Og8KvY9kNCEA
	 +nJpexk2izbeq20O9hx2PsTv9d2z0g6keWYQip/68qqyEs31CiyZ3UNzOr0jho+mcXHoc
	 tqN8KukK2qgd92A1gr0L/m2LlM0QGVoBVWawRkoAAyF5CfElLAIVWDtvYpcuTk4+2IVIa
	 k/keXlhk1MmtkCGwyt2SAFHuxT/VD8jySxlEeDiVIltv3FBRK/6tUFBUVuORwpTQspw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063086;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XzMtpQXkJqMBwuApjv0TQMYS7fpAhSaHbDd1fkFa6M8=;
	b=1EpCW95R4okXJg8u7W2ivXw726QkgVdSR0HsaxNRPnGBM2eyzA4m5SsWvui2xPeyfKWs
	 ArUIOHvHVbt8GajDN2ePZPqNVhowWWqTlnFsnO3mSXhcePL5Syis9MyP++7ZSh00FIWGJ
	 KcCB6uwxOQZPCHtkN4wvfeHqs14zC5j1hhD8yC0bUlpNdU3G+0v7awymiidbIEAqq7fsP
	 vchSS4VGhMWcb+T1gwiNjNQgbwaoYmY1Cf+Yu/dBaVUbvCSVQ56kTdvH7mSMArjIjadVL
	 Etr7xEnnv+lHgJLs9gh2w3nGMHT5ad8WS1srfcCAnabtRM28sdeQfErAiC1CnhqiDFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i6WazUD0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D10AB606D814;
	Sat,  7 Nov 2026 14:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i6WazUD0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B3E21F0089F;
	Sat,  7 Nov 2026 14:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063085;
	bh=XzMtpQXkJqMBwuApjv0TQMYS7fpAhSaHbDd1fkFa6M8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i6WazUD0F6B0NTIWRDYAuS15Lx4KsiqIx+p4B8EBdd0Tu3oAXpRau3mwR4t/dzhrU
	 eY6lSrjoCFfuaRqSveeLk5gttw0kBM7TPCosMAsgH898qNFsqMF94/fiWaG+H3EviG
	 STaXbhpOYWbIz7NYJWq4EkI0t16/awslx56KDLDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 324/869] block: amiflop: synchronize flush timer before track flush
Date: Sat,  7 Nov 2026 08:50:06 -0500
Message-ID: <20261107134903.446709003@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit 9690943353cec1690a715e000ba6a74e5139f530 ]

The amiflop track buffer is shared with the timer callback. timer_delete()
does not wait for an in-flight callback, and that callback can rearm itself
when it cannot acquire the floppy controller. A synchronous track flush can
therefore race with the callback.

Stop the timer before synchronous track writes and use timer_delete_sync()
to wait for any callback already running. Keep callback rearming disabled
until the write is complete. Apply this to the FDFMTTRK path as well.

FDFLUSH, FDFMTTRK and close-time flushes run outside the blk-mq
request callback. Freeze their queues so an in-flight request cannot
change the shared track buffer while it is encoded and written. Restart
the timer if a track remains dirty after a failed flush.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Link: https://patch.msgid.link/20260930065951.2932739-1-runyu.xiao@seu.edu.cn
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/amiflop.c | 71 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 63 insertions(+), 8 deletions(-)

diff --git a/drivers/block/amiflop.c b/drivers/block/amiflop.c
index 2932b6653b6f0..a477ada6b1ef5 100644
--- a/drivers/block/amiflop.c
+++ b/drivers/block/amiflop.c
@@ -265,6 +265,8 @@ static struct fd_data_type data_types[] = {
 static struct amiga_floppy_struct unit[FD_MAX_UNITS];
 
 static struct timer_list flush_track_timer[FD_MAX_UNITS];
+static DEFINE_SPINLOCK(flush_track_timer_lock);
+static bool flush_track_timer_stopped[FD_MAX_UNITS];
 static struct timer_list post_write_timer;
 static unsigned long post_write_timer_drive;
 static struct timer_list motor_on_timer;
@@ -1370,11 +1372,22 @@ static void flush_track_callback(struct timer_list *timer)
 					sizeof(flush_track_timer[0]);
 
 	nr&=3;
+	spin_lock(&flush_track_timer_lock);
+	if (flush_track_timer_stopped[nr]) {
+		spin_unlock(&flush_track_timer_lock);
+		return;
+	}
+	spin_unlock(&flush_track_timer_lock);
+
 	writefromint = 1;
 	if (!try_fdc(nr)) {
 		/* we might block in an interrupt, so try again later */
-		flush_track_timer[nr].expires = jiffies + 1;
-		add_timer(flush_track_timer + nr);
+		spin_lock(&flush_track_timer_lock);
+		if (!flush_track_timer_stopped[nr]) {
+			flush_track_timer[nr].expires = jiffies + 1;
+			add_timer(flush_track_timer + nr);
+		}
+		spin_unlock(&flush_track_timer_lock);
 		return;
 	}
 	get_fdc(nr);
@@ -1421,6 +1434,35 @@ static int non_int_flush_track (unsigned long nr)
 	return 1;
 }
 
+static void flush_track_timer_stop(unsigned int drive)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&flush_track_timer_lock, flags);
+	flush_track_timer_stopped[drive] = true;
+	spin_unlock_irqrestore(&flush_track_timer_lock, flags);
+
+	timer_delete_sync(flush_track_timer + drive);
+}
+
+static void flush_track_timer_start(unsigned int drive)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&flush_track_timer_lock, flags);
+	flush_track_timer_stopped[drive] = false;
+	if (unit[drive].dirty)
+		mod_timer(flush_track_timer + drive, jiffies + 1);
+	spin_unlock_irqrestore(&flush_track_timer_lock, flags);
+}
+
+static void flush_track_timer_sync(unsigned int drive)
+{
+	flush_track_timer_stop(drive);
+	non_int_flush_track(drive);
+	flush_track_timer_start(drive);
+}
+
 static int get_track(int drive, int track)
 {
 	int error, errcnt;
@@ -1435,8 +1477,7 @@ static int get_track(int drive, int track)
 	}
 
 	if (unit[drive].dirty == 1) {
-		timer_delete(flush_track_timer + drive);
-		non_int_flush_track (drive);
+		flush_track_timer_sync(drive);
 	}
 	errcnt = 0;
 	while (errcnt < MAX_ERRORS) {
@@ -1562,6 +1603,12 @@ static int fd_locked_ioctl(struct block_device *bdev, blk_mode_t mode,
 	case FDFMTTRK:
 		if (param < p->type->tracks * p->type->heads)
 		{
+			flush_track_timer_stop(drive);
+			if (unit[drive].dirty == 1 &&
+			    !non_int_flush_track(drive)) {
+				flush_track_timer_start(drive);
+				return -EIO;
+			}
 			get_fdc(drive);
 			if (fd_seek(drive,param) != 0){
 				memset(p->trackbuf, FD_FILL_BYTE,
@@ -1570,6 +1617,7 @@ static int fd_locked_ioctl(struct block_device *bdev, blk_mode_t mode,
 			}
 			floppy_off(drive);
 			rel_fdc();
+			flush_track_timer_start(drive);
 		}
 		else
 			return -EINVAL;
@@ -1591,8 +1639,7 @@ static int fd_locked_ioctl(struct block_device *bdev, blk_mode_t mode,
 	case FDDEFPRM:
 		return -EINVAL;
 	case FDFLUSH: /* unconditionally, even if not needed */
-		timer_delete(flush_track_timer + drive);
-		non_int_flush_track(drive);
+		flush_track_timer_sync(drive);
 		break;
 #ifdef RAW_IOCTL
 	case IOCTL_RAW_TRACK:
@@ -1611,9 +1658,15 @@ static int fd_ioctl(struct block_device *bdev, blk_mode_t mode,
 			     unsigned int cmd, unsigned long param)
 {
 	int ret;
+	unsigned int memflags = 0;
+	bool freeze_queue = cmd == FDFMTTRK || cmd == FDFLUSH;
 
 	mutex_lock(&amiflop_mutex);
+	if (freeze_queue)
+		memflags = blk_mq_freeze_queue(bdev->bd_disk->queue);
 	ret = fd_locked_ioctl(bdev, mode, cmd, param);
+	if (freeze_queue)
+		blk_mq_unfreeze_queue(bdev->bd_disk->queue, memflags);
 	mutex_unlock(&amiflop_mutex);
 
 	return ret;
@@ -1711,11 +1764,12 @@ static void floppy_release(struct gendisk *disk)
 {
 	struct amiga_floppy_struct *p = disk->private_data;
 	int drive = p - unit;
+	unsigned int memflags;
 
 	mutex_lock(&amiflop_mutex);
+	memflags = blk_mq_freeze_queue(disk->queue);
 	if (unit[drive].dirty == 1) {
-		timer_delete(flush_track_timer + drive);
-		non_int_flush_track (drive);
+		flush_track_timer_sync(drive);
 	}
   
 	if (!fd_ref[drive]--) {
@@ -1725,6 +1779,7 @@ static void floppy_release(struct gendisk *disk)
 #ifdef MODULE
 	floppy_off (drive);
 #endif
+	blk_mq_unfreeze_queue(disk->queue, memflags);
 	mutex_unlock(&amiflop_mutex);
 }
 
-- 
2.53.0



