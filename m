Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5584A3905EB;
	Sat, 17 Oct 2026 16:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254508; cv=none; b=KUrWaOIvj6G5tQb89jSoSQ88wRdMmO1khrNmcdiqaJ2SmU+YlYhwCVUidJpR/axO9fTTXiEepefRu/kTM6FG4ObGicWT8t+4xxVYSJ6cD3p4taaBVaQAJ3J1bwDwIot1llrptlRQlXFWv6HMakVUqF+wwtVHBgoPG/ay6gykDVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254508; c=relaxed/simple;
	bh=T/5geJE9R5f0JDviuLrKvZZ6pShdf8jN8p3PEK9gL50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dP69lJa2vAUKwObHxCiTXml0CQ+rF+JeRbBWyCy+7sl3FtfqAKquu/NmYqATDyNEljk9fA1EvbWwpIkeg+joUMJcjiZ2CO02uCVrouB+0EtiCJYI6fZJbLSPvOmmLNwL0STgxMoB0MJwadoLAkenuNXjrlwGLSdZNXvVF4jWF2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tNRha2rV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tNRha2rV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC38F1F000C4;
	Sat, 17 Oct 2026 16:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254507;
	bh=6dCnzzJ0lbqjm7P9+dQ+wOtdZjgQxU+/N3abGFmNXfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tNRha2rV62yCbynpoZ0rHnrgeqqUNBoA2QV+pxYKDPwYDC8wnxvymTNee5c1Tn0h8
	 ITVR50nB8YGQe1AMCv4Wosm6ndvkqcQWIs5ZlRaGm3vN8kSvx2piurvgDBiQTcbWLf
	 Mu4SY22pUf3FPjXgAo7NONbWr/pKVdGHYrWUaeGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Bridges <icb@fastmail.org>,
	syzbot+be16e33db01e6644db7a@syzkaller.appspotmail.com,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 430/869] ocfs2: fix UBSAN array-index-out-of-bounds in ocfs2_sum_rightmost_rec
Date: Sat, 17 Oct 2026 17:54:31 +0200
Message-ID: <20261017160048.167309911@linuxfoundation.org>
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

From: Ian Bridges <icb@fastmail.org>

[ Upstream commit 452a8467be8143747292218212671deeb186d2ae ]

[BUG]
On-disk corruption setting l_next_free_rec to 0 in an inode's embedded
extent list triggers a UBSAN panic on the next write to that file.

[CAUSE]
ocfs2_sum_rightmost_rec() computes
i = le16_to_cpu(el->l_next_free_rec) - 1
and accesses el->l_recs[i] without validating i. When l_next_free_rec
is 0, i becomes -1; when l_next_free_rec exceeds l_count, i falls
past the end of the array. Either case violates the
__counted_by_le(l_count) annotation on l_recs[] and triggers UBSAN.

[FIX]
Validate the inode's embedded extent list when the inode is read, in
ocfs2_validate_inode_block(): l_count must be non-zero and no larger
than the inode block can hold, and l_next_free_rec must not exceed
l_count. A corrupt list is rejected at read time, before the b-tree
code can index l_recs[] out of bounds.

Link: https://lore.kernel.org/ain_780qc0P4ypNd@dev
Signed-off-by: Ian Bridges <icb@fastmail.org>
Reported-by: syzbot+be16e33db01e6644db7a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=be16e33db01e6644db7a
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/inode.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 03a3fc96e534f..4f7b03f34a4c0 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1609,6 +1609,38 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
+	if (ocfs2_dinode_has_extents(di)) {
+		struct ocfs2_extent_list *el = &di->id2.i_list;
+		u16 count = le16_to_cpu(el->l_count);
+		u16 next_free = le16_to_cpu(el->l_next_free_rec);
+
+		if (count == 0) {
+			rc = ocfs2_error(sb,
+					 "Invalid dinode %llu: extent list l_count is zero\n",
+					 (unsigned long long)bh->b_blocknr);
+			goto bail;
+		}
+		/*
+		 * The exact capacity depends on i_xattr_inline_size, another
+		 * unvalidated on-disk field. Inline xattrs only shrink the
+		 * list, so the no-xattr maximum is a safe upper bound that a
+		 * valid l_count never exceeds.
+		 */
+		if (count > ocfs2_extent_recs_per_inode(sb)) {
+			rc = ocfs2_error(sb,
+					 "Invalid dinode %llu: extent list l_count %u exceeds max %u\n",
+					 (unsigned long long)bh->b_blocknr, count,
+					 ocfs2_extent_recs_per_inode(sb));
+			goto bail;
+		}
+		if (next_free > count) {
+			rc = ocfs2_error(sb,
+					 "Invalid dinode %llu: extent list l_next_free_rec %u exceeds l_count %u\n",
+					 (unsigned long long)bh->b_blocknr, next_free, count);
+			goto bail;
+		}
+	}
+
 	rc = 0;
 
 bail:
-- 
2.53.0



