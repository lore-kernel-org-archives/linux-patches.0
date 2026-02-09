Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ABEC2222B2;
	Mon,  9 Feb 2026 14:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647920; cv=none; b=RWChN1SYbB8OIO4nfy0C8r/FYowyHiitp6kxJR/FE8z0CQRApYwG8gs4HnpBqct6j5/IJaMNGHFru9BwL2aK/Ay+bj2pZzG/oRxeqlGD7R0p5C8WKoIN3yZUuJ96zpE+dYk9GRC6jZqFoUBBruXtPivUBWXrmC8fnQcmFSb67xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647920; c=relaxed/simple;
	bh=LWCKqKTSnY0xaaA+XfKMMcEafSf68vmu+MM8dGjG5Xs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yqz1xYtJwJ6sRWIU3ICBlE4tY1m2CdC4J8jyWuAWIBUu4t9p0yw0liZtHIGdzvpe6DP4zMCON2NQEQwOJ+6M5jsnYFF60skFTxPsZqayX7dvjmERAC+dv3b2GsdDArVlB4b9EzWvK9CSlwaXBLVGKFAb2Tq5CFmZ/k5M9z26BE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JMhOgG9I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JMhOgG9I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9D12C19422;
	Mon,  9 Feb 2026 14:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647920;
	bh=LWCKqKTSnY0xaaA+XfKMMcEafSf68vmu+MM8dGjG5Xs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JMhOgG9IFZFgrMH9gzyllZ87OvQeS0YkdERhkdg0oIfE+3U/WLqhO/XclFmSZ3QiI
	 RTO7bwcJ+mYCbc+s/XFOFa/UzClJ6sO+w2m1qvDOYYaeY0zeZDXL96UaKdCWBBsM8z
	 luCLCkhAee+wj2oSQqjiXu/PYITgg9xn7bgZjj8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai@fnnas.com>,
	shechenglong <shechenglong@xfusion.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 033/113] block,bfq: fix aux stat accumulation destination
Date: Mon,  9 Feb 2026 15:23:02 +0100
Message-ID: <20260209142311.398267587@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
References: <20260209142310.204833231@linuxfoundation.org>
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
index 9fb9f35331502..6a75fe1c7a5c0 100644
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



