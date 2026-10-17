Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E09FA3911A9;
	Sat, 17 Oct 2026 16:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254503; cv=none; b=EXyuQooNFNrvslGRs5t4o0/f3ms8+/CEl/mFABG8ggwi7fKZj9g2mf+ZSS1uTdYrYfPEXXIOHUWdIALhs81RdxV3+tx4rZrIdYAYzXATtDgTc+orutp5vYWASCxzM2NODtgw6qF5sSXq04PGPAzw9mphTxnLKgvvokFwuiZ5lRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254503; c=relaxed/simple;
	bh=P3fLtRLCUKcvEUgTxq/lTx2X0eQQsNTUasvlE9jDS3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MYXHzypmnhh4EjaW9qdfjMdwOo046vauxc1OgTNqFDjg0nHgMWiWZ37Lcx0+ksV11+fZHgkiihitZgjGVBZxla0pxz0eVWSt1oZfdf9TzMAasWEEc6Iof6Fp0Ao8VKEvf0t/XMJLcUVYhnRH624dZy+Ulgud9YDDV4qattfJ+NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kOCgIf25; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kOCgIf25"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 421881F000C4;
	Sat, 17 Oct 2026 16:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254501;
	bh=/xThDJFeVJoPOqKpmaW0LaYyhdrjYn0aJBItNUOqeLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kOCgIf25C7jcCu3Ltz5HNDGnfWw2jKI7g0EytMgyw8Vq/UfVRyTk/pfgSs1YWYofM
	 nLWve2EaaMrkznudfCafsNlCuovHOLDdl58ZpO5uI0yYN8g92a4N1ZgR/3scKDovPl
	 e7CogqsvdeS3xla7guGZMWfU7OXCSBEEZXgnXUho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	syzbot+77026564530dbc29b854@syzkaller.appspotmail.com,
	syzbot+5054473a31f78f735416@syzkaller.appspotmail.com,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Jun Piao <piaojun@huawei.com>,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Joel Becker <jlbec@evilplan.org>,
	Mark Fasheh <mark@fasheh.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 428/869] ocfs2: add extra consistency checks for chain allocator dinodes
Date: Sat, 17 Oct 2026 17:54:29 +0200
Message-ID: <20261017160048.112583931@linuxfoundation.org>
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

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit e1c70505ee8158c1108340d9cd67182ade93af4a ]

When validating chain allocator dinode in 'ocfs2_validate_inode_block()',
add an extra checks whether a) the maximum amount of chain records in
'struct ocfs2_chain_list' matches the value calculated based on the
filesystem block size, and b) the next free slot index is within the valid
range.

Link: https://lkml.kernel.org/r/20251030153003.1934585-1-dmantipov@yandex.ru
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Reported-by: syzbot+77026564530dbc29b854@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=77026564530dbc29b854
Reported-by: syzbot+5054473a31f78f735416@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=5054473a31f78f735416
Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mark@fasheh.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Adapted for this tree: the inline-data i_clusters check this change sits
next to is already present earlier in ocfs2_validate_inode_block(), so only
the new chain allocator dinode checks are added.

Stable-dep-of: 452a8467be81 ("ocfs2: fix UBSAN array-index-out-of-bounds in ocfs2_sum_rightmost_rec")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/inode.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 9104f088c86d8..e3aba593e189f 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1585,6 +1585,23 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
+	if (le32_to_cpu(di->i_flags) & OCFS2_CHAIN_FL) {
+		struct ocfs2_chain_list *cl = &di->id2.i_chain;
+
+		if (le16_to_cpu(cl->cl_count) != ocfs2_chain_recs_per_inode(sb)) {
+			rc = ocfs2_error(sb, "Invalid dinode %llu: chain list count %u\n",
+					 (unsigned long long)bh->b_blocknr,
+					 le16_to_cpu(cl->cl_count));
+			goto bail;
+		}
+		if (le16_to_cpu(cl->cl_next_free_rec) > le16_to_cpu(cl->cl_count)) {
+			rc = ocfs2_error(sb, "Invalid dinode %llu: chain list index %u\n",
+					 (unsigned long long)bh->b_blocknr,
+					 le16_to_cpu(cl->cl_next_free_rec));
+			goto bail;
+		}
+	}
+
 	rc = 0;
 
 bail:
-- 
2.53.0



