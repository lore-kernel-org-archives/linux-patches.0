Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 553A5423A79;
	Tue, 31 Mar 2026 16:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974545; cv=none; b=HSSM62LCmj4BCCLne/4esHNQH0Zh+mUOtGaWau971gjyHFEd0eaAKQKfkLUTkLPLduTfJuAV+SNW4tMGghBy+acYwJJozOnHhbxG1CC4uSPNoa+Y1qSxadIUe16iacdLpjm780NVLTyQ5sMQzXHhRpBgsnlG/N7JUOC9kz6l3ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974545; c=relaxed/simple;
	bh=lgRv/hE/nZ3crLhiCqhhR2tYMUxBRnkMj5AP2H5Z/mQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SbGSKI6Y0RGsrvI5SuCJVf6vyNR9143mNZ0xiIlUkebCWqGIj/ZOIsL6XGNQLYBXj58hiO6fUI5NZvg/WWQcIJJNyU8ROh8yzY+7L/0S+9kE54W3QUFNNOlZ6k67e5FRBuGPjKRy4n8AJmrWpQYyjq7MC0eCFGUZBqO36JQXUwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jIdBugFB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jIdBugFB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84FE4C19424;
	Tue, 31 Mar 2026 16:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974544;
	bh=lgRv/hE/nZ3crLhiCqhhR2tYMUxBRnkMj5AP2H5Z/mQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jIdBugFBZk4udLDvubWxPeEf6E4l2M544iyfqlmZKipcD27XRQ/WwErgta/6zoONC
	 rjXg83NDds8Re9XDpaHxaOiKOUafQO29dJFVIR7hvaUTvVfJhEOYq1vg7Lrn1aZVDd
	 sDmRPce+9UVCDy4Zp+0K6sY1Ic+61G2DtE+mFHNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+652af2b3c5569c4ab63c@syzkaller.appspotmail.com,
	Yuto Ohnuki <ytohnuki@amazon.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.6 127/175] xfs: stop reclaim before pushing AIL during unmount
Date: Tue, 31 Mar 2026 18:21:51 +0200
Message-ID: <20260331161734.448446472@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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
@@ -576,8 +576,9 @@ xfs_unmount_check(
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
@@ -589,9 +590,9 @@ xfs_unmount_flush_inodes(
 
 	set_bit(XFS_OPSTATE_UNMOUNTING, &mp->m_opstate);
 
-	xfs_ail_push_all_sync(mp->m_ail);
 	xfs_inodegc_stop(mp);
 	cancel_delayed_work_sync(&mp->m_reclaim_work);
+	xfs_ail_push_all_sync(mp->m_ail);
 	xfs_reclaim_inodes(mp);
 	xfs_health_unmount(mp);
 }


