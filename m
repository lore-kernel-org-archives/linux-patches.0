Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E822572
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:41:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7616C433EF;
	Tue, 18 Apr 2023 12:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821669;
	bh=3x6INlL+EyQvHlMmm7eq6/GZXrYaDgUt1YGPrTJfwUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D+M9EBGsK7hJi3YZAuF1B8G3QNvrS77nRUrxuM9HE4ZI+zG9crPT8FP5olJUiOouD
	 lKGGzSNeuOXrOxuxL+zDHV/3OFBo3Uykjz0sSp7B0cusp6iBx2BTfnbfa/4zbWkmtR
	 U2drEuLznUSr72IBcmm3KsMgqyEryZ/mh6Ix1HG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tingjia Cao <tjcao980311@gmail.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 71/91] sched/fair: Fix imbalance overflow
Date: Tue, 18 Apr 2023 14:22:15 +0200
Message-Id: <20230418120308.022151080@linuxfoundation.org>
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

From: Vincent Guittot <vincent.guittot@linaro.org>

[ Upstream commit 91dcf1e8068e9a8823e419a7a34ff4341275fb70 ]

When local group is fully busy but its average load is above system load,
computing the imbalance will overflow and local group is not the best
target for pulling this load.

Fixes: 0b0695f2b34a ("sched/fair: Rework load_balance()")
Reported-by: Tingjia Cao <tjcao980311@gmail.com>
Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Tingjia Cao <tjcao980311@gmail.com>
Link: https://lore.kernel.org/lkml/CABcWv9_DAhVBOq2=W=2ypKE9dKM5s2DvoV8-U0+GDwwuKZ89jQ@mail.gmail.com/T/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 024d18d85526d..7ac00dede846c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -9647,6 +9647,16 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
 
 		sds->avg_load = (sds->total_load * SCHED_CAPACITY_SCALE) /
 				sds->total_capacity;
+
+		/*
+		 * If the local group is more loaded than the average system
+		 * load, don't try to pull any tasks.
+		 */
+		if (local->avg_load >= sds->avg_load) {
+			env->imbalance = 0;
+			return;
+		}
+
 	}
 
 	/*
-- 
2.39.2



