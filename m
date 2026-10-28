Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216444;
	b=K5a83VFMDPb61dFJPALTKyZL6abM6xJSBnL3MLbINnhHKLTej+S7XDk2YePd+80h/bXi
	 y5LuDnJPmpJDovdj2OJtMePidFmVZ2Ljcgxv74OoD3AHLMLmM7jImXgFiauGt1IosMa6j
	 edUhUtpNPFY7P8+6yCRYX5hs1pDHaFTnnHqndC9U9f4A0qMDxQw4UGex40vSDTIT7Oxh6
	 B731MNNDGDUlSy8+yc0wB7+uuKOZ/FQ465aWkf99nv/f0ImjwdeC2fue4a25bPPaI2kV9
	 lQBc6WpHgrUbdL7yA1561y4t4uYvGEbiX2xT4FS0A+vw0mz7h57XO1xVcpbtX0KSgsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216444;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pN5yhx9w67ikaqvz2QB56v4m93ydtUvtisWTF2aV5KE=;
	b=11WTbtY8KyVAl8P1SM2jIMiLRyHvRy/a7OBvyAHrhAX2D4lXt6E+yaIWBl8Lzr97NHlW
	 /gcrhabYQ4ewU44+d5rzv/UcrcC3kZM9sRp5htox4IhkW4miJ6rm/yRo9tO9wH1Q0OODN
	 JuugKTynWKanN7dbxWDW0yieAfCvFTcDGEtclOapy1WQ4tQKFdUR8+1Q5zsKyce9hkf0C
	 8v81hpOal3PZm7u+iBjPncSVo3FVbM1A3As6uH2um8QdOVVv8OtY9a1b13RK5UWox8XKy
	 mFD70/KgldSYk9hXjk4mEBifdm/aPA2uBbO5ihl84W26ZSt+n12TBE1RxBgi6HMCluA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="zRoCF/5U";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DABA4606A31E;
	Wed, 28 Oct 2026 19:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zRoCF/5U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34AC21F01825;
	Wed, 28 Oct 2026 19:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216443;
	bh=pN5yhx9w67ikaqvz2QB56v4m93ydtUvtisWTF2aV5KE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zRoCF/5UCQXnGXQM9TYFqrcs4eGeh4R8vS7zyWoZ/VoQwB9eYAl6paCC/l5vjVZ3C
	 dOOXYHhM1dooGQ6WFa6tFdEdmnq8PStVHweAZRXXCmAhydv8bjJMiutUsxWyoShimz
	 ze6Xl6SNxEjewGYAlkmn49hUhv1NkOMLkOFa7QTw=
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
Subject: [PATCH 6.1 1551/1887] ocfs2: validate DIO orphan slot during inode read
Date: Wed, 28 Oct 2026 18:00:47 +0100
Message-ID: <20261028170534.762997541@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ed7b4be3ea7a5..8cd76357d3bf9 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1585,6 +1585,14 @@ int ocfs2_validate_inode_block(struct super_block *sb,
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
 	if (S_ISLNK(le16_to_cpu(di->i_mode)) &&
 	    !le32_to_cpu(di->i_clusters)) {
 		int max_inline = ocfs2_fast_symlink_chars(sb);
-- 
2.53.0



