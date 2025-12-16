Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3538E32BF22;
	Tue, 16 Dec 2025 11:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884296; cv=none; b=ZyogFSvbFwbXkQnphODXIttXp8KZbk4ZeX6rcHaK9Q/h1i/asdSE1K4X4u3hEtYkbhSsZfFRWZgbAGtPtFg5TwHVTkDHtyv5ykauosrKxy47FYhJjDaLEFpk7MkgjJckopauk/LZTDJ3kO90s0Mx90WSa2E5speOwoGephvIQ8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884296; c=relaxed/simple;
	bh=fs9kGNy6z3fZxu1KDFy0sBDNELh9n2jZCZT3sRHOpnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fMi9WgiEni0PA1iC8oFe6Rhd8BQz2V2SGg/Q9+NxoGxNGb4FncVrQztu9OAg8aI3nfWzU2KtC2S5e13mbPmhe6IxGN9nqVDuoHKuyiu7tl/vxYb4n4LFM6XU4rIlNTUSIpd1FigtFBXGYGZp7eEhzqHt9RVMBzkmGnkIvpYomg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z1S2dT4O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z1S2dT4O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8572FC4CEF1;
	Tue, 16 Dec 2025 11:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884296;
	bh=fs9kGNy6z3fZxu1KDFy0sBDNELh9n2jZCZT3sRHOpnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z1S2dT4O52rwHJroTMyVH84+GXP9rA2ICVYl6AvKeWT3gad99mGvjxsW5gkgnOZDZ
	 IG/GSTjkUW6y/H5r2X0yBmg8JsLBXi8O9iRssRcyrY1sEIRjbIQLizKz8bYlXrEiiO
	 4lfeyIva1NJkt0oWZimMZ+0df+qW6lggDAWZf0IQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	syzbot+727d161855d11d81e411@syzkaller.appspotmail.com,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 151/354] ocfs2: relax BUG() to ocfs2_error() in __ocfs2_move_extent()
Date: Tue, 16 Dec 2025 12:11:58 +0100
Message-ID: <20251216111326.386599904@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

[ Upstream commit 8a7d58845fae061c62b50bc5eeb9bae4a1dedc3d ]

In '__ocfs2_move_extent()', relax 'BUG()' to 'ocfs2_error()' just
to avoid crashing the whole kernel due to a filesystem corruption.

Fixes: 8f603e567aa7 ("Ocfs2/move_extents: move a range of extent.")
Link: https://lkml.kernel.org/r/20251009102349.181126-2-dmantipov@yandex.ru
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Closes: https://syzkaller.appspot.com/bug?extid=727d161855d11d81e411
Reported-by: syzbot+727d161855d11d81e411@syzkaller.appspotmail.com
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/move_extents.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index aa595cd1ab6fe..6fcaaeece6666 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -98,7 +98,13 @@ static int __ocfs2_move_extent(handle_t *handle,
 
 	rec = &el->l_recs[index];
 
-	BUG_ON(ext_flags != rec->e_flags);
+	if (ext_flags != rec->e_flags) {
+		ret = ocfs2_error(inode->i_sb,
+				  "Inode %llu has corrupted extent %d with flags 0x%x at cpos %u\n",
+				  (unsigned long long)ino, index, rec->e_flags, cpos);
+		goto out;
+	}
+
 	/*
 	 * after moving/defraging to new location, the extent is not going
 	 * to be refcounted anymore.
-- 
2.51.0



