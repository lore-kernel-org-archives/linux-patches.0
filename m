Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1924B1CC14E;
	Tue, 27 Aug 2024 15:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772393; cv=none; b=dondSFz79AuOJxltq4IQKATJ1BuvuwfsvYIeVGVZGhrXBPFzycNvp/+npgsvJYJNYvkHymps1AMSV1mdkemklwZ4d/mubGkxkuI1rTfuenJD2D+o0N9E7TJZeIUvyYz838s/f2kMMyNJz1097L2ekkRZISyZ8PFY3HFKa3G7p0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772393; c=relaxed/simple;
	bh=x6EhfmCMvrVsJav+rzYRP4cxbmcwMAjfY3ccv2cS+yo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rtmM0iImbrPKy5VYNnk85060Du6Dozpg1LVyFvBYm4XD7Ey9hr4Jc58kgxrQdcQLGfSGcP+fHOBlierhsJehfeu3A5OJm4uwlcpOdGpM+9N5Ykvg5LCmFJw3J0/yrdd/8KP1UBP0jIV5IKlY0cm8LbX9e/mpudyXJ3NFkY1016U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o7lTq4fT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o7lTq4fT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95012C4DE14;
	Tue, 27 Aug 2024 15:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772393;
	bh=x6EhfmCMvrVsJav+rzYRP4cxbmcwMAjfY3ccv2cS+yo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o7lTq4fTqhyrBLOt6iSlK0peNBnAAaRmXnImBnhTFP4ObxXCBcTt/ZGz9TYYnSbCD
	 Ff7PuBNIbSz4N/Lhhj51ApFh1V7jWZ95sfTUXeXSqP9chJfGW1Ln/1WvurFSKzmZ2q
	 qezjSptvQGdjfGbD8miBsd6peK/PAECF5htoAe60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Costa Shulyupin <costa.shul@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 170/321] hrtimer: Select housekeeping CPU during migration
Date: Tue, 27 Aug 2024 16:37:58 +0200
Message-ID: <20240827143844.702218237@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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
index 9bb88836c42e6..314fb7598a879 100644
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
@@ -2220,8 +2221,8 @@ static void migrate_hrtimer_list(struct hrtimer_clock_base *old_base,
 
 int hrtimers_cpu_dying(unsigned int dying_cpu)
 {
+	int i, ncpu = cpumask_any_and(cpu_active_mask, housekeeping_cpumask(HK_TYPE_TIMER));
 	struct hrtimer_cpu_base *old_base, *new_base;
-	int i, ncpu = cpumask_first(cpu_active_mask);
 
 	tick_cancel_sched_timer(dying_cpu);
 
-- 
2.43.0



