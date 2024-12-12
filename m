Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49996205501;
	Thu, 12 Dec 2024 17:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023901; cv=none; b=nPpGLQScLeMOcyPbkHxFqihXlNKbDyNkypx1bmIVvWKVK6/DITiJ/F3+k/grxq4HchNgneIYu+5SNRJZN7lJ6+eNWoO91hqFI6oxdeqkk+p+ykbkB/S0chvov106/mPhxIePIRvweU/To6HV3TYhbQQPu+CEkfVFCx4H5jAT3Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023901; c=relaxed/simple;
	bh=z6wVPX7f+S9kvXCCFi3O3nf+F1BfMxpCM3DltFERuj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FOp/YsoStUWgmpuE/uawRhQPOKNwuwG5Zu/SndaSeXt+QDFJn6Q3yDVve38ki/GzrN3PHreedPNLkYXWzcmWZ0a66A4nLoS0Oz9oEc3zbKcco3Be36IgGPB3cyd39sLdqg8mVZSoCmIE6NVz+hBgTy1Xxgz5KkCEHacneZvlUSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oEXubEcL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oEXubEcL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74651C4CECE;
	Thu, 12 Dec 2024 17:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023899;
	bh=z6wVPX7f+S9kvXCCFi3O3nf+F1BfMxpCM3DltFERuj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oEXubEcL8heSEymlxk+I2MBM79FdrbGBJJoMeohyrfayZ/AH4YGy7VZN1kBkMTzM8
	 Yci/h+PVBhN5rC50uj22wSpt1DWpBJC8+XJzBytRXBgdBkMU1+IUtLrz1eEYBDeBLx
	 tlyZilfigC/gt+8vaNJ/j23sCCCEKV9BSPupoFNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 089/459] cgroup/bpf: only cgroup v2 can be attached by bpf programs
Date: Thu, 12 Dec 2024 15:57:07 +0100
Message-ID: <20241212144257.030353244@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index c5e51bad62473..efeb0b7427501 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2018,8 +2018,10 @@ int cgroup_setup_root(struct cgroup_root *root, u16 ss_mask)
 	if (ret)
 		goto destroy_root;
 
-	ret = cgroup_bpf_inherit(root_cgrp);
-	WARN_ON_ONCE(ret);
+	if (root == &cgrp_dfl_root) {
+		ret = cgroup_bpf_inherit(root_cgrp);
+		WARN_ON_ONCE(ret);
+	}
 
 	trace_cgroup_setup_root(root);
 
@@ -5355,9 +5357,11 @@ static struct cgroup *cgroup_create(struct cgroup *parent, const char *name,
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
@@ -5676,7 +5680,8 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 
 	cgroup1_check_for_release(parent);
 
-	cgroup_bpf_offline(cgrp);
+	if (cgrp->root == &cgrp_dfl_root)
+		cgroup_bpf_offline(cgrp);
 
 	/* put the base reference */
 	percpu_ref_kill(&cgrp->self.refcnt);
-- 
2.43.0



