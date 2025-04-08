Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D6A269838;
	Tue,  8 Apr 2025 11:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110234; cv=none; b=nKZnwFlXNIjFx5vphhgY3tCJW/87PzBlivEUTf1irchH+IG2JnZ0qeRRHWe5a2jaWpbsS0Ui/lBFUVCybhBa3WlXEpZQEHm+RhM37tuapwULbsGTCw5vFg7iK7dhzNNwgCvr/yN6+v9fSp0ew5Jkn8ZJqyfFFgxJW4eihbOXOY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110234; c=relaxed/simple;
	bh=CYr7/urEiZdqlfcBGxMapV7sXTiAIXX3xvVQyTT070M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CKRM4NKTK/YIZ5a7Wz8iv7a1Q7VhUXsM5v7buZYVsWDzkPJaRvdwFE+A+iDUrkVf4SjMQjwiWCEEM4RTSD0j/gZrcy8gOqMbWNfE9G6DgS0GGt9tYc6Bfx7JEKEUkB5Ca/yy5xmlhIEIcZi5oSsZN0bC7v2EUr0d7k8eecrad1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QHtwk3IK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QHtwk3IK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A905C4CEE5;
	Tue,  8 Apr 2025 11:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110234;
	bh=CYr7/urEiZdqlfcBGxMapV7sXTiAIXX3xvVQyTT070M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QHtwk3IKlWkYtis6Pdz6KY98fh7pW01BSfZ4lIxH6pukYuL60xgN4A5uDYZCMj3B0
	 T/TuPOmUG3kE8/n58Mrp3Vy+HndtYfbyoQkHvB86in0h5teOEQIXv7A7dAMJZBu8p2
	 yhI7XpQnK2vKGbrawUqVNxgZd4vAqxGShD/uL0fk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasiliy Kovalev <kovalev@altlinux.org>,
	syzbot+66c146268dc88f4341fd@syzkaller.appspotmail.com,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Kurt Hackel <kurt.hackel@oracle.com>,
	Mark Fasheh <mark@fasheh.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 167/227] ocfs2: validate l_tree_depth to avoid out-of-bounds access
Date: Tue,  8 Apr 2025 12:49:05 +0200
Message-ID: <20250408104825.327513005@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasiliy Kovalev <kovalev@altlinux.org>

[ Upstream commit a406aff8c05115119127c962cbbbbd202e1973ef ]

The l_tree_depth field is 16-bit (__le16), but the actual maximum depth is
limited to OCFS2_MAX_PATH_DEPTH.

Add a check to prevent out-of-bounds access if l_tree_depth has an invalid
value, which may occur when reading from a corrupted mounted disk [1].

Link: https://lkml.kernel.org/r/20250214084908.736528-1-kovalev@altlinux.org
Fixes: ccd979bdbce9 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
Reported-by: syzbot+66c146268dc88f4341fd@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=66c146268dc88f4341fd [1]
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Kurt Hackel <kurt.hackel@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Vasiliy Kovalev <kovalev@altlinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/alloc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index a9a6276ff29bd..94c7acfebe183 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -1798,6 +1798,14 @@ static int __ocfs2_find_path(struct ocfs2_caching_info *ci,
 
 	el = root_el;
 	while (el->l_tree_depth) {
+		if (unlikely(le16_to_cpu(el->l_tree_depth) >= OCFS2_MAX_PATH_DEPTH)) {
+			ocfs2_error(ocfs2_metadata_cache_get_super(ci),
+				    "Owner %llu has invalid tree depth %u in extent list\n",
+				    (unsigned long long)ocfs2_metadata_cache_owner(ci),
+				    le16_to_cpu(el->l_tree_depth));
+			ret = -EROFS;
+			goto out;
+		}
 		if (le16_to_cpu(el->l_next_free_rec) == 0) {
 			ocfs2_error(ocfs2_metadata_cache_get_super(ci),
 				    "Owner %llu has empty extent list at depth %u\n",
-- 
2.39.5



