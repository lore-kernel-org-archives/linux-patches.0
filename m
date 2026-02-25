Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E7072494FE;
	Wed, 25 Feb 2026 01:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982839; cv=none; b=guJJB1DSp1Fj23K9o+5y1d3XjrVZJJNSyxySv8wrhOTn9UrbwTmQGQiQn7xvO2gfR4I2gKg/42LDFZpeu5ir2AaRikvQRFN5yIe/jyKVau4UA4enbp++PxkpPCEi+8utmoO6lDUtA3gr2QLQW6StrPE9c7uOjpQawfTBUktquV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982839; c=relaxed/simple;
	bh=t6qsHfydwdeDQ78bSaZ9yUxfxqg28T7Gx3twQTivgyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qsQqgpTnXOI91Ad0fnIMMNcQBP45GSbiz61v3kvFLbnC6SSNHWIg3xW/L0Z2ltFOunapDTFfWL5z4CPEfQ9+6fzEFx2vMkzCBT4KomwTb0X4B5YsJevIlsQUsO8ksP2xWsfUCoTYZ/ThHBZ0codJTWSKT6QnwxPgp5bYfdjpMZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bl4PRQVZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bl4PRQVZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBA26C116D0;
	Wed, 25 Feb 2026 01:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982839;
	bh=t6qsHfydwdeDQ78bSaZ9yUxfxqg28T7Gx3twQTivgyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bl4PRQVZRFkfMVKQTZgEkOp85KLn+CJBeCT337nDoGa6hFxvAiVWQyJSVFgXnWPS+
	 ExuWVqJYvu6/VkTnaIt85KGVNZY2Tgf2NUy1Ns8JSRT0qcd+kwpwQcJrvS4N+Ltmdj
	 lvE/6s1x+Ex5+nLiahkPk2BswuMZmmo8aFm3ylZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+aac438d7a1c44071e04b@syzkaller.appspotmail.com,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 031/781] gfs2: fix memory leaks in gfs2_fill_super error path
Date: Tue, 24 Feb 2026 17:12:20 -0800
Message-ID: <20260225012400.463881553@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index e7a88b717991a..c7d57de7c8f06 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -1276,7 +1276,6 @@ static int gfs2_fill_super(struct super_block *sb, struct fs_context *fc)
 
 	if (error) {
 		gfs2_freeze_unlock(sdp);
-		gfs2_destroy_threads(sdp);
 		fs_err(sdp, "can't make FS RW: %d\n", error);
 		goto fail_per_node;
 	}
@@ -1286,6 +1285,7 @@ static int gfs2_fill_super(struct super_block *sb, struct fs_context *fc)
 
 fail_per_node:
 	init_per_node(sdp, UNDO);
+	gfs2_destroy_threads(sdp);
 fail_inodes:
 	init_inodes(sdp, UNDO);
 fail_sb:
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index f6cd907b3ec6c..d96160636161c 100644
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
2.51.0



