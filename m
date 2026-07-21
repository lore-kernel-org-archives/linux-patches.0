Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E4E743B48C;
	Tue, 21 Jul 2026 22:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674288; cv=none; b=CPnS2HP6JaMaPPoSa7+LFhE5G+r+s0LdlLZjythnXBJQWyv65TcmTxjzTKNwCPCHBl5daq4H1rgBe12s+On/m9xOWj4B8bN4VxA8JarYAPQ2ne8OBLVRcUWz+zIu1hlR/lMzTj2e7Y5Pp68895kIzBRwdvSl3SfsDzzO2BLDi0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674288; c=relaxed/simple;
	bh=zUeO54JuZTTeTq3+z0rnEnWwEqMImahPUCmq4bOhI4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NRH+1nm+7n0iCykJyYiTkDUQHyUSycfemRe4LCpnqrTd4lfr4FtGXtayMi7d7JVkszAulzmfaYIf6MqFvqtlgkaEjfBfPi6G0Yd4BhgBxb88dCFg1NyBiI6NidwkCIuBaq8voQtKz8KlJa6cx1yZUD3Yz/yMx2rjPjzVeRzDwX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nqZhvJ0x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nqZhvJ0x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8960E1F000E9;
	Tue, 21 Jul 2026 22:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674287;
	bh=MA1XuoCVgz7s4B1QRW87iErP7T5PWMrMRa1vgC/uVDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nqZhvJ0xm+I+MdDS2e1etmWdl8fr9tFS8eOvqa+TleMRBoX4jIoFdW9RAACca3NQ4
	 pTA83TAMEpyi/KxSNu+qpb9Mly8juptM7zwiop/jKZPIOiS55u4zcDLML1QYCxWIYk
	 1CIdA/7+cqB7G8srrQUaH3K+B4W7mDejkfCocoOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7ea0b96c4ddb49fd1a70@syzkaller.appspotmail.com,
	Tristan Madani <tristan@talencesecurity.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.10 483/699] ocfs2: use kzalloc for quota recovery bitmap allocation
Date: Tue, 21 Jul 2026 17:24:02 +0200
Message-ID: <20260721152406.596965621@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tristan Madani <tristan@talencesecurity.com>

commit 93c8c6ea90be9e9df8fe14048ad4e3caad0770a6 upstream.

ocfs2 quota recovery allocates a bitmap buffer with kmalloc and does not
fully initialize it.  This can lead to use of uninitialized bits during
quota recovery from a corrupted filesystem image.

Use kzalloc instead to ensure the bitmap is zero-initialized.

Link: https://lore.kernel.org/20260418131048.1052507-1-tristmd@gmail.com
Reported-by: syzbot+7ea0b96c4ddb49fd1a70@syzkaller.appspotmail.com
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/quota_local.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -302,7 +302,7 @@ static int ocfs2_add_recovery_chunk(stru
 	if (!rc)
 		return -ENOMEM;
 	rc->rc_chunk = chunk;
-	rc->rc_bitmap = kmalloc(sb->s_blocksize, GFP_NOFS);
+	rc->rc_bitmap = kzalloc(sb->s_blocksize, GFP_NOFS);
 	if (!rc->rc_bitmap) {
 		kfree(rc);
 		return -ENOMEM;


