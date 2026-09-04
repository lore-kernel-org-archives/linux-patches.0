Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC093D9521;
	Fri,  4 Sep 2026 05:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498751; cv=none; b=dyBtSQNg72EP/uMw5LFEZWwd/rrBAhp82SM8a0ipZmyYeI4tKJWKuiQbvPwlVC5yCwF7qWnLiubfNcFPmga26bIFHOrx5vlhafeKyPV7cvUUl/YUKxo89jE3RDtfw8PUDl76pEW0mjuRncbDTkhdn2jlZE4ZWfxdxzWED7YHqRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498751; c=relaxed/simple;
	bh=ycuzHf59zWp7j/iHS7TiLL4fo1nc3csZOgI8/Qn/qBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A4nj2yHOOZszsdoSFRQSpGtE8TIbkWZ6Ru5Q7EaO4khNT/GJ1IGHxP3OKcnw/ABz5KNBUaqKvSy+U21MrwC63eYBA1kSu1zG3gMARlT3FrKp6C4/a6/Ia5NxQZT6G5U8fhSC5e96d7cb14K03BcqTkqueJMEaljYPtQ9Af3BPl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2G1D1ai1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2G1D1ai1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21E6C1F00A3D;
	Fri,  4 Sep 2026 05:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498750;
	bh=NLyC19ZeD6VTcnBKMvbwA7IxQgb/eljOEO3Ox2cQicQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2G1D1ai104sVcYfK1QA0PX3Mxt8+F2Y5LjSYzzudKWbMYhPkXpgD/489lcmT/2e8W
	 R9EA9vG+Y/+chcpCBktJ1z1L+EpR/JY3Box4WKRII2IKoTd2BsTrG1gMrH29mVILT/
	 BTybgB2vSVCBiTfoJRccKI1s0GZBYx6t00RgzfRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Longlong Xia <xialonglong@kylinos.cn>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Jens Axboe <axboe@kernel.dk>,
	Minchan Kim <minchan@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.2 131/713] zram: fix out-of-bounds access in read_block_state()
Date: Fri,  4 Sep 2026 06:51:39 +0200
Message-ID: <20260904045806.768853390@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Longlong Xia <xialonglong@kylinos.cn>

commit 391f057f44a51cc9418da5cba78b014324174264 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/zram/zram_drv.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1549,7 +1549,7 @@ static ssize_t read_block_state(struct f
 	char *kbuf;
 	ssize_t index, written = 0;
 	struct zram *zram = file->private_data;
-	unsigned long nr_pages = zram->disksize >> PAGE_SHIFT;
+	unsigned long nr_pages;
 
 	kbuf = kvmalloc(count, GFP_KERNEL);
 	if (!kbuf)
@@ -1561,6 +1561,8 @@ static ssize_t read_block_state(struct f
 		return -EINVAL;
 	}
 
+	nr_pages = zram->disksize >> PAGE_SHIFT;
+
 	for (index = *ppos; index < nr_pages; index++) {
 		int copied;
 


