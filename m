Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 611D7456DE1;
	Sat, 12 Sep 2026 11:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211183; cv=none; b=UUmP71fqK68vpQvmbqzIY70Akk2ObReUDxukbj0gQAUvN+hWgx9p7h9lBYj32wVyLEzh0BivUCPx4EU5rlwTnNxkzVV/pmsm/c/XPQEHnHoqN3nO/MRTQjyMZNUaHTdSNTcrnAcq9UzoWpTKqHhe+qa+S+6CnE9i+t9ixgR4YCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211183; c=relaxed/simple;
	bh=RTJQNq23HuFRoqcK8j26/kvXvZCMg6FQ9jy9nIapJqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xf9rFtNr/ZtO0qhX1cCWeqLEe3ocMsCMQJ4VDB4Eu2g2EuXlDf2qDbCm7yxPYl+eFVwvFs8MSU/ltgqmEUcBIU2DF+09kw8ll2gFqdfDmgNW+hTnr6ebmqfzN3hE3BZuy8/as3gtHGL4tdyjwG4DWh/O7MkiPeetbapBXqF31HE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PtQCJ/Oh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PtQCJ/Oh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AA881F000FF;
	Sat, 12 Sep 2026 11:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211182;
	bh=TM4B70Pi22Pf1L8/XWExhpp6qOYZ9p4vhyE6dg7Mu8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PtQCJ/OhrdSSmH3ES6QXSQuLz+i1+qT3iqMy7InAno/IZYdz8ZgoAK99aJz3RAb5v
	 J9eX89BHdMX6i3s6n7UmBY4pzmxrGVqMUrxiIZLhLp6CZpjvBfJZm/3VXGC8KiZIYM
	 pVwpLe/+urVssClVqM7XghFDfxQ2jn1qoWpFIOfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhengYuan Huang <gality369@gmail.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1177/1518] ocfs2: validate orphan slot during inode read
Date: Sat, 12 Sep 2026 08:55:46 +0200
Message-ID: <20260912065650.101335404@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ZhengYuan Huang <gality369@gmail.com>

[ Upstream commit b2d31acbd3b182755b019183fb46949ba5e39b9f ]

Patch series "ocfs2: validate active orphan slots during inode read".

OCFS2 trusts active ordinary and append-DIO orphan slots read from dinodes.
A corrupted slot can therefore index osb_orphan_wipes or the slot-local
system-inode cache outside their allocations before the corruption is
reported.

Patch 1 validates the ordinary orphan slot used by inode wipe processing.
Patch 2 validates the append-DIO orphan slot used by DIO completion and
orphan recovery.  Both checks reject corrupt metadata at the existing inode
validation boundary.

This patch (of 2):

[BUG]
A corrupted dinode with OCFS2_ORPHANED_FL can carry an
i_orphaned_slot outside the mounted filesystem slot range.
ocfs2_wipe_inode() uses it to index osb_orphan_wipes before looking
up the orphan directory, causing an out-of-bounds memory access.

BUG: KASAN: slab-use-after-free in ocfs2_get_system_file_inode+0x780/0x820 fs/ocfs2/sysfile.c:102
Read of size 8 at addr ffff88800b767c00 by task kworker/u8:3/85
Call Trace:
 ...
 ocfs2_get_system_file_inode+0x780/0x820 fs/ocfs2/sysfile.c:102
 ocfs2_wipe_inode+0x292/0xf70 fs/ocfs2/inode.c:840
 ocfs2_delete_inode fs/ocfs2/inode.c:1155 [inline]
 ocfs2_evict_inode+0x6c9/0x1170 fs/ocfs2/inode.c:1295
 evict+0x38e/0x8f0 fs/inode.c:810
 iput_final fs/inode.c:1914 [inline]
 iput fs/inode.c:1966 [inline]
 iput+0x55b/0x8b0 fs/inode.c:1926
 ocfs2_recover_orphans+0x610/0xe40 fs/ocfs2/journal.c:2374
 ocfs2_complete_recovery+0x5af/0xd00 fs/ocfs2/journal.c:1373
 ...

[CAUSE]
ocfs2_validate_inode_block() validates i_suballoc_slot but leaves
the active ordinary orphan slot unchecked. Downstream consumers
assume that the value is smaller than osb->max_slots.

[FIX]
Reject an active i_orphaned_slot outside the slot range during
dinode validation, before the inode reaches orphan wipe processing.

Link: https://lore.kernel.org/20260803030007.3993199-1-gality369@gmail.com
Link: https://lore.kernel.org/20260803030007.3993199-2-gality369@gmail.com
Fixes: b4df6ed8db0c ("[PATCH] ocfs2: fix orphan recovery deadlock")
Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/inode.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index d247d69349e4a..a33de57f31618 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1538,6 +1538,14 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
+	if ((le32_to_cpu(di->i_flags) & OCFS2_ORPHANED_FL) &&
+	    le16_to_cpu(di->i_orphaned_slot) >= OCFS2_SB(sb)->max_slots) {
+		rc = ocfs2_error(sb, "Invalid dinode %llu: orphaned slot %u\n",
+				 (unsigned long long)bh->b_blocknr,
+				 le16_to_cpu(di->i_orphaned_slot));
+		goto bail;
+	}
+
 	/*
 	 * Reject dinodes whose i_mode does not name one of the seven
 	 * canonical POSIX file types.  ocfs2_populate_inode() copies
-- 
2.53.0



