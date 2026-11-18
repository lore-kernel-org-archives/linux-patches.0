Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021696;
	b=Ib/L7wCa4bh2ZA9/jBXV1vsan0RwI+AGu5LOHGKVsg7FFYUOISBIKGNjk5iIaOLytiWr
	 DYgFD4D48WdA1dGmV7SncZ6+gFukIhjM0WNjbNMhH7lkiFH8KqwcHoVVgaLCDTudMYF2F
	 MzvUjkkZgliHiB+eFT7i3vKu0HKmq1zwvOjed/kOvQL/Tx+F7ErS1UtQRSjUEM3lPbGkJ
	 vvfBhLAYS4i6JDqt9hM7p2CKrUxnvxfjijcZFqjywE5b7f0Frb1TLmXffPi2coejH3tr4
	 Hgj+D/3Xk/F+nmuvhJ8gG3yAD7w207XFfXvuRLr7a94aVdah9Qx268Nr6UQcM/QL5tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021696;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KyipvP1OzcqAgPEq8p1PCt8zzhyUPjKiY1YDOoZeFUk=;
	b=t6XGigddREbnEyRGy43pNx3K88a6eWpkHVK4v/70jWGbnkxEWD99ponHeS5cKTbzqgQY
	 XafHz0ZRPenke379rHbq3hS8q6ivdrgcuHCMHAf4WnA2pR5kt0TiFIxuI9h7Z2d/HBjEh
	 9E98lYSDA9NPenp0JEOkrEkFpQCFU/wBsqAQlAAYqdt9mAjI8Y2UMbtmWWW+HeMCj9Rek
	 9ZSjbzLIypvbd1/QQnv7CIiSerBTrOos23ls9GpOErUX+qVvXvtJYfTJPOO/Vw/8ifaQJ
	 4twxIANC7D4BSJqCfUZWTviuFVt3MGU8DINKBKaUpepdG04N01Db5ir2DUhxuLexlwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ywJQUPQc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4977E606A325;
	Wed, 18 Nov 2026 17:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ywJQUPQc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B681F000C4;
	Wed, 18 Nov 2026 17:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021696;
	bh=KyipvP1OzcqAgPEq8p1PCt8zzhyUPjKiY1YDOoZeFUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ywJQUPQcsBXTYzAz4ScSuUB3pvcT7lmVH3udFDTAH8zQrzHADdXKjq+EN0sQ/8WvR
	 8n+/MjI7HYjWU9pBCTAE2AKi8673RWuofgh7X0bQM02l4AUTEUz4sPqPd9wq+p3f7r
	 SnmZog/vvd9SGwqsk2W+OayuVhabgpVfY5Jg8G/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pooyan Azad <pooyan.azadparvar@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Minchan Kim <minchan@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2398/2651] zram: fix short reads from block_state
Date: Wed, 18 Nov 2026 16:00:38 +0100
Message-ID: <20261118150411.696529189@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pooyan Azad <pooyan.azadparvar@gmail.com>

[ Upstream commit 372012202260db088b489ed00059c4571a602552 ]

read_block_state() formats each entry directly into the buffer supplied by
read().  If the remaining buffer is too small for one complete record,
snprintf() returns the full record length and the function stops without
copying data or advancing the file position.  A read from this debugfs
file which is smaller than a record therefore returns zero at a non-EOF
position and cannot make progress.

Convert block_state to seq_file so formatted records are buffered
independently of the userspace read size.  Keep dev_lock held across each
seq_file iteration and continue to protect individual entries with their
slot locks.

Link: https://lore.kernel.org/20260929071846.24829-1-pooyan.azadparvar@gmail.com
Fixes: c0265342bff4 ("zram: introduce zram memory tracking")
Signed-off-by: Pooyan Azad <pooyan.azadparvar@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Closes: https://lore.kernel.org/r/CANC3H+LdtoydSp+o2ecErAw7k6R2+gRf9LyxcaoHv_mGhJmyQQ@mail.gmail.com/
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Tested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/zram/zram_drv.c | 102 +++++++++++++++++-----------------
 1 file changed, 52 insertions(+), 50 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 4ba0f77b2abd8..30f11e36d19c7 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1547,68 +1547,70 @@ static void zram_debugfs_destroy(void)
 	debugfs_remove_recursive(zram_debugfs_root);
 }
 
-static ssize_t read_block_state(struct file *file, char __user *buf,
-				size_t count, loff_t *ppos)
+static void *zram_block_state_start(struct seq_file *seq, loff_t *pos)
 {
-	char *kbuf;
-	unsigned long index;
-	ssize_t written = 0;
-	struct zram *zram = file->private_data;
+	struct zram *zram = seq->private;
 	unsigned long nr_pages;
 
-	kbuf = kvmalloc(count, GFP_KERNEL);
-	if (!kbuf)
-		return -ENOMEM;
-
-	guard(rwsem_read)(&zram->dev_lock);
-	if (!init_done(zram)) {
-		kvfree(kbuf);
-		return -EINVAL;
-	}
+	down_read(&zram->dev_lock);
+	if (!init_done(zram))
+		return ERR_PTR(-EINVAL);
 
 	nr_pages = zram->disksize >> PAGE_SHIFT;
+	if (*pos >= nr_pages)
+		return NULL;
 
-	for (index = *ppos; index < nr_pages; index++) {
-		int copied;
+	return pos;
+}
 
-		slot_lock(zram, index);
-		if (!slot_allocated(zram, index))
-			goto next;
+static void *zram_block_state_next(struct seq_file *seq, void *v, loff_t *pos)
+{
+	struct zram *zram = seq->private;
+	unsigned long nr_pages = zram->disksize >> PAGE_SHIFT;
 
-		copied = snprintf(kbuf + written, count,
-			"%12lu %12u.%06d %c%c%c%c%c%c\n",
-			index, zram->table[index].attr.ac_time, 0,
-			test_slot_flag(zram, index, ZRAM_SAME) ? 's' : '.',
-			test_slot_flag(zram, index, ZRAM_WB) ? 'w' : '.',
-			test_slot_flag(zram, index, ZRAM_HUGE) ? 'h' : '.',
-			test_slot_flag(zram, index, ZRAM_IDLE) ? 'i' : '.',
-			get_slot_comp_priority(zram, index) ? 'r' : '.',
-			test_slot_flag(zram, index,
-				       ZRAM_INCOMPRESSIBLE) ? 'n' : '.');
-
-		if (count <= copied) {
-			slot_unlock(zram, index);
-			break;
-		}
-		written += copied;
-		count -= copied;
-next:
-		slot_unlock(zram, index);
-		*ppos += 1;
-	}
+	++*pos;
+	if (*pos >= nr_pages)
+		return NULL;
+
+	return pos;
+}
+
+static void zram_block_state_stop(struct seq_file *seq, void *v)
+{
+	struct zram *zram = seq->private;
 
-	if (copy_to_user(buf, kbuf, written))
-		written = -EFAULT;
-	kvfree(kbuf);
+	up_read(&zram->dev_lock);
+}
+
+static int zram_block_state_show(struct seq_file *seq, void *v)
+{
+	struct zram *zram = seq->private;
+	unsigned long index = *(loff_t *)v;
+
+	slot_lock(zram, index);
+	if (slot_allocated(zram, index)) {
+		seq_printf(seq, "%12lu %12u.%06d %c%c%c%c%c%c\n",
+			   index, zram->table[index].attr.ac_time, 0,
+			   test_slot_flag(zram, index, ZRAM_SAME) ? 's' : '.',
+			   test_slot_flag(zram, index, ZRAM_WB) ? 'w' : '.',
+			   test_slot_flag(zram, index, ZRAM_HUGE) ? 'h' : '.',
+			   test_slot_flag(zram, index, ZRAM_IDLE) ? 'i' : '.',
+			   get_slot_comp_priority(zram, index) ? 'r' : '.',
+			   test_slot_flag(zram, index,
+					  ZRAM_INCOMPRESSIBLE) ? 'n' : '.');
+	}
+	slot_unlock(zram, index);
 
-	return written;
+	return 0;
 }
 
-static const struct file_operations proc_zram_block_state_op = {
-	.open = simple_open,
-	.read = read_block_state,
-	.llseek = default_llseek,
+static const struct seq_operations zram_block_state_sops = {
+	.start = zram_block_state_start,
+	.next = zram_block_state_next,
+	.stop = zram_block_state_stop,
+	.show = zram_block_state_show,
 };
+DEFINE_SEQ_ATTRIBUTE(zram_block_state);
 
 static void zram_debugfs_register(struct zram *zram)
 {
@@ -1618,7 +1620,7 @@ static void zram_debugfs_register(struct zram *zram)
 	zram->debugfs_dir = debugfs_create_dir(zram->disk->disk_name,
 						zram_debugfs_root);
 	debugfs_create_file("block_state", 0400, zram->debugfs_dir,
-				zram, &proc_zram_block_state_op);
+				zram, &zram_block_state_fops);
 }
 
 static void zram_debugfs_unregister(struct zram *zram)
-- 
2.53.0



