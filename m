Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6621B3B8BBB;
	Sat, 17 Oct 2026 17:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259150; cv=none; b=EtiEfuyyVpBduk2Z61ZArKd1kvYXqcornkl4JSIZ3Am21tIDQekxTEoaUVc7mubGV0VhWg8jO3U87DpgB+D8+8Ls/s4A3LJaVO89h66aywzBJDnZUi9XHOJAFs1RysuvZuaCX7cDBqcHSs5txGFcKt96UZWeMVYk8uD6XCXmkIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259150; c=relaxed/simple;
	bh=q8l+kOda2sNJr85mEIJzLBx1j03+2bLxmH1XnWplhJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m4opdZ4cW70HMAaNdVc1pvv31Ctk4S9pT/UgAZkwLa7qhJlDiPHLjRX16dDHB8qXg6LqW3hesykhE5jdrGM4xFqgWjKYx+Pv9/yYykUWS9Z2j1BzbVJj/fYFtnRjW6OuDPW4MBXdMfePHP1UqKPUncDBtNkl510gcwDW+tsgyYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LiMMMu//; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LiMMMu//"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD6F41F000C4;
	Sat, 17 Oct 2026 17:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259148;
	bh=FQJospv8AFSrua3kdeRjvyO0bpZ4vUsmc/wY8V0sk9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LiMMMu//0+KUZasq7E06ISzcj9i1d429KN2HE3xHsTJm5BX5vble5F4xq6n9eQm8m
	 MbRRw9iyAPyL78Q3pHqunr8DB87EZszqeeiEYpa9dQ5MNrsIse8SvKbpONQcZO3Z6i
	 ULaIZI7iTCpvf9DOpUvBiFBkujFBBRMC4nFiKPXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+6d832e79d3efe1c46743@syzkaller.appspotmail.com,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1119/1674] ocfs2: validate i_refcount_loc when refcount flag is set
Date: Sat, 17 Oct 2026 17:56:31 +0200
Message-ID: <20261017160459.854216586@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Deepanshu Kartikey <kartikey406@gmail.com>

[ Upstream commit 688dab01c3bb14cb559878aaf7019bfba4a79275 ]

Add validation in ocfs2_validate_inode_block() to check that if an inode
has OCFS2_HAS_REFCOUNT_FL set, it must also have a valid i_refcount_loc.
A corrupted filesystem image can have this inconsistent state, which later
triggers a BUG_ON in ocfs2_remove_refcount_tree() when the inode is being
wiped during unlink.

Catch this corruption early during inode validation to fail gracefully
instead of crashing the kernel.

Link: https://lkml.kernel.org/r/20251212055826.20929-1-kartikey406@gmail.com
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Reported-by: syzbot+6d832e79d3efe1c46743@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=6d832e79d3efe1c46743
Tested-by: syzbot+6d832e79d3efe1c46743@syzkaller.appspotmail.com
Link: https://lore.kernel.org/all/20251208084407.3021466-1-kartikey406@gmail.com/T/ [v1]
Link: https://lore.kernel.org/all/20251212045646.9988-1-kartikey406@gmail.com/T/ [v2]
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

has OCFS2_HAS_REFCOUNT_FL set, it must also have a valid i_refcount_loc.
A corrupted filesystem image can have this inconsistent state, which later
triggers a BUG_ON in ocfs2_remove_refcount_tree() when the inode is being
wiped during unlink.

Catch this corruption early during inode validation to fail gracefully
instead of crashing the kernel.

[ Dropped the context-dependent inline-data and chain-list checks that
  precede this hunk upstream but are absent here; only the i_refcount_loc
  validation is kept. ]

Stable-dep-of: 452a8467be81 ("ocfs2: fix UBSAN array-index-out-of-bounds in ocfs2_sum_rightmost_rec")
Signed-off-by: Sasha Levin <sashal@kernel.org>

# Conflicts:
#	fs/ocfs2/inode.c
---
 fs/ocfs2/inode.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 937d149417a1d..569ef52fe116a 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1585,6 +1585,13 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
+	if ((le16_to_cpu(di->i_dyn_features) & OCFS2_HAS_REFCOUNT_FL) &&
+	    !di->i_refcount_loc) {
+		rc = ocfs2_error(sb, "Inode #%llu has refcount flag but no i_refcount_loc\n",
+				(unsigned long long)bh->b_blocknr);
+		goto bail;
+	}
+
 	rc = 0;
 
 bail:
-- 
2.53.0



