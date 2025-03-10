Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535CA233700;
	Mon, 10 Mar 2025 17:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627555; cv=none; b=W56ZuKaChAnt8lyhtXFstViPEVuOsyQpoGL7TdEI7slbDtfzm5xrpHDkjpmXyXULNRNtnw9AXf23f6rFrrDQJK2eSSk1RTZ3alIeEOgUVcdAt3S1o+DwbOUWyb7q6CPxylqHqPSlLTL+BiEmRmlFqqS4NlGV7RingXWt3mTLs/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627555; c=relaxed/simple;
	bh=s5Ty1FrENfhxl/CL0WM7pDOSp+DMG4YASZlo/sOKuto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YAGHnBT5FTj/rNrXBQmHhVXUBIItlIVhOc2fpsIGYyYVCDZDJz3jQTufaMu+4fFnP2zVYwb9xXI56heXoI151ssO/+ZNvRnWliti/8tfFGdh5Q9LBPngf4mLEv0QAHBlFzsqWN00yr4tmXCx+ddAnbkUEbecp6GUyfWkaUnPksc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N1hnTlfm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N1hnTlfm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDCCAC4CEE5;
	Mon, 10 Mar 2025 17:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627555;
	bh=s5Ty1FrENfhxl/CL0WM7pDOSp+DMG4YASZlo/sOKuto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N1hnTlfmk4FEZ/eI1HSssEAnD+AGZ3iAnLIcRfyULoZlmtMIRm4NgtB57Yz1970Em
	 fY3gof0vMdrtQULQf+Zbsg3FxttuzGQCtdCd/z+noDUGSQfwrNKbcKXPHkcfPOGq0Q
	 e82qons+Ip/XBACS8iYqUNiuK5A6aFUWQQIhMJ8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 169/269] perf/core: Fix pmus_lock vs. pmus_srcu ordering
Date: Mon, 10 Mar 2025 18:05:22 +0100
Message-ID: <20250310170504.455428815@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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
index a0e1d2124727e..5fff74c736063 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -11846,6 +11846,8 @@ void perf_pmu_unregister(struct pmu *pmu)
 {
 	mutex_lock(&pmus_lock);
 	list_del_rcu(&pmu->entry);
+	idr_remove(&pmu_idr, pmu->type);
+	mutex_unlock(&pmus_lock);
 
 	/*
 	 * We dereference the pmu list under both SRCU and regular RCU, so
@@ -11855,7 +11857,6 @@ void perf_pmu_unregister(struct pmu *pmu)
 	synchronize_rcu();
 
 	free_percpu(pmu->pmu_disable_count);
-	idr_remove(&pmu_idr, pmu->type);
 	if (pmu_bus_running && pmu->dev && pmu->dev != PMU_NULL_DEV) {
 		if (pmu->nr_addr_filters)
 			device_remove_file(pmu->dev, &dev_attr_nr_addr_filters);
@@ -11863,7 +11864,6 @@ void perf_pmu_unregister(struct pmu *pmu)
 		put_device(pmu->dev);
 	}
 	free_pmu_context(pmu);
-	mutex_unlock(&pmus_lock);
 }
 EXPORT_SYMBOL_GPL(perf_pmu_unregister);
 
-- 
2.39.5



