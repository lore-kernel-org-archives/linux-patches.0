Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF3832BF21;
	Fri,  9 Jan 2026 11:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959809; cv=none; b=AjqKOcEMqX2FNxtNQCjbsuLc+w/BXemu4yVypoyAtpvfzrL5/0xwrLfQFFpEyEZAyD57RzgDM9cjP4p7Yk4b8Wx/a8A91px2R+FHyqkFWhXhBL8mZ2+GFw/kL+Kkn7aioZUNIVcIt0NDmh0I2QTe1O5L1E4mYwfc8HvM6/9wyK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959809; c=relaxed/simple;
	bh=Wt1igFejJT8ll9N3wVXfvLpXOASaKkSbx86bk/pEjmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=saTHsgvu4205ujYyWMaxJqqL6CJm9Mqz4AfWr6eLf2L/ifvMt3utb1dfsxogX36LJZwiL87h8/y3Uji4YvdgkWjq8oejQFRzDXePmFFE2ulIV4EEq9KyuNdSru0hH8HUiw1Be5mx5c8TFV+7unq/kkZAUNuvTs/a2eCdNwhQy98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pvHEUeVY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pvHEUeVY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03299C4CEF1;
	Fri,  9 Jan 2026 11:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959809;
	bh=Wt1igFejJT8ll9N3wVXfvLpXOASaKkSbx86bk/pEjmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pvHEUeVYyqa6gjUJmQWyzo+/GE1mTPQngPC8kaOob+jxdveP2Vl72XCDQvOCI+aY9
	 auouZcWHsv+FmbW7FL1B0oBiKQs83SBsMK7eWMA+GdIDswm1WfrT9bo/8RlkgleNOj
	 H6zyQmyu89g8LiNTy+1tRZ+q9/KZ1OL5B1Nqz+u8=
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
Subject: [PATCH 6.6 149/737] ocfs2: relax BUG() to ocfs2_error() in __ocfs2_move_extent()
Date: Fri,  9 Jan 2026 12:34:48 +0100
Message-ID: <20260109112139.603382322@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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
index 2f34074f0078b..d97ec93ff4c26 100644
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



