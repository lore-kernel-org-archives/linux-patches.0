Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C8F2E3AFB;
	Tue, 15 Jul 2025 13:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585627; cv=none; b=WYYkE8hJWREdb0X7iiipkCi6uYIr8oW0obBvYXo7kv7ysvZOYrFokqypvJLJ8A8kuhHfqwjqqUdKw+H9Z8DV82hghQS8HTmaK8+gyF3eFfg6/x33tLDaYwau2Xibq95CFzNoOUsuDMUUzC+Cr6Cz9ErgsPFbw1R/iL5Gi9yulwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585627; c=relaxed/simple;
	bh=SeVpBYho0YkZhbG/IcW7AHKsPxURe5Asgm24oH0qRF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TSvZTLlHmWntwEm978W9f74kBIxsjjr/fp4ShTRWKxLCxFzp0QTE5Ci6snh+GZ+Q9iLNR0fGxShG57IiTSKZfZ50AnO3941pRSKAvqobAGha7c+KB+YxzFajJ+VvrD7am6AmsMo5Byj35mzvnjL8N2O8vSZX1L3h0gQVVNfLFS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jNYqyS9V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jNYqyS9V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CA1CC4CEF7;
	Tue, 15 Jul 2025 13:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585627;
	bh=SeVpBYho0YkZhbG/IcW7AHKsPxURe5Asgm24oH0qRF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jNYqyS9VQV1MeKH+EIT9buqXviEZ9mWeKBCCovQAcemTWSZLoIKVXGlcaGYPe4UCv
	 fTM2pAsLYwHJVJq/f9nsa1vLmI/qAFbyltMq9pty64Nex2QuCibqs6q7Mkpf4e2rLk
	 m7BLJ4tb6PKuD91KbDCO74E+TeXeoopKvKX99NNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nigel Croxon <ncroxon@redhat.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 111/163] raid10: cleanup memleak at raid10_make_request
Date: Tue, 15 Jul 2025 15:12:59 +0200
Message-ID: <20250715130813.308939945@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nigel Croxon <ncroxon@redhat.com>

[ Upstream commit 43806c3d5b9bb7d74ba4e33a6a8a41ac988bde24 ]

If raid10_read_request or raid10_write_request registers a new
request and the REQ_NOWAIT flag is set, the code does not
free the malloc from the mempool.

unreferenced object 0xffff8884802c3200 (size 192):
   comm "fio", pid 9197, jiffies 4298078271
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 88 41 02 00 00 00 00 00  .........A......
     08 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
   backtrace (crc c1a049a2):
     __kmalloc+0x2bb/0x450
     mempool_alloc+0x11b/0x320
     raid10_make_request+0x19e/0x650 [raid10]
     md_handle_request+0x3b3/0x9e0
     __submit_bio+0x394/0x560
     __submit_bio_noacct+0x145/0x530
     submit_bio_noacct_nocheck+0x682/0x830
     __blkdev_direct_IO_async+0x4dc/0x6b0
     blkdev_read_iter+0x1e5/0x3b0
     __io_read+0x230/0x1110
     io_read+0x13/0x30
     io_issue_sqe+0x134/0x1180
     io_submit_sqes+0x48c/0xe90
     __do_sys_io_uring_enter+0x574/0x8b0
     do_syscall_64+0x5c/0xe0
     entry_SYSCALL_64_after_hwframe+0x76/0x7e

V4: changing backing tree to see if CKI tests will pass.
The patch code has not changed between any versions.

Fixes: c9aa889b035f ("md: raid10 add nowait support")
Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
Link: https://lore.kernel.org/linux-raid/c0787379-9caa-42f3-b5fc-369aed784400@redhat.com
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid10.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index cc194f6ec18da..5cdc599fcad3c 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1181,8 +1181,11 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 		}
 	}
 
-	if (!regular_request_wait(mddev, conf, bio, r10_bio->sectors))
+	if (!regular_request_wait(mddev, conf, bio, r10_bio->sectors)) {
+		raid_end_bio_io(r10_bio);
 		return;
+	}
+
 	rdev = read_balance(conf, r10_bio, &max_sectors);
 	if (!rdev) {
 		if (err_rdev) {
@@ -1368,8 +1371,11 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 	}
 
 	sectors = r10_bio->sectors;
-	if (!regular_request_wait(mddev, conf, bio, sectors))
+	if (!regular_request_wait(mddev, conf, bio, sectors)) {
+		raid_end_bio_io(r10_bio);
 		return;
+	}
+
 	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
 	    (mddev->reshape_backwards
 	     ? (bio->bi_iter.bi_sector < conf->reshape_safe &&
-- 
2.39.5



