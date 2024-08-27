Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC31344C8C;
	Tue, 27 Aug 2024 14:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770241; cv=none; b=FIYoA/IBKi1iIPwx9OFSEmFoCuosP4KjUNcOciUnjILCTPwJpq9DWlHWE7feGJwfQjlLMuZ4gLjdAhcLaieUgX9SQEyEW7UA+NqHKKbUhw9bJSedPXHkt/kVP8HIBfogAuzAVJTmnoNI9c03bDiiEwZGQjgRjqC6ZsVUxPtS0gE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770241; c=relaxed/simple;
	bh=/xSYDMAA/dl71aOqmWMZbl5PxXH7dyEfnOdb+sOlD0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GF4xdPbzEYovWemQZpqqB8ZySXitl0NHLtV/W/k2MsHIwPHYAePrcocTCkXhZuKH5SxWnryK1qlDw0z3G5g89GlvKENtO0aHTgDqD1mfiACG4S9rf5/o0uKFBAJtxCESELmFCsQzCpMk8hidT4TWMYj97adUmPt5Xkc+uogBhVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o0Q+ir7w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o0Q+ir7w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53838C4DDFB;
	Tue, 27 Aug 2024 14:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770241;
	bh=/xSYDMAA/dl71aOqmWMZbl5PxXH7dyEfnOdb+sOlD0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o0Q+ir7wgrXe93Tk7PztgrcO+vdhnpGBKJxEeeEhe08GBkXL4Ioyd7kfcwILLzkcp
	 i4AisOJ6Lz1gcIaeihFThlvPoZbJt+Pull5RJEuZ+v2jweNoIpvdBTQ+0rbhDIw+ri
	 QXC0j2qqqSATbykL6YCsqZ1SGtgup1xSlL1uILRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Costa Shulyupin <costa.shul@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 170/341] hrtimer: Select housekeeping CPU during migration
Date: Tue, 27 Aug 2024 16:36:41 +0200
Message-ID: <20240827143849.883298843@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: Costa Shulyupin <costa.shul@redhat.com>

[ Upstream commit 56c2cb10120894be40c40a9bf0ce798da14c50f6 ]

During CPU-down hotplug, hrtimers may migrate to isolated CPUs,
compromising CPU isolation.

Address this issue by masking valid CPUs for hrtimers using
housekeeping_cpumask(HK_TYPE_TIMER).

Suggested-by: Waiman Long <longman@redhat.com>
Signed-off-by: Costa Shulyupin <costa.shul@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Waiman Long <longman@redhat.com>
Link: https://lore.kernel.org/r/20240222200856.569036-1-costa.shul@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/hrtimer.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index edb0f821dceaa..6057fe2e179b0 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -38,6 +38,7 @@
 #include <linux/sched/deadline.h>
 #include <linux/sched/nohz.h>
 #include <linux/sched/debug.h>
+#include <linux/sched/isolation.h>
 #include <linux/timer.h>
 #include <linux/freezer.h>
 #include <linux/compat.h>
@@ -2223,8 +2224,8 @@ static void migrate_hrtimer_list(struct hrtimer_clock_base *old_base,
 
 int hrtimers_cpu_dying(unsigned int dying_cpu)
 {
+	int i, ncpu = cpumask_any_and(cpu_active_mask, housekeeping_cpumask(HK_TYPE_TIMER));
 	struct hrtimer_cpu_base *old_base, *new_base;
-	int i, ncpu = cpumask_first(cpu_active_mask);
 
 	tick_cancel_sched_timer(dying_cpu);
 
-- 
2.43.0



