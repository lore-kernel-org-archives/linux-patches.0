Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6701446E009;
	Tue, 21 Jul 2026 18:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658776; cv=none; b=aGl3xfFeuAOKmjPqEY+pNu3yEmLG3gw+17uV24LpcghF3b6UenaLpXLGLe0jIsMQlr6sEIlxSmm0SnGPRLx6ANQNOqvBmklCcM6p+nTlKnOiBxPpD+SO37MLy6OTnoMoks4LyGE27gKivBbu2Biti7jkwEUZ+Cn4e2gYKO9dUP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658776; c=relaxed/simple;
	bh=V/8cvMOVqGNrQ8phL87E1kArmGryeH5LbVMU6U0wThI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IbYYl07Yi1kLmQPt5kD5zYPMUtbxBEJ8h+Ql+YsEBJ8IbMExfOKk09TLLRhcLmNhVEBYMLvvVvDleoU67YjWwDs3f4gBWU+Edwf4ul6EWnnapMNrBd21cDt5JgV4/e6ke0jSMDpbbo6QOf8Es6vyHIxrTdZvB44hRnYyBuh+LJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VGAkffCT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VGAkffCT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4E261F000E9;
	Tue, 21 Jul 2026 18:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658775;
	bh=IWsYC5syzyJSTqUH85Z1uqATCaQn5L/MEherdzWqrRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VGAkffCTjLfpGS6wRqD2N5RL6vo4y8uoM8O/OY0XV1UyUvAIKENw7t1kWBgPFGZ5P
	 rwmLsOcQnczsQY7s4dtYrURIuRmcrpAiG8Gsfo8Y0ID6CM5t3ahIhyVNVxEwsTPGMx
	 SfN5nkNhEcNB/hhlGO3vcBkSI6ZeahBkLyw+udHY=
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
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 1271/1611] ocfs2: fix UBSAN array-index-out-of-bounds in ocfs2_sum_rightmost_rec
Date: Tue, 21 Jul 2026 17:23:07 +0200
Message-ID: <20260721152544.035283431@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Bridges <icb@fastmail.org>

commit 452a8467be8143747292218212671deeb186d2ae upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/inode.c |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1536,6 +1536,38 @@ int ocfs2_validate_inode_block(struct su
 		}
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


