Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208235;
	b=5R9TGVBM4UwWMG8DozgMDa4yk5wLoaWIbeLziESQHs0XUULqGfgvHZWHAvtmAFhA1Qlu
	 09jTYQebDpsXA0CYjOHJbz2u4M1xP/SRL2rp0IUh+L5wtPtKPiaU0/tb8QozmOEHjonza
	 adEq+nFe/LCSY+IppYOQuLkPWtaBVOb1LHMfxQcohzLkxZK7oNJ4WeaV5DKyO/qYiSWzC
	 Z3vAzk9zM0Of1nkXN7A4imPh9XoJZWfceScdY9lTzZ3jaYC4oV6YhZR9kz84UbjsDKYLT
	 cV5ab/T9IWvQKN2SGcWtvok4q1BNT29O+K2uaJ6XfJuCh+qF3NX113/1/bE2By0Rvdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208235;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UOypCvNaHqXYiOFje+1RWMnQs35Hz62VNOIzhYbgLm8=;
	b=hIIfaAiIM2gyoEStkHLZ1nQ5thnh3w2o9UQ9e55cCAx+8kSmsldyD8eCijPDGaNbjhgd
	 k84fF9cno08PWIDxuOLJgc+/DnavcHV00ms4dAbbm/QYxu5akaKPsQ2KrEQEybYEYQb6F
	 4L1mb4cQEFEDLEDSS9OemGWndZvvjOe0SbrmolnxjFSbOMW3oi4zq+FG4EGt6cSFYyqjA
	 TdgduG1lNw1ZZ4LIkB1EP537o6ZA6JYBXrGXc8JSJk9oJgGCN/3AMYdMDuvQTRZrzLIqn
	 Kco4LF0VX6vMAs6+TErLheZY7v7jlTdfotilmcFIPdM183JUoEX8nMb14/eMJmuQTAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="fo3bs/YS";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB8A606A31A;
	Wed, 28 Oct 2026 17:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fo3bs/YS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BAF11F031E0;
	Wed, 28 Oct 2026 17:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208234;
	bh=UOypCvNaHqXYiOFje+1RWMnQs35Hz62VNOIzhYbgLm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fo3bs/YSVoOYIfXgKg1d3ObRsin7M8S9QBV6tV1CFVN7SgM6Hetyncm8UtiDYsY86
	 fwgdjHhbVjpqXv0XFWJn7PMtKO3sq0qvT6/kKR3Egvu7zfA099AB3RQb5ZxZQ1znhD
	 pKMuyAKHLhn5UzePJXu7SvdSZz8WRmNWvYKxC0B4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Longlong Xia <xialonglong@kylinos.cn>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Jens Axboe <axboe@kernel.dk>,
	Minchan Kim <minchan@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 046/516] zram: fix out-of-bounds access in read_block_state()
Date: Wed, 28 Oct 2026 17:53:18 +0100
Message-ID: <20261028170004.623312480@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Longlong Xia <xialonglong@kylinos.cn>

[ Upstream commit 391f057f44a51cc9418da5cba78b014324174264 ]

read_block_state() calculates nr_pages before taking dev_lock.  If the
device is reset and reinitialized with a smaller disksize before lock
acquisition, nr_pages still describes the old table.  The subsequent loop
can then call slot_lock() past the end of the newly allocated table.

Read disksize after acquiring dev_lock and checking that the device is
initialized.  The read lock then keeps the table and its bound stable for
the duration of the scan.

Link: https://lore.kernel.org/20260804065919.3970386-3-xialonglong2025@163.com
Fixes: c0265342bff4 ("zram: introduce zram memory tracking")
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/zram/zram_drv.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index ac5965ee64b2c..8a3670dbfa1ab 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -882,7 +882,7 @@ static ssize_t read_block_state(struct file *file, char __user *buf,
 	char *kbuf;
 	ssize_t index, written = 0;
 	struct zram *zram = file->private_data;
-	unsigned long nr_pages = zram->disksize >> PAGE_SHIFT;
+	unsigned long nr_pages;
 
 	kbuf = kvmalloc(count, GFP_KERNEL);
 	if (!kbuf)
@@ -895,6 +895,8 @@ static ssize_t read_block_state(struct file *file, char __user *buf,
 		return -EINVAL;
 	}
 
+	nr_pages = zram->disksize >> PAGE_SHIFT;
+
 	for (index = *ppos; index < nr_pages; index++) {
 		int copied;
 		struct timespec64 ts;
-- 
2.53.0



