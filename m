Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E85D53365;
	Thu, 12 Dec 2024 17:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023888; cv=none; b=t4JW7aYeVVSPSaVSmG5Th4mbHSUgzrLUEUsVTnfHM9yqJIYs3oSFt/356j7HOtoYBS7Sa/citsWUQYmnKvshiyzsombm4aWwTnnoZjT6sIysYPXDxzgjyPxtcUF6+ww8RWyUTDmZkaRqk/HQvRia7KUKB2aSXfFJftz2t4qVA88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023888; c=relaxed/simple;
	bh=7jyrvU8kZgwoL+uprP+nRm2jqYnmcQX8u0P+thLfG1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kNvtqV+AtR61mRvqXCdrodhyMLB69L8MBQDKBIUhbDF9gQpzEWWTkMwPuJCmvNsl8Xg357t+B+QpzEHdoAnMgA7yVUhvJ2RcWcIc00GXfbFA8LJGH8iIcjymKXlgQLDpGTIOy6dTrCCP7c6uKuGEar9sWq/OImiZ6nnAswWLlog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m7utqNGF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m7utqNGF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66ADAC4CECE;
	Thu, 12 Dec 2024 17:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023887;
	bh=7jyrvU8kZgwoL+uprP+nRm2jqYnmcQX8u0P+thLfG1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m7utqNGFYtg5Vu9V7XI8imXDugi7+ScZW+hJVVqjrttaDYeiBJDmghU1GE+ccusHj
	 arwHKOsCAGkbkgbM//K2VVRm9/8lF2DPnaiev404lwhrYifJH2yBJbqBbpvqGOZ0Q4
	 C2GU3ZS8vcX6Xjm8K/ERfBwhxCcTmaQgtnOXK2GQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 088/459] Revert "cgroup: Fix memory leak caused by missing cgroup_bpf_offline"
Date: Thu, 12 Dec 2024 15:57:06 +0100
Message-ID: <20241212144256.991985456@linuxfoundation.org>
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
index e0fd62d56110a..c5e51bad62473 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2187,10 +2187,8 @@ static void cgroup_kill_sb(struct super_block *sb)
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



