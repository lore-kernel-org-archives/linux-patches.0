Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406931C6F5E;
	Tue, 27 Aug 2024 15:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771875; cv=none; b=hPWKdkSDiq//4eJxbPevg7wGe9DP6CcrFtFDlSEo+e2P2UqA9JsXCzLeNsYE/AtJXLjdRZVRbaA+K1rghessVg4ccO3Fx2YWsoSToMn0PHrR4AwtWYd/qM++mXHQpvxXSG/2Pu8fyPbrsvbmyUCmlIJjwEkA+8hiFfDDj5PbgU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771875; c=relaxed/simple;
	bh=I/F1cplcDfaN8vehajwpHbhhX5HECEt9MtTGdA8zs2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FNMBlm5HunXJmrx+D/VtkwfGSyedEcft6KizQUJbUwrlX4DxsNWWLO5liRhtdN4ZnuZS5OKa9+zw9+3OAK4OGvumicwo1FGI6utlO0jHYDQ1bhYg1vqyyArNBwILSlVbn00q8gGsswwwfPfAdT/bkrDPX9QPRlZX9NxBi+E81Gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wmDVRS8g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wmDVRS8g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA55EC4FE11;
	Tue, 27 Aug 2024 15:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771874;
	bh=I/F1cplcDfaN8vehajwpHbhhX5HECEt9MtTGdA8zs2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wmDVRS8gWpWdNFtCqy+qg7+Zu91rK7QSFIwI/tCsnuIxIk5gG2wMp5VzxUaJjB6aS
	 fDMLhQp2g4XtkHQRBibjpZkP7H3TZnh+HPpttyPhRHNBD61Rtct7+T636dmLc9HyWs
	 HvSx5Yt+fEedvWwgq1fNfeuBnikYQoEqBxg/Pblo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3f6a670108ce43356017@syzkaller.appspotmail.com,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 047/321] gfs2: Stop using gfs2_make_fs_ro for withdraw
Date: Tue, 27 Aug 2024 16:35:55 +0200
Message-ID: <20240827143840.021438695@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit f66af88e33212b57ea86da2c5d66c0d9d5c46344 ]

[   81.372851][ T5532] CPU: 1 PID: 5532 Comm: syz-executor.0 Not tainted 6.2.0-rc1-syzkaller-dirty #0
[   81.382080][ T5532] Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/12/2023
[   81.392343][ T5532] Call Trace:
[   81.395654][ T5532]  <TASK>
[   81.398603][ T5532]  dump_stack_lvl+0x1b1/0x290
[   81.418421][ T5532]  gfs2_assert_warn_i+0x19a/0x2e0
[   81.423480][ T5532]  gfs2_quota_cleanup+0x4c6/0x6b0
[   81.428611][ T5532]  gfs2_make_fs_ro+0x517/0x610
[   81.457802][ T5532]  gfs2_withdraw+0x609/0x1540
[   81.481452][ T5532]  gfs2_inode_refresh+0xb2d/0xf60
[   81.506658][ T5532]  gfs2_instantiate+0x15e/0x220
[   81.511504][ T5532]  gfs2_glock_wait+0x1d9/0x2a0
[   81.516352][ T5532]  do_sync+0x485/0xc80
[   81.554943][ T5532]  gfs2_quota_sync+0x3da/0x8b0
[   81.559738][ T5532]  gfs2_sync_fs+0x49/0xb0
[   81.564063][ T5532]  sync_filesystem+0xe8/0x220
[   81.568740][ T5532]  generic_shutdown_super+0x6b/0x310
[   81.574112][ T5532]  kill_block_super+0x79/0xd0
[   81.578779][ T5532]  deactivate_locked_super+0xa7/0xf0
[   81.584064][ T5532]  cleanup_mnt+0x494/0x520
[   81.593753][ T5532]  task_work_run+0x243/0x300
[   81.608837][ T5532]  exit_to_user_mode_loop+0x124/0x150
[   81.614232][ T5532]  exit_to_user_mode_prepare+0xb2/0x140
[   81.619820][ T5532]  syscall_exit_to_user_mode+0x26/0x60
[   81.625287][ T5532]  do_syscall_64+0x49/0xb0
[   81.629710][ T5532]  entry_SYSCALL_64_after_hwframe+0x63/0xcd

In this backtrace, gfs2_quota_sync() takes quota data references and
then calls do_sync().  Function do_sync() encounters filesystem
corruption and withdraws the filesystem, which (among other things) calls
gfs2_quota_cleanup().  Function gfs2_quota_cleanup() wrongly assumes
that nobody is holding any quota data references anymore, and destroys
all quota data objects.  When gfs2_quota_sync() then resumes and
dereferences the quota data objects it is holding, those objects are no
longer there.

Function gfs2_quota_cleanup() deals with resource deallocation and can
easily be delayed until gfs2_put_super() in the case of a filesystem
withdraw.  In fact, most of the other work gfs2_make_fs_ro() does is
unnecessary during a withdraw as well, so change signal_our_withdraw()
to skip gfs2_make_fs_ro() and perform the necessary steps directly
instead.

Thanks to Edward Adam Davis <eadavis@sina.com> for the initial patches.

Link: https://lore.kernel.org/all/0000000000002b5e2405f14e860f@google.com
Reported-by: syzbot+3f6a670108ce43356017@syzkaller.appspotmail.com
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/super.c |  9 ++-------
 fs/gfs2/util.c  | 19 ++++++++++++++++++-
 2 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 1a888b9c3d110..f9b47df485d17 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -563,15 +563,8 @@ void gfs2_make_fs_ro(struct gfs2_sbd *sdp)
 				   gfs2_log_is_empty(sdp),
 				   HZ * 5);
 		gfs2_assert_warn(sdp, gfs2_log_is_empty(sdp));
-	} else {
-		wait_event_timeout(sdp->sd_log_waitq,
-				   gfs2_log_is_empty(sdp),
-				   HZ * 5);
 	}
 	gfs2_quota_cleanup(sdp);
-
-	if (!log_write_allowed)
-		sdp->sd_vfs->s_flags |= SB_RDONLY;
 }
 
 /**
@@ -607,6 +600,8 @@ static void gfs2_put_super(struct super_block *sb)
 	} else {
 		gfs2_quota_cleanup(sdp);
 	}
+	if (gfs2_withdrawn(sdp))
+		gfs2_quota_cleanup(sdp);
 	WARN_ON(gfs2_withdrawing(sdp));
 
 	/*  At this point, we're through modifying the disk  */
diff --git a/fs/gfs2/util.c b/fs/gfs2/util.c
index d4cc8667a5b72..30b8821c54ad4 100644
--- a/fs/gfs2/util.c
+++ b/fs/gfs2/util.c
@@ -9,6 +9,7 @@
 #include <linux/spinlock.h>
 #include <linux/completion.h>
 #include <linux/buffer_head.h>
+#include <linux/kthread.h>
 #include <linux/crc32.h>
 #include <linux/gfs2_ondisk.h>
 #include <linux/delay.h>
@@ -153,7 +154,23 @@ static void signal_our_withdraw(struct gfs2_sbd *sdp)
 	if (!sb_rdonly(sdp->sd_vfs)) {
 		bool locked = mutex_trylock(&sdp->sd_freeze_mutex);
 
-		gfs2_make_fs_ro(sdp);
+		if (sdp->sd_quotad_process &&
+		    current != sdp->sd_quotad_process) {
+			kthread_stop(sdp->sd_quotad_process);
+			sdp->sd_quotad_process = NULL;
+		}
+
+		if (sdp->sd_logd_process &&
+		    current != sdp->sd_logd_process) {
+			kthread_stop(sdp->sd_logd_process);
+			sdp->sd_logd_process = NULL;
+		}
+
+		wait_event_timeout(sdp->sd_log_waitq,
+				   gfs2_log_is_empty(sdp),
+				   HZ * 5);
+
+		sdp->sd_vfs->s_flags |= SB_RDONLY;
 
 		if (locked)
 			mutex_unlock(&sdp->sd_freeze_mutex);
-- 
2.43.0



