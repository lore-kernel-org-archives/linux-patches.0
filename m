Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF3BE2222B2;
	Mon,  9 Feb 2026 14:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648149; cv=none; b=jhfAFVrTt0OPbFuFJll1kioQzyB6GB/AGWtjBaahpCVcYIZF1KOL5znBVyvUJX0+2UW8rkaP1s1bJMs/nnUbfwTbqsVMAdtJkMnUyxDKbvxek+qZHfGWx+hOrrDDDA9QHWkVyb6JD9Agl0PnlYLY+L3JP0RNiIgYMBzp40/TZc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648149; c=relaxed/simple;
	bh=IXN/nawYpygkbdkJec2Wlhv1lBIkSoVVDpN0mTrwEqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NB4Ur+tUg/Dlkvpqf1pIZxTEybD9vFXRWytc3VuKXU5E1TPrLBN9PGInhlxgJI3ncSYHP/MTviQV39a3atguAQcWq8vCIVwZwif0M6DVS3WTq9VfM5FpQy3MzOwpFtLJE8Y6BYXZgj04DDHeKKHyPoEQjq4eg2H4gfUuD8wdRxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0T+HQKyF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0T+HQKyF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF873C116C6;
	Mon,  9 Feb 2026 14:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648149;
	bh=IXN/nawYpygkbdkJec2Wlhv1lBIkSoVVDpN0mTrwEqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0T+HQKyF0FvwmtLTcouDpEAOslXooZyWmeiPaU8J2rkx5k1v/vD0XTyDza+V/uZvm
	 /49rS/3+5s4WGFm/RJT1ERzW6fp+LuGfXxuriZSjWs/ZEV98RR3juG8YkN6m2/wc1Q
	 TleOKornSFSlP26cEIPg54BDR85jC9AAnosqz0mg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai@fnnas.com>,
	shechenglong <shechenglong@xfusion.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 21/69] block,bfq: fix aux stat accumulation destination
Date: Mon,  9 Feb 2026 15:23:49 +0100
Message-ID: <20260209142302.691084083@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142301.913348974@linuxfoundation.org>
References: <20260209142301.913348974@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c202e2527d053..8e2478efd6695 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -382,7 +382,7 @@ static void bfqg_stats_add_aux(struct bfqg_stats *to, struct bfqg_stats *from)
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



