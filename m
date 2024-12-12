Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 820DF22F395;
	Thu, 12 Dec 2024 15:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019052; cv=none; b=bNlKU7hW59few6J8eDdRy9QB6VOlVcf1HHmCKuJ6v0beQGl47QOndWnfYTrx97ON10lQViZUDCIV/rVW5otIQit+bHFSUKZq9iIK4mbO6nVzcmiyMarFiQTyIDlEABJOPKDGIi7euMWG8CSracCEtujH0xfjFtYwEZ4hZijq3hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019052; c=relaxed/simple;
	bh=QeCsHVI0dpQe7X5YgGeacw1DlQPS6ykDPSWheOfycl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TMsezw4ETgGPgS2/iC5lTDGDB0o7ioDcsFnDS1KxAYoe9z4KiGMEtHMjcTkX06YYyocUjccr58b9zNJqLERqZVB8sUXjDElELjazxZElr4AxWSIqRhLKKLS9WJpXWtKyc0M2JOkXemp8GOUVH3/7bpK4aiPVBsnUxm2RAw0yDZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0xrnMy2R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0xrnMy2R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E59E5C4CECE;
	Thu, 12 Dec 2024 15:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019052;
	bh=QeCsHVI0dpQe7X5YgGeacw1DlQPS6ykDPSWheOfycl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0xrnMy2RJsKgwE3FBySLsXSI327IgHzIWi5mpmOoyMEWpOm9VZORtoMBulZe3YtJn
	 pT0DzcQwiHqO1vlioMG2b8Opew25G6I+aQYluSSFM2CTU7GOfwCTSit+KJc9Hjgh95
	 Eu0iVWqEJrT+IMpAL2eyrFaNcIdbslG3nyKc4heM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 105/772] cgroup/bpf: only cgroup v2 can be attached by bpf programs
Date: Thu, 12 Dec 2024 15:50:50 +0100
Message-ID: <20241212144354.274997360@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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
index 11aa400979971..72ad4de66d10f 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2119,8 +2119,10 @@ int cgroup_setup_root(struct cgroup_root *root, u16 ss_mask)
 	if (ret)
 		goto exit_stats;
 
-	ret = cgroup_bpf_inherit(root_cgrp);
-	WARN_ON_ONCE(ret);
+	if (root == &cgrp_dfl_root) {
+		ret = cgroup_bpf_inherit(root_cgrp);
+		WARN_ON_ONCE(ret);
+	}
 
 	trace_cgroup_setup_root(root);
 
@@ -5626,9 +5628,11 @@ static struct cgroup *cgroup_create(struct cgroup *parent, const char *name,
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
@@ -5946,7 +5950,8 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 
 	cgroup1_check_for_release(parent);
 
-	cgroup_bpf_offline(cgrp);
+	if (cgrp->root == &cgrp_dfl_root)
+		cgroup_bpf_offline(cgrp);
 
 	/* put the base reference */
 	percpu_ref_kill(&cgrp->self.refcnt);
-- 
2.43.0



