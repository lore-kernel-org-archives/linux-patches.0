Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4DEC4F93D8;
	Tue, 13 Oct 2026 12:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893358; cv=none; b=UQC1CZnwU1M72s8ETOl2jQFiuZSZdoYib0zEAqRcvBI49ignalBbhi01OzLiqREJzN/nZecKJxv0sSDxN1t/agmnZQTH7A11jaht1QYGYyRlWpKYmnGbkcwUAYvVu9r8z9/BR3Y3j2fzoiPIdFXTPNGINVzyd5oYNa8CWWA93Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893358; c=relaxed/simple;
	bh=gCAD8F22+BxCW7o1d8IlWtDPnLKYf+fZThg2iBrO138=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fUJ0saWet587ugjnnvbwv4BXAJZ5j4dc9UIPAMPJtQF2wzwwv5p/K7ArK2+rC/aosHQ5jE1edRqnyf6tipwIZZPkY57MjMckkTLbWRkqRod1G7kxDLxT1etjhXuEjE6p1YMddqguz/qjhrSlfBouA8TKg7Px0HUioKKPqkfr9rU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wgX2SA17; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wgX2SA17"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F47F1F000FF;
	Tue, 13 Oct 2026 12:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893357;
	bh=Rzum73nTbRqeTwuzBkYPbBXVtqusy9c9AKf4lFgjWn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wgX2SA17E/eY7lm4YudZP5H/rM764VfzHfniuR9QQOSjCN3kkUnqNZ0GUpEWRm5TP
	 IuNuOBJyQH2wslMZ+YEDJ2fpco3MLi0eeI83nx4coQTRRp3sfmwkD7Sn1yhTdGMzlm
	 ddWfGDSmnYwInfO110NNBLfuwaDLh7Rn06xxj/P0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+aac438d7a1c44071e04b@syzkaller.appspotmail.com,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 197/621] gfs2: fix memory leaks in gfs2_fill_super error path
Date: Tue, 13 Oct 2026 13:33:12 +0200
Message-ID: <20261013112925.539655838@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 3138cc4658d3d..4ac80436c4dc8 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -1283,7 +1283,6 @@ static int gfs2_fill_super(struct super_block *sb, struct fs_context *fc)
 
 	if (error) {
 		gfs2_freeze_unlock(sdp);
-		gfs2_destroy_threads(sdp);
 		fs_err(sdp, "can't make FS RW: %d\n", error);
 		goto fail_per_node;
 	}
@@ -1293,6 +1292,7 @@ static int gfs2_fill_super(struct super_block *sb, struct fs_context *fc)
 
 fail_per_node:
 	init_per_node(sdp, UNDO);
+	gfs2_destroy_threads(sdp);
 fail_inodes:
 	init_inodes(sdp, UNDO);
 fail_sb:
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 0e08d2c5c1555..e82a7cac00df1 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -147,8 +147,10 @@ int gfs2_make_fs_rw(struct gfs2_sbd *sdp)
 	}
 
 	error = gfs2_quota_init(sdp);
-	if (!error && gfs2_withdrawn(sdp))
+	if (!error && gfs2_withdrawn(sdp)) {
+		gfs2_quota_cleanup(sdp);
 		error = -EIO;
+	}
 	if (!error)
 		set_bit(SDF_JOURNAL_LIVE, &sdp->sd_flags);
 	return error;
-- 
2.53.0



