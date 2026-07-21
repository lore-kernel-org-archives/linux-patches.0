Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B6D846C4D2;
	Tue, 21 Jul 2026 15:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649182; cv=none; b=kVjHnze2Lsdj/nHNuv4UWG8vFTYSU8n5VSojUyH/Z/HfVQ/w4xsqzOcAQM0l9JPCkp8hbwjG9p9eATzHsbREmprc19t3mO1Cpgq5MS6vAK3ebqONsG+9TG89ic0GMMR4L2Fb8mgyY6BVsEbUFBZCkE/cBFb4DiGZ02SEEtaw9I8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649182; c=relaxed/simple;
	bh=q6ociaMValsiQgdjauAz3FZC7p9OhRUZGH5TPYwos7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qc67HUKxDehBGXkYm6Y70IEge1FISVT69AozEvOvMgbwlToi7FD0QhzEGPN7b+btQELnhIW7mnKLWw+2J0P1Wym+gaYCRsxGWGS86wgx7+/H/ae7fj77UXekDFt5Y9yP6meSwOpK+5mFWIcK3MPxsTU8cXjfoGm969bcQdfybUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vVXUGiAV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vVXUGiAV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 838361F000E9;
	Tue, 21 Jul 2026 15:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649181;
	bh=b0tx3wDOr/W4ekveekDGBHFrja/czsWba5U2273xh34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vVXUGiAVsW/hP5mu7hKUWjylER2iDD62cZ93mTyycIFO9XiiL4SpCyjdmaDwknGgu
	 F7E4+U781sJhqAJV2TmXWHfXp+zsWU2duklr+7jFs/2Q55HHnhuiy8BjsiDHB1JhZ1
	 IGWmbQKvQLOm7u6vrWQUFp4CqeZFjLPL1DkdX1hI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Bridges <icb@fastmail.org>,
	syzbot+3ef989aae096b30f1663@syzkaller.appspotmail.com,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0481/2077] ocfs2: fix out-of-bounds write in ocfs2_remove_refcount_extent
Date: Tue, 21 Jul 2026 17:02:34 +0200
Message-ID: <20260721152604.152778831@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Bridges <icb@fastmail.org>

[ Upstream commit 1ec3cca2d8b6b9ff6584ca626d4c8918bbf48d44 ]

[BUG]
Unlinking a refcounted file whose refcount tree has leaf blocks
triggers a fortify panic due to an out-of-bounds write.

[CAUSE]
When the last leaf block is removed from a refcount tree,
ocfs2_remove_refcount_extent() converts the root back to leaf mode
with a bulk memset on &rb->rf_records. rf_records sits in an anonymous
union with rf_list. rf_list.l_tree_depth aliases rf_records.rl_count,
and is 0 for a single-level tree. With rl_count equal to 0, the memset
writes past the 16-byte declared size of rf_records, which the fortify
checker catches.

[FIX]
Replace the bulk memset on &rb->rf_records with a correctly-bounded
memset on rl_recs[] alone, after setting rl_count to the correct value.

Link: https://lore.kernel.org/ah3TESOsEO9j_JLU@dev
Fixes: 2f26f58df041 ("ocfs2: annotate flexible array members with __counted_by_le()")
Signed-off-by: Ian Bridges <icb@fastmail.org>
Reported-by: syzbot+3ef989aae096b30f1663@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=3ef989aae096b30f1663
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/refcounttree.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 8eee5be4d1ed4c..7323bde70caaf4 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -2131,10 +2131,15 @@ static int ocfs2_remove_refcount_extent(handle_t *handle,
 		rb->rf_flags = 0;
 		rb->rf_parent = 0;
 		rb->rf_cpos = 0;
-		memset(&rb->rf_records, 0, sb->s_blocksize -
-		       offsetof(struct ocfs2_refcount_block, rf_records));
+		rb->rf_records.rl_used = 0;
+		rb->rf_records.rl_reserved2 = 0;
+		rb->rf_records.rl_reserved1 = 0;
+		/* rl_count determines the memset size and fortify object size. */
 		rb->rf_records.rl_count =
 				cpu_to_le16(ocfs2_refcount_recs_per_rb(sb));
+		memset(rb->rf_records.rl_recs, 0,
+		       le16_to_cpu(rb->rf_records.rl_count) *
+		       sizeof(*rb->rf_records.rl_recs));
 	}
 
 	ocfs2_journal_dirty(handle, ref_root_bh);
-- 
2.53.0



