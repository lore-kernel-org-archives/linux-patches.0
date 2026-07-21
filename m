Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4528F43E4B5;
	Tue, 21 Jul 2026 22:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671309; cv=none; b=ZB+5xfwLj/JGaXJ6I/jk2KzThc0g71/d12qAboSDjZiTpjDmPO+sLnoRKGpqG1cxwTIugDsUUUqlFCyN8lGMMoLsKmmlmlVi7hV3fG56+Ep9zMe7JsNt7yPH+T4SGChQP3R611vvELSZ930emyhWLAkup6CLxuShyjvukM/lNxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671309; c=relaxed/simple;
	bh=fZQKnqz3IqSEgxT4I8QXpuaI+AGzqqBhqcCHqMvnZM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cwWcTPq6ngeiVS4Q6R/sE0izKGDfufj+gl1NLEMgKpGIJKyNgTd4oriAK6aoZ6ysvL7gN4j81uj8+7GEmBQlzRRrGxlCA7FnALgBtmuR0EUiify+0QGr23bc6RUDWmtKkLWyJ7GiW4LwXMbLiD6zPfG4jJOm1eOlNevNUsMYnXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DDNLpP9w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DDNLpP9w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAF151F000E9;
	Tue, 21 Jul 2026 22:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671308;
	bh=T49stwhSCC9fKEYmw7Jb1JVGkmJBpDn6m+K+C3nkEyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DDNLpP9wFydCqYN3kFvcx7p4e3LvQiC2EbxyYkLK1vdpzr6oVwzq92epzVQrcpaAx
	 mWWIeBE6ReFbCSKdFtbY+nVFnTmlINHH09QHYbpbiL7ZKbD0gXJ5948s2nNGYzDgPW
	 KCU0a6Vxcg1iysin1+f0zTbvGOQV7aIu7m6Yk+0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 5.15 197/843] xfs: fail recovery on a committed log item with no regions
Date: Tue, 21 Jul 2026 17:17:12 +0200
Message-ID: <20260721152410.447785082@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weiming Shi <bestswngs@gmail.com>

commit 2094dab19d45c487285617b7b68913d0cc0c1211 upstream.

If the first op of a transaction is a bare transaction header
(len == sizeof(struct xfs_trans_header)), xlog_recover_add_to_trans()
adds an item but no region, leaving it on r_itemq with ri_cnt == 0 and
ri_buf == NULL.

The header can be split across op records, so later ops may still add
regions; the item is only invalid if the transaction commits with none.
The runtime commit path never emits such a transaction, so this only
happens on a crafted log.  It came from an AI-assisted code audit of the
recovery parser.

xlog_recover_reorder_trans() calls ITEM_TYPE() on the item, which reads
*(unsigned short *)item->ri_buf[0].iov_base and faults on the NULL
ri_buf.  Reject it there, before the commit handlers that also read
ri_buf[0].

 KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
 RIP: 0010:xlog_recover_reorder_trans (fs/xfs/xfs_log_recover.c:1836)
  xlog_recover_commit_trans (fs/xfs/xfs_log_recover.c:2043)
  xlog_recover_process_data (fs/xfs/xfs_log_recover.c:2501)
  xlog_do_recovery_pass (fs/xfs/xfs_log_recover.c:3244)
  xlog_recover (fs/xfs/xfs_log_recover.c:3493)
  xfs_log_mount (fs/xfs/xfs_log.c:618)
  xfs_mountfs (fs/xfs/xfs_mount.c:1034)
  xfs_fs_fill_super (fs/xfs/xfs_super.c:1938)
  vfs_get_tree (fs/super.c:1695)
  path_mount (fs/namespace.c:4161)
  __x64_sys_mount (fs/namespace.c:4367)

Fixes: 89cebc847729 ("xfs: validate transaction header length on log recovery")
Cc: stable@vger.kernel.org # v4.3
Reported-by: Xiang Mei <xmei5@asu.edu>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_log_recover.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1882,6 +1882,15 @@ xlog_recover_reorder_trans(
 	list_for_each_entry_safe(item, n, &sort_list, ri_list) {
 		enum xlog_recover_reorder	fate = XLOG_REORDER_ITEM_LIST;
 
+		/* a committed item with no regions has a NULL ri_buf[0] */
+		if (!item->ri_cnt || !item->ri_buf) {
+			xfs_warn(log->l_mp,
+				"%s: committed log item has no regions",
+				__func__);
+			error = -EFSCORRUPTED;
+			break;
+		}
+
 		item->ri_ops = xlog_find_item_ops(item);
 		if (!item->ri_ops) {
 			xfs_warn(log->l_mp,


