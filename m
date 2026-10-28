Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215003;
	b=Jf5WWgopew2dmHSr7LhPzg70kWi788aFBlzQK8g+ZhoP/esYOyOSkTku+HqIpJORNCCN
	 tAQu4Ao5Rpth03FUHnY/Ioz3OnBxCmDLM2zLGIsSefWypHIsbz4WduNYQPsKg1fzVQdEA
	 gYKh0pVYz7b3JFVVsyp6iBfQ0QuwUtIzGpA4K6SuLzwnEyi59cImyVN1DCzKxiBGuZAiD
	 +84EUx8n0QebcpPWcbKSyKWxlvI6pTYhVBqlT1hy39WLkYvL23UFbcYkohKAhHV/+yXqa
	 JRu/a2ErLbakbBpTJOnafnY853Fni41Xa9Zbsgr/pfhsJXpwgx1XsMirZU73P92f4UQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215003;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e0x+xkKUdV4hdPkYLeeuzEW+5bjY+vuGU04lPVfjH+0=;
	b=h5W8OmEIhBvIaRnXSXuq63SYKBxqADNPLfZQFtxrGKp9g08tE2HB6Da+OAar9Qn1vmp2
	 sCR7IZ58PziA6NHHp2UgdJlkH8wgiFXMKO5OkyWDTnmgADMYDrsWfjEXaFJrABoiWqhZx
	 XSFUSZVAWzQJ4hrZ+eAIzSPHPpB60wnJz8xi9IWw3s3ebrqKl+E9y47VFqKTouIE1X0Vp
	 ScjEF54xQcj/Qot2an7YatxwPizxRzSQQErzJK0nkAjoDiQzLIFvJf4efSEbSTI45w7k2
	 DzaFnauozrIeeP40Y7Rv0La+QtujStlRKlnej7fbgtOeNONwJ79tJEQgtKLiJyefQUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hkcGI7I9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87DB1606A31C;
	Wed, 28 Oct 2026 19:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hkcGI7I9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D861C1F01825;
	Wed, 28 Oct 2026 19:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215003;
	bh=e0x+xkKUdV4hdPkYLeeuzEW+5bjY+vuGU04lPVfjH+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hkcGI7I9c+3msb8WBfdbsTD9lziRq87cj6gYf9bijADVkUyTHG0u0xbq/o6wvOYBV
	 JvGpJSfOp+6cTrwJpDkRd5SaaDenNDC1YrMYqO4/cCFkU6jssd6y0aoG990zGnn0Fe
	 i/TSx1UhHhHrQbY4HKzvANWaGsdEd9BZceAR5TZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+aac438d7a1c44071e04b@syzkaller.appspotmail.com,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1041/1887] gfs2: fix memory leaks in gfs2_fill_super error path
Date: Wed, 28 Oct 2026 17:52:17 +0100
Message-ID: <20261028170523.100588190@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 fs/gfs2/ops_fstype.c | 12 ++++++------
 fs/gfs2/super.c      |  4 +++-
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index ec019e38cf7fa..0b457be8d99e2 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -1273,12 +1273,6 @@ static int gfs2_fill_super(struct super_block *sb, struct fs_context *fc)
 
 	if (error) {
 		gfs2_freeze_unlock(&sdp->sd_freeze_gh);
-		if (sdp->sd_quotad_process)
-			kthread_stop(sdp->sd_quotad_process);
-		sdp->sd_quotad_process = NULL;
-		if (sdp->sd_logd_process)
-			kthread_stop(sdp->sd_logd_process);
-		sdp->sd_logd_process = NULL;
 		fs_err(sdp, "can't make FS RW: %d\n", error);
 		goto fail_per_node;
 	}
@@ -1288,6 +1282,12 @@ static int gfs2_fill_super(struct super_block *sb, struct fs_context *fc)
 
 fail_per_node:
 	init_per_node(sdp, UNDO);
+	if (sdp->sd_quotad_process)
+		kthread_stop(sdp->sd_quotad_process);
+	sdp->sd_quotad_process = NULL;
+	if (sdp->sd_logd_process)
+		kthread_stop(sdp->sd_logd_process);
+	sdp->sd_logd_process = NULL;
 fail_inodes:
 	init_inodes(sdp, UNDO);
 fail_sb:
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 4b56a163669ca..644e74c33f8d2 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -157,8 +157,10 @@ int gfs2_make_fs_rw(struct gfs2_sbd *sdp)
 	gfs2_log_pointers_init(sdp, head.lh_blkno);
 
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



