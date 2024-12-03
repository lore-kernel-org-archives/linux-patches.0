Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14141F76AE;
	Tue,  3 Dec 2024 15:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240574; cv=none; b=H4hnc8KkH8AEGB1VfrOyxQf4FSf7pOzNecKlQfVq4/w/6o8Xm4uAGvDYJC92y+2oix5dLBhf82guUtUATrozPl5P4cDd0Zaz26O+W3h8Fwc8f3Dt1Pmf6qO9XQ50H7uS+Jp2u1gs3tQIMT/KgVkA59a55atQ6d9NPPdAM6Qxmto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240574; c=relaxed/simple;
	bh=waAMaJB3hXBP/tF0lZNSDnl8wyHo3i1qDzZEuHFxA9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ftziistFs0s0SU3bzwkQ5zIvZ0rbEFsjlh6GPSSXJpiDoNe4gA9dRe01GwAuogFaefwj9vqEZE9b8DSNTt6vVo+3cEDY5VqPQAZQXIGBA0iKOkVJlyrhvsCgjCzO92fXTgt2/vtMoDm7DyX1RoJapzz6sZbw3tjeuUKsClCCY3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zQg8LEtj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zQg8LEtj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49882C4CECF;
	Tue,  3 Dec 2024 15:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240574;
	bh=waAMaJB3hXBP/tF0lZNSDnl8wyHo3i1qDzZEuHFxA9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zQg8LEtjMGSrjvk06ms6C+9I0Sn0ZYmsf725RDS0kz/we5Kmu9TzOdFwH2U4VNZGh
	 Jf+CC3iV/72gwF4uY+pnPAXmUZpz5MFq3iN5APF4N6TYXtN5t7kBzsy3jCX+AoHri2
	 VK7q++RKKQa4xr2zqjXa72VQoc31Gjq15D2t+Dps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 135/826] Revert "cgroup: Fix memory leak caused by missing cgroup_bpf_offline"
Date: Tue,  3 Dec 2024 15:37:42 +0100
Message-ID: <20241203144749.009303125@linuxfoundation.org>
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
index 044c7ba1cc482..30444e0960276 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2314,10 +2314,8 @@ static void cgroup_kill_sb(struct super_block *sb)
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



