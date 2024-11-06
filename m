Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E901EE00C;
	Wed,  6 Nov 2024 13:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898509; cv=none; b=IyMkA9EHS/0Rnk5gKYdlxFFDZgCq36y0yzkX+yNGHnOF3lIDGf+sT7pwhR6G+AkNDkRsmVmu9uSmvH79Zjq6VgZmeOUDKQHt4ud+qodhytac0NJyLeQIbeOISjXdJlQbino4Z3ihF7v6Xf54Y97mbbakSG739dwxBG2tXBioQO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898509; c=relaxed/simple;
	bh=THqEmqyBIfutGpiEBn1+QU0tfd9mx54dno1jY2lEFVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iv0ChlCBTXybm33kFqt+rrSKIylvFIZ9cASHVABHcSKfVlOwDSBusTvDf7l0NRBUl40JnZvjQ0YjxfxehpfZne8KDrWbGye1j46/ICN2KbduRluxwwIARgfdoUFsohULfa0Mn/H3SfTPXrTaa79v3yz+SUcblsa5sVseMaRgU4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2FSTe0rg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2FSTe0rg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5EB1C4CED5;
	Wed,  6 Nov 2024 13:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898509;
	bh=THqEmqyBIfutGpiEBn1+QU0tfd9mx54dno1jY2lEFVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2FSTe0rg28/giVHshnycQ1E3Fj4muS0ec8yjVB6kNpO0K6CPi66/kWTsDzQqRv7j7
	 VH/EXoPBHmK1zTLO98rPiqnVqHxTzWLwGNQA4qOJbF2nyyFe+w3fgJE1Y7xudN+E0F
	 kCGE9mkWDSiBjkF1rINOQtZ309dfjtqztiKOB+xA=
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
Subject: [PATCH 5.4 261/462] ocfs2: cancel dqi_sync_work before freeing oinfo
Date: Wed,  6 Nov 2024 13:02:34 +0100
Message-ID: <20241106120337.972345633@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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


