Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D45422FE18;
	Mon, 10 Mar 2025 17:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626788; cv=none; b=btxGOBLpV8deDeR13MLjb8nvQ4wIf4zhCh74O/M+v5uepbmxRLkX67mmZ2p3O2epzTKjOzzwTNJURzbaa9in5/H/OSVqNoaMdB8FTG2l1C244SPMjh0EmdlivvqLG6RE9MD6jcNQ1w8XxGO3fx3wTXc7ApjNA8ipaHYCaRuwCfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626788; c=relaxed/simple;
	bh=V/4i8PTmmRCspvU63NDAjWKw0JG5/9LX5BHsUsNfY0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZIwCDkcNhsumSus7F7/7t2DhQo8Inc1JtvL4Dth/QBK5827u5aapsWFGeHO8s40nOsnmlMDBCMInedtYFGGJkUpOfd+IUDy7tRJyunGa/H9MtClwg69x2XiZdS4OpWAEGE/b/5s5kAUfmV5EFgyfCdpIpOZ+0dK5WDbBeHqfrjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fjoTNmEo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fjoTNmEo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50D74C4CEE5;
	Mon, 10 Mar 2025 17:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626787;
	bh=V/4i8PTmmRCspvU63NDAjWKw0JG5/9LX5BHsUsNfY0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fjoTNmEoS4SexA5XKz2p7tiA+mmird6IWD3//d0d3e8F3hvMRHtfnnywjrC4S1h5W
	 5lF2odWNohMFt5MmcY0Hj4xe1e6LmT8zide60qqtd7jidm9IHHWK5j6OuNwE7UEe3F
	 +m6iJjQ/8JzkXQGCdks1R0v+TY3M3nK1N3AAEd7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 113/207] perf/core: Fix pmus_lock vs. pmus_srcu ordering
Date: Mon, 10 Mar 2025 18:05:06 +0100
Message-ID: <20250310170452.306963355@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 0e6e16eb2d106..43a44a6e243b1 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -11896,6 +11896,8 @@ void perf_pmu_unregister(struct pmu *pmu)
 {
 	mutex_lock(&pmus_lock);
 	list_del_rcu(&pmu->entry);
+	idr_remove(&pmu_idr, pmu->type);
+	mutex_unlock(&pmus_lock);
 
 	/*
 	 * We dereference the pmu list under both SRCU and regular RCU, so
@@ -11905,7 +11907,6 @@ void perf_pmu_unregister(struct pmu *pmu)
 	synchronize_rcu();
 
 	free_percpu(pmu->pmu_disable_count);
-	idr_remove(&pmu_idr, pmu->type);
 	if (pmu_bus_running && pmu->dev && pmu->dev != PMU_NULL_DEV) {
 		if (pmu->nr_addr_filters)
 			device_remove_file(pmu->dev, &dev_attr_nr_addr_filters);
@@ -11913,7 +11914,6 @@ void perf_pmu_unregister(struct pmu *pmu)
 		put_device(pmu->dev);
 	}
 	free_pmu_context(pmu);
-	mutex_unlock(&pmus_lock);
 }
 EXPORT_SYMBOL_GPL(perf_pmu_unregister);
 
-- 
2.39.5



