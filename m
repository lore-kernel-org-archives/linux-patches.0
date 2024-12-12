Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D856B216E3B;
	Thu, 12 Dec 2024 16:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021763; cv=none; b=QXJwtLGRsS26hH/MBLMyFMtdAd/fY89beZdZ52yoTCjlm86iipK6wao8ajuo8od20367K8xijXm8PopWri67wUBvfW3yZVQ/1soOWPN7Pqo2U6HFtda5u6b7jkSRisM255VVHc12KWH8VTZTTL16kZ1tBPIUadm3IqS7S14V6pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021763; c=relaxed/simple;
	bh=PB5SQZgsx0EBOsDMIN/QDrnn1Wkg7LgBuEP9VA+HReI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=as31uPgwld6JfZ1aDqBNbHcxMMfngQEeHBYy9hQ8v9hNoVt0uXt7xc2bYpa3mivHbOPjpe9kVkRHN17HvwqkhfNCQmdNgHslyiQCGaKooMFAyfFjqQNU+J43ue44m9FPjXaF4uZU2Pk62vtlbo/sojWEiZPck4td33m1yV47UgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P1l3kSCs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P1l3kSCs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0378DC4CECE;
	Thu, 12 Dec 2024 16:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021763;
	bh=PB5SQZgsx0EBOsDMIN/QDrnn1Wkg7LgBuEP9VA+HReI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P1l3kSCs4EMe3mM9xm7mzP2XX8H6Jkg6snBUoJElV7S3RsVPgX1+V8ZBEr3EJC97p
	 waKayu4DJV4bGXdEbVAGjlQG2KmBSnARFE4ILLIEi4OYq5NIjpS2p/VDbDYxP2aHAo
	 ItqDo97EMs777CQDvWTiMESVZs+JpS+vFj7ei34I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	syzbot+453873f1588c2d75b447@syzkaller.appspotmail.com,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Joel Becker <jlbec@evilplan.org>,
	Mark Fasheh <mark@fasheh.com>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 026/565] ocfs2: uncache inode which has failed entering the group
Date: Thu, 12 Dec 2024 15:53:41 +0100
Message-ID: <20241212144312.481864358@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

From: Dmitry Antipov <dmantipov@yandex.ru>

commit 737f34137844d6572ab7d473c998c7f977ff30eb upstream.

Syzbot has reported the following BUG:

kernel BUG at fs/ocfs2/uptodate.c:509!
...
Call Trace:
 <TASK>
 ? __die_body+0x5f/0xb0
 ? die+0x9e/0xc0
 ? do_trap+0x15a/0x3a0
 ? ocfs2_set_new_buffer_uptodate+0x145/0x160
 ? do_error_trap+0x1dc/0x2c0
 ? ocfs2_set_new_buffer_uptodate+0x145/0x160
 ? __pfx_do_error_trap+0x10/0x10
 ? handle_invalid_op+0x34/0x40
 ? ocfs2_set_new_buffer_uptodate+0x145/0x160
 ? exc_invalid_op+0x38/0x50
 ? asm_exc_invalid_op+0x1a/0x20
 ? ocfs2_set_new_buffer_uptodate+0x2e/0x160
 ? ocfs2_set_new_buffer_uptodate+0x144/0x160
 ? ocfs2_set_new_buffer_uptodate+0x145/0x160
 ocfs2_group_add+0x39f/0x15a0
 ? __pfx_ocfs2_group_add+0x10/0x10
 ? __pfx_lock_acquire+0x10/0x10
 ? mnt_get_write_access+0x68/0x2b0
 ? __pfx_lock_release+0x10/0x10
 ? rcu_read_lock_any_held+0xb7/0x160
 ? __pfx_rcu_read_lock_any_held+0x10/0x10
 ? smack_log+0x123/0x540
 ? mnt_get_write_access+0x68/0x2b0
 ? mnt_get_write_access+0x68/0x2b0
 ? mnt_get_write_access+0x226/0x2b0
 ocfs2_ioctl+0x65e/0x7d0
 ? __pfx_ocfs2_ioctl+0x10/0x10
 ? smack_file_ioctl+0x29e/0x3a0
 ? __pfx_smack_file_ioctl+0x10/0x10
 ? lockdep_hardirqs_on_prepare+0x43d/0x780
 ? __pfx_lockdep_hardirqs_on_prepare+0x10/0x10
 ? __pfx_ocfs2_ioctl+0x10/0x10
 __se_sys_ioctl+0xfb/0x170
 do_syscall_64+0xf3/0x230
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
...
 </TASK>

When 'ioctl(OCFS2_IOC_GROUP_ADD, ...)' has failed for the particular
inode in 'ocfs2_verify_group_and_input()', corresponding buffer head
remains cached and subsequent call to the same 'ioctl()' for the same
inode issues the BUG() in 'ocfs2_set_new_buffer_uptodate()' (trying
to cache the same buffer head of that inode). Fix this by uncaching
the buffer head with 'ocfs2_remove_from_cache()' on error path in
'ocfs2_group_add()'.

Link: https://lkml.kernel.org/r/20241114043844.111847-1-dmantipov@yandex.ru
Fixes: 7909f2bf8353 ("[PATCH 2/2] ocfs2: Implement group add for online resize")
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Reported-by: syzbot+453873f1588c2d75b447@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=453873f1588c2d75b447
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/resize.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ocfs2/resize.c
+++ b/fs/ocfs2/resize.c
@@ -566,6 +566,8 @@ out_commit:
 	ocfs2_commit_trans(osb, handle);
 
 out_free_group_bh:
+	if (ret < 0)
+		ocfs2_remove_from_cache(INODE_CACHE(inode), group_bh);
 	brelse(group_bh);
 
 out_unlock:


