Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDABE4DEC08;
	Thu, 17 Sep 2026 17:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665295; cv=none; b=NjeouUw6jAxge+ZkKSBcq05TRHvSOtO9R3Akgtbr8cBwx+V9BYNiQTE92amIscbtZKwd/BPUCr7XFid1pueCjUH1b1L60KHwhRwYYsEuzMVsDlLqy9/oMR4yQ6BX1F8+abyHAo9BfyNk914GT7nTj64LvIHYpiRSr3MyMiMewaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665295; c=relaxed/simple;
	bh=QPPcVxCgpkps374BtTiy7uK+9SfgrAg5N7Oho28W0bA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Voqwrx0ppWTye66v6yBHjoOT685uJOmcdSVPGLZ3dhRckmUwa447WgpW9skbAkG5QYHbPJiDr3JLnL7/aEp9efsEbWaWPuSsLI/YxLWsDRHu1GxgcFcEpQtK66XZPEz4JCQl2EOf5K29V7aRhG9SViVSaG+eHvxXFap1Et1zOxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ms2QmtH2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ms2QmtH2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33EB11F000FF;
	Thu, 17 Sep 2026 17:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665293;
	bh=wcVBA0lbj1norK7tzM3ff1UxhB50ZNLjXouIIUPJswY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ms2QmtH2hJK1mQu13FwKIE5/b+JJk0DQXQp/XY1gipbLITjxrKOd23e93V/Ubpk5Z
	 zdoeRTDSrTa6zD8tk9ZU+IxWSGt3+s+wcN+Lzi/YNABO71FpImI6f6hLU5BaU4CTKy
	 FfjWfufrKBztUT4W2uhGvknBXIZ0J/dVXc1SzYOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wanwu Li <liwanwu@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0658/1250] sched_ext: Fix vtime delta loss in scx_flatcg cgroup migration
Date: Thu, 17 Sep 2026 16:07:33 +0100
Message-ID: <20260917151609.729988992@linuxfoundation.org>
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
index 7d2c5ab114242..d1fc6cb8206c0 100644
--- a/tools/sched_ext/scx_flatcg.bpf.c
+++ b/tools/sched_ext/scx_flatcg.bpf.c
@@ -932,7 +932,7 @@ void BPF_STRUCT_OPS(fcg_cgroup_move, struct task_struct *p,
 	if (!(from_cgc = find_cgrp_ctx(from)) || !(to_cgc = find_cgrp_ctx(to)))
 		return;
 
-	delta = time_delta(p->scx.dsq_vtime, from_cgc->tvtime_now);
+	delta = (s64)(p->scx.dsq_vtime - from_cgc->tvtime_now);
 	scx_bpf_task_set_dsq_vtime(p, to_cgc->tvtime_now + delta);
 }
 
-- 
2.53.0



