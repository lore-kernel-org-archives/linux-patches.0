Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE42349AE6;
	Wed, 20 May 2026 16:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294522; cv=none; b=ZW0mVb1mfYLxELj/ccLPSHT4aPffR0SjTUSWQgqPfsf+FFXeN+NsVIRqg/WcJeE5hxHFn8Ruvudrlk6vn5UGLlbBgVXwa/AcxiAE/RLomTg0MgzwhwE54yhGk6DG9lFU5cDHasEmcyPBh66wCOFdpU9atYJhGNMGJWnX57TREoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294522; c=relaxed/simple;
	bh=2uHg12NYZAPjSSNvsi1yy8y7FlGKD+2ZisPR5ghxVfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T2TNjk5qwhVX5KwBQjuI4Qn0ZHrn5QX5iGvfH9Zzo0odNjLD1UlIe040bc8DVCkhNIErQl+9tlv40Qhcv1KKEPzUH8X1h/HUoKwmSMzCC3XYMQ0otn2bdClRfsecqzClp0zztjFd+FCmmhhoSv5vSMMrRMFNi5/L8Kj0S8IkUCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E7hUqPiG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E7hUqPiG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88F221F00894;
	Wed, 20 May 2026 16:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294519;
	bh=8FLsqtkZWouewFdxRnq9/DGRCsU/xodzlckR07jrxvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E7hUqPiG4RkG0DHWZxShhHF0HSGv7LfgUu13SWjv2u3zBS/uOWhanSkYcorZyTTYL
	 pXepUjZpf91QAyVTJvTHAx2M+G+kmss8er04PryBlMWYIQ9iqndG26xmCAs/x8HXym
	 +zt6TluB13zFufysI89AYAU/86spTj7J3/nSopdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0069/1146] sched/rt: Skip group schedulable check with rt_group_sched=0
Date: Wed, 20 May 2026 18:05:19 +0200
Message-ID: <20260520162149.921042191@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Koutný <mkoutny@suse.com>

[ Upstream commit 8b016dcec9365675be81d26be88f2c09cf983bd4 ]

The warning from the commit 87f1fb77d87a6 ("sched: Add RT_GROUP WARN
checks for non-root task_groups") is wrong -- it assumes that only
task_groups with rt_rq are traversed, however, the schedulability check
would iterate all task_groups even when rt_group_sched=0 is disabled at
boot time but some non-root task_groups exist.

The schedulability check is supposed to validate:
  a) that children don't overcommit its parent,
  b) no RT task group overcommits global RT limit.
but with rt_group_sched=0 there is no (non-trivial) hierarchy of RT groups,
therefore skip the validation altogether. Otherwise, writes to the
global sched_rt_runtime_us knob will be rejected with incorrect
validation error.

This fix is immaterial with CONFIG_RT_GROUP_SCHED=n.

Fixes: 87f1fb77d87a6 ("sched: Add RT_GROUP WARN checks for non-root task_groups")
Signed-off-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260323-sched-rert_groups-v3-1-1e7d5ed6b249@suse.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/rt.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 87462d889f199..0cbee031858a5 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -2685,9 +2685,6 @@ static int tg_rt_schedulable(struct task_group *tg, void *data)
 	    tg->rt_bandwidth.rt_runtime && tg_has_rt_tasks(tg))
 		return -EBUSY;
 
-	if (WARN_ON(!rt_group_sched_enabled() && tg != &root_task_group))
-		return -EBUSY;
-
 	total = to_ratio(period, runtime);
 
 	/*
@@ -2831,6 +2828,8 @@ long sched_group_rt_period(struct task_group *tg)
 static int sched_rt_global_constraints(void)
 {
 	int ret = 0;
+	if (!rt_group_sched_enabled())
+		return ret;
 
 	mutex_lock(&rt_constraints_mutex);
 	ret = __rt_schedulable(NULL, 0, 0);
-- 
2.53.0



