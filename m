Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F0812D1F1;
	Tue, 30 Apr 2024 11:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475695; cv=none; b=Wlk9fy79imf51ZVhYyIz4TwtAoMcrqgcBapoBCT5XfQ9kxO+hdHw5Uzp2uuq+vu1Aqv/H/NQuKPuqzNJI1Che/2yX6CVqC8nlAOKOnURg8kVTpPA3WTAv/++TB7uFFnTlBQ7ag+ldw+LzHS2Dpi1gAao7Vfiza4oZC+fmhyUUeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475695; c=relaxed/simple;
	bh=6p7SbYZRNIg5HspxSLEw8kG1XSIZJKS+Fzvr93uew/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=px0+dvrzKhGMC4P9tFTAQerc1y6Ub5YfmiGCdAqYiTySakElvT65/5TdRwY/C2AuI5Y/8bqqFLfQNg3JjIL6pcHqAHHbz3a/YkMoppwLSXn3VLc8nhZUfk2w5q2TVg2fak7G+3Rh/q2BViVT65kRVHuPu7GF1s1SR5cLmiNkylo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RbJRCW9F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RbJRCW9F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B59DCC2BBFC;
	Tue, 30 Apr 2024 11:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475695;
	bh=6p7SbYZRNIg5HspxSLEw8kG1XSIZJKS+Fzvr93uew/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RbJRCW9FaiqCKW8X/lXWsWT54J85Rk/x0kQFafxS192zmiGJLf2BtkwiW04lpJ5O0
	 NvddDSX8W2STno8z9ChE4LC+APNGmGpSVeukRz6SXtFk80JRMrM4hJKbkT2MwwSC3C
	 /OIMMt9MviFXylsied0BiDE46JsTYZte7idICWJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Wu <wuyun.abel@bytedance.com>,
	Tianchen Ding <dtcccc@linux.alibaba.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Chen Yu <yu.c.chen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 176/186] sched/eevdf: Always update V if se->on_rq when reweighting
Date: Tue, 30 Apr 2024 12:40:28 +0200
Message-ID: <20240430103103.140388045@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tianchen Ding <dtcccc@linux.alibaba.com>

[ Upstream commit 11b1b8bc2b98e21ddf47e08b56c21502c685b2c3 ]

reweight_eevdf() needs the latest V to do accurate calculation for new
ve and vd. So update V unconditionally when se is runnable.

Fixes: eab03c23c2a1 ("sched/eevdf: Fix vruntime adjustment on reweight")
Suggested-by: Abel Wu <wuyun.abel@bytedance.com>
Signed-off-by: Tianchen Ding <dtcccc@linux.alibaba.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Abel Wu <wuyun.abel@bytedance.com>
Tested-by: K Prateek Nayak <kprateek.nayak@amd.com>
Tested-by: Chen Yu <yu.c.chen@intel.com>
Link: https://lore.kernel.org/r/20240306022133.81008-2-dtcccc@linux.alibaba.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 69fe62126a28e..71e7cf6f77f65 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3740,9 +3740,8 @@ static void reweight_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
 
 	if (se->on_rq) {
 		/* commit outstanding execution time */
-		if (curr)
-			update_curr(cfs_rq);
-		else
+		update_curr(cfs_rq);
+		if (!curr)
 			__dequeue_entity(cfs_rq, se);
 		update_load_sub(&cfs_rq->load, se->load.weight);
 	}
-- 
2.43.0



