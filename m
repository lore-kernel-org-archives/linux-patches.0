Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19CAE3596F3;
	Tue, 16 Dec 2025 12:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886684; cv=none; b=TVLEnzvK/WIKX4XQ4bXH77u7VnxtFeMhZDszHg+jbbktyIW0fBwB+nAGYDRoTlauZaXO3U1vwtpGyOw19LohM8CFQip5AfBpHNkbToBht59/84y27mu4gxh1WmkKtMkdSv78kdkagOMHabkKp66etxTyUEaJDLb6fWpJMl0sjuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886684; c=relaxed/simple;
	bh=s9LupDkbAUwTr3IR//EwvMGd0Ro/3n09NGKz/7ACza4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hrAPt9f3dOD0ksLs8j4ZC5iG3pGjpjUT2l8TSZIvNgU6RQBXlyXkk0sYaLzkj2u+KQaVC9iMe8eg6eBqaYoMVTTVNE9+DIsaFioMFmPaYnNTtv43Iu5i/mAUgqgRKsBg6pA0j2T7gE09rts0RziEgaI+feoGlDnA57eYhaEKMvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gy4iJV2c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gy4iJV2c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08769C4CEF1;
	Tue, 16 Dec 2025 12:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886683;
	bh=s9LupDkbAUwTr3IR//EwvMGd0Ro/3n09NGKz/7ACza4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gy4iJV2c47vbXtSU/Rq9T9CwB0i3dooRLTz4Y4kJICqe4cc0wPr1JWua0UrFTsrpY
	 7lcPqIGV5x7kFzW3jen6/Yua2a/sTEhO0HI5yuzGO9IyoGlBcNfN3YS6NHSApIeVl1
	 7nU+3qF+OA1xN4KbTaNWAjguDVlH6ZG53YdqyZC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	syzbot+cfc7cab3bb6eaa7c4de2@syzkaller.appspotmail.com,
	Heming Zhao <heming.zhao@suse.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 496/507] ocfs2: fix memory leak in ocfs2_merge_rec_left()
Date: Tue, 16 Dec 2025 12:15:37 +0100
Message-ID: <20251216111403.408916819@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit 2214ec4bf89d0fd27717322d3983a2f3b469c7f3 ]

In 'ocfs2_merge_rec_left()', do not reset 'left_path' to NULL after
move, thus allowing 'ocfs2_free_path()' to free it before return.

Link: https://lkml.kernel.org/r/20251205065159.392749-1-dmantipov@yandex.ru
Fixes: 677b975282e4 ("ocfs2: Add support for cross extent block")
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Reported-by: syzbot+cfc7cab3bb6eaa7c4de2@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=cfc7cab3bb6eaa7c4de2
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/alloc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 821cb7874685e..b23eb63dc838b 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -3654,7 +3654,6 @@ static int ocfs2_merge_rec_left(struct ocfs2_path *right_path,
 			 * So we use the new rightmost path.
 			 */
 			ocfs2_mv_path(right_path, left_path);
-			left_path = NULL;
 		} else
 			ocfs2_complete_edge_insert(handle, left_path,
 						   right_path, subtree_index);
-- 
2.51.0



