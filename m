Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B1E519E0C;
	Thu, 17 Sep 2026 17:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664652; cv=none; b=QCDYXlmK1Yj072NV4+rwsMEjx31ykkcpk6Ju1WlNw05SHYFHKTItQynzOTteWtXPheez5JaegWyfMqG0D01y5Oz9GD271MRC/+EVn2X2aNwlFPCVLPuYY1y9zo5tcnfIPM+Xo0YQNCnvWXF1At+F0LcgU4kjdsTSIcMdRZcBmko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664652; c=relaxed/simple;
	bh=SiXVV2F3ZkiGK5UKKSLGXCWXAHjMyHYF6CT+Xe2VYjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lpJjUG8OqTKvXCeEdiRoQK5eOY59hwIkHpm+4mpI9cblHOddo3gEvE1dFq/C7i/M8cj4RaY2iOrXsV92ilRcazsZalW2JY57TxJCGt9QOHodKRnetDHWUXMGx43rMDXOn4AidebMQ8Qnb+EIL64+b6VQLfG98TX6/vzS9TVOPrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pEB1k/SZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pEB1k/SZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80DA81F000FF;
	Thu, 17 Sep 2026 17:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664651;
	bh=1bLUefknMK0hVa4ldh3cFKQHyhbCnMT1S5u7rA67vDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pEB1k/SZYk/ZEIroQVinmwaSDbuiUIvfKryFBB1IOmIbvzPZ44Ld9FxJmX6Opf8Tn
	 41aybrKGMeHWoiDySCj2UhY3rOSKtyyFzdO600b44bmQ19QjdzAYEYDCu1zMtnH+nh
	 vCKyyCeORQkVmNoqVkwYf1O71bnoB342ewRO/AXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jia Jie <jiajie.lee@starlabs.sg>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0444/1250] perf: Fix addr_filter_ranges lifetime
Date: Thu, 17 Sep 2026 16:03:59 +0100
Message-ID: <20260917151604.037070119@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit e62d4192e593630f355094adc467058a05bdc935 ]

Lee Jia Jie reported that since event::addr_filter_ranges is used
under RCU, it should be RCU freed.

Reported-by: Lee Jia Jie <jiajie.lee@starlabs.sg>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 76d048a488270..b3bdb23106f37 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5168,6 +5168,7 @@ static void free_event_rcu(struct rcu_head *head)
 	if (event->ns)
 		put_pid_ns(event->ns);
 	perf_event_free_filter(event);
+	kfree(event->addr_filter_ranges);
 	kmem_cache_free(perf_event_cache, event);
 }
 
@@ -5614,8 +5615,6 @@ static void __free_event(struct perf_event *event)
 	if (event->attach_state & PERF_ATTACH_CALLCHAIN)
 		put_callchain_buffers();
 
-	kfree(event->addr_filter_ranges);
-
 	if (event->attach_state & PERF_ATTACH_EXCLUSIVE)
 		exclusive_event_destroy(event);
 
-- 
2.53.0



