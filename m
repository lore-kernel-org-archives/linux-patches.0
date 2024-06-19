Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF4D313F428;
	Wed, 19 Jun 2024 13:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718804016; cv=none; b=m1LKsSqyP24kiFSYHOYEUDjyTZBsAb9swtaus35+ZUhuohjHlKRrG2o4WkwJd20S1KqQUWcHhHfxmgcIU46t3Kn2H1d5YhBt52aQzb8YC5rOS0vSP/gAQmPP3W8eqfvFybzfVSS/zrvQVZa9xFhEzbPdFz3DRZOyJT9v37S2C9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718804016; c=relaxed/simple;
	bh=wjuxMx8j1DYMz54aSbuXDlnznO0Gg8MLP8cTK6XHnBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tWdsQEl4OWvX7RGG1ZfysT1g3vCIAk9V5u4TkYXEmo3733VO55pyWm3185JNHvA+HHe44IUvEEv+WY/ZvwIOsA9+qEC9dMRmAD6ItXMFSys9QAxyfYqV8v0J+LjNLVoTrEDbctRSt0NtsuPWCg5aS167EYbcjOnUbwXyUm+iAtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TAsBeDIt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TAsBeDIt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CC12C2BBFC;
	Wed, 19 Jun 2024 13:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718804015;
	bh=wjuxMx8j1DYMz54aSbuXDlnznO0Gg8MLP8cTK6XHnBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TAsBeDIt892lzgqEs51YRBZqO6VChUHEasCKZ356u0DJoYku+91j8zUqP35305FXd
	 UjqUng5A09z+ePBn2FEybCtkxvG6a+vmS93+0FzGs2DJfM1QS4rV/SF2Elss8MrPSq
	 IKLK9+91+Y/yXvns0wrN6qL8lOGN55mad0x3hdMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Yue <glass.su@suse.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Changwei Ge <gechangwei@live.cn>,
	Gang He <ghe@suse.com>,
	Joel Becker <jlbec@evilplan.org>,
	Jun Piao <piaojun@huawei.com>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Mark Fasheh <mark@fasheh.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 181/217] ocfs2: fix races between hole punching and AIO+DIO
Date: Wed, 19 Jun 2024 14:57:04 +0200
Message-ID: <20240619125603.670964467@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

From: Su Yue <glass.su@suse.com>

commit 952b023f06a24b2ad6ba67304c4c84d45bea2f18 upstream.

After commit "ocfs2: return real error code in ocfs2_dio_wr_get_block",
fstests/generic/300 become from always failed to sometimes failed:

========================================================================
[  473.293420 ] run fstests generic/300

[  475.296983 ] JBD2: Ignoring recovery information on journal
[  475.302473 ] ocfs2: Mounting device (253,1) on (node local, slot 0) with ordered data mode.
[  494.290998 ] OCFS2: ERROR (device dm-1): ocfs2_change_extent_flag: Owner 5668 has an extent at cpos 78723 which can no longer be found
[  494.291609 ] On-disk corruption discovered. Please run fsck.ocfs2 once the filesystem is unmounted.
[  494.292018 ] OCFS2: File system is now read-only.
[  494.292224 ] (kworker/19:11,2628,19):ocfs2_mark_extent_written:5272 ERROR: status = -30
[  494.292602 ] (kworker/19:11,2628,19):ocfs2_dio_end_io_write:2374 ERROR: status = -3
fio: io_u error on file /mnt/scratch/racer: Read-only file system: write offset=460849152, buflen=131072
=========================================================================

In __blockdev_direct_IO, ocfs2_dio_wr_get_block is called to add unwritten
extents to a list.  extents are also inserted into extent tree in
ocfs2_write_begin_nolock.  Then another thread call fallocate to puch a
hole at one of the unwritten extent.  The extent at cpos was removed by
ocfs2_remove_extent().  At end io worker thread, ocfs2_search_extent_list
found there is no such extent at the cpos.

    T1                        T2                T3
                              inode lock
                                ...
                                insert extents
                                ...
                              inode unlock
ocfs2_fallocate
 __ocfs2_change_file_space
  inode lock
  lock ip_alloc_sem
  ocfs2_remove_inode_range inode
   ocfs2_remove_btree_range
    ocfs2_remove_extent
    ^---remove the extent at cpos 78723
  ...
  unlock ip_alloc_sem
  inode unlock
                                       ocfs2_dio_end_io
                                        ocfs2_dio_end_io_write
                                         lock ip_alloc_sem
                                         ocfs2_mark_extent_written
                                          ocfs2_change_extent_flag
                                           ocfs2_search_extent_list
                                           ^---failed to find extent
                                          ...
                                          unlock ip_alloc_sem

In most filesystems, fallocate is not compatible with racing with AIO+DIO,
so fix it by adding to wait for all dio before fallocate/punch_hole like
ext4.

Link: https://lkml.kernel.org/r/20240408082041.20925-3-glass.su@suse.com
Fixes: b25801038da5 ("ocfs2: Support xfs style space reservation ioctls")
Signed-off-by: Su Yue <glass.su@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/file.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1937,6 +1937,8 @@ static int __ocfs2_change_file_space(str
 
 	inode_lock(inode);
 
+	/* Wait all existing dio workers, newcomers will block on i_rwsem */
+	inode_dio_wait(inode);
 	/*
 	 * This prevents concurrent writes on other nodes
 	 */


