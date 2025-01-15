Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0036248BA0;
	Wed, 15 Jan 2025 10:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937835; cv=none; b=FhlGqS13t6ZIGgSLy4JZlpITe01/l6CmY87rteAzVMkoa3pEzGCRuR63QDIQwG7xkJ1LcJVIPyW22So8zxXhwQWIMK3hplgZTfvEnRS0Hwok5Wsl878B4lrIqZh7a/7g55y8fKlKdY2hDJcJZJaguUR/z65ihUpd7qai8bIcKfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937835; c=relaxed/simple;
	bh=LXp+dqnqZgmSnI+NyUQBPjyCAE12X0WKPF3kHUIJahU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iY7oWy6KO4bBzxage1SU6zdb3fHCKi4A2fEgY3roQbgsKcMUXGjN7ffKVkOM/s890k8RN8/l4H12/D1ogepdYInp+kanZWjrAzUBUqFTi5Vn1oZNKEFmjSASohNkbiLayICXpGg2ErXzASgOCCKUihErHopwM+OI06/yGrjwCes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z1wqPFx4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z1wqPFx4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D609C4CEE1;
	Wed, 15 Jan 2025 10:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937835;
	bh=LXp+dqnqZgmSnI+NyUQBPjyCAE12X0WKPF3kHUIJahU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z1wqPFx4H0REJe1VNBeUZOsPTCO3Yrgc1zwfP3FpSVgQNtK/GOonDNml54PdFTXO+
	 osjyhoFdVzg4UMgpcqp9gGWqYhLS7t+6ilIsSsj+L0/NUCuEOBcJBSrK51ZzHP10Kg
	 VQ5dHTognIfjca+K+MfxBtR26qWukmBaHld305Z8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dennis Lam <dennis.lamerice@gmail.com>,
	syzbot+d173bf8a5a7faeede34c@syzkaller.appspotmail.com,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 90/92] ocfs2: fix slab-use-after-free due to dangling pointer dqi_priv
Date: Wed, 15 Jan 2025 11:37:48 +0100
Message-ID: <20250115103551.160313428@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
References: <20250115103547.522503305@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Dennis Lam <dennis.lamerice@gmail.com>

[ Upstream commit 5f3fd772d152229d94602bca243fbb658068a597 ]

When mounting ocfs2 and then remounting it as read-only, a
slab-use-after-free occurs after the user uses a syscall to
quota_getnextquota.  Specifically, sb_dqinfo(sb, type)->dqi_priv is the
dangling pointer.

During the remounting process, the pointer dqi_priv is freed but is never
set as null leaving it to be accessed.  Additionally, the read-only option
for remounting sets the DQUOT_SUSPENDED flag instead of setting the
DQUOT_USAGE_ENABLED flags.  Moreover, later in the process of getting the
next quota, the function ocfs2_get_next_id is called and only checks the
quota usage flags and not the quota suspended flags.

To fix this, I set dqi_priv to null when it is freed after remounting with
read-only and put a check for DQUOT_SUSPENDED in ocfs2_get_next_id.

[akpm@linux-foundation.org: coding-style cleanups]
Link: https://lkml.kernel.org/r/20241218023924.22821-2-dennis.lamerice@gmail.com
Fixes: 8f9e8f5fcc05 ("ocfs2: Fix Q_GETNEXTQUOTA for filesystem without quotas")
Signed-off-by: Dennis Lam <dennis.lamerice@gmail.com>
Reported-by: syzbot+d173bf8a5a7faeede34c@syzkaller.appspotmail.com
Tested-by: syzbot+d173bf8a5a7faeede34c@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/6731d26f.050a0220.1fb99c.014b.GAE@google.com/T/
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/quota_global.c | 2 +-
 fs/ocfs2/quota_local.c  | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index dc9f76ab7e13..0dffd6a44d39 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -881,7 +881,7 @@ static int ocfs2_get_next_id(struct super_block *sb, struct kqid *qid)
 	int status = 0;
 
 	trace_ocfs2_get_next_id(from_kqid(&init_user_ns, *qid), type);
-	if (!sb_has_quota_loaded(sb, type)) {
+	if (!sb_has_quota_active(sb, type)) {
 		status = -ESRCH;
 		goto out;
 	}
diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index 257f13cdd14c..4b4fa58cd32f 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -864,6 +864,7 @@ static int ocfs2_local_free_info(struct super_block *sb, int type)
 	brelse(oinfo->dqi_libh);
 	brelse(oinfo->dqi_lqi_bh);
 	kfree(oinfo);
+	info->dqi_priv = NULL;
 	return status;
 }
 
-- 
2.39.5



