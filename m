Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 957D733F8A1
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300938; cv=none; b=kVRtqVl6P1Jv7PPV4gAIA8kMegVG2dJ3pf5EGWM6bXSjOlGbGqdj12VZK07IKQdrqGebg02uwkPbrACWSda22MwgD1zCZ/a/HXXD08zIjeEMAV4If8s960xsEy7Bprd7Dp/09xx2QhxLTObgax2jmpGnnUPFR9ZRMdzMWHjI91Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300938; c=relaxed/simple;
	bh=ud9NxTJvziABtcYsdphsPN4vVdkp89h028I62Vg6mrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EmdcmUirYWOID2UaKHqZ1VrObJ3CrDB8TZhWoy8dcpnEQgR/a+f7rdASfObnHKKy2AGyD0zvw3Iv98QQUcoVUKqXOzwH8FG6Qi0QO3G6X0/vdKTWk/0leakEaQ3/nqFNSDXnP4sB2MV/wGhyAi1LDZdA6Y7nfsjDhdIFJ0dCCrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B514tJsj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B514tJsj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 040A7C19423;
	Sat, 28 Feb 2026 17:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300938;
	bh=ud9NxTJvziABtcYsdphsPN4vVdkp89h028I62Vg6mrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B514tJsjAeDmYnZ9P+6veT0O2f3trIzH55B+LgvsKqlHOchftG5MlUDMllqFNj0L/
	 o9yeBFIqntSjO//koCBVf8E4vYsMu0ENhfbYbzCyH6bZeyA8NeMg2GLs7k7X/Sb9JO
	 qofUKX7ptiNcinip91dlv5KlMVxBaZq5uAloqSx6W5R91idY7y3Tw/bJFsZUrJOVFu
	 OfeBt8UBGBVctXFopQJywA20oiBtjpUQ9JhOZefbLT5H/utXSSDzHwxePpkLbJVXEz
	 B3EF69C0E3QAzgiEkGPt/u/rp/Ihy8ioV4iJhJ65/i3XI37Fvg2L8dLPKejflYRkrS
	 DAI6Zman1Pkeg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jens Axboe <axboe@kernel.dk>,
	syzbot+6c48db7d94402407301e@syzkaller.appspotmail.com,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 059/752] io_uring/timeout: annotate data race in io_flush_timeouts()
Date: Sat, 28 Feb 2026 12:36:10 -0500
Message-ID: <20260228174750.1542406-59-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
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

[ Upstream commit 42b12cb5fd4554679bac06bbdd05dc8b643bcc42 ]

syzbot correctly reports this as a KCSAN race, as ctx->cached_cq_tail
should be read under ->uring_lock. This isn't immediately feasible in
io_flush_timeouts(), but as long as we read a stable value, that should
be good enough. If two io-wq threads compete on this value, then they
will both end up calling io_flush_timeouts() and at least one of them
will see the correct value.

Reported-by: syzbot+6c48db7d94402407301e@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/timeout.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index 17e3aab0af367..cd42316d0f3c0 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -129,7 +129,7 @@ __cold void io_flush_timeouts(struct io_ring_ctx *ctx)
 	u32 seq;
 
 	raw_spin_lock_irq(&ctx->timeout_lock);
-	seq = ctx->cached_cq_tail - atomic_read(&ctx->cq_timeouts);
+	seq = READ_ONCE(ctx->cached_cq_tail) - atomic_read(&ctx->cq_timeouts);
 
 	list_for_each_entry_safe(timeout, tmp, &ctx->timeout_list, list) {
 		struct io_kiocb *req = cmd_to_io_kiocb(timeout);
-- 
2.51.0

