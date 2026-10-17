Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9191222F767;
	Sat, 17 Oct 2026 16:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254505; cv=none; b=LlaIFjh/frn+52CRv19BGdFedIH9Jk8/0XOBBIbZGtGxmK5YehtsjWdbxQ8qxHKMw3BOej9xOo2q2hqJjh340BusXRvBx5Fky3SXv3LIOTo2tlj+HxNWa0lUOSA2OA+/GU4JUkGY0b1WkzQLAc9+VbZ5BHY8YPpqCzplQfH6Qsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254505; c=relaxed/simple;
	bh=JJ6QIreRRu75BwzB+o3Z9UlLWu8MlXQePXRWkp1miCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NibFvDEwho1dNtrPDmgZRXCrJcY4eYGyq3ZK+xvUqCaSI2bpJNW1TaRi+wazKAI64qUsWEJ4s0B5PPoX88EilmwYPmPke4wFqJm4OLEAFETIKmTaMW1/qhgix9LGYqPX7sLpSRzQPlks1MgpgrtnySdDI3/BwmADPKYq0ekKiRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e0JUOk84; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e0JUOk84"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9B3A1F000C4;
	Sat, 17 Oct 2026 16:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254504;
	bh=8HOYVBup7uv8oiy9ittxHPym6KdeMxnOtGD+2JxVZLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e0JUOk84j+YuxlDlTwzyNj0Ee6s1cxR+Xq28Q0cuBpiiYel5fUO0h2EcJVT9l054s
	 fZpkUTA0hsogqQM9C8ywwU1PX4Lso3NZh5+4vYO+76KkQpJVtwKtRNrBkwtZ8dZy+j
	 npRh8RalfdXUWUIxsnS25uE2FbNgBsqhZ++hVizY=
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
Subject: [PATCH 6.12 429/869] ocfs2: validate i_refcount_loc when refcount flag is set
Date: Sat, 17 Oct 2026 17:54:30 +0200
Message-ID: <20261017160048.139394533@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: 452a8467be81 ("ocfs2: fix UBSAN array-index-out-of-bounds in ocfs2_sum_rightmost_rec")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/inode.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index e3aba593e189f..03a3fc96e534f 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1602,6 +1602,13 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		}
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



