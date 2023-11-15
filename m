Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A763A8F3
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TObX10rG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F58AC433CA;
	Wed, 15 Nov 2023 19:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077955;
	bh=wnuvdXMCj7jNG2rtOAMsejSmcqiUrUXfr9WpGI3OW4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TObX10rGvit6/0bOg5UWDaUfZOReSzli3WldKNY5TkYAjQsUpvHL6OEQIi3ARObhy
	 nS95dRdIIOxwFxvEPOQTEPa67a/RPAwg+c8qiUolVO0/sBEoXZM8HWYSvfV4fLNyGw
	 D73oyRJ4BUByi0zjIuI/m9qo+HvBfQB9MHWFcr8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yu-Chi Liang <ycliang@andestech.com>,
	Chengming Zhou <zhouchengming@bytedance.com>,
	Ingo Molnar <mingo@kernel.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 002/379] sched/fair: Fix cfs_rq_is_decayed() on !SMP
Date: Wed, 15 Nov 2023 14:21:17 -0500
Message-ID: <20231115192645.293350733@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengming Zhou <zhouchengming@bytedance.com>

[ Upstream commit c0490bc9bb62d9376f3dd4ec28e03ca0fef97152 ]

We don't need to maintain per-queue leaf_cfs_rq_list on !SMP, since
it's used for cfs_rq load tracking & balancing on SMP.

But sched debug interface uses it to print per-cfs_rq stats.

This patch fixes the !SMP version of cfs_rq_is_decayed(), so the
per-queue leaf_cfs_rq_list is also maintained correctly on !SMP,
to fix the warning in assert_list_leaf_cfs_rq().

Fixes: 0a00a354644e ("sched/fair: Delete useless condition in tg_unthrottle_up()")
Reported-by: Leo Yu-Chi Liang <ycliang@andestech.com>
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Leo Yu-Chi Liang <ycliang@andestech.com>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Closes: https://lore.kernel.org/all/ZN87UsqkWcFLDxea@swlinux02/
Link: https://lore.kernel.org/r/20230913132031.2242151-1-chengming.zhou@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 612873ec2197f..65cd5c153216c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4585,7 +4585,7 @@ static inline void update_misfit_status(struct task_struct *p, struct rq *rq)
 
 static inline bool cfs_rq_is_decayed(struct cfs_rq *cfs_rq)
 {
-	return true;
+	return !cfs_rq->nr_running;
 }
 
 #define UPDATE_TG	0x0
-- 
2.42.0



