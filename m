Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD61A4315A;
	Sun,  7 Sep 2025 20:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277761; cv=none; b=XxYssC9BPGifUYBs5xfmK8v8925jh8pdRepPDYLAGE/Y41dKMWmM6oSLVrmcTUvd72sKDR4+knUHUsXDt9zPi7qA4xqmniInYKr60doLcdP1B2kgvKmJAl4mkLGrqN4OI/B2fce4sjcVFj+vmNiH/a7spJYT4M1h6ELN94atv8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277761; c=relaxed/simple;
	bh=C18SIJQxLsJQcTXN4siFQ5W0LHEUnLv9Gf26K9ZXqxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LPLpMG1U9PLzzMYq4TF6yMAzmEuNkKWhdbl7ie2suVih2zVkw1TctAydlH0ifSHUAZcDgfU5/e5VBdKcOOHlLKpMLBUTOO1bTFk8vzbdvHoUoxQ4e9OJyXLwUrObsZD8Q61vi43FPFfb9lZWMX/gpnFqs2Mb7y22kc2VJ6PsWDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ob+dMgcU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ob+dMgcU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12A81C4CEF0;
	Sun,  7 Sep 2025 20:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277761;
	bh=C18SIJQxLsJQcTXN4siFQ5W0LHEUnLv9Gf26K9ZXqxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ob+dMgcUC8QjI2VBPMrFoQpKMdxfWYuzYofnccUzr8cMsjZbQhRTk5YYJ2xCl3qaT
	 4gUowdYGjNlQFF1PvJgzJF5fgeFncGxdkh/NsBHNtgA8iO7bsfIyvxWGqq9v6ouxad
	 24+8Ofa0/sBwW7PsMfrYUUhoMn62LMO1SW+pAalo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	syzbot+47d8cb2f2cc1517e515a@syzkaller.appspotmail.com,
	Mark Tinguely <mark.tinguely@oracle.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.16 113/183] ocfs2: prevent release journal inode after journal shutdown
Date: Sun,  7 Sep 2025 21:59:00 +0200
Message-ID: <20250907195618.477125132@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Adam Davis <eadavis@qq.com>

commit f46e8ef8bb7b452584f2e75337b619ac51a7cadf upstream.

Before calling ocfs2_delete_osb(), ocfs2_journal_shutdown() has already
been executed in ocfs2_dismount_volume(), so osb->journal must be NULL.
Therefore, the following calltrace will inevitably fail when it reaches
jbd2_journal_release_jbd_inode().

ocfs2_dismount_volume()->
  ocfs2_delete_osb()->
    ocfs2_free_slot_info()->
      __ocfs2_free_slot_info()->
        evict()->
          ocfs2_evict_inode()->
            ocfs2_clear_inode()->
	      jbd2_journal_release_jbd_inode(osb->journal->j_journal,

Adding osb->journal checks will prevent null-ptr-deref during the above
execution path.

Link: https://lkml.kernel.org/r/tencent_357489BEAEE4AED74CBD67D246DBD2C4C606@qq.com
Fixes: da5e7c87827e ("ocfs2: cleanup journal init and shutdown")
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Reported-by: syzbot+47d8cb2f2cc1517e515a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=47d8cb2f2cc1517e515a
Tested-by: syzbot+47d8cb2f2cc1517e515a@syzkaller.appspotmail.com
Reviewed-by: Mark Tinguely <mark.tinguely@oracle.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/inode.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1219,6 +1219,9 @@ static void ocfs2_clear_inode(struct ino
 	 * the journal is flushed before journal shutdown. Thus it is safe to
 	 * have inodes get cleaned up after journal shutdown.
 	 */
+	if (!osb->journal)
+		return;
+
 	jbd2_journal_release_jbd_inode(osb->journal->j_journal,
 				       &oi->ip_jinode);
 }


