Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E50228371
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GC9GaLj5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E26F3C433C9;
	Wed, 15 Nov 2023 19:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076027;
	bh=SuHBy7E/NykkDtC6n19gCdulU5oaKDv7JLs8pq2REQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GC9GaLj5UF4Dw42UMLAt65poD7yNSBtcKmO/nLN38Tl/Jjh12hHgjbt16w0kkZU0g
	 E4YFS3EfNqawvpManJ9NbtFLe0aq16b0h/CfC0T4o1y6KpQ0tetWQgRY3qSXdOwuOb
	 kPW/3JV1HsoSjXl8FVLW/ZKX/zFMGvv8MVtnxRH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yu-Chi Liang <ycliang@andestech.com>,
	Chengming Zhou <zhouchengming@bytedance.com>,
	Ingo Molnar <mingo@kernel.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 005/550] sched/fair: Fix cfs_rq_is_decayed() on !SMP
Date: Wed, 15 Nov 2023 14:09:49 -0500
Message-ID: <20231115191601.087096401@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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
index 1d9c2482c5a35..7e3ed4f447fdf 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4654,7 +4654,7 @@ static inline void update_misfit_status(struct task_struct *p, struct rq *rq)
 
 static inline bool cfs_rq_is_decayed(struct cfs_rq *cfs_rq)
 {
-	return true;
+	return !cfs_rq->nr_running;
 }
 
 #define UPDATE_TG	0x0
-- 
2.42.0



