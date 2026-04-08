Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6456F347503;
	Wed,  8 Apr 2026 18:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671897; cv=none; b=En2bYsa4+AAKPjk/U32JFXN/iL6WDT/rxRNE+8enptOsqeugXhfdC7Yk6Wlhl4MGYUjkfjQG4sj+5ZvNC2OE6juEWXxTka4l63vM8CpORDG9J3GlJ/AN0jPF4PbvXQ3/t1hFeh+yz93quJTRB3RmO1IapwOUpJvEmNDdN2/MxEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671897; c=relaxed/simple;
	bh=8+bY4mGVsZhOim3Ea6eQx2axF7I16QXCrFMk1oyP4fU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZNuaUYaccpatqSGWuWC9NaJ7Q/vdPb+0kvesE0sWQkhCvt9pvIogWxtndBGSBquEK7VdGV8hjKmgX34mMXVyegDiEkhQS45VenMzNdjowY9Xd32CPvxHROFnkYfekeimDWI0zivkXHKD03LfhxhyH9G8F2UoxKGggAMiA37kut4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KUpJqj0l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KUpJqj0l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECB0BC19421;
	Wed,  8 Apr 2026 18:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671897;
	bh=8+bY4mGVsZhOim3Ea6eQx2axF7I16QXCrFMk1oyP4fU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KUpJqj0lAfd7Zs3Ha/btrsmHQs0bhFif9G1ds3MI4htaPpJDwN22w3qA93DPaFVcR
	 CxZjQbjppGb0VmSwpcnfu4bY2AhNHajw5yDsMF1xo7qSVCVU0tICNtHqcSanIWVH/S
	 x6/IxkDKyYajpXPydGNwt6CdjqukvJXu4aFZtbg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+652af2b3c5569c4ab63c@syzkaller.appspotmail.com,
	Yuto Ohnuki <ytohnuki@amazon.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.1 110/312] xfs: stop reclaim before pushing AIL during unmount
Date: Wed,  8 Apr 2026 20:00:27 +0200
Message-ID: <20260408175937.873424494@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

From: Yuto Ohnuki <ytohnuki@amazon.com>

commit 4f24a767e3d64a5f58c595b5c29b6063a201f1e3 upstream.

The unmount sequence in xfs_unmount_flush_inodes() pushed the AIL while
background reclaim and inodegc are still running. This is broken
independently of any use-after-free issues - background reclaim and
inodegc should not be running while the AIL is being pushed during
unmount, as inodegc can dirty and insert inodes into the AIL during the
flush, and background reclaim can race to abort and free dirty inodes.

Reorder xfs_unmount_flush_inodes() to stop inodegc and cancel background
reclaim before pushing the AIL. Stop inodegc before cancelling
m_reclaim_work because the inodegc worker can re-queue m_reclaim_work
via xfs_inodegc_set_reclaimable.

Reported-by: syzbot+652af2b3c5569c4ab63c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=652af2b3c5569c4ab63c
Fixes: 90c60e164012 ("xfs: xfs_iflush() is no longer necessary")
Cc: stable@vger.kernel.org # v5.9
Signed-off-by: Yuto Ohnuki <ytohnuki@amazon.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_mount.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -575,8 +575,9 @@ xfs_unmount_check(
  * have been retrying in the background.  This will prevent never-ending
  * retries in AIL pushing from hanging the unmount.
  *
- * Finally, we can push the AIL to clean all the remaining dirty objects, then
- * reclaim the remaining inodes that are still in memory at this point in time.
+ * Stop inodegc and background reclaim before pushing the AIL so that they
+ * are not running while the AIL is being flushed. Then push the AIL to
+ * clean all the remaining dirty objects and reclaim the remaining inodes.
  */
 static void
 xfs_unmount_flush_inodes(
@@ -588,9 +589,9 @@ xfs_unmount_flush_inodes(
 
 	set_bit(XFS_OPSTATE_UNMOUNTING, &mp->m_opstate);
 
-	xfs_ail_push_all_sync(mp->m_ail);
 	xfs_inodegc_stop(mp);
 	cancel_delayed_work_sync(&mp->m_reclaim_work);
+	xfs_ail_push_all_sync(mp->m_ail);
 	xfs_reclaim_inodes(mp);
 	xfs_health_unmount(mp);
 }


