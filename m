Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4B53314B4;
	Tue, 16 Dec 2025 11:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884945; cv=none; b=XrbKrT01Kg3zBzFSnLmKhRm38Hy7GwdveflF/WgqYWTgjM2ubMB9bIKuoRhwGCz18R/kNOHxL1Bu8nWlaNdK7uKGO0MQQNKAzQ6UJVka/h5iyeKTYdeEWxNcidYI6GjTpLr10+StVVTn+CEc8aOfbKkMAz0vch9L2KBJRX+roiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884945; c=relaxed/simple;
	bh=v1bCXdX+msZZWEl+X5v5ObQyBYc/qu/c9N3969KJFQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LrzYH35YqQ8J1wSq6BmHnCaIBaf5nyJnzt6vUtEIg/6gkr6aJb2iLPaV12QfyrNcM/jW8PD+M+7JmW4YHb0m9MhGHZwsiuzpT7s3LVo91AUyb7uEjHDrBpU0jEHjvlpRlNjLsFXi4RQuPP79kSv5pLuU0ageOpOzPDPYdNe0YxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H+++pIr5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H+++pIr5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D9D4C4CEF1;
	Tue, 16 Dec 2025 11:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884945;
	bh=v1bCXdX+msZZWEl+X5v5ObQyBYc/qu/c9N3969KJFQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H+++pIr5MV/PwuegDEos/GELQZ0gY3fgmIkYmIeTAmPapcBgXrn6304zS9H43dFZx
	 Gcv2VPM+mwmcJSsosjdmFZL7QZXjM9d7Sm4dI5TvaxqfCeDPMWPkjDRXlFCyPrz60U
	 3kZ4rImOcLVGmkdICOCpmoPb3X9sWPsEU15a7TNY=
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
Subject: [PATCH 6.12 345/354] ocfs2: fix memory leak in ocfs2_merge_rec_left()
Date: Tue, 16 Dec 2025 12:15:12 +0100
Message-ID: <20251216111333.404716560@linuxfoundation.org>
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
index 5d9388b44e5be..f8025433ce3bf 100644
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



