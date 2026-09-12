Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A0E93BFAF7;
	Sat, 12 Sep 2026 14:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225006; cv=none; b=aLDbP2jKkrMZn2SIfJmQXTAnfRy1uFxBCFzljZ2rC1Gwechk9yg6UZWTXdWBPtjte7Pwx6VpKPxWqUY6H02mZUI5vdcdddFlFeP5DIbr4ZHOP4bwMLNLiIYNJuE+3iDNC5k+gWgNnMcInnWaXW+wHRoaW5qKWvYbMjuZw1HB7os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225006; c=relaxed/simple;
	bh=oF9CwHX1wYG+p4JTUwq+6eJBJDUsc4bmVvGbI174UT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hmg+XTFCoS2iDYtVsHNSJufHvrhpY6melXnAwZHeXxkqVh2Z+pAybAC+KMxExNIyheZoj3plDKcQwN/wIN6i9eWEYkzVv8SaN7Kmb4lhdexRBaVefKcFFhIlFRt2Rucafb/wT1qYwuP+t49IBVWh0JzlC7Seoj5tSmKFrcT8i1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cfqpvQrs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cfqpvQrs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1F631F000FF;
	Sat, 12 Sep 2026 14:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225000;
	bh=WNsjLfWF3pkn8sp81xfIqXa7JLJVB7VZa8E53UAodis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cfqpvQrsvI/hy3vBlZyr3BDYCWRJ8/ApaoDhJhHcZHA9OPBn6BVj9SfrApuAdg1ZQ
	 Vr39/o1LRsaF9Z92TddQAdAVcK8iPaQ31LJcmjkeREd1M4no9hpX5l9U0HB2rxsUv7
	 AFNvmui3iyRLQdPMDEbSiX4/ajBFRKIahiorRDcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mykola Marzhan <mykola@meshstor.io>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1109/1424] md: avoid stale clone I/O accounting timestamps
Date: Sat, 12 Sep 2026 08:59:01 +0200
Message-ID: <20260912065632.139771710@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai@fygo.io>

[ Upstream commit 45102fc8330525d35675b1c193242bba101df5ee ]

md_clone_bio() always allocates the clone from mddev->io_clone_set, even
when queue I/O stats are disabled. In that case it does not call
bio_start_io_acct(), but it also left md_io_clone->start_time untouched.

The clone private data comes from a mempool and can contain data from a
previous user. md_end_clone_io() checks start_time to decide whether it
needs to call bio_end_io_acct(), so a stale non-zero value can make the
completion path end accounting that was never started for this bio.

Set start_time to 0 in the no-stats branch. This keeps the end path tied
to whether bio_start_io_acct() actually ran.

Fixes: c687297b8845 ("md: also clone new io if io accounting is disabled")
Tested-by: Mykola Marzhan <mykola@meshstor.io>
Link: https://patch.msgid.link/20260802195038.164272-8-yukuai@kernel.org
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 43e52cb6bd585..3c605ba3801aa 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8771,6 +8771,8 @@ static void md_clone_bio(struct mddev *mddev, struct bio **bio)
 	md_io_clone->mddev = mddev;
 	if (blk_queue_io_stat(bdev->bd_disk->queue))
 		md_io_clone->start_time = bio_start_io_acct(*bio);
+	else
+		md_io_clone->start_time = 0;
 
 	if (bio_data_dir(*bio) == WRITE && mddev->bitmap) {
 		md_io_clone->offset = (*bio)->bi_iter.bi_sector;
-- 
2.53.0



