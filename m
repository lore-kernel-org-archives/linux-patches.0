Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07FCB3F23AA;
	Tue, 17 Mar 2026 16:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766116; cv=none; b=AoQL2X4BG4+FthDH/i4J7zbRdj+PoCj7IrfiqNThcK+5WGrAWp2UGrztmEXYv6sIAhI4m77KqMKOMWGx1qMNBzkB87hBvZELNgOIlEAxKdK8dB7K9qdY8Fj1wM9FtbyLMFtjX5Aa7x/X7rshzqVO2nWTgZ1a9YaIGh9RpgqIRis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766116; c=relaxed/simple;
	bh=C7XSwJ296z9I1jN7oLAKQgxmzzj2Rgyhblmrhm/vKqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ciLyNP0IrBAkACEmrpnN29g6rseRYzSMBHkPgogsgAJJNncty0iudrmD00MOsIfxoORgZk/9OKts6Y4yJ6OKMt/bv3a75Smi7+hf/EYe5PXEEcyjULpjRbuIw1giA3NNy84Mix3EBTYjQvccygpqbaW4VpgdbB/QyneJw2cTeV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MWj2MNV5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MWj2MNV5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB6F2C4CEF7;
	Tue, 17 Mar 2026 16:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766115;
	bh=C7XSwJ296z9I1jN7oLAKQgxmzzj2Rgyhblmrhm/vKqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MWj2MNV5toc+/5LkZnFBE+4B8/jD8+O9hgdQ8q2sHTxdD46fp1nJnadV7mO99RKH9
	 zbGlpVIqrbLcnfTxXuwA5j3gHOG8TTvzCsV77rzvD+3Pjr4aN7R8kfRdLl0W9knlQE
	 3m3yw5cHxBcMTD1ae0DFmQoTdhokQ/kpFw7+E2XE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.19 174/378] ceph: fix i_nlink underrun during async unlink
Date: Tue, 17 Mar 2026 17:32:11 +0100
Message-ID: <20260317163013.410567523@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

From: Max Kellermann <max.kellermann@ionos.com>

commit ce0123cbb4a40a2f1bbb815f292b26e96088639f upstream.

During async unlink, we drop the `i_nlink` counter before we receive
the completion (that will eventually update the `i_nlink`) because "we
assume that the unlink will succeed".  That is not a bad idea, but it
races against deletions by other clients (or against the completion of
our own unlink) and can lead to an underrun which emits a WARNING like
this one:

 WARNING: CPU: 85 PID: 25093 at fs/inode.c:407 drop_nlink+0x50/0x68
 Modules linked in:
 CPU: 85 UID: 3221252029 PID: 25093 Comm: php-cgi8.1 Not tainted 6.14.11-cm4all1-ampere #655
 Hardware name: Supermicro ARS-110M-NR/R12SPD-A, BIOS 1.1b 10/17/2023
 pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
 pc : drop_nlink+0x50/0x68
 lr : ceph_unlink+0x6c4/0x720
 sp : ffff80012173bc90
 x29: ffff80012173bc90 x28: ffff086d0a45aaf8 x27: ffff0871d0eb5680
 x26: ffff087f2a64a718 x25: 0000020000000180 x24: 0000000061c88647
 x23: 0000000000000002 x22: ffff07ff9236d800 x21: 0000000000001203
 x20: ffff07ff9237b000 x19: ffff088b8296afc0 x18: 00000000f3c93365
 x17: 0000000000070000 x16: ffff08faffcbdfe8 x15: ffff08faffcbdfec
 x14: 0000000000000000 x13: 45445f65645f3037 x12: 34385f6369706f74
 x11: 0000a2653104bb20 x10: ffffd85f26d73290 x9 : ffffd85f25664f94
 x8 : 00000000000000c0 x7 : 0000000000000000 x6 : 0000000000000002
 x5 : 0000000000000081 x4 : 0000000000000481 x3 : 0000000000000000
 x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff08727d3f91e8
 Call trace:
  drop_nlink+0x50/0x68 (P)
  vfs_unlink+0xb0/0x2e8
  do_unlinkat+0x204/0x288
  __arm64_sys_unlinkat+0x3c/0x80
  invoke_syscall.constprop.0+0x54/0xe8
  do_el0_svc+0xa4/0xc8
  el0_svc+0x18/0x58
  el0t_64_sync_handler+0x104/0x130
  el0t_64_sync+0x154/0x158

In ceph_unlink(), a call to ceph_mdsc_submit_request() submits the
CEPH_MDS_OP_UNLINK to the MDS, but does not wait for completion.

Meanwhile, between this call and the following drop_nlink() call, a
worker thread may process a CEPH_CAP_OP_IMPORT, CEPH_CAP_OP_GRANT or
just a CEPH_MSG_CLIENT_REPLY (the latter of which could be our own
completion).  These will lead to a set_nlink() call, updating the
`i_nlink` counter to the value received from the MDS.  If that new
`i_nlink` value happens to be zero, it is illegal to decrement it
further.  But that is exactly what ceph_unlink() will do then.

The WARNING can be reproduced this way:

1. Force async unlink; only the async code path is affected.  Having
   no real clue about Ceph internals, I was unable to find out why the
   MDS wouldn't give me the "Fxr" capabilities, so I patched
   get_caps_for_async_unlink() to always succeed.

   (Note that the WARNING dump above was found on an unpatched kernel,
   without this kludge - this is not a theoretical bug.)

2. Add a sleep call after ceph_mdsc_submit_request() so the unlink
   completion gets handled by a worker thread before drop_nlink() is
   called.  This guarantees that the `i_nlink` is already zero before
   drop_nlink() runs.

The solution is to skip the counter decrement when it is already zero,
but doing so without a lock is still racy (TOCTOU).  Since
ceph_fill_inode() and handle_cap_grant() both hold the
`ceph_inode_info.i_ceph_lock` spinlock while set_nlink() runs, this
seems like the proper lock to protect the `i_nlink` updates.

I found prior art in NFS and SMB (using `inode.i_lock`) and AFS (using
`afs_vnode.cb_lock`).  All three have the zero check as well.

Cc: stable@vger.kernel.org
Fixes: 2ccb45462aea ("ceph: perform asynchronous unlink if we have sufficient caps")
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/dir.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -1339,6 +1339,7 @@ static int ceph_unlink(struct inode *dir
 	struct ceph_client *cl = fsc->client;
 	struct ceph_mds_client *mdsc = fsc->mdsc;
 	struct inode *inode = d_inode(dentry);
+	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_mds_request *req;
 	bool try_async = ceph_test_mount_opt(fsc, ASYNC_DIROPS);
 	struct dentry *dn;
@@ -1424,7 +1425,19 @@ retry:
 			 * We have enough caps, so we assume that the unlink
 			 * will succeed. Fix up the target inode and dcache.
 			 */
-			drop_nlink(inode);
+
+			/*
+			 * Protect the i_nlink update with i_ceph_lock
+			 * to precent racing against ceph_fill_inode()
+			 * handling our completion on a worker thread
+			 * and don't decrement if i_nlink has already
+			 * been updated to zero by this completion.
+			 */
+			spin_lock(&ci->i_ceph_lock);
+			if (inode->i_nlink > 0)
+				drop_nlink(inode);
+			spin_unlock(&ci->i_ceph_lock);
+
 			d_delete(dentry);
 		} else {
 			spin_lock(&fsc->async_unlink_conflict_lock);


