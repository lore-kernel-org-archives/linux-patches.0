Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24BC2442B2E;
	Thu, 20 Aug 2026 16:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244488; cv=none; b=QQiblhRzp1M9w/n+mC/qmvwe4OAtMz75QTkiL+aEUp0KLner8sbzhxFSMIkg49XQq7g1ElAxa7BN550kt95Ov2zZM2DTtsnh3L8VNr9sCRNRvOWHWqMnk1KrMS2wTWB6UcTpoO1prIUxwUdfOMk8HcwouNG/wFOwBeOwwynbxYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244488; c=relaxed/simple;
	bh=mVud08j9VKmlFSsiMuDpm/XuKzBAY8I9+GPS3IbQGXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BAUdsWLmKwvlvCcjoNbhG2nm/JWv7+FbRTfNshyFZVJBnZlnK26Mj151VDF+bBEe4T+mo+KNlPLR9qkm1EtmrhhoJSqcjK+v60gI9YUD/K84Lp7VlqTLyjTX+PHCuKw2JDWOdDDqaxlOJRgEENBIWf4gEW6a/+v3vdevKwgUR8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tQDNSc/p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tQDNSc/p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F0A51F000E9;
	Thu, 20 Aug 2026 16:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244487;
	bh=eJhL73Lezp7PPWvgLXr1FuiN+yR5G0DzW9kySRaWjjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tQDNSc/pN2Q+4rO5QdZuJ6Vf/LtYqGRpBKmDtMyBWG4igYROZ9SvwxHQ0uJctxGgw
	 SRMhKkT27tVZVcbVKAcy/cU72Cp+vGESdxpooP5S9lSnAZH/2VxUmyvi2FdA5zZZby
	 5gMEXgsyqgxThoLqbGw0ZL7N9voKshUbl7EHtPIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Xiubo Li <xiubo.li@clyso.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 179/235] ceph: avoid fs reclaim while using current->journal_info
Date: Thu, 20 Aug 2026 16:56:55 +0200
Message-ID: <20260820145221.946879710@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Kellermann <max.kellermann@ionos.com>

[ Upstream commit 5b602344a49e039e792ce5a8923bcc61412ee134 ]

handle_reply() stores a `ceph_mds_request` pointer in
`current->journal_info` while filling the inode and dentry cache from
an MDS reply.

An allocation in this section can enter direct reclaim and prune
dentries from another filesystem.  If this dirties an ext4 inode, ext4
starts a JBD2 transaction.  JBD2 interprets the Ceph request in
`current->journal_info` as a journal handle and dereferences the
request's `r_tid` as `h_transaction`, causing a kernel crash, e.g.:

 Unable to handle kernel paging request at virtual address 00000000077b4818
 [...]
 Internal error: Oops: 0000000096000004 [#1]  SMP
 Modules linked in:
 CPU: 6 UID: 0 PID: 2699135 Comm: kworker/6:3 Tainted: G        W           6.18.38-i3 #1113 NONE
 [...]
 Workqueue: ceph-msgr ceph_con_workfn
 pstate: 80400009 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
 pc : jbd2__journal_start+0x2c/0x208
 lr : __ext4_journal_start_sb+0x100/0x178
 [...]
 Call trace:
  jbd2__journal_start+0x2c/0x208 (P)
  __ext4_journal_start_sb+0x100/0x178
  ext4_dirty_inode+0x3c/0x90
  __mark_inode_dirty+0x58/0x400
  iput.part.0+0x2b0/0x370
  iput+0x18/0x30
  dentry_unlink_inode+0xc0/0x158
  __dentry_kill+0x80/0x250
  shrink_dentry_list+0x90/0x130
  prune_dcache_sb+0x60/0x98
  super_cache_scan+0xe8/0x190
  do_shrink_slab+0x174/0x388
  shrink_slab+0xd8/0x4c0
  shrink_node+0x31c/0x908
  do_try_to_free_pages+0xd0/0x508
  try_to_free_pages+0x11c/0x238
  __alloc_frozen_pages_noprof+0x4d0/0xdd0
  __folio_alloc_noprof+0x18/0x70
  __filemap_get_folio+0x248/0x440
  ceph_readdir_prepopulate+0x570/0x9e8
  mds_dispatch+0x1424/0x1ba0
  ceph_con_process_message+0x74/0xa0
  ceph_con_v1_try_read+0x3a0/0x1510
  ceph_con_workfn+0x260/0x460

Enter a scoped NOFS allocation context and leave it after clearing
`journal_info`.  This prevents filesystem reclaim from recursing into
another filesystem while the field contains Ceph-private data.

Cc: stable@vger.kernel.org
Fixes: 315f24088048 ("ceph: fix security xattr deadlock")
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Reviewed-by: Xiubo Li <xiubo.li@clyso.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/mds_client.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -6,6 +6,7 @@
 #include <linux/slab.h>
 #include <linux/gfp.h>
 #include <linux/sched.h>
+#include <linux/sched/mm.h>
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
 #include <linux/ratelimit.h>
@@ -3126,6 +3127,7 @@ static void handle_reply(struct ceph_mds
 	struct ceph_mds_reply_head *head = msg->front.iov_base;
 	struct ceph_mds_reply_info_parsed *rinfo;  /* parsed reply info */
 	struct ceph_snap_realm *realm;
+	unsigned int nofs_flags;
 	u64 tid;
 	int err, result;
 	int mds = session->s_mds;
@@ -3258,6 +3260,14 @@ static void handle_reply(struct ceph_mds
 
 	/* insert trace into our cache */
 	mutex_lock(&req->r_fill_mutex);
+
+	/* disable fs reclaim while we are using current->journal_info
+	 * for our own purposes, or else shrinkers of other
+	 * filesystems might dereference this pointer as a different
+	 * type
+	 */
+	nofs_flags = memalloc_nofs_save();
+
 	current->journal_info = req;
 	err = ceph_fill_trace(mdsc->fsc->sb, req);
 	if (err == 0) {
@@ -3266,6 +3276,7 @@ static void handle_reply(struct ceph_mds
 			ceph_readdir_prepopulate(req, req->r_session);
 	}
 	current->journal_info = NULL;
+	memalloc_nofs_restore(nofs_flags);
 	mutex_unlock(&req->r_fill_mutex);
 
 	up_read(&mdsc->snap_rwsem);


