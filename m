Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48774377022
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301637; cv=none; b=IQ28lUWVwMdU9yQ8CEXAZfjDhSVZo+wxeiXvFVDHRd9p0AXcXXQSD5O6rTK5+bhF81rtQ9htO62YJngr0Hgo0B9SpX076+kPd5RDe1moDlxs2ZuJH1akkWbbn4juX/B72vDvODRjpCqfhIz3Sj6mhbEnGIV+mNVQOlQgiYBHcxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301637; c=relaxed/simple;
	bh=B79EG2LYC+euL18wqK1Lt2nJryyy92rN+TCFpVK74Gg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cDwn+rwjxDfwiVeCfnH4JaKGoz3PgL1LcAp1XxuXhTdvTQG4FazBRP6stBVM+tkL9oyY+bcol2AgSQf8+nGuU7u8t8xlZYResY17QSDw48yhEDcjJqeobhoVEev35bfmNRsap5Z4FhaBShlAmeryl0dgE9Bh8tFBlY6rNFjQ4BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UL2VK4cU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UL2VK4cU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE5BBC19423;
	Sat, 28 Feb 2026 18:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301637;
	bh=B79EG2LYC+euL18wqK1Lt2nJryyy92rN+TCFpVK74Gg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UL2VK4cUt7REeTtK3bOq/OUrV7JHdkeQDMojN27FKqkU3lFGw+2RLw4Ue79p14C2K
	 QGoD28j8NHYFvVfeLFISroTgdk0EVyw9chQO2NjbhE7wElBCP+sItcz+0Bw6tZ4Roe
	 xxB1ouJQAE15ceGwh/EptQa7jQ/l7pYLNnusmXXQ3wApKmgp6Nb0Z8CDBo7hkDzCXs
	 1FB2sfupTG7sVI6gkzE5riOK/opdaKQ84ijK45WdsfXJuP8Y47YfpR7aywlbh5W/7K
	 K45D8admdrZ+SWHIHzScXDYWdWI3u7H7YmIftTpVKf7im2qtasDGuccROQz/KkcTdy
	 +LxjhwEIwtAdQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 030/385] io_uring/sync: validate passed in offset
Date: Sat, 28 Feb 2026 12:54:12 -0500
Message-ID: <20260228180011.1568201-30-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 649dd18f559891bdafc5532d737c7dfb56060a6d ]

Check if the passed in offset is negative once cast to sync->off. This
ensures that -EINVAL is returned for that case, like it would be for
sync_file_range(2).

Fixes: c992fe2925d7 ("io_uring: add fsync support")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/sync.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/sync.c b/io_uring/sync.c
index 255f68c37e55c..27bd0a26500bc 100644
--- a/io_uring/sync.c
+++ b/io_uring/sync.c
@@ -62,6 +62,8 @@ int io_fsync_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return -EINVAL;
 
 	sync->off = READ_ONCE(sqe->off);
+	if (sync->off < 0)
+		return -EINVAL;
 	sync->len = READ_ONCE(sqe->len);
 	req->flags |= REQ_F_FORCE_ASYNC;
 	return 0;
-- 
2.51.0

