Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9273148832;
	Fri,  6 Dec 2024 14:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496873; cv=none; b=kRnkeiHJnecIJL5CgQsuN4/NJzianuanqAIVOlDTzto8A2PKwfx7oIBUS2H47md5tsvhcU5vovh6L4r3vrhEDOUB7bl/X6lA6Wq8Adax5qklif+x8SJtpgG40od1N2jC5K8yhYw3IOChCoJsla4Q1o3etbQMaRaxajelgXsKMk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496873; c=relaxed/simple;
	bh=Y8SFE5zlDq7hcmUI6y3EGNRl6edbSWsmye7kFYxHFw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KkpCuzJpJcvSPxTMD6aQ31gztYNIalgUwgY2Igv9jxKpFXulG++GOxGtcA8/KB9xf96A1AQLQQXo6l2xbswlUTTOX46ZKFOQZigOkSQ2+K9lCrFNdohECGzcbSuRQ8VyO/fEWxaqLAb63ZUWlc6+ZHK6zb4F7vOMvLRNeS1prdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r7H9RmGM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r7H9RmGM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA292C4CED1;
	Fri,  6 Dec 2024 14:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496873;
	bh=Y8SFE5zlDq7hcmUI6y3EGNRl6edbSWsmye7kFYxHFw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r7H9RmGMIOHCSbG8GeYm3WbIz1g9pvqSKdmWlDfWk5+VNJfMIYmGAhk718qvGJ+Q3
	 SpsWtVuBPS60OLZ6dlBabHes4qdbp8B5gEOkLCTs2mn/XHQXaxGkxQkQlLwgoihSD0
	 PhBHikEoKMI8NnhXLzJ/B7wOUSj2qGDaDaqX+ORw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 130/676] cgroup/bpf: only cgroup v2 can be attached by bpf programs
Date: Fri,  6 Dec 2024 15:29:09 +0100
Message-ID: <20241206143658.433567026@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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
index d31cc406fb58e..36097e8c904fe 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2096,8 +2096,10 @@ int cgroup_setup_root(struct cgroup_root *root, u16 ss_mask)
 	if (ret)
 		goto exit_stats;
 
-	ret = cgroup_bpf_inherit(root_cgrp);
-	WARN_ON_ONCE(ret);
+	if (root == &cgrp_dfl_root) {
+		ret = cgroup_bpf_inherit(root_cgrp);
+		WARN_ON_ONCE(ret);
+	}
 
 	trace_cgroup_setup_root(root);
 
@@ -5616,9 +5618,11 @@ static struct cgroup *cgroup_create(struct cgroup *parent, const char *name,
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
@@ -5936,7 +5940,8 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 
 	cgroup1_check_for_release(parent);
 
-	cgroup_bpf_offline(cgrp);
+	if (cgrp->root == &cgrp_dfl_root)
+		cgroup_bpf_offline(cgrp);
 
 	/* put the base reference */
 	percpu_ref_kill(&cgrp->self.refcnt);
-- 
2.43.0



