Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7AF9329C64;
	Mon, 27 Oct 2025 19:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591664; cv=none; b=n8eKYE8dRAp8ljKW1vJyewM0m+UDKQ+WU/i3BiQByRADhLs7Bl9wWCklvQ6qn/UXmac02FhPbU6lKzxy+2tJeEE1ezijMJD7eafBWaO+diZRJV/45QzPLYyEjFHA1n/Yjhh0GV7TFuceMSsptpi7EhYU9atiZYQbN2cGiVUi8mM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591664; c=relaxed/simple;
	bh=NcKCYg02McSAVWVPhkQzLPwsUwF18hQnoW+DVojEyYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XX0NhPofUtMH8W5eqI1QpJDayGWjxTT0FFSwDM2kXArq9ebUAv+atnPYWMSMidMsAlZ+BfNCc8UuYOf/2RuweQPJJFbBRc4IBOajEkOYjoX5MugTeUq5Cn7bj/VF4L5jw9zbeVdU+fDPIT35f4Ex5BuhAYG6lKTuogLekRJMkNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V6u6y/2J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V6u6y/2J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5183DC4CEF1;
	Mon, 27 Oct 2025 19:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591663;
	bh=NcKCYg02McSAVWVPhkQzLPwsUwF18hQnoW+DVojEyYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V6u6y/2JLkG0nfxjdxuEwRFQtrByNGagzj3O+8KHn8pvtVjXY8+MwOycsaSkcxHad
	 UuaOEuaUy+dGzsq6XmPQTaCYVG0bnPiACQQ2XBujubISwAr3GWcx3VGDRTk/g0iOrl
	 QWrThJd2K4TDe1NYukmwFDvcp763hJOUA+BMir1c=
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
Subject: [PATCH 5.10 283/332] ocfs2: clear extent cache after moving/defragmenting extents
Date: Mon, 27 Oct 2025 19:35:36 +0100
Message-ID: <20251027183532.332273752@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -870,6 +870,11 @@ static int __ocfs2_move_extents_range(st
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


