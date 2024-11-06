Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871C01CCB5F;
	Wed,  6 Nov 2024 13:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899295; cv=none; b=tI9YCnvFXpqKNJKGvfPghFdWkF+vsRgRjWWRvg9Ty/FP10I4DpoKVM6JceYXv8x4OWjfdWdedId+VkuLMZ6d6A6qkTilpskivWrwUC1fZShzEsOKaGxephYGMKGyA96xlY7rksVnYb2VqIej6BLdBcGQ0Rz8dmR/nHTkTSM8BmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899295; c=relaxed/simple;
	bh=Lv0pFotLrsb4fXif2OcUBGzxNg4h8CE5VF8mbZlZHa4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tLq+X9U60zzYJztevUrD7WQM2zSSkOwLIPuNe1Obv1d5gZkwbfYsedqG0PPXphjs1t3lVC2vFr/eoofO5FyyaCIJlh0ILa3LK0q5iofi49om/fRxxLwNKyVBVu8IDGbQnpPKSD6FDes1BcK9kVTx9IUJ9xziv2dBcI5UpzvZ50o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v1YT7Gf4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v1YT7Gf4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79066C4CECD;
	Wed,  6 Nov 2024 13:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899295;
	bh=Lv0pFotLrsb4fXif2OcUBGzxNg4h8CE5VF8mbZlZHa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v1YT7Gf4cr1SC8GZ18CmsgTS/EzN8znJbH8hoV6gummQvgno/1gua6DKxYWBQ93wN
	 L/ZkkjzwY32vhbBLtRwwvic0urc0VjKDj4I2RXJzYG64mD0AYobWq/1NAjSgh6725E
	 u8ze0GQ0OmkGiLOP7109U+yruAFopvoyPv/ZHOWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	syzbot+81092778aac03460d6b7@syzkaller.appspotmail.com,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Joel Becker <jlbec@evilplan.org>,
	Mark Fasheh <mark@fasheh.com>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Gang He <ghe@suse.com>,
	Jun Piao <piaojun@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 65/73] ocfs2: pass u64 to ocfs2_truncate_inline maybe overflow
Date: Wed,  6 Nov 2024 13:06:09 +0100
Message-ID: <20241106120301.890453548@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120259.955073160@linuxfoundation.org>
References: <20241106120259.955073160@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit bc0a2f3a73fcdac651fca64df39306d1e5ebe3b0 ]

Syzbot reported a kernel BUG in ocfs2_truncate_inline.  There are two
reasons for this: first, the parameter value passed is greater than
ocfs2_max_inline_data_with_xattr, second, the start and end parameters of
ocfs2_truncate_inline are "unsigned int".

So, we need to add a sanity check for byte_start and byte_len right before
ocfs2_truncate_inline() in ocfs2_remove_inode_range(), if they are greater
than ocfs2_max_inline_data_with_xattr return -EINVAL.

Link: https://lkml.kernel.org/r/tencent_D48DB5122ADDAEDDD11918CFB68D93258C07@qq.com
Fixes: 1afc32b95233 ("ocfs2: Write support for inline data")
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Reported-by: syzbot+81092778aac03460d6b7@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=81092778aac03460d6b7
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/file.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 403c71a485c7c..fc1e929ae0381 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1787,6 +1787,14 @@ int ocfs2_remove_inode_range(struct inode *inode,
 		return 0;
 
 	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
+		int id_count = ocfs2_max_inline_data_with_xattr(inode->i_sb, di);
+
+		if (byte_start > id_count || byte_start + byte_len > id_count) {
+			ret = -EINVAL;
+			mlog_errno(ret);
+			goto out;
+		}
+
 		ret = ocfs2_truncate_inline(inode, di_bh, byte_start,
 					    byte_start + byte_len, 0);
 		if (ret) {
-- 
2.43.0



