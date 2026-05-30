Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E06B349CCF;
	Sat, 30 May 2026 16:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159401; cv=none; b=BfoCNR2t8uLilonfZwmhN+j2SRrEaS/SXAxyyQ+Wc7Nw30ZXBVq38kgmgJfYXxiF7vomJmIAwcEB0xb6V9Q8Q5JFKA17CGgXQFxrIZL/eNrVG6SRfC1Si1FMpb0ArdHvIbFqnefqrt9uF5y/icCdykLLWL6N8EAs75DWMKy9OyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159401; c=relaxed/simple;
	bh=Z+SR7J3ofecUHLyYJ+2x/LNU/TqWU0Lx3OCmbxpKWcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zie3sbvWfSiJ6YZ8NNhUEBRalOmtKAWiPIgcBUguL37E/WbjPsJZWrmsZne5NL+41UYz0gyk9rMy8z7fMAc0loM78Zf8pjhTis0YbPzJcJ0tRRyePdDFSWfxHRHDnVzAUrZQ+uF1OAJkJbTQqiR2G0nhkBv4zmcaLUBCUR1QPA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CU7VIhM8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CU7VIhM8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B90A41F00893;
	Sat, 30 May 2026 16:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780159400;
	bh=uFQFeY0TWpFH27F10KoCoya80ZObjE+6m6cKYVxGANQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CU7VIhM8lcuAbMc9H/+H/fiRJte+GsWTz/Nkhpksb5d65sUd5MPxydTwWpNHnGuQc
	 o4bZn3w6gVa1LMujmaU4dHqcUpUiAgPQAg7LLtytahfollIdobCdiN/kX1LwLWozBv
	 9BFxmV8CBSUFBtZgtGEGauVpLR0nrlEhT0APb6JI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	syzbot+c16daba279a1161acfb0@syzkaller.appspotmail.com,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Joseph Qi <jiangqi903@gmail.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 121/969] ocfs2: add inline inode consistency check to ocfs2_validate_inode_block()
Date: Sat, 30 May 2026 17:54:05 +0200
Message-ID: <20260530160303.740457812@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit a2b1c419ff72ec62ff5831684e30cd1d4f0b09ee ]

In 'ocfs2_validate_inode_block()', add an extra check whether an inode
with inline data (i.e.  self-contained) has no clusters, thus preventing
an invalid inode from being passed to 'ocfs2_evict_inode()' and below.

Link: https://lkml.kernel.org/r/20251023141650.417129-1-dmantipov@yandex.ru
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Reported-by: syzbot+c16daba279a1161acfb0@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c16daba279a1161acfb0
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 7bc5da4842be ("ocfs2: fix out-of-bounds write in ocfs2_write_end_inline")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/inode.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1419,6 +1419,14 @@ int ocfs2_validate_inode_block(struct su
 		goto bail;
 	}
 
+	if ((le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL) &&
+	    le32_to_cpu(di->i_clusters)) {
+		rc = ocfs2_error(sb, "Invalid dinode %llu: %u clusters\n",
+				 (unsigned long long)bh->b_blocknr,
+				 le32_to_cpu(di->i_clusters));
+		goto bail;
+	}
+
 	rc = 0;
 
 bail:


