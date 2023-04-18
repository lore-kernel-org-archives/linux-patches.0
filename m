Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61A122572
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:40:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9C44C433EF;
	Tue, 18 Apr 2023 12:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821640;
	bh=W0Naz6NOIlH4aotutUfRy/ygGu83YJSolibwdpWp9gw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1SJoJNhjylfJ9IwPcoVcjNB+2TDlo7U09mPSQHNFrB7wGNs4SsQuhg8/mC52N3hLE
	 JmZikIVCx5RQomkcy7d4FNeBv/vvUXPc8y9OItPl+fz0cCyneF4EWKloLdPNd4VM1s
	 DJJ8hyc/W4MoCxk+TVSAXYEaHai7KUldZd3O1QHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zgpeng <zgpeng@tencent.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Samuel Liao <samuelliao@tencent.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 70/91] sched/fair: Move calculate of avg_load to a better location
Date: Tue, 18 Apr 2023 14:22:14 +0200
Message-Id: <20230418120307.987870275@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120305.520719816@linuxfoundation.org>
References: <20230418120305.520719816@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: zgpeng <zgpeng.linux@gmail.com>

[ Upstream commit 06354900787f25bf5be3c07a68e3cdbc5bf0fa69 ]

In calculate_imbalance function, when the value of local->avg_load is
greater than or equal to busiest->avg_load, the calculated sds->avg_load is
not used. So this calculation can be placed in a more appropriate position.

Signed-off-by: zgpeng <zgpeng@tencent.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Samuel Liao <samuelliao@tencent.com>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Link: https://lore.kernel.org/r/1649239025-10010-1-git-send-email-zgpeng@tencent.com
Stable-dep-of: 91dcf1e8068e ("sched/fair: Fix imbalance overflow")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 8f5a5e72bdb3e..024d18d85526d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -9636,8 +9636,6 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
 		local->avg_load = (local->group_load * SCHED_CAPACITY_SCALE) /
 				  local->group_capacity;
 
-		sds->avg_load = (sds->total_load * SCHED_CAPACITY_SCALE) /
-				sds->total_capacity;
 		/*
 		 * If the local group is more loaded than the selected
 		 * busiest group don't try to pull any tasks.
@@ -9646,6 +9644,9 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
 			env->imbalance = 0;
 			return;
 		}
+
+		sds->avg_load = (sds->total_load * SCHED_CAPACITY_SCALE) /
+				sds->total_capacity;
 	}
 
 	/*
-- 
2.39.2



