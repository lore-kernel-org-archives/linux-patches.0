Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C003B2FCA;
	Sat, 17 Oct 2026 18:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260047; cv=none; b=cWvM/5a4fuLW05fZYxVI9UZLmsfHZxgFNHcYQ42qFSHx55vqwST2dvvQe9tlhxnpPToGRMlN7H7ROf4i7fllUyIbHYFG/aDEUXQJDU8jW2NQRmitDnf9GtCuOLRSybn7HgOCEO24viF0Trj5e7Sz+uXOeOFiMaKnaTrvVSKLsAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260047; c=relaxed/simple;
	bh=Bogc00yqWlL2wdL6z2rHkpFAKb481eFAG4V/sF3EFYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ctq2ChR7z1C1AaYoz+PZgI0z/5y8Nf7B74jAj51NMOuRf+xECOkcDl7fRHFGk9+LLwA9lLO1pcaRQL4227tV6zsS+y2dZGcKhxF92M5/wCM3XYy9Z8R0W+ADQuZBN4heJUgAg+w3e1NU2wFhKVSMDEcmPOhLk67jFerzSOUfBAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dMtQrLRr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dMtQrLRr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFB6B1F000C4;
	Sat, 17 Oct 2026 18:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260046;
	bh=YSw6xkZeFxtFryWvDbjADz2jYVqQu4XRraQe+WHq/8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dMtQrLRrSc01Y8uRylOvN3gi/LbpGUg8D2CdCwDTZtqN1+GUZ+ssATssPuJ7nK6h9
	 351Nfnp84FmOr8iKqBopxMs/J7PPVMXHNQrggotHUDYPOWoGk0iZbVzxxlHJPFSxkp
	 fNn1UL/G3tgZKooHg0h+m0yHduCotWQAIdy+Vv1Q=
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
Subject: [PATCH 6.6 1408/1674] ocfs2: validate DIO orphan slot during inode read
Date: Sat, 17 Oct 2026 18:01:20 +0200
Message-ID: <20261017160507.320754090@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ZhengYuan Huang <gality369@gmail.com>

[ Upstream commit bb88131c9831075b8dc08cdd375743e5d44c7ca2 ]

[BUG]
A corrupted append-DIO dinode (high byte at offset 0xa1
corrupted from 0 to 1) can carry an i_dio_orphaned_slot
outside the mounted filesystem slot range and trigger a
use-after-free error:

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
ocfs2_del_inode_from_orphan() uses i_dio_orphaned_slot to index the
slot-local system inode cache. The dinode validator does not check
this active slot, so an out-of-range value produces an invalid cache
entry pointer that is dereferenced as an inode pointer.

[FIX]
Reject an active i_dio_orphaned_slot outside the slot range during
dinode validation, before DIO orphan recovery can consume it.

Link: https://lore.kernel.org/20260803030007.3993199-3-gality369@gmail.com
Fixes: 06ee5c75b575 ("ocfs2: add functions to add and remove inode in orphan dir")
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
index d0f58966d6339..6647faa04438b 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1466,6 +1466,14 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
+	if ((le32_to_cpu(di->i_flags) & OCFS2_DIO_ORPHANED_FL) &&
+	    le16_to_cpu(di->i_dio_orphaned_slot) >= OCFS2_SB(sb)->max_slots) {
+		rc = ocfs2_error(sb, "Invalid dinode %llu: DIO orphaned slot %u\n",
+				 (unsigned long long)bh->b_blocknr,
+				 le16_to_cpu(di->i_dio_orphaned_slot));
+		goto bail;
+	}
+
 	/*
 	 * Reject dinodes whose i_mode does not name one of the seven
 	 * canonical POSIX file types.  ocfs2_populate_inode() copies
-- 
2.53.0



