Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C46A32DF134;
	Sat, 30 May 2026 16:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780158861; cv=none; b=NJt+zW8bRXGFXw4xO98Skyp0Q6/xqMc62DdJ/ack6gjhO7zB07fzWWOQYyk4SXVXD79yg6jeDs265sI8HLMd+yP4Mr4G51aX3fFg7pcIh8evhxSOFeyQUDVJVb5SGrds2n1vzE5TwDePcXeqoJB6q6H5myNcNM1UZhGudKaWzt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780158861; c=relaxed/simple;
	bh=XA+7ZWw0iZbziAo0taxGBYRXXXKKEu5qYKxqWR0WXvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tNgDElVv+Rff5stAefaRPl5QbMTTqJ3ipWc6AZ3Vhp6j+ikNtVfbVxeOciAPJWjy/KbO7RLHLZweGSYiKJFjM3hCSyeN6He8o4K6PTILvwZKSCyZB+NeXFxCKxPhN+++/Bxck49UVYoIgH5zv50IV4OdERaH0qXpp1RjnH8nwgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0+lUfrQp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0+lUfrQp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EAB21F00893;
	Sat, 30 May 2026 16:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780158860;
	bh=azAG3VrZHzxuKlVkE9alaKvetDIIDLd4O3Nhe0fC6FM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0+lUfrQp9Pn78K/r5bBtJoGrwqUbHyhQ8zBpT0qhTE2tbLD05jSeBxBxOqERgMPvp
	 VYhJrujhT+PZaGn0Mm2T5TlxJsQoO50i1VA8RjDOhXO9ZTHyPOmsAaqeVQPFK/4nix
	 u2f1iPjCEsHqdxc7cSsyfQTcbyzTqmKa2qtYT68w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+67b90111784a3eac8c04@syzkaller.appspotmail.com,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Joseph Qi <jiangqi903@gmail.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 084/969] ocfs2: fix possible deadlock between unlink and dio_end_io_write
Date: Sat, 30 May 2026 17:53:28 +0200
Message-ID: <20260530160302.662437592@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joseph Qi <joseph.qi@linux.alibaba.com>

commit b02da26a992db0c0e2559acbda0fc48d4a2fd337 upstream.

ocfs2_unlink takes orphan dir inode_lock first and then ip_alloc_sem,
while in ocfs2_dio_end_io_write, it acquires these locks in reverse order.
This creates an ABBA lock ordering violation on lock classes
ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE] and
ocfs2_file_ip_alloc_sem_key.

Lock Chain #0 (orphan dir inode_lock -> ip_alloc_sem):
ocfs2_unlink
  ocfs2_prepare_orphan_dir
    ocfs2_lookup_lock_orphan_dir
      inode_lock(orphan_dir_inode) <- lock A
    __ocfs2_prepare_orphan_dir
      ocfs2_prepare_dir_for_insert
        ocfs2_extend_dir
	  ocfs2_expand_inline_dir
	    down_write(&oi->ip_alloc_sem) <- Lock B

Lock Chain #1 (ip_alloc_sem -> orphan dir inode_lock):
ocfs2_dio_end_io_write
  down_write(&oi->ip_alloc_sem) <- Lock B
  ocfs2_del_inode_from_orphan()
    inode_lock(orphan_dir_inode) <- Lock A

Deadlock Scenario:
  CPU0 (unlink)                     CPU1 (dio_end_io_write)
  ------                            ------
  inode_lock(orphan_dir_inode)
                                    down_write(ip_alloc_sem)
  down_write(ip_alloc_sem)
                                    inode_lock(orphan_dir_inode)

Since ip_alloc_sem is to protect allocation changes, which is unrelated
with operations in ocfs2_del_inode_from_orphan.  So move
ocfs2_del_inode_from_orphan out of ip_alloc_sem to fix the deadlock.

Link: https://lkml.kernel.org/r/20260306032211.1016452-1-joseph.qi@linux.alibaba.com
Reported-by: syzbot+67b90111784a3eac8c04@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=67b90111784a3eac8c04
Fixes: a86a72a4a4e0 ("ocfs2: take ip_alloc_sem in ocfs2_dio_get_block & ocfs2_dio_end_io_write")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/aops.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -2322,8 +2322,6 @@ static int ocfs2_dio_end_io_write(struct
 		goto out;
 	}
 
-	down_write(&oi->ip_alloc_sem);
-
 	/* Delete orphan before acquire i_rwsem. */
 	if (dwc->dw_orphaned) {
 		BUG_ON(dwc->dw_writer_pid != task_pid_nr(current));
@@ -2336,6 +2334,7 @@ static int ocfs2_dio_end_io_write(struct
 			mlog_errno(ret);
 	}
 
+	down_write(&oi->ip_alloc_sem);
 	di = (struct ocfs2_dinode *)di_bh->b_data;
 
 	ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(inode), di_bh);


