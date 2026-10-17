Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE38D3BFE2D;
	Sat, 17 Oct 2026 17:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258656; cv=none; b=h/3V6DQ5J1p8xqdWoj/JKHvnSX5a2pVMAPk/xH4Ofuj9ysQMOnBy02iTKls0e19vPcOkBvK5akqNk4n95eIaWKJLYXV/MqvMN35BfgjDU9AvU2ZMB6eNr7husTeatgXXECjq+1NSg2wqDewXtJkNOuVPDQXUQAojLzy3xVEceo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258656; c=relaxed/simple;
	bh=doNwbU2D5Wa/hiouONhy2fP60wbpraxl+ew0EpTeic0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iuV+F+3EimgD8bU36Bny/A1cDPCuzlU7B8zKBs6O2XXabfFkKIT+oiXqYegCxQ4MlMGlSHf7ED8b0HhbEiloxnKb+lgi0sav8xcmV/ja3YAWAZBgfC8Xf+azoTgBcMRfFfaa555PFfRtm+Go/SvJRYDwGAVFeCSXe4sp0+QlYUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fCaXUjVo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fCaXUjVo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BF1B1F000C5;
	Sat, 17 Oct 2026 17:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258655;
	bh=7KM96N9zAy870/d/fM/xfBLJcUAsxNAjOeA0HrnEZRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fCaXUjVonTenWS21EuNCS7tsmNvhgOeiNovP4pCWf/ijZAEKu2Mr1xthYY04XnnYh
	 4P7MwEnEDQ3GW3ms8Pp6TKsDgkFE/701CHWGyOiy0T74RohTj1YQWg4Uny6po8HyqF
	 wYfKqHmlPwaFUHiupOh6Hh1hFbmNsgNJxKu4D2rM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+aac438d7a1c44071e04b@syzkaller.appspotmail.com,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0956/1674] gfs2: fix memory leaks in gfs2_fill_super error path
Date: Sat, 17 Oct 2026 17:53:48 +0200
Message-ID: <20261017160455.668149866@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Deepanshu Kartikey <kartikey406@gmail.com>

[ Upstream commit da6f5bbc2e7902f578b503f2a4c3d8d09ca4b102 ]

Fix two memory leaks in the gfs2_fill_super() error handling path when
transitioning a filesystem to read-write mode fails.

First leak: kthread objects (thread_struct, task_struct, etc.)
When gfs2_freeze_lock_shared() fails after init_threads() succeeds, the
created kernel threads (logd and quotad) are never destroyed. This
occurs because the fail_per_node label doesn't call
gfs2_destroy_threads().

Second leak: quota bitmap buffer (8192 bytes)
When gfs2_make_fs_rw() fails after gfs2_quota_init() succeeds but
before other operations complete, the allocated quota bitmap is never
freed.

The fix moves thread cleanup to the fail_per_node label to handle all
error paths uniformly. gfs2_destroy_threads() is safe to call
unconditionally as it checks for NULL pointers. Quota cleanup is added
in gfs2_make_fs_rw() to properly handle the withdrawal case where
quota initialization succeeds but the filesystem is then withdrawn.

Thread leak backtrace (gfs2_freeze_lock_shared failure):
  unreferenced object 0xffff88801d7bca80 (size 4480):
    copy_process+0x3a1/0x4670 kernel/fork.c:2422
    kernel_clone+0xf3/0x6e0 kernel/fork.c:2779
    kthread_create_on_node+0x100/0x150 kernel/kthread.c:478
    init_threads+0xab/0x350 fs/gfs2/ops_fstype.c:611
    gfs2_fill_super+0xe5c/0x1240 fs/gfs2/ops_fstype.c:1265

Quota leak backtrace (gfs2_make_fs_rw failure):
  unreferenced object 0xffff88812de7c000 (size 8192):
    gfs2_quota_init+0xe5/0x820 fs/gfs2/quota.c:1409
    gfs2_make_fs_rw+0x7a/0xe0 fs/gfs2/super.c:149
    gfs2_fill_super+0xfbb/0x1240 fs/gfs2/ops_fstype.c:1275

Reported-by: syzbot+aac438d7a1c44071e04b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=aac438d7a1c44071e04b
Fixes: 6c7410f44961 ("gfs2: gfs2_freeze_lock_shared cleanup")
Fixes: b66f723bb552 ("gfs2: Improve gfs2_make_fs_rw error handling")
Link: https://lore.kernel.org/all/20260131062509.77974-1-kartikey406@gmail.com/T/ [v1]
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/ops_fstype.c | 2 +-
 fs/gfs2/super.c      | 4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 65da3ae6d48e4..3a13cd3781cc5 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -1292,7 +1292,6 @@ static int gfs2_fill_super(struct super_block *sb, struct fs_context *fc)
 
 	if (error) {
 		gfs2_freeze_unlock(&sdp->sd_freeze_gh);
-		gfs2_destroy_threads(sdp);
 		fs_err(sdp, "can't make FS RW: %d\n", error);
 		goto fail_per_node;
 	}
@@ -1302,6 +1301,7 @@ static int gfs2_fill_super(struct super_block *sb, struct fs_context *fc)
 
 fail_per_node:
 	init_per_node(sdp, UNDO);
+	gfs2_destroy_threads(sdp);
 fail_inodes:
 	init_inodes(sdp, UNDO);
 fail_sb:
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index ee370c586014e..a5024cfd618d7 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -157,8 +157,10 @@ int gfs2_make_fs_rw(struct gfs2_sbd *sdp)
 	gfs2_log_pointers_init(sdp, head.lh_blkno);
 
 	error = gfs2_quota_init(sdp);
-	if (!error && gfs2_withdrawing_or_withdrawn(sdp))
+	if (!error && gfs2_withdrawing_or_withdrawn(sdp)) {
+		gfs2_quota_cleanup(sdp);
 		error = -EIO;
+	}
 	if (!error)
 		set_bit(SDF_JOURNAL_LIVE, &sdp->sd_flags);
 	return error;
-- 
2.53.0



