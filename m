Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036339;
	b=HCWhi3fwqbDIKCnyk/IqmMzvz9O5JgidaKjN4RadFcTxKYza6pVLhFpgvi7yLs4jqvDk
	 E1Q6BhfoAenJgffwgdqxwEXnA8y9qorxEI8WvFWd274JMxjJJjktw0gL3NLLWFBXu34Cq
	 LDn2pfdMDNjXvjG5mKs2kXW7+H9P84wYNuU4WwccAVFGDjHy9SiDKWyCRlpejb1VeLD/b
	 3hWxXP3pM2mJ2LKcMN53rxIcrSLPfsm8840o1/+aIChRnZWntPVRw3ICHFE7WIOrD98Hg
	 6sVeq96vt3M9Uc+2sxKpkg1JW/5YUJ2oa9yKwDzyNUwwVucatExzTNv0lHKcwmhFSRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036339;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kO4iqsB3268UxD/eoBRVbEIYoI2TDNDGsICQGW/6vUM=;
	b=n9N6y5loGXfOyAMVMrkhdSbLwZuOjyEvsGsxNEC06/4CKHi4lOP+SGYSvxzELAB215bS
	 gK81BeLf/z7+Hn5AaVdHOsQ9u3oxnJGF+9mwQKAuUT4YFlkzh2nzNXCLwBm6MIrhk0j9j
	 eQJT6+/27Am6iTcc/iZ7rSMFiDWILIRmmpWWG5urw9ayx8Ta02B+eLuJ+FTa8L2ZRMF7c
	 qVqz//0poNJA6qo6wG1o6pJuVYXm4hd5880PDJGpCDyOZ8rusd3NWVeQM5f5aJH/rhFCb
	 l4pdOHlH99/8bPAybhIJev3+MxDASZb/7NROzXZw7IPqMMQnryUAPf17VAwnzovxR8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=axB43uVm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BDE9606A330;
	Wed, 18 Nov 2026 21:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=axB43uVm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBE701F000C4;
	Wed, 18 Nov 2026 21:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036339;
	bh=kO4iqsB3268UxD/eoBRVbEIYoI2TDNDGsICQGW/6vUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=axB43uVmqzCl234yIwpbKybPUjeH6EdcfDPWSOBLluvIuuBxbdkdU5AiApQOjm7gF
	 KE/FeYSfS+j1x0KO8lXDaHPMBMSYzpmUUK13ECHBl/VZabNkI5NKDapBWh+V6NSNx0
	 KapKrf3PdnF2Ho6MqMtlNFE6XuhX0t3i0y+B4Wpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>,
	Changwei Ge <gechangwei@live.cn>,
	Joel Becker <jlbec@evilplan.org>,
	Jun Piao <piaojun@huawei.com>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Mark Fasheh <mark@fasheh.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1025/3318] ocfs2: free replay slots in ocfs2_recovery_exit()
Date: Wed, 18 Nov 2026 15:27:27 +0100
Message-ID: <20261118150350.633470926@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joseph Qi <joseph.qi@linux.alibaba.com>

[ Upstream commit 1ddadc6d41c1a29fd8fad1891bdcd2956e08b7f0 ]

Commit ce2fcf1516d6 ("ocfs2: fix memory leak in ocfs2_mount_volume()")
added ocfs2_free_replay_slots() calls to the mount error paths
out_dismount and out_check_volume to fix a leak of osb->replay_map.
However these calls are unlocked while the bail path of the recovery
thread, which is woken up by out_dismount right before the call, also
frees the replay slots under osb->recovery_lock.  Both sides can thus
observe a non-NULL osb->replay_map and trigger a double free.

Fix this by moving ocfs2_free_replay_slots() into ocfs2_recovery_exit()
after ocfs2_recovery_disable(), which waits for a running recovery thread
to exit under osb->recovery_lock, and drop the unlocked call sites.  Both
ocfs2_dismount_volume() and the out_super path of ocfs2_fill_super() call
ocfs2_recovery_exit(), so the replay slots are freed on every path.  Since
super.c no longer references it, make ocfs2_free_replay_slots() static
again.

Link: https://lore.kernel.org/20260828112825.666097-2-joseph.qi@linux.alibaba.com
Fixes: ce2fcf1516d6 ("ocfs2: fix memory leak in ocfs2_mount_volume()")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/journal.c | 3 ++-
 fs/ocfs2/journal.h | 1 -
 fs/ocfs2/super.c   | 5 +----
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 79fd52d9ba099..3dfe330aa000a 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -158,7 +158,7 @@ static void ocfs2_queue_replay_slots(struct ocfs2_super *osb,
 	replay_map->rm_state = REPLAY_DONE;
 }
 
-void ocfs2_free_replay_slots(struct ocfs2_super *osb)
+static void ocfs2_free_replay_slots(struct ocfs2_super *osb)
 {
 	struct ocfs2_replay_map *replay_map = osb->replay_map;
 
@@ -246,6 +246,7 @@ void ocfs2_recovery_exit(struct ocfs2_super *osb)
 	/* XXX: Should we bug if there are dirty entries? */
 
 	kfree(rm);
+	ocfs2_free_replay_slots(osb);
 }
 
 static int __ocfs2_recovery_map_test(struct ocfs2_super *osb,
diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index f8b3b2a3d6309..19fc920d26b1c 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -151,7 +151,6 @@ void ocfs2_recovery_exit(struct ocfs2_super *osb);
 void ocfs2_recovery_disable_quota(struct ocfs2_super *osb);
 
 int ocfs2_compute_replay_slots(struct ocfs2_super *osb);
-void ocfs2_free_replay_slots(struct ocfs2_super *osb);
 /*
  *  Journal Control:
  *  Initialize, Load, Shutdown, Wipe a journal.
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index edb04328c9656..ea49e9a5e00aa 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1164,7 +1164,6 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 out_dismount:
 	atomic_set(&osb->vol_state, VOLUME_DISABLED);
 	wake_up(&osb->osb_mount_event);
-	ocfs2_free_replay_slots(osb);
 	ocfs2_dismount_volume(sb, 1);
 	goto out;
 
@@ -1834,14 +1833,12 @@ static int ocfs2_mount_volume(struct super_block *sb)
 	status = ocfs2_truncate_log_init(osb);
 	if (status < 0) {
 		mlog_errno(status);
-		goto out_check_volume;
+		goto out_system_inodes;
 	}
 
 	ocfs2_super_unlock(osb, 1);
 	return 0;
 
-out_check_volume:
-	ocfs2_free_replay_slots(osb);
 out_system_inodes:
 	if (osb->local_alloc_state == OCFS2_LA_ENABLED)
 		ocfs2_shutdown_local_alloc(osb);
-- 
2.53.0



