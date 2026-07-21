Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F83A44607D;
	Tue, 21 Jul 2026 15:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648758; cv=none; b=T7/kK0RBx8/o0UfqXRo2xMamzvmcLldYO9qo2TcvzxLkF2we3ebj3HHXcbISK1zNTCmYlB92Y1MiZLmvFQ+gBVE5iII34/fm1XOEMqmB/Iiao9pEaLxv+/bsTjtVbT23HAxFHakZuBsZ5AG0UzBlquclURsISMlBSeNAmpq84oM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648758; c=relaxed/simple;
	bh=fO5L0ZTq8j+/RaoDdcB7xgpeo/xg3W9O4v/+/mnA27I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ND7259ufyFtxHaEMqx6H+DHMP6PEDN4soUOe2F+H5NGs911XQsjOaS5WWGAfBZfQynaIqy3HH/qwNIxKZq/KWMpq520SaFmj9C5mfyQgylmOS/3dirQDfFD7b6wgi1uF3HF5AcvGsdFB3aQeg6tz8HfnDAbpQgOIkixUzkLA/dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mf1F+IqZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mf1F+IqZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C41D1F000E9;
	Tue, 21 Jul 2026 15:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648757;
	bh=DsFHB7/5lvjJU5sZHU1UDtvkIEczuO9XH7aoGO9+/T4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mf1F+IqZSFYOxiwmKetEIEi5+Xu3jjXRkhvEt4bRMTnfuhzxDsIHi9rTDoha1dqeh
	 75yJzLh6K2nKMwx0HAFFrjVBF/XkbUyvTMIQsxMskENe+HGNb5TyjbDJ3NGk9hfjaf
	 +nN/7DE1h2Nb2AyIUDGQC0huSGzgAPzPwN9kbQ4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Tejun Heo <tj@kernel.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0277/2077] writeback: drop now-unnecessary rcu_barrier() in cgroup_writeback_umount()
Date: Tue, 21 Jul 2026 16:59:10 +0200
Message-ID: <20260721152559.216863453@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun@linux.alibaba.com>

[ Upstream commit e90a6d668e26e00a72df2d09c173b563468f09c9 ]

Commit e1b849cfa6b6 ("writeback: Avoid contention on wb->list_lock when
switching inodes") replaced the queue_rcu_work() based scheduling of
inode wb switches with a plain queue_work().  Since then no switcher
goes through call_rcu(), so rcu_barrier() in cgroup_writeback_umount()
has no callbacks of its own to wait for.  It still drains unrelated
call_rcu() callbacks from other subsystems on busy systems, which
incidentally slows umount down; drop it.

Fixes: e1b849cfa6b6 ("writeback: Avoid contention on wb->list_lock when switching inodes")
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
Link: https://patch.msgid.link/20260521095016.2791354-3-libaokun@linux.alibaba.com
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fs-writeback.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 6766de9f9d75b3..325a30cc35bfb8 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1248,11 +1248,6 @@ void cgroup_writeback_umount(struct super_block *sb)
 		 * will then drain it.
 		 */
 		synchronize_rcu();
-		/*
-		 * Use rcu_barrier() to wait for all pending callbacks to
-		 * ensure that all in-flight wb switches are in the workqueue.
-		 */
-		rcu_barrier();
 		flush_workqueue(isw_wq);
 	}
 }
-- 
2.53.0



