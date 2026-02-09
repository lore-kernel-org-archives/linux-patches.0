Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C092BCF4C;
	Mon,  9 Feb 2026 14:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648511; cv=none; b=ozzttq7ysMGygMeMD16SVEhwknln6USPNgofOQju9LIKcykPtMb8sX/Rh4i/Mf4QYZzYzPRMcwSYpvN9SJAJ2RWO4jDFFD4c2Doh9pHbV4UW03Pn8NpZOcBJfOHCRZT59oWQC7TP9Nn11UveaDsgHGX/CEn9EwtYu38fcAN/iQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648511; c=relaxed/simple;
	bh=fINvjAwyB3GX8XTPYMivK5NYFaEIxb5RRg9v7okxL2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O/+WljIQUF870AqZLBN90ijdG9hRV+xwXxw3aYb8dKOPYeXw64LRg4AjzIjckHD4K3hbQHX5E+Ufgqjv/QuraJPsuver2YiURUiZehMW0qVZpkYNKXHlSJwnPhT3cO/6PANc8kk0cvP2TUu92lVtWKBGvC3BnGBjwS+CgbunLN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sE4hh15j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sE4hh15j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AACA8C116C6;
	Mon,  9 Feb 2026 14:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648511;
	bh=fINvjAwyB3GX8XTPYMivK5NYFaEIxb5RRg9v7okxL2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sE4hh15jhgNFU9BLXle1bVVDq7E/0reiGTJFXv5cI7Yr4ESXe9eUIkvRHzIG7c655
	 k0ULH4zBUmJjxOS0Acw1vOvT+dxZq7v/yOJP46+k+RZusatTA99GeiWuD5mtrCkRrT
	 X+vQVvIivWcQyKggTCojlxCwfZlBGyHtGO/8q9kw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai@fnnas.com>,
	shechenglong <shechenglong@xfusion.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 25/86] block,bfq: fix aux stat accumulation destination
Date: Mon,  9 Feb 2026 15:23:48 +0100
Message-ID: <20260209142305.692274941@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142304.770150175@linuxfoundation.org>
References: <20260209142304.770150175@linuxfoundation.org>
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

From: shechenglong <shechenglong@xfusion.com>

[ Upstream commit 04bdb1a04d8a2a89df504c1e34250cd3c6e31a1c ]

Route bfqg_stats_add_aux() time accumulation into the destination
stats object instead of the source, aligning with other stat fields.

Reviewed-by: Yu Kuai <yukuai@fnnas.com>
Signed-off-by: shechenglong <shechenglong@xfusion.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bfq-cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index 2c90e5de0acd9..cb2a381193d13 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -380,7 +380,7 @@ static void bfqg_stats_add_aux(struct bfqg_stats *to, struct bfqg_stats *from)
 	blkg_rwstat_add_aux(&to->merged, &from->merged);
 	blkg_rwstat_add_aux(&to->service_time, &from->service_time);
 	blkg_rwstat_add_aux(&to->wait_time, &from->wait_time);
-	bfq_stat_add_aux(&from->time, &from->time);
+	bfq_stat_add_aux(&to->time, &from->time);
 	bfq_stat_add_aux(&to->avg_queue_size_sum, &from->avg_queue_size_sum);
 	bfq_stat_add_aux(&to->avg_queue_size_samples,
 			  &from->avg_queue_size_samples);
-- 
2.51.0



