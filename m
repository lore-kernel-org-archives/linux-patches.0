Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D92D36B924;
	Sat, 12 Sep 2026 12:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217518; cv=none; b=EuX/mEBps+F4UUK64nAqmJDkFBglPgEXmEBNMKN8TeC3KB3UIpkWxvFZbAO7pPF2cys+sVrXs8cOLNOj2Wv09CObj6bepVWQZVNsR9ol+EAeBL849ReEoq4l5i4kd5vUylzYGhHja515mA8lZTCSqJNuoSmRFt2Z1guFNKVXvG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217518; c=relaxed/simple;
	bh=EbYyucUn5JmESsy+evYSQZ7ov+HZIHC43MM84AFI+v4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GFsLVyfCGA99a2SjlsUjLS5jS9ILU7QdyV4JFG6wzVQJGiMRLKbpIgxXX8Rx1fCoNCbvevE1fktiEHr6llqRdiYPp1XH6WjsnBC+QeppASlWRg6C3aye5DBVop/UGwRwN+dnvYIzemrZ8K3e8/nhUfknuI6FeuPmPJPJV8l2AJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B/JjFR0Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B/JjFR0Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE0E01F00893;
	Sat, 12 Sep 2026 12:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217517;
	bh=J40MsMrH1EF59XpYVgW/5bXZWakqE5IRYbRaCR03r+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B/JjFR0Yh7PYgI8VikASxi/dMWxiIxfQl55dNwjC7bd/orq3VD+5VS3hCWCv3RjEQ
	 ojWtF83p4y3iKgBaVsdtAAwXW2cPJmA0UUFSBJPlXRxzRv+Zo4ReiqTzPyy4v7Gfqz
	 EAD3Io5YSJDS38hb/dzNTivx3/fQSCgO71sMykAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mykola Marzhan <mykola@meshstor.io>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0956/1376] md: avoid stale clone I/O accounting timestamps
Date: Sat, 12 Sep 2026 08:56:22 +0200
Message-ID: <20260912065628.867696785@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index dedd8a583f7e6..79ca70ca797db 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8836,6 +8836,8 @@ static void md_clone_bio(struct mddev *mddev, struct bio **bio)
 	md_io_clone->mddev = mddev;
 	if (blk_queue_io_stat(bdev->bd_disk->queue))
 		md_io_clone->start_time = bio_start_io_acct(*bio);
+	else
+		md_io_clone->start_time = 0;
 
 	if (bio_data_dir(*bio) == WRITE && mddev->bitmap) {
 		md_io_clone->offset = (*bio)->bi_iter.bi_sector;
-- 
2.53.0



