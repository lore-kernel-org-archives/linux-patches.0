Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692C41DE89C;
	Mon, 10 Mar 2025 17:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628118; cv=none; b=PXXoPUWG6NpHYG0LghBOjohtqxFQQ3YtRS7PNhNdf88cHzXkYIU96ctqnue8MKlZuktsn9FVoGbWO39SZT6jZCa/weQfnp7EUS0eJDVmWsyx4LuHb6SApQJfNOEOE4JiimG8Me5wjeTosJLB380NnyH2OuMHxYucD18RcnVa6x0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628118; c=relaxed/simple;
	bh=YvHVFuMMYHhbHMdneNJS7zha00RfUsO5f/tSMo/pSUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uzoRglQZ300kjRxbq6V8Cbnb/qPOoyOnoTQpix6SxBHPBfkYhVwqxWuMCVsXxPEC37mRcooU9PzG011+8qQ1zQS59ifgC12RVkx30aqhBqkHwoN1mZc231nv4neEkfIFjfqMtAa9ldiGtYWvkQd+7sAhRqXpsZiP9VGDtve4M8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B2Z3wxfe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B2Z3wxfe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4D06C4CEE5;
	Mon, 10 Mar 2025 17:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628118;
	bh=YvHVFuMMYHhbHMdneNJS7zha00RfUsO5f/tSMo/pSUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B2Z3wxfeirw6ya70FRz7CD+XuGvLrhLLKr2Wz2JFOwW5UK8o54aGr4NLrIyV0c0LN
	 v8v7xNLLt/pFnUwVqlACP1gS5/SnkZd1cAF5UapaoxO7MBqCsZkutbi2HKOT8AbnuT
	 Le6LOjAA0ahj9j3dGV1Whfo0ktKye7JowBDkoLUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 066/145] perf/core: Fix pmus_lock vs. pmus_srcu ordering
Date: Mon, 10 Mar 2025 18:06:00 +0100
Message-ID: <20250310170437.414791689@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 2565e42539b120b81a68a58da961ce5d1e34eac8 ]

Commit a63fbed776c7 ("perf/tracing/cpuhotplug: Fix locking order")
placed pmus_lock inside pmus_srcu, this makes perf_pmu_unregister()
trip lockdep.

Move the locking about such that only pmu_idr and pmus (list) are
modified while holding pmus_lock. This avoids doing synchronize_srcu()
while holding pmus_lock and all is well again.

Fixes: a63fbed776c7 ("perf/tracing/cpuhotplug: Fix locking order")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20241104135517.679556858@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 4f6b18ecfdb21..4dd8936b5aa09 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -11660,6 +11660,8 @@ void perf_pmu_unregister(struct pmu *pmu)
 {
 	mutex_lock(&pmus_lock);
 	list_del_rcu(&pmu->entry);
+	idr_remove(&pmu_idr, pmu->type);
+	mutex_unlock(&pmus_lock);
 
 	/*
 	 * We dereference the pmu list under both SRCU and regular RCU, so
@@ -11669,7 +11671,6 @@ void perf_pmu_unregister(struct pmu *pmu)
 	synchronize_rcu();
 
 	free_percpu(pmu->pmu_disable_count);
-	idr_remove(&pmu_idr, pmu->type);
 	if (pmu_bus_running && pmu->dev && pmu->dev != PMU_NULL_DEV) {
 		if (pmu->nr_addr_filters)
 			device_remove_file(pmu->dev, &dev_attr_nr_addr_filters);
@@ -11677,7 +11678,6 @@ void perf_pmu_unregister(struct pmu *pmu)
 		put_device(pmu->dev);
 	}
 	free_pmu_context(pmu);
-	mutex_unlock(&pmus_lock);
 }
 EXPORT_SYMBOL_GPL(perf_pmu_unregister);
 
-- 
2.39.5



