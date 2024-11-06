Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF3E1DE8B4;
	Wed,  6 Nov 2024 12:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895391; cv=none; b=J9nJ3HJgf8u6e3kubb0jUoV2iAmrj/wAfDaDqC7pqAf20xgn/wfXVcyAuAUSZnVkl9BVz5XiFWCLXJbZkz3p+pZ+RoG3J+tQ899TD8i+xco/bL/emYbY4zwnD0jbG0hnoZZjGgMzEefuXGyWw9cNcEht3yt8Q6fngWP3BKRVVko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895391; c=relaxed/simple;
	bh=ZMm8FcFFpmhGuX47Yl+WUd/8Fee6YzMCCMaJZLf3RV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=olh1FmGjwVXG73bwFH0A8GeB87VOA4QDhAcic9K2fUqHxa0t5tyyAJBshmmGfOCHAH9Oc5Mq6nOR/GzOBvV9p8/DaI7BRX530f5n1OZRoxXyL1nveeT394LcKDaZIll8Ack56BGDvFDcMIgvLEiZLW2itFfjLefT7XbYEMwbjis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ET4UgRX/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ET4UgRX/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 172B2C4CECD;
	Wed,  6 Nov 2024 12:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895391;
	bh=ZMm8FcFFpmhGuX47Yl+WUd/8Fee6YzMCCMaJZLf3RV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ET4UgRX/V0nQYeT1OmRBiIkQNXrCcoMGULcqmCk+MZvl6n+Qr9x2bOi5moKHd/I5b
	 OGntqgTFDSiMY0iGgwTXb+ixKECGIPaV5O+cRXDxIB5eys8+ZSQpxlOyxHJMjRtx2Q
	 ovrFRY7HZrJkWnTrN4hfhDvWLH6wijfUhRty3rNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lizhi Xu <lizhi.xu@windriver.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Heming Zhao <heming.zhao@suse.com>,
	syzbot+ab134185af9ef88dfed5@syzkaller.appspotmail.com,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Gang He <ghe@suse.com>,
	Jun Piao <piaojun@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4.19 201/350] ocfs2: remove unreasonable unlock in ocfs2_read_blocks
Date: Wed,  6 Nov 2024 13:02:09 +0100
Message-ID: <20241106120325.939199226@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lizhi Xu <lizhi.xu@windriver.com>

commit c03a82b4a0c935774afa01fd6d128b444fd930a1 upstream.

Patch series "Misc fixes for ocfs2_read_blocks", v5.

This series contains 2 fixes for ocfs2_read_blocks().  The first patch fix
the issue reported by syzbot, which detects bad unlock balance in
ocfs2_read_blocks().  The second patch fixes an issue reported by Heming
Zhao when reviewing above fix.


This patch (of 2):

There was a lock release before exiting, so remove the unreasonable unlock.

Link: https://lkml.kernel.org/r/20240902023636.1843422-1-joseph.qi@linux.alibaba.com
Link: https://lkml.kernel.org/r/20240902023636.1843422-2-joseph.qi@linux.alibaba.com
Fixes: cf76c78595ca ("ocfs2: don't put and assigning null to bh allocated outside")
Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reported-by: syzbot+ab134185af9ef88dfed5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ab134185af9ef88dfed5
Tested-by: syzbot+ab134185af9ef88dfed5@syzkaller.appspotmail.com
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>	[4.20+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/buffer_head_io.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/ocfs2/buffer_head_io.c
+++ b/fs/ocfs2/buffer_head_io.c
@@ -251,7 +251,6 @@ int ocfs2_read_blocks(struct ocfs2_cachi
 		if (bhs[i] == NULL) {
 			bhs[i] = sb_getblk(sb, block++);
 			if (bhs[i] == NULL) {
-				ocfs2_metadata_cache_io_unlock(ci);
 				status = -ENOMEM;
 				mlog_errno(status);
 				/* Don't forget to put previous bh! */


