Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 309F3397929;
	Sat, 17 Oct 2026 16:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254458; cv=none; b=n/KuceLZBolPEELubt91viVjXazIAlxntAMrwi9ZaQoG/GP1cx+XEoaxqGiqaQzHr4gu6L1mm2ZBXtATJ3Cm6CdEisJFrkwwRHhX6Rf5Tfidu1/3majEcAoTUl0r5KsDF2CLl1un2unEF/7P8meBPjHMiAzug9ZDE8w5T7K+Ho4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254458; c=relaxed/simple;
	bh=/zWd8DKs36JwRNohcTJJ7eKHCyyBAGEd8vy8K9MOlE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RVlexGNCRYRGvszlEF6VmttiJd7FIMfqHNxd+WPRsdda33Y47sF+wiQN0FlTbNPRKhp5a2tjnY/HRBt+pZum0dvFyr7mDritn3amgH0f8Ibc80DB1PmcWQ8zs+CpImvjnjWwrkU2y6QhtKJyOGE/BFnI6Q7IbKrzFvA+KUAs0H8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=brm2nv33; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="brm2nv33"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F3E71F000C4;
	Sat, 17 Oct 2026 16:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254457;
	bh=alxiNtKWZb2iOUJ4h9RQmsJqleN5hDVszZE5C3cYPqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=brm2nv33j5iSPqw4zDt9vLQm0O8EXIBgCzVkoPk0cG72IHSMOnOOb53BXU4mw1RjL
	 SSUqtonedArhaSE8Kz/dxK6dwHnf6/pFnRXxUl+lUYejX1GUrjRNNqw1oWdFXdw2pb
	 UMlx8XWti0gS7f/byyFO3G2UDxcVhN73ZQs3b5YQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Sun <sunjunchao2870@gmail.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 426/869] ocfs2: correct l_next_free_rec in online check
Date: Sat, 17 Oct 2026 17:54:27 +0200
Message-ID: <20261017160048.058226904@linuxfoundation.org>
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

From: Julian Sun <sunjunchao2870@gmail.com>

[ Upstream commit fdbb6cd96ed51da002bd9a5a142586a74a436784 ]

Correct the value of l_next_free_rec to l_count during the online check,
as done in the check_el() function in ocfs2_tools.

Link: https://lkml.kernel.org/r/20250106023432.1320904-2-sunjunchao2870@gmail.com
Signed-off-by: Julian Sun <sunjunchao2870@gmail.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 452a8467be81 ("ocfs2: fix UBSAN array-index-out-of-bounds in ocfs2_sum_rightmost_rec")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/inode.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 9a56c57f9ded2..5c540d0af8aa2 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -233,6 +233,20 @@ struct inode *ocfs2_iget(struct ocfs2_super *osb, u64 blkno, unsigned flags,
 	return inode;
 }
 
+static int ocfs2_dinode_has_extents(struct ocfs2_dinode *di)
+{
+	/* inodes flagged with other stuff in id2 */
+	if (di->i_flags & (OCFS2_SUPER_BLOCK_FL | OCFS2_LOCAL_ALLOC_FL |
+			   OCFS2_CHAIN_FL | OCFS2_DEALLOC_FL))
+		return 0;
+	/* i_flags doesn't indicate when id2 is a fast symlink */
+	if (S_ISLNK(di->i_mode) && di->i_size && di->i_clusters == 0)
+		return 0;
+	if (di->i_dyn_features & OCFS2_INLINE_DATA_FL)
+		return 0;
+
+	return 1;
+}
 
 /*
  * here's how inodes get read from disk:
@@ -1728,6 +1742,16 @@ static int ocfs2_filecheck_repair_inode_block(struct super_block *sb,
 		     le32_to_cpu(di->i_fs_generation));
 	}
 
+	if (ocfs2_dinode_has_extents(di) &&
+	    le16_to_cpu(di->id2.i_list.l_next_free_rec) > le16_to_cpu(di->id2.i_list.l_count)) {
+		di->id2.i_list.l_next_free_rec = di->id2.i_list.l_count;
+		changed = 1;
+		mlog(ML_ERROR,
+		     "Filecheck: reset dinode #%llu: l_next_free_rec to %u\n",
+		     (unsigned long long)bh->b_blocknr,
+		     le16_to_cpu(di->id2.i_list.l_next_free_rec));
+	}
+
 	if (changed || ocfs2_validate_meta_ecc(sb, bh->b_data, &di->i_check)) {
 		ocfs2_compute_meta_ecc(sb, bh->b_data, &di->i_check);
 		mark_buffer_dirty(bh);
-- 
2.53.0



