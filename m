Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28CF41442E8;
	Fri,  6 Dec 2024 14:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496870; cv=none; b=HbnJwl1KiOC/rNXT08yWEH7FDX0nTziTTwx5AgoLmAI+JUKB1Ea0GuKRh3E/AAWxCxcW+GJdyjAbhu6W+fegrStFlsiH3mqgmmD8CxtHKkDTcSM9GTn0dbubvYbjOY+XE8fARtATUZqZhFjFE3+QBZzNTjCUlSKDpmQR5dKrPmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496870; c=relaxed/simple;
	bh=s76MWQSpqPUjudmQdCHFjW/lSd/yGPamLGkEbISoOTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uIhH7Cv3sV00lDSpNmCwCp0TLHPQLdU7QD8wKZ/mSqGDZuS6A8BnhE6VxHdo9hSxPkdPIzU1yAl/G8W4EW0P0RyncbqV+Jb1myWhGVACp0UerA0y5p1GiAQc0sNToWBdjGzNlgJSJB8iUcNuhPP1Cf+2H1EVaaMORcc3F9t4ido=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wNW/l733; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wNW/l733"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 398A1C4CED1;
	Fri,  6 Dec 2024 14:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496869;
	bh=s76MWQSpqPUjudmQdCHFjW/lSd/yGPamLGkEbISoOTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wNW/l73346ngcRzgZB3/owp0qMSX+6hI6ae8lX0D1eJgqV0xUszmRQULPti8NJnBu
	 iJs6Ny01zXa1fXMKyk5R65r6Fy5u+jN7SnQC4dZQfoc+KK07bmP41YZG0MnlLMWA7N
	 i3SuHHly3i4p8NeRBuVQTg+qql44wdJCo1DHPziY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 129/676] Revert "cgroup: Fix memory leak caused by missing cgroup_bpf_offline"
Date: Fri,  6 Dec 2024 15:29:08 +0100
Message-ID: <20241206143658.395031473@linuxfoundation.org>
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
index b927f0623ac77..d31cc406fb58e 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2270,10 +2270,8 @@ static void cgroup_kill_sb(struct super_block *sb)
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



