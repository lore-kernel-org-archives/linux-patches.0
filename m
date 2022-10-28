Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 847EB23A3
	for <patches@lists.linux.dev>; Fri, 28 Oct 2022 12:04:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0AFDC433D6;
	Fri, 28 Oct 2022 12:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1666958671;
	bh=r+KS8rqtmSjB5OajPQGy7sYcPK6l46rCGGmiNG3tgRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2B0uQzKaN2EOFAdksM8ZI854/ttcdIRESP7CGdVmCJhzb17ufg1eZ+M7oCEK57ldG
	 8hqrq+bvcw0fhN34we55bxPwJwBkd3cxGrn9zwl/6N2rkzEKTijF/r7vJukQEE8IYS
	 +IRHVbOXIjip+CtebVOy7yTqGOjoAw2WTdVOrGgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Yan Wang <wangyan122@huawei.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Gang He <ghe@suse.com>,
	Jun Piao <piaojun@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.10 02/73] ocfs2: fix BUG when iput after ocfs2_mknod fails
Date: Fri, 28 Oct 2022 14:02:59 +0200
Message-Id: <20221028120232.472090320@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221028120232.344548477@linuxfoundation.org>
References: <20221028120232.344548477@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Joseph Qi <joseph.qi@linux.alibaba.com>

commit 759a7c6126eef5635506453e9b9d55a6a3ac2084 upstream.

Commit b1529a41f777 "ocfs2: should reclaim the inode if
'__ocfs2_mknod_locked' returns an error" tried to reclaim the claimed
inode if __ocfs2_mknod_locked() fails later.  But this introduce a race,
the freed bit may be reused immediately by another thread, which will
update dinode, e.g.  i_generation.  Then iput this inode will lead to BUG:
inode->i_generation != le32_to_cpu(fe->i_generation)

We could make this inode as bad, but we did want to do operations like
wipe in some cases.  Since the claimed inode bit can only affect that an
dinode is missing and will return back after fsck, it seems not a big
problem.  So just leave it as is by revert the reclaim logic.

Link: https://lkml.kernel.org/r/20221017130227.234480-1-joseph.qi@linux.alibaba.com
Fixes: b1529a41f777 ("ocfs2: should reclaim the inode if '__ocfs2_mknod_locked' returns an error")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reported-by: Yan Wang <wangyan122@huawei.com>
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
 fs/ocfs2/namei.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -636,18 +636,9 @@ static int ocfs2_mknod_locked(struct ocf
 		return status;
 	}
 
-	status = __ocfs2_mknod_locked(dir, inode, dev, new_fe_bh,
+	return __ocfs2_mknod_locked(dir, inode, dev, new_fe_bh,
 				    parent_fe_bh, handle, inode_ac,
 				    fe_blkno, suballoc_loc, suballoc_bit);
-	if (status < 0) {
-		u64 bg_blkno = ocfs2_which_suballoc_group(fe_blkno, suballoc_bit);
-		int tmp = ocfs2_free_suballoc_bits(handle, inode_ac->ac_inode,
-				inode_ac->ac_bh, suballoc_bit, bg_blkno, 1);
-		if (tmp)
-			mlog_errno(tmp);
-	}
-
-	return status;
 }
 
 static int ocfs2_mkdir(struct inode *dir,


