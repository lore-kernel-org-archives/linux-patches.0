Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215448;
	b=IabMW2G24DSf0uIFxFj0DUovWHs/Sd9lKr7FAu93b12DsbCDTAe7T62X8UQT4FSlHdmU
	 mdHSwP/nLz7xI2JlJQ9D2CKJMmJ9CTkado8KqKo6OX8hZ/AeFbs1U5Dt37TG3Tivc97Vq
	 JvzUEKUb83YBEVz0cx5EjNi+DciEYd98Fd/vvQ4d4XygWNWy/HwguiirZN8vTq7Z+0FMJ
	 evT+lgbT5RwuX2JZKTm+GLLbwrUx0ds8UB01ap+vSX6AXG2MseuuxgxWtJf52S2eLBFmc
	 gX+Cb6kSu9Ay8TdLQvQWLol8lRYv2zDBupmOZnkSRYdo1QzJyzw7+dwPhszup1Xf/Mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215448;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Lc+3elvZuTciH3ksg+iRFiFs5lFDNqleZSvCXsr/gJI=;
	b=n4klQgBcBu8frd+8Tt7Di3ibQCroG+QSFMW8Q7FeEuP5CV8mdqyApRpJLy3ToU7zXt3f
	 Gun0kzDqDHw/1g8ZqcKnUNqvc/eHGaw1iFz0DSIOi0HizSdQI+y/CbgY1PBRK9Nxs/q9H
	 OLELxeJS9xFYHfJizWUOT0l9a/B97S8rom2Tsv46yfQBcbm4+AjfAgICRsx+Ic7Rgx06y
	 q7yeNQw8S1PoSpg55a+b2LKu0Cq9DL3M1tn+KAlLU3E88zXDo4mtmFUzUY7E8SNIUD+rB
	 +rvpp9/ukxopD94WPC6YT+wDKR8F6jhLm9KgkQXCSr5DJjU3c1pdlz17oljkRwty3Hg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iaxkr2P6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F53606A31A;
	Wed, 28 Oct 2026 19:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iaxkr2P6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54C6D1F01825;
	Wed, 28 Oct 2026 19:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215447;
	bh=Lc+3elvZuTciH3ksg+iRFiFs5lFDNqleZSvCXsr/gJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iaxkr2P6N84o3GW/sZstARuXnVoTO76DpIBfVwQEporokpFFy2+6nkE7pEHEEz8KE
	 Vzt6GaRT778H9z99WFe48zaPgG/KYvVvqSVsi8PNllxf+A+RWo5KlKx4o5UjtGZyaM
	 1X0CJioir2zFGUAizQvlKzuhoBK9SxO6GR/GHOVc=
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
Subject: [PATCH 6.1 1213/1887] ocfs2: correct l_next_free_rec in online check
Date: Wed, 28 Oct 2026 17:55:09 +0100
Message-ID: <20261028170527.012862654@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 38170b4f46472..5d9da67e9ba5b 100644
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



