Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 309D02E338F;
	Tue, 15 Jul 2025 13:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586730; cv=none; b=ql8fpw4IgB3U408eVwAX9HfYKvpg4Efju8uQ9q1w+AHhC6SSAL0vWt/7z0905/Kf/2gJfDU9znBNlnZwTEsdyqPvK5Ra+9ps7jW8xCHWNq0YHy9fFr+Vy+s3i3S//ZmUZkyNZarC8kSgbv5Pxs6ma2JnTtXlGAOBVwzlp83QIsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586730; c=relaxed/simple;
	bh=+PdRjk7Hyoyd+VyX+xd5LNrNcA3dhrr92gyh8W7DEfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jhpGHiTLJ5QCw+r01EFx7LchTNOSUG4GWwW5OMEMVskmsrrMlsjh1CFt6H7YOKDwASpkyVDaYTHXVa27nBMg5cujmX+IrM8bf5EVioHTmItmDGX5RyiomQqKIcclQVaZXuQKCRlPCOb6cj4Q8Hm+PLy3qp61jpiOiSbaMNU/z+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NrqtQzKp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NrqtQzKp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7197C4CEE3;
	Tue, 15 Jul 2025 13:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586730;
	bh=+PdRjk7Hyoyd+VyX+xd5LNrNcA3dhrr92gyh8W7DEfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NrqtQzKp93P2kBn/GW+e837PYYj4Sdhvk8if+BX4Jpuvz2No/2O4oeixavjwQq52B
	 V9UqJCyX0v5USWeiz7f1Yrv1MXHn+ksxkavwAyX6OceVBRjXWDRpVBh88nbdhyRkVR
	 ADpoR4IMWpyYyf3zqD+Og+LKdRPlhgWbRqlmAai4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luo Gengkun <luogengkun@huaweicloud.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 009/192] perf/core: Fix the WARN_ON_ONCE is out of lock protected region
Date: Tue, 15 Jul 2025 15:11:44 +0200
Message-ID: <20250715130815.234114429@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luo Gengkun <luogengkun@huaweicloud.com>

[ Upstream commit 7b4c5a37544ba22c6ebe72c0d4ea56c953459fa5 ]

commit 3172fb986666 ("perf/core: Fix WARN in perf_cgroup_switch()") try to
fix a concurrency problem between perf_cgroup_switch and
perf_cgroup_event_disable. But it does not to move the WARN_ON_ONCE into
lock-protected region, so the warning is still be triggered.

Fixes: 3172fb986666 ("perf/core: Fix WARN in perf_cgroup_switch()")
Signed-off-by: Luo Gengkun <luogengkun@huaweicloud.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20250626135403.2454105-1-luogengkun@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 2d1131e2cfc02..53d2457f5c08a 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -951,8 +951,6 @@ static void perf_cgroup_switch(struct task_struct *task)
 	if (READ_ONCE(cpuctx->cgrp) == NULL)
 		return;
 
-	WARN_ON_ONCE(cpuctx->ctx.nr_cgroups == 0);
-
 	cgrp = perf_cgroup_from_task(task, NULL);
 	if (READ_ONCE(cpuctx->cgrp) == cgrp)
 		return;
@@ -964,6 +962,8 @@ static void perf_cgroup_switch(struct task_struct *task)
 	if (READ_ONCE(cpuctx->cgrp) == NULL)
 		return;
 
+	WARN_ON_ONCE(cpuctx->ctx.nr_cgroups == 0);
+
 	perf_ctx_disable(&cpuctx->ctx, true);
 
 	ctx_sched_out(&cpuctx->ctx, NULL, EVENT_ALL|EVENT_CGROUP);
-- 
2.39.5



