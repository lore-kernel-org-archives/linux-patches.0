Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA001E7C27;
	Thu, 30 Jan 2025 14:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247041; cv=none; b=EuZsi5/TjSGUNtX90V09c8DuUys9taHeMvStWUSTizCtSOLqV+FAM7S9JM93rk1W+/4wPP8LXQfKD0vufH6JTuEtx2qrC/jbwLeMMhElFBHyC1pKv5Y2GB5ax5G4bNmqhXzVV6pQ9klRo2VsS31LueD5xt+l4mqFklKrT2dmPIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247041; c=relaxed/simple;
	bh=hTowguVZIxES7kwqxa9TtqUlYDlFabvUWOb3u5JrR8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cUn3U/d0UcVr3JYPfQ5Z95st2KxHCLyPji0Szan0OJbyaltC2GxSaubDvOuHqO/xVgXpciJYrD9+VM0HzmvWUoXN1E4ClylUc39LGudHDS7+uhNFUaagiov7glaURSC84DZtB/vZsogEsjlZ8EUM1HAD2Gef6F0FK9bPCQBQ1bA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t1ygLq19; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t1ygLq19"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6633C4CED2;
	Thu, 30 Jan 2025 14:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247040;
	bh=hTowguVZIxES7kwqxa9TtqUlYDlFabvUWOb3u5JrR8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t1ygLq19rAlA7DWn2kLJG08e4rlRK3PoHU/wCtxxVdcYUtXE8YNyQXn/+A1iJtMRB
	 VoW74oChflW4adzcGUNqAByN6wjiXiDv/TjbhWqYs2z8lITS7o3++PioFdIi+8m2hp
	 m7YjBjGT0wYCq4GJ3urbL9ZYAaK7HPLZ9tMBgIy0=
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
Subject: [PATCH 5.10 060/133] ocfs2: fix slab-use-after-free due to dangling pointer dqi_priv
Date: Thu, 30 Jan 2025 15:00:49 +0100
Message-ID: <20250130140144.934219332@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index eda83487c9ec..1ce3780e8b49 100644
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
index fbab536741e2..77d5aa90338f 100644
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



