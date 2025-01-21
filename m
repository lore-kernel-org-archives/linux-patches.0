Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E99E185935;
	Tue, 21 Jan 2025 17:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482190; cv=none; b=QAHSDX2QIBfFfC5xkilSwG7MR7TJPICGnCl9zKMdcl1ZyeF8aX7gZg5+NnUu3edCDbuKy5QPrr2zRRc+ASckdLyEeMCtOOFIa/nh3Q+//dFOyg844LW2RwIczVQ1z6mBl4Z2iEh1nokUp9/sjDTxPmbGO9RJNagLKgUO2Gh2OWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482190; c=relaxed/simple;
	bh=gaXI52KyD0JZTUtOwW8lRcQSu/zKHs74tXY+TLqD1Pw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sln5UwWVznTSmBX2u2FowXu1yVhg3mjmFbL6HZYDbc9vo6S62Jrg8VSn/I9wQUR51Ehh/qjuphrOROMLElQ2QJrx+UDxpVcnOnMLKHpTBTH9INzfaPp+gVNaV7lHyksI1AoAzKDGEnLXsotfx5WiBVT6d1Lueac2GXIjwyIYcHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h16aiutY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h16aiutY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50DF1C4CEDF;
	Tue, 21 Jan 2025 17:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482189;
	bh=gaXI52KyD0JZTUtOwW8lRcQSu/zKHs74tXY+TLqD1Pw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h16aiutYSne+wRaErrUIPETJiATh3bEaBb7tbFIsV7HJ5WQUrt3C8oQHSa8Ky8JNE
	 wFElZXC+HvoxiSyxOZtr5EyTTIxGpHNuxeZ4m/QM61wZKY2YriE6HvftWZRBNZ5oWb
	 bNnzyc1sIf8QhcZS2NpCEXjge1LrU9FFS/sltD3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohammed Anees <pvmohammedanees2003@gmail.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	syzbot+e0055ea09f1f5e6fabdd@syzkaller.appspotmail.com,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Gang He <ghe@suse.com>,
	Jun Piao <piaojun@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Xingyu Li <xli399@ucr.edu>,
	Zheng Zhang <zzhan173@ucr.edu>
Subject: [PATCH 6.6 65/72] ocfs2: fix deadlock in ocfs2_get_system_file_inode
Date: Tue, 21 Jan 2025 18:52:31 +0100
Message-ID: <20250121174525.940188035@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174523.429119852@linuxfoundation.org>
References: <20250121174523.429119852@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mohammed Anees <pvmohammedanees2003@gmail.com>

commit 7bf1823e010e8db2fb649c790bd1b449a75f52d8 upstream.

syzbot has found a possible deadlock in ocfs2_get_system_file_inode [1].

The scenario is depicted here,

	CPU0					CPU1
lock(&ocfs2_file_ip_alloc_sem_key);
                               lock(&osb->system_file_mutex);
                               lock(&ocfs2_file_ip_alloc_sem_key);
lock(&osb->system_file_mutex);

The function calls which could lead to this are:

CPU0
ocfs2_mknod - lock(&ocfs2_file_ip_alloc_sem_key);
.
.
.
ocfs2_get_system_file_inode - lock(&osb->system_file_mutex);

CPU1 -
ocfs2_fill_super - lock(&osb->system_file_mutex);
.
.
.
ocfs2_read_virt_blocks - lock(&ocfs2_file_ip_alloc_sem_key);

This issue can be resolved by making the down_read -> down_read_try
in the ocfs2_read_virt_blocks.

[1] https://syzkaller.appspot.com/bug?extid=e0055ea09f1f5e6fabdd

Link: https://lkml.kernel.org/r/20240924093257.7181-1-pvmohammedanees2003@gmail.com
Signed-off-by: Mohammed Anees <pvmohammedanees2003@gmail.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reported-by: <syzbot+e0055ea09f1f5e6fabdd@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=e0055ea09f1f5e6fabdd
Tested-by: syzbot+e0055ea09f1f5e6fabdd@syzkaller.appspotmail.com
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc:  <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Xingyu Li <xli399@ucr.edu>
Cc: Zheng Zhang <zzhan173@ucr.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/extent_map.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/extent_map.c
+++ b/fs/ocfs2/extent_map.c
@@ -973,7 +973,13 @@ int ocfs2_read_virt_blocks(struct inode
 	}
 
 	while (done < nr) {
-		down_read(&OCFS2_I(inode)->ip_alloc_sem);
+		if (!down_read_trylock(&OCFS2_I(inode)->ip_alloc_sem)) {
+			rc = -EAGAIN;
+			mlog(ML_ERROR,
+				 "Inode #%llu ip_alloc_sem is temporarily unavailable\n",
+				 (unsigned long long)OCFS2_I(inode)->ip_blkno);
+			break;
+		}
 		rc = ocfs2_extent_map_get_blocks(inode, v_block + done,
 						 &p_block, &p_count, NULL);
 		up_read(&OCFS2_I(inode)->ip_alloc_sem);


