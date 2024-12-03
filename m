Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63401F76B6;
	Tue,  3 Dec 2024 15:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238222; cv=none; b=mOsDoa9EDECPZfxBLMG8Hd53/SAbxesFlHGCK98V8Pdas+1bUKdTK7Q57iN11C9Q2dzuWt+WTe+YfUDzDu1Zmw2rFgQYCTfGaYDOjthtgnpzPpsWWlEql1n7TvppGMdKqHWpamHlp75ne9wJ77H3Vdp2t/oskeb/5qzASjARi5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238222; c=relaxed/simple;
	bh=Q6/sq+4ojXMWkcltFJW+bJO07fBrgUj+SrU0Oz7E8HQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jOSt+SVewUIF4CCl2JeIEZkCZOpVszTlU3ABZcYvH9+j/V2tZznAVYQOy3BOoz7qmKrthKTQzHEBkiqz66c73ZT1kPVE33P1SlGb/j/asNE8b7NV5PRLRoNbmJXuxCd2hgstWV5coBq45AuRYWP1htUijWCTRU5sLlxO4jTO8mA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IUC0QIyM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IUC0QIyM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3D8EC4CED8;
	Tue,  3 Dec 2024 15:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238221;
	bh=Q6/sq+4ojXMWkcltFJW+bJO07fBrgUj+SrU0Oz7E8HQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IUC0QIyMoQ3rcbpUy+4VMJHsrUsc/j2Q2o1bvs+0NtykBQCDCYOp/KmI8Kc4Gofvz
	 By60RnRgm25lUQoWMW5BJ7oa4tydpc20r0Mgk+Z8BJ5GMGSU7BETOCQJRihaizY/Wu
	 7PBwyPs5ew2Cb8KbWv9ZrBDUCF0TLzybnvJcZR7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 172/817] Revert "cgroup: Fix memory leak caused by missing cgroup_bpf_offline"
Date: Tue,  3 Dec 2024 15:35:44 +0100
Message-ID: <20241203144002.445340061@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ridong <chenridong@huawei.com>

[ Upstream commit feb301c60970bd2a1310a53ce2d6e4375397a51b ]

This reverts commit 04f8ef5643bcd8bcde25dfdebef998aea480b2ba.

Only cgroup v2 can be attached by cgroup by BPF programs. Revert this
commit and cgroup_bpf_inherit and cgroup_bpf_offline won't be called in
cgroup v1. The memory leak issue will be fixed with next patch.

Fixes: 04f8ef5643bc ("cgroup: Fix memory leak caused by missing cgroup_bpf_offline")
Link: https://lore.kernel.org/cgroups/aka2hk5jsel5zomucpwlxsej6iwnfw4qu5jkrmjhyfhesjlfdw@46zxhg5bdnr7/
Signed-off-by: Chen Ridong <chenridong@huawei.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cgroup.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 6ba7dd2ab771d..2592cbbc95ae8 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2307,10 +2307,8 @@ static void cgroup_kill_sb(struct super_block *sb)
 	 * And don't kill the default root.
 	 */
 	if (list_empty(&root->cgrp.self.children) && root != &cgrp_dfl_root &&
-	    !percpu_ref_is_dying(&root->cgrp.self.refcnt)) {
-		cgroup_bpf_offline(&root->cgrp);
+	    !percpu_ref_is_dying(&root->cgrp.self.refcnt))
 		percpu_ref_kill(&root->cgrp.self.refcnt);
-	}
 	cgroup_put(&root->cgrp);
 	kernfs_kill_sb(sb);
 }
-- 
2.43.0



