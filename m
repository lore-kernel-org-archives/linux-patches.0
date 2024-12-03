Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CDC31F8AFF;
	Tue,  3 Dec 2024 15:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240465; cv=none; b=u+rSu3OrR4Eh2UEi9dfNRfs2LG3H64Prfd/5bSCc6HrlPQx5g+6WKgNaFaJ+Uzcp6psYYrqr9HW0YGGu7y4gTDvw0AL4ouDGrY0sslP31s/yazD0hBDTOP7z19J3YF+Bfa8ENJxNUoodDjkSiNoClUAowM2GL/KJpN5szNHXShQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240465; c=relaxed/simple;
	bh=S62T9uQ9zNmz08A1pkqckSPkZUcPiNv1yrtS3ESgZ/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F6j/PdTOCXrJCenSgAKoVBTfapb11vUgKBUV34imdCAbXAjrhp2iXKnDur4GIEZBFn6ZoKzPt217cMMchCnxMfS0yGR/GNCnHNnw71C4rP29OhFmoA7k39Emm+1SdfgChdJdWUlrIjwJQdcmrxlkNgtW8IWEPFgwAU63uDwz9TU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qCfEWSIt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qCfEWSIt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DAC4C4CECF;
	Tue,  3 Dec 2024 15:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240464;
	bh=S62T9uQ9zNmz08A1pkqckSPkZUcPiNv1yrtS3ESgZ/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qCfEWSItKrCeNnAwGXyBZBovaZNK/ndXsx6D0/6r14SJowLmyrbdD/z97/4A4rjM9
	 JKMv+CxDkBkacwrCWn5kF/17MEb/jMFjjrTxVG3MWnawDC6KOTp6TKi8HcD8wJUGCY
	 PB5OG9UAAiOqCIaTXyNTErotM6fDERSwF/cXVK7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 136/826] cgroup/bpf: only cgroup v2 can be attached by bpf programs
Date: Tue,  3 Dec 2024 15:37:43 +0100
Message-ID: <20241203144749.048898959@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ridong <chenridong@huawei.com>

[ Upstream commit 2190df6c91373fdec6db9fc07e427084f232f57e ]

Only cgroup v2 can be attached by bpf programs, so this patch introduces
that cgroup_bpf_inherit and cgroup_bpf_offline can only be called in
cgroup v2, and this can fix the memleak mentioned by commit 04f8ef5643bc
("cgroup: Fix memory leak caused by missing cgroup_bpf_offline"), which
has been reverted.

Fixes: 2b0d3d3e4fcf ("percpu_ref: reduce memory footprint of percpu_ref in fast path")
Fixes: 4bfc0bb2c60e ("bpf: decouple the lifetime of cgroup_bpf from cgroup itself")
Link: https://lore.kernel.org/cgroups/aka2hk5jsel5zomucpwlxsej6iwnfw4qu5jkrmjhyfhesjlfdw@46zxhg5bdnr7/
Signed-off-by: Chen Ridong <chenridong@huawei.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cgroup.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 30444e0960276..e275eaf2de7f8 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2140,8 +2140,10 @@ int cgroup_setup_root(struct cgroup_root *root, u16 ss_mask)
 	if (ret)
 		goto exit_stats;
 
-	ret = cgroup_bpf_inherit(root_cgrp);
-	WARN_ON_ONCE(ret);
+	if (root == &cgrp_dfl_root) {
+		ret = cgroup_bpf_inherit(root_cgrp);
+		WARN_ON_ONCE(ret);
+	}
 
 	trace_cgroup_setup_root(root);
 
@@ -5708,9 +5710,11 @@ static struct cgroup *cgroup_create(struct cgroup *parent, const char *name,
 	if (ret)
 		goto out_kernfs_remove;
 
-	ret = cgroup_bpf_inherit(cgrp);
-	if (ret)
-		goto out_psi_free;
+	if (cgrp->root == &cgrp_dfl_root) {
+		ret = cgroup_bpf_inherit(cgrp);
+		if (ret)
+			goto out_psi_free;
+	}
 
 	/*
 	 * New cgroup inherits effective freeze counter, and
@@ -6024,7 +6028,8 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 
 	cgroup1_check_for_release(parent);
 
-	cgroup_bpf_offline(cgrp);
+	if (cgrp->root == &cgrp_dfl_root)
+		cgroup_bpf_offline(cgrp);
 
 	/* put the base reference */
 	percpu_ref_kill(&cgrp->self.refcnt);
-- 
2.43.0



