Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A4DD33290F;
	Fri, 17 Oct 2025 15:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714017; cv=none; b=o2XYDIlvA6LlrgpXAI1YyNBVXviAYQ+pr+NdlRnVIMLtSfRZr2odCl5BYg2/bWZ/EZUAn5FVwaTolSYxNQkhLph1hBeSLvek92Or6c6KBS+ckbcESWAQFpaUt/l5pY6y2pNITsba2zrIBGeR2LCOZ5cNMkFGQriw/MHay5DEjUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714017; c=relaxed/simple;
	bh=1wfBPW5gRNL5+HzeDyPWz8WTikKXTnAPdf6gHMHyC2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ffUP/UCMXV5IUEhjjWkUdsVYvH/GiqAYhcxie+k3uSq8debmMRqw+pZoyxR2z2OICprOXPpwvBeZBVCFiS8bmY/NSNaMcYUfTMoj49ztqD3XF6KH2dbYNdH0Uun2a8uy79PfyhWdj2Or8Pb5aevHv+a36kL18v0ltDja0hU6EA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dYnSGdcg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dYnSGdcg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B306CC4CEE7;
	Fri, 17 Oct 2025 15:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714017;
	bh=1wfBPW5gRNL5+HzeDyPWz8WTikKXTnAPdf6gHMHyC2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dYnSGdcg9jGQeVNBr8kT9wbqzLcVjrZJpYwuMGOLxGiaqrTeuPyLLVDbYJIRGu5Y5
	 P7kqCGrbPBQaT7jqV2li4HGK3gBAoSQZ3XBoFe/+GLJ7rnjFc2MCkL1NJzLCsesRpS
	 Nv+YQ1svlVOLbstPtNg5keXmRaBmiCseejtFZXGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 200/201] writeback: Avoid excessively long inode switching times
Date: Fri, 17 Oct 2025 16:54:21 +0200
Message-ID: <20251017145142.106178814@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

From: Jan Kara <jack@suse.cz>

[ Upstream commit 9a6ebbdbd41235ea3bc0c4f39e2076599b8113cc ]

With lazytime mount option enabled we can be switching many dirty inodes
on cgroup exit to the parent cgroup. The numbers observed in practice
when systemd slice of a large cron job exits can easily reach hundreds
of thousands or millions. The logic in inode_do_switch_wbs() which sorts
the inode into appropriate place in b_dirty list of the target wb
however has linear complexity in the number of dirty inodes thus overall
time complexity of switching all the inodes is quadratic leading to
workers being pegged for hours consuming 100% of the CPU and switching
inodes to the parent wb.

Simple reproducer of the issue:
  FILES=10000
  # Filesystem mounted with lazytime mount option
  MNT=/mnt/
  echo "Creating files and switching timestamps"
  for (( j = 0; j < 50; j ++ )); do
      mkdir $MNT/dir$j
      for (( i = 0; i < $FILES; i++ )); do
          echo "foo" >$MNT/dir$j/file$i
      done
      touch -a -t 202501010000 $MNT/dir$j/file*
  done
  wait
  echo "Syncing and flushing"
  sync
  echo 3 >/proc/sys/vm/drop_caches

  echo "Reading all files from a cgroup"
  mkdir /sys/fs/cgroup/unified/mycg1 || exit
  echo $$ >/sys/fs/cgroup/unified/mycg1/cgroup.procs || exit
  for (( j = 0; j < 50; j ++ )); do
      cat /mnt/dir$j/file* >/dev/null &
  done
  wait
  echo "Switching wbs"
  # Now rmdir the cgroup after the script exits

We need to maintain b_dirty list ordering to keep writeback happy so
instead of sorting inode into appropriate place just append it at the
end of the list and clobber dirtied_time_when. This may result in inode
writeback starting later after cgroup switch however cgroup switches are
rare so it shouldn't matter much. Since the cgroup had write access to
the inode, there are no practical concerns of the possible DoS issues.

Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fs-writeback.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 0454a1f0fc636..274fae88b498e 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -422,22 +422,23 @@ static bool inode_do_switch_wbs(struct inode *inode,
 	 * Transfer to @new_wb's IO list if necessary.  If the @inode is dirty,
 	 * the specific list @inode was on is ignored and the @inode is put on
 	 * ->b_dirty which is always correct including from ->b_dirty_time.
-	 * The transfer preserves @inode->dirtied_when ordering.  If the @inode
-	 * was clean, it means it was on the b_attached list, so move it onto
-	 * the b_attached list of @new_wb.
+	 * If the @inode was clean, it means it was on the b_attached list, so
+	 * move it onto the b_attached list of @new_wb.
 	 */
 	if (!list_empty(&inode->i_io_list)) {
 		inode->i_wb = new_wb;
 
 		if (inode->i_state & I_DIRTY_ALL) {
-			struct inode *pos;
-
-			list_for_each_entry(pos, &new_wb->b_dirty, i_io_list)
-				if (time_after_eq(inode->dirtied_when,
-						  pos->dirtied_when))
-					break;
+			/*
+			 * We need to keep b_dirty list sorted by
+			 * dirtied_time_when. However properly sorting the
+			 * inode in the list gets too expensive when switching
+			 * many inodes. So just attach inode at the end of the
+			 * dirty list and clobber the dirtied_time_when.
+			 */
+			inode->dirtied_time_when = jiffies;
 			inode_io_list_move_locked(inode, new_wb,
-						  pos->i_io_list.prev);
+						  &new_wb->b_dirty);
 		} else {
 			inode_cgwb_move_to_attached(inode, new_wb);
 		}
-- 
2.51.0



