Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 545D4223302;
	Thu, 12 Dec 2024 15:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019049; cv=none; b=BA9awgAKEL+ZnPXBi61StEPBb5bd6X/vSAJk+xAfgG1znWJO1eEHBAxvIinNx1aga+EnqlXG3yQKZvsm42PK+dw3DRgY3NoP/MgcZD5WGomLqxAoYdDmG0iX2wGkQEbYLXD9q5hZURsXJhCLzyufrpc2jnj8ukjI08ylKN2wlec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019049; c=relaxed/simple;
	bh=p53jGnmM4bSpyJlms/yxMD79PB/wGMkCA+tULBny3wc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F9h4qdz9pWi3L9ynXbSXNxtWb3LerS26Jqhd6/Mdjdl5l8kF+P5NOSuyqQFxps50Tbim6tp6EX6cdJ9REzLEIKmH+iPNDS4mEvdzmhaEmgqBQi9PXPNlUqR4M9Ghl4tJKe8MLgQV4jQTmTztDhtX8YMZaxEHobSt9p7Csx33KPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M0QSat3m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M0QSat3m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55FD0C4CECE;
	Thu, 12 Dec 2024 15:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019048;
	bh=p53jGnmM4bSpyJlms/yxMD79PB/wGMkCA+tULBny3wc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M0QSat3m5Bvweis6vtUNAO2Urp/ido/mornEkq+y04ho/2eVwnmnl9i3/JDUiwyUV
	 GTu8aTJIklSvdpzb6SH/oTEjvylJFqRVE84SLNJfR6Lv2pnJhd2Fat5ClU1lmYjaqW
	 09o6XsCnMxcOz5Vm+jfX2SN8K1Urhn1VXf/iyEuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 104/772] Revert "cgroup: Fix memory leak caused by missing cgroup_bpf_offline"
Date: Thu, 12 Dec 2024 15:50:49 +0100
Message-ID: <20241212144354.236751592@linuxfoundation.org>
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
index 2ca4aeb21a440..11aa400979971 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2293,10 +2293,8 @@ static void cgroup_kill_sb(struct super_block *sb)
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



