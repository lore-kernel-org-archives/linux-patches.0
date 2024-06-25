Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6AC614A4FF;
	Tue, 25 Jun 2024 09:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309338; cv=none; b=LLNEDdM6OPdll84hge8eSrt7uqM7b6a3s2NVboAncycOtxhejjGxQTmNsrHBpDrcDZJmiYTPbsiB4tBQP1yKw1jxsGEkARQ8aJNzXDwdwGqW8E20Gbv3mVcfCTkZXmAsIbSTQvsmcJz4Of/GBZYwKzK8+e8eu85I/se2OtrFVYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309338; c=relaxed/simple;
	bh=N4lJrWBeaUNroXedKqKHrh5fbZfY8kopTzpSCgLKOqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZWwoWJJ6duP9mUOQl0nnj8pvsHXrAKZLkSpVfzPJA4H0DCAYN1EWn6JLA5gTusrFbnopah+pf9dRwhTYsgrFAgZoQuYzxrGE/T3leDmNiwSA8/6ZHcVU7oNva5bjvOKa0rUGcCxFh1/EQ3QMFuJoucUFROr1T6Q8fWQeF9AWhbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JcbGWxtu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JcbGWxtu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A329C32781;
	Tue, 25 Jun 2024 09:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309338;
	bh=N4lJrWBeaUNroXedKqKHrh5fbZfY8kopTzpSCgLKOqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JcbGWxtulX7D8X6gVtxOXGv605ZHtnJ6MSx4m4VHnvQYcOW0Xay5aOJVD8ReZSddd
	 W933MvXKWt45VHZXCN/vBZ8dDlw8inXZiALybokkUnqtDEl3Sgsq+D41bpYzQKJ/Kk
	 2K4VXWhHJ2LyNS8QjOYtideQkg7r8zTFIERxGG4E=
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
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 175/192] ocfs2: update inode fsync transaction id in ocfs2_unlink and ocfs2_link
Date: Tue, 25 Jun 2024 11:34:07 +0200
Message-ID: <20240625085543.877052380@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Su Yue <glass.su@suse.com>

[ Upstream commit 8c40984eeb8804cffcd28640f427f4fe829243fc ]

transaction id should be updated in ocfs2_unlink and ocfs2_link.
Otherwise, inode link will be wrong after journal replay even fsync was
called before power failure:
=======================================================================
$ touch testdir/bar
$ ln testdir/bar testdir/bar_link
$ fsync testdir/bar
$ stat -c %h $SCRATCH_MNT/testdir/bar
1
$ stat -c %h $SCRATCH_MNT/testdir/bar
1
=======================================================================

Link: https://lkml.kernel.org/r/20240408082041.20925-4-glass.su@suse.com
Fixes: ccd979bdbce9 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/namei.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 791fc5050e46b..21b3d5b9be603 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -797,6 +797,7 @@ static int ocfs2_link(struct dentry *old_dentry,
 	ocfs2_set_links_count(fe, inode->i_nlink);
 	fe->i_ctime = cpu_to_le64(inode_get_ctime_sec(inode));
 	fe->i_ctime_nsec = cpu_to_le32(inode_get_ctime_nsec(inode));
+	ocfs2_update_inode_fsync_trans(handle, inode, 0);
 	ocfs2_journal_dirty(handle, fe_bh);
 
 	err = ocfs2_add_entry(handle, dentry, inode,
@@ -993,6 +994,7 @@ static int ocfs2_unlink(struct inode *dir,
 		drop_nlink(inode);
 	drop_nlink(inode);
 	ocfs2_set_links_count(fe, inode->i_nlink);
+	ocfs2_update_inode_fsync_trans(handle, inode, 0);
 	ocfs2_journal_dirty(handle, fe_bh);
 
 	inode_set_mtime_to_ts(dir, inode_set_ctime_current(dir));
-- 
2.43.0



