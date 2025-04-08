Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D5D2690D7;
	Tue,  8 Apr 2025 11:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113343; cv=none; b=ePuESwK+ZwX0QdkdQ2X71N50mzbKTVWXO6tORFADY3z4XaYC5OvApM/0s/cCH13XUlAzoi47H9Tg0YnmfIM3b/zoNYVvxb1DLvwni1YncPqlVEO9uZWNFV6FgIVutOKalFwnQDKp8nfRmtfbB5vDgGdZpDd7YPjAPpWZgP/4Ppc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113343; c=relaxed/simple;
	bh=UONtUgZWoaQRiBFJBCv+/i5fDExWXW9Jt9uHMhJyP/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mXGwYSYx7TfM6N5yDAHYDEql49cH/cx+JceHPsV7g/0p6TA3xXaCm9V6+ZJ7VFMj8LwVULPF4/9gr9JnQspfJWQFyOIRfIXYhB5u37v5IWIzATbcVD9+ZZNa7GLIARPQUu41sm+D//Yqxyb4FmZecdaXX3lt464aOAMSG0Rgw0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LRgvhPQm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LRgvhPQm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88F98C4CEE5;
	Tue,  8 Apr 2025 11:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113343;
	bh=UONtUgZWoaQRiBFJBCv+/i5fDExWXW9Jt9uHMhJyP/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LRgvhPQmwKk6fqnV+w1rt7do/VpT9GBixJneHrS/NBcrdsiHfDzbiChcPjz9CW3vw
	 HwOLLeSduYD7tC3KJTEdbNa4lF6wxL+BqZnDr1d7TrXXzXIFGyGlRmFzpXeD9drSjN
	 D41O8v/MExXw2x3CESm9v/nW+JdIwzsZ9JvV9BL0=
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
Subject: [PATCH 6.6 125/268] ocfs2: validate l_tree_depth to avoid out-of-bounds access
Date: Tue,  8 Apr 2025 12:48:56 +0200
Message-ID: <20250408104831.872424464@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f0937902f7b46..e6191249169e6 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -1796,6 +1796,14 @@ static int __ocfs2_find_path(struct ocfs2_caching_info *ci,
 
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



