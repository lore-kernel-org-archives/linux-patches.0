Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 188393BF2FF;
	Thu, 15 Jan 2026 17:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497773; cv=none; b=Da25ic+hnNxwKpTPm4YQ/UEJ4dN4oOfoys31k9Nx3L65VWtkjFiEDnNFxmcoOb7Tno30eSO06N92A7wLfPdH0C63Hw/8LDzSqTqCcETIEquBmPJQW51M4MSQ/236K9K/KDx9I33ZhNOC60Thnm/+SU3d8uJTPXWH8zn8bXNKVco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497773; c=relaxed/simple;
	bh=n4WGg28TsKyx7SXgKEM+UGHWpFeqHWMDfJY1JZxPPNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n3+NARavRMuhQDCi7FMQTZxT74rY2CKXQyyKEFSfDJvBbFazkBvt67NJHAMES56cSmBXRKM3qrHXjzxyc/y0AdLSBAX3a6iph58NA7hbJrYoDhr4ChKUmSS45LQC3O/qpf4qGqBoJzNVdobEI6nEziPPeK/GpbXP/Hrr3zZ+ra8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oi2KCusm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oi2KCusm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 701B5C16AAE;
	Thu, 15 Jan 2026 17:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497773;
	bh=n4WGg28TsKyx7SXgKEM+UGHWpFeqHWMDfJY1JZxPPNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oi2KCusmN74gvwMbz7m3+dSqqFb3WTEvRe03gzQfd8PkrB1cpCZdmrPaPHGpCjHK2
	 yoRMUcl+zlDcBIw7tacLylCm/L0f7EuXm+4SnlhEt0eSa/seMCsMc5RRAUjqEanXrV
	 ZZPnewbTYo7BEeREocQK/uUGJg1uuwOMhQv4ArOo=
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
Subject: [PATCH 5.15 197/554] ocfs2: fix memory leak in ocfs2_merge_rec_left()
Date: Thu, 15 Jan 2026 17:44:23 +0100
Message-ID: <20260115164253.387841861@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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
index 9c95d911a14b1..9589b462b5913 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -3647,7 +3647,6 @@ static int ocfs2_merge_rec_left(struct ocfs2_path *right_path,
 			 * So we use the new rightmost path.
 			 */
 			ocfs2_mv_path(right_path, left_path);
-			left_path = NULL;
 		} else
 			ocfs2_complete_edge_insert(handle, left_path,
 						   right_path, subtree_index);
-- 
2.51.0



