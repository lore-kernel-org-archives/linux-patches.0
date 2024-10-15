Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0421F7084;
	Tue, 15 Oct 2024 13:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998137; cv=none; b=DUjKVqtGbg7qPMweXJpQoEC5yueIFLwLsVcbb9yZkU06a2UKsdIrmckpUUGoX17JJjsdvjdHxxFkkM9SyR4IHYERkQAXv6PVwuXKrPIGDvWa531xEP0BH3RsDDPXUiL3HqsGEniE6a6Uig7J1ohnzV11TzGnYuZ2Gm/kTX1St14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998137; c=relaxed/simple;
	bh=tvB+TJSfclEeBcvrRvCRNeXh8zTEhcr9/XL+AAwnobA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n6h1p0NZOJzyluCiiQfvyDz9sHA97ZHkDorsovaXGutQ2m4cTivkQlYMy1poORROniSDEsc9lTliqS6nl/Lf2UObkTeJQc8IUuDDp4aeivd8S1V/YKnFS1Y3MsFkJc/dDI65azXKNRss+XnWQmc8J3BhoxEdWeMbQjchZY9l0Ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=18dna8B+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="18dna8B+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5920CC4CEDE;
	Tue, 15 Oct 2024 13:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998137;
	bh=tvB+TJSfclEeBcvrRvCRNeXh8zTEhcr9/XL+AAwnobA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=18dna8B+cQRnHcIH0HD3KdifZ+rduaIiMbA+Ho/9O3xynuUUCVwxtjqKbjtLzhuJL
	 LGa4c0HtkRJV/IqakWRFQss6ilfljVM9wfigyLQWS+WIad9m+Y02qs297qNr3kMbD1
	 YwcMPctqtQjIWoo3ne+HIEBvKtljcAT1m5NxanAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Heming Zhao <heming.zhao@suse.com>,
	syzbot+f7af59df5d6b25f0febd@syzkaller.appspotmail.com,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Gang He <ghe@suse.com>,
	Jun Piao <piaojun@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.10 389/518] ocfs2: cancel dqi_sync_work before freeing oinfo
Date: Tue, 15 Oct 2024 14:44:53 +0200
Message-ID: <20241015123931.984420803@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

From: Joseph Qi <joseph.qi@linux.alibaba.com>

commit 35fccce29feb3706f649726d410122dd81b92c18 upstream.

ocfs2_global_read_info() will initialize and schedule dqi_sync_work at the
end, if error occurs after successfully reading global quota, it will
trigger the following warning with CONFIG_DEBUG_OBJECTS_* enabled:

ODEBUG: free active (active state 0) object: 00000000d8b0ce28 object type: timer_list hint: qsync_work_fn+0x0/0x16c

This reports that there is an active delayed work when freeing oinfo in
error handling, so cancel dqi_sync_work first.  BTW, return status instead
of -1 when .read_file_info fails.

Link: https://syzkaller.appspot.com/bug?extid=f7af59df5d6b25f0febd
Link: https://lkml.kernel.org/r/20240904071004.2067695-1-joseph.qi@linux.alibaba.com
Fixes: 171bf93ce11f ("ocfs2: Periodic quota syncing")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Reported-by: syzbot+f7af59df5d6b25f0febd@syzkaller.appspotmail.com
Tested-by: syzbot+f7af59df5d6b25f0febd@syzkaller.appspotmail.com
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/quota_local.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -689,7 +689,7 @@ static int ocfs2_local_read_info(struct
 	int status;
 	struct buffer_head *bh = NULL;
 	struct ocfs2_quota_recovery *rec;
-	int locked = 0;
+	int locked = 0, global_read = 0;
 
 	info->dqi_max_spc_limit = 0x7fffffffffffffffLL;
 	info->dqi_max_ino_limit = 0x7fffffffffffffffLL;
@@ -697,6 +697,7 @@ static int ocfs2_local_read_info(struct
 	if (!oinfo) {
 		mlog(ML_ERROR, "failed to allocate memory for ocfs2 quota"
 			       " info.");
+		status = -ENOMEM;
 		goto out_err;
 	}
 	info->dqi_priv = oinfo;
@@ -709,6 +710,7 @@ static int ocfs2_local_read_info(struct
 	status = ocfs2_global_read_info(sb, type);
 	if (status < 0)
 		goto out_err;
+	global_read = 1;
 
 	status = ocfs2_inode_lock(lqinode, &oinfo->dqi_lqi_bh, 1);
 	if (status < 0) {
@@ -779,10 +781,12 @@ out_err:
 		if (locked)
 			ocfs2_inode_unlock(lqinode, 1);
 		ocfs2_release_local_quota_bitmaps(&oinfo->dqi_chunk);
+		if (global_read)
+			cancel_delayed_work_sync(&oinfo->dqi_sync_work);
 		kfree(oinfo);
 	}
 	brelse(bh);
-	return -1;
+	return status;
 }
 
 /* Write local info to quota file */


