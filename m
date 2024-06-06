Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BF7119A2A7;
	Thu,  6 Jun 2024 14:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683016; cv=none; b=DDBITisMsv4g0NjUmNz1jyUhwnD2ZYB0LZU5B4wK3evuTFUyEisHxDBZ7bwa+YfbKcDLrlEPkk99FfhYDbDVla4jRG0L0mX52Owm2O8qrfQHksjvMghXoLyr9OJqc3oRHUt62byFy6cBGl+M9ynkEnDSn0DX4vVqLEF2hohjjtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683016; c=relaxed/simple;
	bh=GkllS0O51hHRP7YI9PqwSTia7AsI13fENTq/cJJX6v8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n8H1z3RXhOmgicCB8D58L2xD2p4aT1496Me92q6SHZCCksOf6R9CNkt7swgu5aAQAv51eBCxHQBlSJMlEgPcTBwkBE7wYpNfV8PnyaktW8moKeTmc6tUddjNX90S7d+s6tVk0xWBj1SZgPHbeY8EfDmRRfwzpe5kLN6jBaSZUdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pF92vaJk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pF92vaJk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BFC2C32781;
	Thu,  6 Jun 2024 14:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683016;
	bh=GkllS0O51hHRP7YI9PqwSTia7AsI13fENTq/cJJX6v8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pF92vaJkOGI3AGTyv7757zjqIckcpm1Rcf0sXcmgAonF6yYboTmzLLVDf6hgO0pde
	 EvVk4+4+HdXiebJ9ihT+lOHdSLIl8pBfB+8Y01/o8LH7hVRVT9n/DnxNtkHFdLM3je
	 RmQtCYQSZO65eJEd7BvNSfRw1vWc/eJa+bgjRqKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 226/374] blk-cgroup: fix list corruption from reorder of WRITE ->lqueued
Date: Thu,  6 Jun 2024 16:03:25 +0200
Message-ID: <20240606131659.373989414@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit d0aac2363549e12cc79b8e285f13d5a9f42fd08e ]

__blkcg_rstat_flush() can be run anytime, especially when blk_cgroup_bio_start
is being executed.

If WRITE of `->lqueued` is re-ordered with READ of 'bisc->lnode.next' in
the loop of __blkcg_rstat_flush(), `next_bisc` can be assigned with one
stat instance being added in blk_cgroup_bio_start(), then the local
list in __blkcg_rstat_flush() could be corrupted.

Fix the issue by adding one barrier.

Cc: Tejun Heo <tj@kernel.org>
Cc: Waiman Long <longman@redhat.com>
Fixes: 3b8cc6298724 ("blk-cgroup: Optimize blkcg_rstat_flush()")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20240515013157.443672-3-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-cgroup.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 86752b1652b5b..b36ba1d40ba1d 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1036,6 +1036,16 @@ static void __blkcg_rstat_flush(struct blkcg *blkcg, int cpu)
 		struct blkg_iostat cur;
 		unsigned int seq;
 
+		/*
+		 * Order assignment of `next_bisc` from `bisc->lnode.next` in
+		 * llist_for_each_entry_safe and clearing `bisc->lqueued` for
+		 * avoiding to assign `next_bisc` with new next pointer added
+		 * in blk_cgroup_bio_start() in case of re-ordering.
+		 *
+		 * The pair barrier is implied in llist_add() in blk_cgroup_bio_start().
+		 */
+		smp_mb();
+
 		WRITE_ONCE(bisc->lqueued, false);
 
 		/* fetch the current per-cpu values */
-- 
2.43.0



