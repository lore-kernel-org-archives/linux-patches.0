Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA6B52E2F03;
	Tue, 15 Jul 2025 13:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585481; cv=none; b=IfVqIUv1Lb/EKI9dSGQhcF4LgnTBCL2/45l1YiQ4fU1kDN/qY1p1jczCaW5Z7gI0XmehNVf0Ch+z+0e8s55UKoDZtLF2yXKZOfajONZkPyynW2Tle4860IKC8oI1B+nG+iUefwGOA0xmTvUhcL9M618X+jT1wxXWMjSJ7A7lBCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585481; c=relaxed/simple;
	bh=H9TlCFTGi0j8dkaUS88U6jlwngGh5pEyo978ZTrOwhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UGId6Gm+4d9M12uo9EJmRb50M+oxZixzQuAAQdw6q1H7lZXgSL2YNRtadorO7NO6LX79ojLUHMed2vFT9oQ+k6AuUtxh03aYoqY2pFYQ53cFIiVrFEsL3KLIvcHctK+o8x/l8UcTVhsy4TXdoctdGaKnjopj2WwEJALN/K45mBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MysEzh5X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MysEzh5X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D559C4CEE3;
	Tue, 15 Jul 2025 13:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585481;
	bh=H9TlCFTGi0j8dkaUS88U6jlwngGh5pEyo978ZTrOwhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MysEzh5XSN6emD6SwkvUGq53J3TjHud/DkWUnZBRtM53C9DP/XyOQAT6OjBCh9HCk
	 zGID9GLKh56HP3fquxQJTjMdb3H5iuPaD7JftPiixQtzyaDCeMN2R2y9An/ZPrvyth
	 lKP/XOI4CetjeOLbzhOiENx170tOYzfc7CyQ0l98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luo Gengkun <luogengkun@huaweicloud.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 015/163] perf/core: Fix the WARN_ON_ONCE is out of lock protected region
Date: Tue, 15 Jul 2025 15:11:23 +0200
Message-ID: <20250715130809.384836464@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
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
index 7210104b3345c..55c19a0d3a814 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -905,8 +905,6 @@ static void perf_cgroup_switch(struct task_struct *task)
 	if (READ_ONCE(cpuctx->cgrp) == NULL)
 		return;
 
-	WARN_ON_ONCE(cpuctx->ctx.nr_cgroups == 0);
-
 	cgrp = perf_cgroup_from_task(task, NULL);
 	if (READ_ONCE(cpuctx->cgrp) == cgrp)
 		return;
@@ -918,6 +916,8 @@ static void perf_cgroup_switch(struct task_struct *task)
 	if (READ_ONCE(cpuctx->cgrp) == NULL)
 		return;
 
+	WARN_ON_ONCE(cpuctx->ctx.nr_cgroups == 0);
+
 	perf_ctx_disable(&cpuctx->ctx, true);
 
 	ctx_sched_out(&cpuctx->ctx, NULL, EVENT_ALL|EVENT_CGROUP);
-- 
2.39.5



