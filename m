Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3AE02572
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:36:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A66FC433EF;
	Tue, 18 Apr 2023 12:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821390;
	bh=MXeqlNyXA7o7vUB1/hQxXX+F+UIf88IioKWB/+anQDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m6aDHItVBJES8k4ahf/o8n3bJqTom2CdRKSAr3In7QzHbG0/AVpwL6xVicpk9Be2t
	 goO8bzBVgiPplPm2LX7MSG4r5zkuuYuZOrjoSae0XZWu7omklJKuw9/raSG7zZVoy8
	 QZMZNXfvEVcSNRhGRFMDcJVd0H2pbXcrmkKvo9+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tingjia Cao <tjcao980311@gmail.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 108/124] sched/fair: Fix imbalance overflow
Date: Tue, 18 Apr 2023 14:22:07 +0200
Message-Id: <20230418120313.729875424@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120309.539243408@linuxfoundation.org>
References: <20230418120309.539243408@linuxfoundation.org>
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
index 22139e97b2a8e..57a58bc48021a 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -9353,6 +9353,16 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
 
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



