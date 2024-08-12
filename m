Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C95E0183CA6;
	Mon, 12 Aug 2024 16:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479807; cv=none; b=tAKvDBzS25y8GQMjgbgJPbN8DecXEGTdIUGP8107IgAr0vm+em/jK9AqDKlBMe+0HzTZqC1dPTrO7czhBVS4g/R5nXSpVSCgv+ycBYtNrjJToVcipfdW7InIGvMWVMyVggKvy4QOxiA7xiArwJmngDtSutFxZY188wBY/9pU+Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479807; c=relaxed/simple;
	bh=Q95F1W2qq60hEXPla5iz6VrDQBmgPG3RL3Q+q3zcxRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BjnAd1ke5vllbKA/jIyPD4oKgkDl4xLOc2rwo88K0Fru0bF6IXCrvAYeh9uxINxWnWlLrshJiqhrZuR7IZEWRlsMxJK9XoEkrjrE917ALfrBraGg4igQNauIasswAAyIfQ2pFOdjKMWR4Z9E8hMRl++GjZlp+eYGNBf3koxbDMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EvxEwISL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EvxEwISL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05BA6C32782;
	Mon, 12 Aug 2024 16:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479807;
	bh=Q95F1W2qq60hEXPla5iz6VrDQBmgPG3RL3Q+q3zcxRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EvxEwISLsX+DTs18069cyxmRsYj66+5QxMiupTqmsO5rtZAz4WJkoNbmQvk6t/ZzK
	 WzIoQQFD9fmUg1JiecKxpZqBkLLbekzeYnMrVmX0IpW1h+5k1oLGUXVf5Rf7fk6cup
	 T6Ix5HHRZ9RNiXmcV1gfQTBM1lK96DSKKVMJiyQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yang Yingliang <yangyingliang@huawei.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.6 160/189] sched/core: Fix unbalance set_rq_online/offline() in sched_cpu_deactivate()
Date: Mon, 12 Aug 2024 18:03:36 +0200
Message-ID: <20240812160138.300787886@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

commit fe7a11c78d2a9bdb8b50afc278a31ac177000948 upstream.

If cpuset_cpu_inactive() fails, set_rq_online() need be called to rollback.

Fixes: 120455c514f7 ("sched: Fix hotplug vs CPU bandwidth control")
Cc: stable@kernel.org
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20240703031610.587047-5-yangyingliang@huaweicloud.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -9773,6 +9773,7 @@ int sched_cpu_deactivate(unsigned int cp
 	ret = cpuset_cpu_inactive(cpu);
 	if (ret) {
 		sched_smt_present_inc(cpu);
+		sched_set_rq_online(rq, cpu);
 		balance_push_set(cpu, false);
 		set_cpu_active(cpu, true);
 		sched_update_numa(cpu, true);


