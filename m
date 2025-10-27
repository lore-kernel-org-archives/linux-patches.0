Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A78A72C3749;
	Mon, 27 Oct 2025 19:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592640; cv=none; b=HbWZvO1mODczYgh5i1DyVQXR3bxw/emOeEUP8G2qdjrFGkdreHU70FlpZsLCNKBuRjf9aXZpsyWtY8PeJS2jtCZ6RBXVhKGwrwNIg8hCEuMe09EKIodCMnzN/rDLsh+v7F3ZgRr6JyIYBH88mSf2GNYj+pFszKWb8jGTAebpd8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592640; c=relaxed/simple;
	bh=E/vaTDzHpP0Ot5XuliCRJjSR2ftZCuuH7lUdErhABgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q5Ebigq1jW+VFTf0raA13g4AyHoACVJc7JubqVcx7mirJRpvEbPezOek9XtSKnnbRzYgOIroT+ihGi89lrqp/agG1gH20fTb03zCM6QE1ZvWEJETWa+JmlZDcr7mqv+5VQzskdrXKLXwXAm3sE9db+RzlPZYVH1eUIx6W3CHZ80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fy1UbfGf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fy1UbfGf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4607C113D0;
	Mon, 27 Oct 2025 19:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592640;
	bh=E/vaTDzHpP0Ot5XuliCRJjSR2ftZCuuH7lUdErhABgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fy1UbfGfbFhG8edxi+zmcXfQ7MQnlPDr/euvsKHUs3f3/G9ufbax9UYOEF/wh8SHD
	 xBNCHyaY80u1kXrY7aIvw0GLAkt8O6T3pU1Oe0e9N1D1bDrnbO5lNXXjbk34dt7lKi
	 w4gqjXH4fvXiyLZPKSUMznSLVkx7lDkrIYzNR5UQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+6fdd8fa3380730a4b22c@syzkaller.appspotmail.com,
	Mark Fasheh <mark@fasheh.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 41/84] ocfs2: clear extent cache after moving/defragmenting extents
Date: Mon, 27 Oct 2025 19:36:30 +0100
Message-ID: <20251027183439.915065155@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183438.817309828@linuxfoundation.org>
References: <20251027183438.817309828@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Deepanshu Kartikey <kartikey406@gmail.com>

commit 78a63493f8e352296dbc7cb7b3f4973105e8679e upstream.

The extent map cache can become stale when extents are moved or
defragmented, causing subsequent operations to see outdated extent flags.
This triggers a BUG_ON in ocfs2_refcount_cal_cow_clusters().

The problem occurs when:
1. copy_file_range() creates a reflinked extent with OCFS2_EXT_REFCOUNTED
2. ioctl(FITRIM) triggers ocfs2_move_extents()
3. __ocfs2_move_extents_range() reads and caches the extent (flags=0x2)
4. ocfs2_move_extent()/ocfs2_defrag_extent() calls __ocfs2_move_extent()
   which clears OCFS2_EXT_REFCOUNTED flag on disk (flags=0x0)
5. The extent map cache is not invalidated after the move
6. Later write() operations read stale cached flags (0x2) but disk has
   updated flags (0x0), causing a mismatch
7. BUG_ON(!(rec->e_flags & OCFS2_EXT_REFCOUNTED)) triggers

Fix by clearing the extent map cache after each extent move/defrag
operation in __ocfs2_move_extents_range().  This ensures subsequent
operations read fresh extent data from disk.

Link: https://lore.kernel.org/all/20251009142917.517229-1-kartikey406@gmail.com/T/
Link: https://lkml.kernel.org/r/20251009154903.522339-1-kartikey406@gmail.com
Fixes: 53069d4e7695 ("Ocfs2/move_extents: move/defrag extents within a certain range.")
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Reported-by: syzbot+6fdd8fa3380730a4b22c@syzkaller.appspotmail.com
Tested-by: syzbot+6fdd8fa3380730a4b22c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?id=2959889e1f6e216585ce522f7e8bc002b46ad9e7
Reviewed-by: Mark Fasheh <mark@fasheh.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/move_extents.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -868,6 +868,11 @@ static int __ocfs2_move_extents_range(st
 			mlog_errno(ret);
 			goto out;
 		}
+		/*
+		 * Invalidate extent cache after moving/defragging to prevent
+		 * stale cached data with outdated extent flags.
+		 */
+		ocfs2_extent_map_trunc(inode, cpos);
 
 		context->clusters_moved += alloc_size;
 next:


