Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 949651E103C;
	Wed,  6 Nov 2024 12:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896883; cv=none; b=kFPXwKPLQj26uZwYI58sPxtcOZejWg8oqgTAiRphnpwUKePOgmzNFMP2sxnkVTsmX5vw9md94sUL9ir2vRetBc1fH/H17ilRPzbX5Uzyk+ri5gTkTndofU4zy7uPWpGN8+3SA6JxvxC9i++0bNqrOnNQFCur/SdesVxuw53Ha1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896883; c=relaxed/simple;
	bh=I/ElNnwj9OVFuCf7Gn2zjOS7IsVIg75+VvaGp51QIRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YFDMrhhqgQNLoxRZ+5wKaQcEztOmpRp0raO10GTFOLaNvb68k4wB/Xk8p6J4HrQSXGn4y7475JJxxCAR1I2spn3T1kmia2L1BypVObwECU9AzKwMsfbJPJ5MPNf7GOu1apvs1pWAYbbT7k/XQK/tQCA8G8umQq121EZWqKUNOgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GmxJkheG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GmxJkheG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2E14C4CECD;
	Wed,  6 Nov 2024 12:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896883;
	bh=I/ElNnwj9OVFuCf7Gn2zjOS7IsVIg75+VvaGp51QIRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GmxJkheG50FYzRkXaUkUdqlTJKZMKQB0WAl4QaG3fxRx/7tsqLGNR+rgR/0tBQF7A
	 BAquem20wclJqL2HFuJJUAcNhqW7xv8xW1pWEZakZ2/5MrIUioIBXnMo4CVvKMmUMB
	 xCnNAUqn4Sm//Zez84Zewu37rhclh1jsAMKkeixg=
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
Subject: [PATCH 5.10 103/110] ocfs2: pass u64 to ocfs2_truncate_inline maybe overflow
Date: Wed,  6 Nov 2024 13:05:09 +0100
Message-ID: <20241106120306.017571792@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120303.135636370@linuxfoundation.org>
References: <20241106120303.135636370@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 5fd565a6228f7..09a62539ab74d 100644
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



