Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53148239BAA;
	Thu, 12 Dec 2024 16:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022003; cv=none; b=Stm0XxWUEOkNlKfNNJfxK9poRWMnq7MxMxtAF8ZQDg8nAa4UYVG4/5eMaQbOcG/8ioBj7VVaV78UcIWgTJj/VzLOoXoeqZVoA/n81LCPbpFyEL84QACp6Fued2RTffasIGZUtqmGj3UNXqIyiEDysYomyY4xXtzmTBdb7sMxAU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022003; c=relaxed/simple;
	bh=/FINlOcDb4yFqWvfhGXJODOPl5jSmRVEIvK96JxSd5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FaEfSg4etSad6Wq0sV0pnNtqrSeyNBgm+ChaGMSAMnvitHRpUHTKpQO+PjLOkNXVxh9SDGZEsJVonhq+Vj4ReFG2noYUO4ItvhmxL2FdGnO9U+9BysoJzA6cBqLvDLf3L6F5m4vOYpphEYMB919emd/BQ2Ec61PyBu0EVl4h5vM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ysNiRpV8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ysNiRpV8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4444C4CECE;
	Thu, 12 Dec 2024 16:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022003;
	bh=/FINlOcDb4yFqWvfhGXJODOPl5jSmRVEIvK96JxSd5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ysNiRpV8S2En5oy91g1/0GO2y+wlWw4WTNkIxFddZv+3M7KF5/Donq3g19BObB0LB
	 zZ/QCkPhH55k9x9fNW0tvu2+K7oI0I83TTS8kX/KTSmIGJlhKm8bPp30lE6SxvcXzk
	 ATfYTjLlVuzLU3pSxxPwSsTY6IWz3VK+BYJdtfB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 119/565] Revert "cgroup: Fix memory leak caused by missing cgroup_bpf_offline"
Date: Thu, 12 Dec 2024 15:55:14 +0100
Message-ID: <20241212144316.189382107@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9ba87c5de1a87..7346197f464cb 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2228,10 +2228,8 @@ static void cgroup_kill_sb(struct super_block *sb)
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



