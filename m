Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622726;
	b=BvSDDzmAvHay9ELh9Y7TD4NY6rJ0RHXQ5Bw9+PHzRuxRZNXo6BzgasCUXm2G5Env1UpS
	 ZBmFBAu9XozrFm+aOBDfwbdmlc06yLPrlGUO0PNGWiOLIk4Gb+dczNyGuSyj1I9xnhc7U
	 PcUOmfSqcuxS5ORj2JHYqw+qY+lQkAAb8G9bPGtgffhD0YY6FlBfYfacX1/TjtylIwon2
	 We+COPBzir7gTQJ3ctUuRMA2ewf1JVoHz+6pCO8LNlej974pF2BzbBctfsydTKiiSTSoI
	 Yu1xQQ8ZB88ppZCyRA2buZxupbFxojaHt/EiLjRCtWuaU7PhsIXDE3MGShn03WKkdGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622726;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y5g/MozCIPSdF0Ys8cHgv+ZlpAWewfupzhCNXpp5yMU=;
	b=Jch/KQoSOr4OG5EORWL8ILI+UsM+X8kXjkZVSYiqCqGTFqlYswN+88+dZxIfKah7404g
	 A/MP/5EOyWVwJJodNlhTPRlHY1kdATeWfAvtA539MosnsUpy7rxzEUBg7+dwb5f3W3wUZ
	 aHBo4F74focmQSLOeoID4/R411CMHEQOFoavwDgCmglKMeF5sZjv0L9dNGJ6oWLnvqI73
	 UHiEcWwwDMg9KLHlRodABL3gmf1bOXwi+15TWWh773zGLDurR5t6zsNpvKIfowVP+ZjmK
	 9T/n1XibUgEUWInnbK2p0fCX5LMFWBF6RrOq8hqd2tRxi1JbB++shfOEdr/n+cRGw3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wS8OMGB5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 589A8606A321;
	Wed, 25 Nov 2026 16:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wS8OMGB5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D6511F000CF;
	Wed, 25 Nov 2026 16:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622726;
	bh=y5g/MozCIPSdF0Ys8cHgv+ZlpAWewfupzhCNXpp5yMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wS8OMGB50PkH82UPV2+DGM6F66dpjUq99eBX2blgg8MfYPXd1yEt424KVBJNe62C/
	 COz0J/oNclb6CLtyzn3KiDdbZWbRTfOcX5SgrUdlA22HDEwfEbtdi125ud0DYjOgSZ
	 6f7YgJBMuVS86EvSWB1cJuPxorQzxOK4UOYS1RCE=
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
Subject: [PATCH 6.18 627/990] zram: fix short reads from block_state
Date: Wed, 25 Nov 2026 15:33:14 +0100
Message-ID: <20261125143836.785113012@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
[ sashal: Renamed this tree's older helpers and lock (init_lock, zram_slot_lock, zram_allocated, etc.) in place of upstream's, and kept the ktime_t-based timestamp formatting instead of upstream's integer ac_time print. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/zram/zram_drv.c | 105 +++++++++++++++++-----------------
 1 file changed, 53 insertions(+), 52 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index ea5a9b81a310e..1ef4a15947683 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1134,72 +1134,73 @@ static void zram_debugfs_destroy(void)
 	debugfs_remove_recursive(zram_debugfs_root);
 }
 
-static ssize_t read_block_state(struct file *file, char __user *buf,
-				size_t count, loff_t *ppos)
+static void *zram_block_state_start(struct seq_file *seq, loff_t *pos)
 {
-	char *kbuf;
-	ssize_t index, written = 0;
-	struct zram *zram = file->private_data;
+	struct zram *zram = seq->private;
 	unsigned long nr_pages;
 
-	kbuf = kvmalloc(count, GFP_KERNEL);
-	if (!kbuf)
-		return -ENOMEM;
-
 	down_read(&zram->init_lock);
-	if (!init_done(zram)) {
-		up_read(&zram->init_lock);
-		kvfree(kbuf);
-		return -EINVAL;
-	}
+	if (!init_done(zram))
+		return ERR_PTR(-EINVAL);
 
 	nr_pages = zram->disksize >> PAGE_SHIFT;
+	if (*pos >= nr_pages)
+		return NULL;
 
-	for (index = *ppos; index < nr_pages; index++) {
-		int copied;
-		struct timespec64 ts;
+	return pos;
+}
 
-		zram_slot_lock(zram, index);
-		if (!zram_allocated(zram, index))
-			goto next;
+static void *zram_block_state_next(struct seq_file *seq, void *v, loff_t *pos)
+{
+	struct zram *zram = seq->private;
+	unsigned long nr_pages = zram->disksize >> PAGE_SHIFT;
 
-		ts = ktime_to_timespec64(zram->table[index].ac_time);
-		copied = snprintf(kbuf + written, count,
-			"%12zd %12lld.%06lu %c%c%c%c%c%c\n",
-			index, (s64)ts.tv_sec,
-			ts.tv_nsec / NSEC_PER_USEC,
-			zram_test_flag(zram, index, ZRAM_SAME) ? 's' : '.',
-			zram_test_flag(zram, index, ZRAM_WB) ? 'w' : '.',
-			zram_test_flag(zram, index, ZRAM_HUGE) ? 'h' : '.',
-			zram_test_flag(zram, index, ZRAM_IDLE) ? 'i' : '.',
-			zram_get_priority(zram, index) ? 'r' : '.',
-			zram_test_flag(zram, index,
-				       ZRAM_INCOMPRESSIBLE) ? 'n' : '.');
-
-		if (count <= copied) {
-			zram_slot_unlock(zram, index);
-			break;
-		}
-		written += copied;
-		count -= copied;
-next:
-		zram_slot_unlock(zram, index);
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
 
 	up_read(&zram->init_lock);
-	if (copy_to_user(buf, kbuf, written))
-		written = -EFAULT;
-	kvfree(kbuf);
+}
 
-	return written;
+static int zram_block_state_show(struct seq_file *seq, void *v)
+{
+	struct zram *zram = seq->private;
+	unsigned long index = *(loff_t *)v;
+	struct timespec64 ts;
+
+	zram_slot_lock(zram, index);
+	if (zram_allocated(zram, index)) {
+		ts = ktime_to_timespec64(zram->table[index].ac_time);
+		seq_printf(seq, "%12lu %12lld.%06lu %c%c%c%c%c%c\n",
+			   index, (s64)ts.tv_sec,
+			   ts.tv_nsec / NSEC_PER_USEC,
+			   zram_test_flag(zram, index, ZRAM_SAME) ? 's' : '.',
+			   zram_test_flag(zram, index, ZRAM_WB) ? 'w' : '.',
+			   zram_test_flag(zram, index, ZRAM_HUGE) ? 'h' : '.',
+			   zram_test_flag(zram, index, ZRAM_IDLE) ? 'i' : '.',
+			   zram_get_priority(zram, index) ? 'r' : '.',
+			   zram_test_flag(zram, index,
+					  ZRAM_INCOMPRESSIBLE) ? 'n' : '.');
+	}
+	zram_slot_unlock(zram, index);
+
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
@@ -1209,7 +1210,7 @@ static void zram_debugfs_register(struct zram *zram)
 	zram->debugfs_dir = debugfs_create_dir(zram->disk->disk_name,
 						zram_debugfs_root);
 	debugfs_create_file("block_state", 0400, zram->debugfs_dir,
-				zram, &proc_zram_block_state_op);
+				zram, &zram_block_state_fops);
 }
 
 static void zram_debugfs_unregister(struct zram *zram)
-- 
2.53.0



