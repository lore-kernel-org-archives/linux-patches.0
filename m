Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CCD33F12CE;
	Tue, 21 Jul 2026 17:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654550; cv=none; b=WZX4tgTh8/qV4NbrNXlF1hhry+6BNw+EuP/0OK94H5Wd3f696VHCL0iKHyvaMW26iF34/KHrzLG33WsZO+qtfLv1as1ovxCQmBJzJ0P30jBjEv/EPuI/Ht3lmI6E6D7S5MdkQdXNHKn5AfxQaAHtMuMtq2glKTgNdUURNrha1WM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654550; c=relaxed/simple;
	bh=V4O4Kn8jliy5hXc8FBhmt1xSecs+j2BZlkfkkr5jceg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A/JzilZUGkSCWQTvx2BrWOFsDFTPEGT5C+oBAkSKUU+5Iiqgps99qh5OqagTn5dmCmJLd3DlXLrkZ2HmIHM1gW8EBL0YP2uXZFd2ZxAW61Eoy6mG2oQuM/MPiLcDeGrI4GUHA1OT0Y9rJlzxdI2RRuv76xhRvExsNj8IN4Scim4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SXn1/cxy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SXn1/cxy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBA3D1F000E9;
	Tue, 21 Jul 2026 17:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654549;
	bh=J21VIQceHPvwhML10yNK28pEWpU/LLTtXnb/jB3Es94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SXn1/cxyFMU40MyLu4WLOW2efLB/aEe7keWkBB74/cW0Q3XGcAhxH4Jz54USmi0GS
	 VbU/B60+J9SeQB4RL/8EZ2Z6sM4pxFPzdGhe7gPEULC3KVi+2wzG44lcKe4dtebPXt
	 WRtfXPtJUq7I9KTumA+F+Zw7TkPagmoiAc1k+ncc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7ea0b96c4ddb49fd1a70@syzkaller.appspotmail.com,
	Tristan Madani <tristan@talencesecurity.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.1 1745/2077] ocfs2: use kzalloc for quota recovery bitmap allocation
Date: Tue, 21 Jul 2026 17:23:38 +0200
Message-ID: <20260721152633.904905912@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tristan Madani <tristan@talencesecurity.com>

commit 93c8c6ea90be9e9df8fe14048ad4e3caad0770a6 upstream.

ocfs2 quota recovery allocates a bitmap buffer with kmalloc and does not
fully initialize it.  This can lead to use of uninitialized bits during
quota recovery from a corrupted filesystem image.

Use kzalloc instead to ensure the bitmap is zero-initialized.

Link: https://lore.kernel.org/20260418131048.1052507-1-tristmd@gmail.com
Reported-by: syzbot+7ea0b96c4ddb49fd1a70@syzkaller.appspotmail.com
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/quota_local.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -302,7 +302,7 @@ static int ocfs2_add_recovery_chunk(stru
 	if (!rc)
 		return -ENOMEM;
 	rc->rc_chunk = chunk;
-	rc->rc_bitmap = kmalloc(sb->s_blocksize, GFP_NOFS);
+	rc->rc_bitmap = kzalloc(sb->s_blocksize, GFP_NOFS);
 	if (!rc->rc_bitmap) {
 		kfree(rc);
 		return -ENOMEM;


