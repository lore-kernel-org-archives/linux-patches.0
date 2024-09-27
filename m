Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A4B718893F;
	Fri, 27 Sep 2024 12:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440378; cv=none; b=aZmssZTMIn+N3SNpoSJYi4FZHo7wD/NS5oxMyJSxmvWapEHcNqwqLrQnURdFBmJaKf4gvVvYQCNYxWfDBeCgB+SbIq6w/0LAWOpIPZKuix0lSXyGl/dZgGwMgULdfUecTJ8PXdFyTBEHiGe7kLHzLNt6umsVvkjvGLtvTGZZgGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440378; c=relaxed/simple;
	bh=0GLgpx6K9wYVQFtFGoycL3rImaAWZ3EqjeAOAITbXgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SibavxGDiOC4fgZlBAimLUNGp7RUqj6TT3Ezlm8h7bwzy8+mXQLnhMQqjQKreDYzDJnETaS7gw4ygePgGKXZTrslONY+W0DyafQNOlyC9ood8xigtlOO7RDqu5M/bkbMdV5CtrM8ZTwIV8hLjMo+fs5WnRnZT1iNC4f4PJOT/tQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HHg4GuaR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HHg4GuaR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC30CC4CEC4;
	Fri, 27 Sep 2024 12:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440378;
	bh=0GLgpx6K9wYVQFtFGoycL3rImaAWZ3EqjeAOAITbXgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HHg4GuaRlz9Guy66w5z9VkdfsVHN51m4GG75HoJxOrs3t+Oh7HkyyAV0cJ1J3xmAi
	 Y0D70qCdO/pXKiKE/Y+e1h0vuc3BPn5i6xsjteTyvKwtCK/3lz4R6ZbBr9t2Gj0WOt
	 PDYwUbqt8wH5qaXmLTwVFNMwgwRilt2ID2YzSYxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Chinner <dchinner@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Chandan Babu R <chandanbabu@kernel.org>
Subject: [PATCH 6.1 35/73] xfs: dont use BMBT btree split workers for IO completion
Date: Fri, 27 Sep 2024 14:23:46 +0200
Message-ID: <20240927121721.331166118@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.897851549@linuxfoundation.org>
References: <20240927121719.897851549@linuxfoundation.org>
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

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit c85007e2e3942da1f9361e4b5a9388ea3a8dcc5b ]

When we split a BMBT due to record insertion, we offload it to a
worker thread because we can be deep in the stack when we try to
allocate a new block for the BMBT. Allocation can use several
kilobytes of stack (full memory reclaim, swap and/or IO path can
end up on the stack during allocation) and we can already be several
kilobytes deep in the stack when we need to split the BMBT.

A recent workload demonstrated a deadlock in this BMBT split
offload. It requires several things to happen at once:

1. two inodes need a BMBT split at the same time, one must be
unwritten extent conversion from IO completion, the other must be
from extent allocation.

2. there must be a no available xfs_alloc_wq worker threads
available in the worker pool.

3. There must be sustained severe memory shortages such that new
kworker threads cannot be allocated to the xfs_alloc_wq pool for
both threads that need split work to be run

4. The split work from the unwritten extent conversion must run
first.

5. when the BMBT block allocation runs from the split work, it must
loop over all AGs and not be able to either trylock an AGF
successfully, or each AGF is is able to lock has no space available
for a single block allocation.

6. The BMBT allocation must then attempt to lock the AGF that the
second task queued to the rescuer thread already has locked before
it finds an AGF it can allocate from.

At this point, we have an ABBA deadlock between tasks queued on the
xfs_alloc_wq rescuer thread and a locked AGF. i.e. The queued task
holding the AGF lock can't be run by the rescuer thread until the
task the rescuer thread is runing gets the AGF lock....

This is a highly improbably series of events, but there it is.

There's a couple of ways to fix this, but the easiest way to ensure
that we only punt tasks with a locked AGF that holds enough space
for the BMBT block allocations to the worker thread.

This works for unwritten extent conversion in IO completion (which
doesn't have a locked AGF and space reservations) because we have
tight control over the IO completion stack. It is typically only 6
functions deep when xfs_btree_split() is called because we've
already offloaded the IO completion work to a worker thread and
hence we don't need to worry about stack overruns here.

The other place we can be called for a BMBT split without a
preceeding allocation is __xfs_bunmapi() when punching out the
center of an existing extent. We don't remove extents in the IO
path, so these operations don't tend to be called with a lot of
stack consumed. Hence we don't really need to ship the split off to
a worker thread in these cases, either.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_btree.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -2913,9 +2913,22 @@ xfs_btree_split_worker(
 }
 
 /*
- * BMBT split requests often come in with little stack to work on. Push
+ * BMBT split requests often come in with little stack to work on so we push
  * them off to a worker thread so there is lots of stack to use. For the other
  * btree types, just call directly to avoid the context switch overhead here.
+ *
+ * Care must be taken here - the work queue rescuer thread introduces potential
+ * AGF <> worker queue deadlocks if the BMBT block allocation has to lock new
+ * AGFs to allocate blocks. A task being run by the rescuer could attempt to
+ * lock an AGF that is already locked by a task queued to run by the rescuer,
+ * resulting in an ABBA deadlock as the rescuer cannot run the lock holder to
+ * release it until the current thread it is running gains the lock.
+ *
+ * To avoid this issue, we only ever queue BMBT splits that don't have an AGF
+ * already locked to allocate from. The only place that doesn't hold an AGF
+ * locked is unwritten extent conversion at IO completion, but that has already
+ * been offloaded to a worker thread and hence has no stack consumption issues
+ * we have to worry about.
  */
 STATIC int					/* error */
 xfs_btree_split(
@@ -2929,7 +2942,8 @@ xfs_btree_split(
 	struct xfs_btree_split_args	args;
 	DECLARE_COMPLETION_ONSTACK(done);
 
-	if (cur->bc_btnum != XFS_BTNUM_BMAP)
+	if (cur->bc_btnum != XFS_BTNUM_BMAP ||
+	    cur->bc_tp->t_firstblock == NULLFSBLOCK)
 		return __xfs_btree_split(cur, level, ptrp, key, curp, stat);
 
 	args.cur = cur;


