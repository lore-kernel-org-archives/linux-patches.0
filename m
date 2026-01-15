Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2A03BFE5D;
	Thu, 15 Jan 2026 17:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499212; cv=none; b=rfnAqigN4I4RIsObAcl34WJ8ob4hOcWgmfVH48t2Soot45xfTWr2SvDo/VSsZxpD0KdoXYAsnposneJbhMD7RjTNa5G3WflyHV23SW9DX3ZE5ygBSiBQSe2JUGLZfa2euaMVH33nF+5JhKZHECpfiTDaA6PIEM4Ufnc74g+eA/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499212; c=relaxed/simple;
	bh=zhO00BepGUpjnfHlKXK4G0w7uIt5DzxFkWUTk0XY8UM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GQBTQufU8eOm81U32T6HOtqTY3QSHvk4w8jmENy8coXFlXO6TcjX5T7UKwAaYhOkK+8bc5zRzU8ng+e+Bkk9yNzz+eqg1rDauY+PT8+1/bV8TOUdUnbCVZ2/Mrt/HSfwXdKPuCD8PWj47DBQ2fM1V8AFwhA6CTLoCbXnT7gOc7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HJnKM7nP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HJnKM7nP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F277C116D0;
	Thu, 15 Jan 2026 17:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499212;
	bh=zhO00BepGUpjnfHlKXK4G0w7uIt5DzxFkWUTk0XY8UM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HJnKM7nPCX7GyKj0Ku0KKqGwSTCIm3qkqhzRzTPFIZaWKIQNwWhQjo0ZcqhZNAfx2
	 6ifmnpGwPAEiXR0h2P5jWMPlTGEM00y5TBcbmTss7HF2DN3AUfk50+asrbK9SA3iDw
	 aiEscYR6VLdu7Gge38+HXpxJ3rsg/91G+xhm+URo=
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
Subject: [PATCH 5.10 147/451] ocfs2: fix memory leak in ocfs2_merge_rec_left()
Date: Thu, 15 Jan 2026 17:45:48 +0100
Message-ID: <20260115164236.233677052@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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
index 94c7acfebe183..9f61a6d64cbce 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -3649,7 +3649,6 @@ static int ocfs2_merge_rec_left(struct ocfs2_path *right_path,
 			 * So we use the new rightmost path.
 			 */
 			ocfs2_mv_path(right_path, left_path);
-			left_path = NULL;
 		} else
 			ocfs2_complete_edge_insert(handle, left_path,
 						   right_path, subtree_index);
-- 
2.51.0



