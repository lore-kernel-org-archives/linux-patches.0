Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECF721F8EFB;
	Wed,  6 Nov 2024 12:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897189; cv=none; b=fbf/ka6NFpoWybpa2rpNfstnFxnlSA/bBkOeYpmt516TmU6n/evNqCXkL2SIn7mQS0DUmnA48MSrMDnjAuiVBHASlTWJh+U2sUY37FQUdTXVOZ8RoJ1b/MrSTIGfb1PdVgynIkjR3j6GWTSAu+31JNEPe5bAFm0nYeATfCY0ukQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897189; c=relaxed/simple;
	bh=XvVQq0tYsNh00Y0Pn4iPWco7ZJBXk+D1Zeb3b714CyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hL8JpY964CLxQlZE8YN6ZxNagc6uRNVnQli266cWNoeQV+1wB7HBl9+8WlZh2VjwScC3rSidyIA0LinBVtEFw9Bppdh/LYeY52sZdf6PcyHlA8W8f0ALCGpwtnFFo6rAixefxjC6Yaf+l5GwlQgjZMZBgHkGSR5e+DEINqwybjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iS2w/U9U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iS2w/U9U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBA8DC4CECD;
	Wed,  6 Nov 2024 12:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897188;
	bh=XvVQq0tYsNh00Y0Pn4iPWco7ZJBXk+D1Zeb3b714CyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iS2w/U9UBarOg6Y53tb4xHOzUYNYTN8gRuhdUXim6mbTh6L8016pX2daqlWaDc3NH
	 P+xtL1/cgLIjqZpx72zFx3kV2iyZiBsdkd5YJ0DfEge4PlA3UqlviaGio7vRWHM3Wi
	 hcKFxEOzUDakA+jbGaxsl/+9CCPv8OYjZtBb6eWw=
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
Subject: [PATCH 6.1 096/126] ocfs2: pass u64 to ocfs2_truncate_inline maybe overflow
Date: Wed,  6 Nov 2024 13:04:57 +0100
Message-ID: <20241106120308.661911491@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f502bb2ce2ea7..ea7c79e8ce429 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1784,6 +1784,14 @@ int ocfs2_remove_inode_range(struct inode *inode,
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



