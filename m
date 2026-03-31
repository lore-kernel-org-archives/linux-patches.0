Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8560E41B373;
	Tue, 31 Mar 2026 16:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976065; cv=none; b=r1hRNhXanZ7IGqLxket27uz2wKC8eVi4uukqtpFY5xwvPO2vF6eYI7LqYvz5Bw3u3ZV8gr/x3iiA6K3G1MiOX5zp97vpNIUonwJd91p6DzRuCRH0GW6orbHUL+AIkvXjy7TwDvyC7N5jU5HwlrCo3ajbe76C8ixghOlGgoAHOuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976065; c=relaxed/simple;
	bh=iTe7D5iPbjHvs1M1kPVUe5/6MaynOoXPf9OgiCIiBKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t4+Hc7X2JIQMG2sljVaYmZoufjIfGWDjP78SR6XIU4idhEyJFHBYCjZxo1CWOrQrn2DNamI9PoNln6fbF6WX36yp7NeKlsfna+kqCU+mNxg5c0q95wZMiJtJtfNYi4CTKp0vXvbLKRRfnvxLazaewep/HW0H2gK8gUu2cGuaeE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Wogo2wr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Wogo2wr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C3AEC19423;
	Tue, 31 Mar 2026 16:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976065;
	bh=iTe7D5iPbjHvs1M1kPVUe5/6MaynOoXPf9OgiCIiBKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Wogo2wrjzprD/jf9D6JrLm2j8xeTqVxQSral3h/dJbg15rchvSuL/wVe/wZAvsee
	 qPqI4g0Sry9tSZUpZGDLugMTMwcg/nUb0vQprlfZDuQQzpaik7YJEKhUbh24B62pX/
	 dap+JFQPZcfrKoQKlWB6Fdn0p0qKxM7ObTZiVUMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Jan Kara <jack@suse.cz>,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.12 193/244] ext4: fix use-after-free in update_super_work when racing with umount
Date: Tue, 31 Mar 2026 18:22:23 +0200
Message-ID: <20260331161748.879282509@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@shopee.com>

commit d15e4b0a418537aafa56b2cb80d44add83e83697 upstream.

Commit b98535d09179 ("ext4: fix bug_on in start_this_handle during umount
filesystem") moved ext4_unregister_sysfs() before flushing s_sb_upd_work
to prevent new error work from being queued via /proc/fs/ext4/xx/mb_groups
reads during unmount. However, this introduced a use-after-free because
update_super_work calls ext4_notify_error_sysfs() -> sysfs_notify() which
accesses the kobject's kernfs_node after it has been freed by kobject_del()
in ext4_unregister_sysfs():

  update_super_work                ext4_put_super
  -----------------                --------------
                                   ext4_unregister_sysfs(sb)
                                     kobject_del(&sbi->s_kobj)
                                       __kobject_del()
                                         sysfs_remove_dir()
                                           kobj->sd = NULL
                                         sysfs_put(sd)
                                           kernfs_put()  // RCU free
  ext4_notify_error_sysfs(sbi)
    sysfs_notify(&sbi->s_kobj)
      kn = kobj->sd              // stale pointer
      kernfs_get(kn)             // UAF on freed kernfs_node
                                   ext4_journal_destroy()
                                     flush_work(&sbi->s_sb_upd_work)

Instead of reordering the teardown sequence, fix this by making
ext4_notify_error_sysfs() detect that sysfs has already been torn down
by checking s_kobj.state_in_sysfs, and skipping the sysfs_notify() call
in that case. A dedicated mutex (s_error_notify_mutex) serializes
ext4_notify_error_sysfs() against kobject_del() in ext4_unregister_sysfs()
to prevent TOCTOU races where the kobject could be deleted between the
state_in_sysfs check and the sysfs_notify() call.

Fixes: b98535d09179 ("ext4: fix bug_on in start_this_handle during umount filesystem")
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260319120336.157873-1-jiayuan.chen@linux.dev
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/ext4.h  |    1 +
 fs/ext4/super.c |    1 +
 fs/ext4/sysfs.c |   10 +++++++++-
 3 files changed, 11 insertions(+), 1 deletion(-)

--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1534,6 +1534,7 @@ struct ext4_sb_info {
 	struct proc_dir_entry *s_proc;
 	struct kobject s_kobj;
 	struct completion s_kobj_unregister;
+	struct mutex s_error_notify_mutex; /* protects sysfs_notify vs kobject_del */
 	struct super_block *s_sb;
 	struct buffer_head *s_mmp_bh;
 
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5313,6 +5313,7 @@ static int __ext4_fill_super(struct fs_c
 
 	timer_setup(&sbi->s_err_report, print_daily_error_info, 0);
 	spin_lock_init(&sbi->s_error_lock);
+	mutex_init(&sbi->s_error_notify_mutex);
 	INIT_WORK(&sbi->s_sb_upd_work, update_super_work);
 
 	err = ext4_group_desc_init(sb, es, logical_sb_block, &first_not_zeroed);
--- a/fs/ext4/sysfs.c
+++ b/fs/ext4/sysfs.c
@@ -551,7 +551,10 @@ static const struct kobj_type ext4_feat_
 
 void ext4_notify_error_sysfs(struct ext4_sb_info *sbi)
 {
-	sysfs_notify(&sbi->s_kobj, NULL, "errors_count");
+	mutex_lock(&sbi->s_error_notify_mutex);
+	if (sbi->s_kobj.state_in_sysfs)
+		sysfs_notify(&sbi->s_kobj, NULL, "errors_count");
+	mutex_unlock(&sbi->s_error_notify_mutex);
 }
 
 static struct kobject *ext4_root;
@@ -564,8 +567,10 @@ int ext4_register_sysfs(struct super_blo
 	int err;
 
 	init_completion(&sbi->s_kobj_unregister);
+	mutex_lock(&sbi->s_error_notify_mutex);
 	err = kobject_init_and_add(&sbi->s_kobj, &ext4_sb_ktype, ext4_root,
 				   "%s", sb->s_id);
+	mutex_unlock(&sbi->s_error_notify_mutex);
 	if (err) {
 		kobject_put(&sbi->s_kobj);
 		wait_for_completion(&sbi->s_kobj_unregister);
@@ -598,7 +603,10 @@ void ext4_unregister_sysfs(struct super_
 
 	if (sbi->s_proc)
 		remove_proc_subtree(sb->s_id, ext4_proc_root);
+
+	mutex_lock(&sbi->s_error_notify_mutex);
 	kobject_del(&sbi->s_kobj);
+	mutex_unlock(&sbi->s_error_notify_mutex);
 }
 
 int __init ext4_init_sysfs(void)


