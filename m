Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4540E2566
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:36:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBFE0C433D2;
	Tue, 18 Apr 2023 12:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821388;
	bh=cb5aHSoMojPxGhhFtZN/E6stPrQdc9yWM8XqkfR9wCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZoXwT3BYJbRMZ4kSEQLiUkg6rWIisbjNPYf9iawsFqUYG9kimaq+Cp8e3ofweecBR
	 0xaOpTbgQcevb9aTthkc5nwBrJLclRZqLN730RBrOwgT7hBnL7QVA+ZPl4nQTFg8ew
	 We8HVKv6EebCrYOAwdRiqyN5PDOFVaNkkMqn+sZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zgpeng <zgpeng@tencent.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Samuel Liao <samuelliao@tencent.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 107/124] sched/fair: Move calculate of avg_load to a better location
Date: Tue, 18 Apr 2023 14:22:06 +0200
Message-Id: <20230418120313.700527184@linuxfoundation.org>
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
index bb70a7856277f..22139e97b2a8e 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -9342,8 +9342,6 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
 		local->avg_load = (local->group_load * SCHED_CAPACITY_SCALE) /
 				  local->group_capacity;
 
-		sds->avg_load = (sds->total_load * SCHED_CAPACITY_SCALE) /
-				sds->total_capacity;
 		/*
 		 * If the local group is more loaded than the selected
 		 * busiest group don't try to pull any tasks.
@@ -9352,6 +9350,9 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
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



