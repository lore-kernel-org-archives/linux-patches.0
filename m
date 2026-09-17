Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 154F15AEC6C;
	Thu, 17 Sep 2026 15:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658999; cv=none; b=LGspamGh71tUL8F1QcSNKDm9xqtjXbyO5wwVxfF3jXTKcUWFft3u5xSpVnGEK31WafFNcoDeWJdnaME+xr9Awm4sN+c30FQ3jlJmghRHVSGXqo+iBOBf2KF5UCBJc9pQzcWC988sDE26ECO1Qm+A/WN5g4g8glPE3lMNnVQnjrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658999; c=relaxed/simple;
	bh=oG+2Y5/z7LdiXPg6SI584t72BUysCRR2sDoOYGUG0+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LRU1lPkjNA1tyOrCcQ5O361gw8JmRUoaGbwyLgrDy9/D0LYzpn1t1YQZCp/5FYPREr1TexYYxo8rcPN7sqjihW+6qjVBT2W7IDDlToee2C7bF2B4MriIyKYjPlJ6d4Mf7q98iGRHnAWi6MidLg/pKei4SPnqb+4HDKiGQDcKpV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=seere7Vr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="seere7Vr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3213B1F00899;
	Thu, 17 Sep 2026 15:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658989;
	bh=eOSUecdrO//LNFJ9+nssSHFEJbCU5nHVjSR6KdhhANw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=seere7Vrgwsrr5W2ffDZ0K4bhk/sPGWjJXD3JDJRsRY5I2DkyLTM5aU5VTnuTXc+z
	 BQmtb3HuT4ve6yrmKrGNmZZv3VXNNQe2PK5s361GyAMrsxbfUawN7rD1bD//gm+mLO
	 MmpiMS1SYHRRoLnXlvI0q/2jiBceLS5Gdr9EO6zE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wanwu Li <liwanwu@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 106/733] sched_ext: Fix vtime delta loss in scx_flatcg cgroup migration
Date: Thu, 17 Sep 2026 16:06:54 +0100
Message-ID: <20260917151353.609958186@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wanwu Li <liwanwu@kylinos.cn>

[ Upstream commit b6ee92d7f7f0498d1f776d0b125a2f6bcedf0891 ]

fcg_cgroup_move() lost the signed vtime offset across cgroup
migration in the mechanical conversion to time helpers:
time_delta() clamps negative deltas to 0, so a queued task (whose
dsq_vtime is normally behind the source frontier) loses its
accumulated vtime credit and lands exactly at the destination
frontier instead of keeping its relative position.  Restore the
wrapping signed subtraction.

Fixes: 62addc6dbf36 ("sched_ext: Use time helpers in BPF schedulers")
Signed-off-by: Wanwu Li <liwanwu@kylinos.cn>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/sched_ext/scx_flatcg.bpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/sched_ext/scx_flatcg.bpf.c b/tools/sched_ext/scx_flatcg.bpf.c
index ddcf6bc03b11c..98fdd4b040331 100644
--- a/tools/sched_ext/scx_flatcg.bpf.c
+++ b/tools/sched_ext/scx_flatcg.bpf.c
@@ -934,7 +934,7 @@ void BPF_STRUCT_OPS(fcg_cgroup_move, struct task_struct *p,
 	if (!(from_cgc = find_cgrp_ctx(from)) || !(to_cgc = find_cgrp_ctx(to)))
 		return;
 
-	delta = time_delta(p->scx.dsq_vtime, from_cgc->tvtime_now);
+	delta = (s64)(p->scx.dsq_vtime - from_cgc->tvtime_now);
 	scx_bpf_task_set_dsq_vtime(p, to_cgc->tvtime_now + delta);
 }
 
-- 
2.53.0



