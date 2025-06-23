Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0E46199FBA;
	Mon, 23 Jun 2025 22:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717346; cv=none; b=Uqmou0wGpoeFujplwgVjrjQeXEzxdyHXYaBZpmkeM1Q80Bn0E0VGpA59duN3wrmgAWPDJqgQSI2hu0Y0YRNXTAp5SQyXbnvUPH/F/bbQMlvrzcCfUn4yTBIJCbMRJmyJ++OU2sNpCtxDYpziDYjuf18d+AK6JDX1soozGVQENrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717346; c=relaxed/simple;
	bh=BX3kON+vbeUcKrYY3hLLwVFbItpoHULu3cqwFNAxv5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eb36afGNilywM30CjkVboG21PmCu1Eo3HHPXji/+Ppg48AzXOCidctV7LtsuXmO9ZJ5ymNsafHruFP6vyR2T28bdHQhKitL/oiGpMIR72SebtMRzxeHnP88xxpJZAoaaB3b2pkCuc2/muR/gruarFyvkhzFdMWtf8xutPNerHls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eq2BShHn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eq2BShHn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C888C4CEEA;
	Mon, 23 Jun 2025 22:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717345;
	bh=BX3kON+vbeUcKrYY3hLLwVFbItpoHULu3cqwFNAxv5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eq2BShHn7AWZrNPQ4mRwWKyMAoFgrE8qFrAUjmnyTA73uzxBsnXZLpcs7Gt8/e0m9
	 /FLTyhWag3uYnjPL3QoeEPQe5NYk7iZhyMdk1PtnAmtebbp3vlYjaXtyaaAVpLooQ8
	 N3lpy7Su5zBYYyqfpbzY8EUmjyyfhhMLElGnvYJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuyi Zhou <zhouchuyi@bytedance.com>,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 370/414] workqueue: Initialize wq_isolated_cpumask in workqueue_init_early()
Date: Mon, 23 Jun 2025 15:08:27 +0200
Message-ID: <20250623130651.207534318@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuyi Zhou <zhouchuyi@bytedance.com>

[ Upstream commit 261dce3d64021e7ec828a17b4975ce9182e54ceb ]

Now when isolcpus is enabled via the cmdline, wq_isolated_cpumask does
not include these isolated CPUs, even wq_unbound_cpumask has already
excluded them. It is only when we successfully configure an isolate cpuset
partition that wq_isolated_cpumask gets overwritten by
workqueue_unbound_exclude_cpumask(), including both the cmdline-specified
isolated CPUs and the isolated CPUs within the cpuset partitions.

Fix this issue by initializing wq_isolated_cpumask properly in
workqueue_init_early().

Fixes: fe28f631fa94 ("workqueue: Add workqueue_unbound_exclude_cpumask() to exclude CPUs from wq_unbound_cpumask")
Signed-off-by: Chuyi Zhou <zhouchuyi@bytedance.com>
Reviewed-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/workqueue.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index a9d64e08dffc7..3c87eb98609c0 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -7731,7 +7731,8 @@ void __init workqueue_init_early(void)
 		restrict_unbound_cpumask("workqueue.unbound_cpus", &wq_cmdline_cpumask);
 
 	cpumask_copy(wq_requested_unbound_cpumask, wq_unbound_cpumask);
-
+	cpumask_andnot(wq_isolated_cpumask, cpu_possible_mask,
+						housekeeping_cpumask(HK_TYPE_DOMAIN));
 	pwq_cache = KMEM_CACHE(pool_workqueue, SLAB_PANIC);
 
 	unbound_wq_update_pwq_attrs_buf = alloc_workqueue_attrs();
-- 
2.39.5



