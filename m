Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB5C42BCF4C;
	Mon,  9 Feb 2026 14:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648706; cv=none; b=gaS8eX0XfxWGUMW4xoLFWWCdBjhpCmNpXzChxELIQcunvSJ4JtdTGit2CbjBgJXkiSMbNVx995jIC/0zrWxPKHIi5Fqz4TRjDF/LRX7FJSRZv5+iwB/XmzMDPPPM6iHIzZdhTVY6KWZH/7MQE8w/rtr+R/c7TF8z0IGOFc//I0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648706; c=relaxed/simple;
	bh=+47BFnW/npC+im4jUNWDN5Uq2WudY8Wu+J2vnBMxtxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S4fRxOHYMa8Kp9yuuR9bwKxAk7Ra1p9ZWfSn8bnqdJy9uBwMF2UVt3T6pf0bFr8D32mk8lYmprkYPQ5Xgrjue2PvXO9ZDSFRsZJp27H/2YpMT1w1P8+GQ6YGTP1rm3at9wtji0YdqyYPGKyP3gvbrst+z5Jzjd9GNUs2/VJFpzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=seGEbbzv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="seGEbbzv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE8FDC116C6;
	Mon,  9 Feb 2026 14:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648706;
	bh=+47BFnW/npC+im4jUNWDN5Uq2WudY8Wu+J2vnBMxtxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=seGEbbzv1pYTedCSSys8mLTZQyLqibwzGeUVHv9yIgIwAKOgYqODGADR/qDrt5nqW
	 rc5+ZJjPDGeVEWyOnA+/of36tLzdxBVA11QYyvfNCAsUenpLkc7cn00RHFLSjL/gkr
	 WqG8nGpoQdxe/okMgWedEoarHGILZ3Mk+xFv0tqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai@fnnas.com>,
	shechenglong <shechenglong@xfusion.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 09/41] block,bfq: fix aux stat accumulation destination
Date: Mon,  9 Feb 2026 15:24:30 +0100
Message-ID: <20260209142257.140724596@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142256.797267956@linuxfoundation.org>
References: <20260209142256.797267956@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 1f9ccc661d574..14341376702e6 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -387,7 +387,7 @@ static void bfqg_stats_add_aux(struct bfqg_stats *to, struct bfqg_stats *from)
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



