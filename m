Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F745417BE9;
	Mon, 31 Aug 2026 13:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184712; cv=none; b=eXUczSX/jCMiXqf8gxWQCBv6d9oXARaRHF68xmjO3LRqwdzUToXEnZcuTZPxvtwvATynYb5wEKWckI76G6ZOBpq9sP4UXqqTl7VEwAs0iV/qqOkzxeAV8IEnkC7Udf1ZaLqr1Vwu42GB21rMnbylCSv/ECCwRYNz5iUdECkDC+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184712; c=relaxed/simple;
	bh=xqMs2of7Z8heKqSgTZm0zmcsoZzNcpAc5fJW6ioI59Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BCcj3v5y69kvtAQzBbgl7e0yQaZuIBkt7jdR1qu2ighiHnxxnIG8CPbOUG0f0dclSmTcR1vgi8vOpjlRIQ+vKvPtp2lBrXEzrEe70zXs/3fGpQGskaeleGuPLWYodAgCll+FawqBoYMAy3SE7n5btkDf4FAzTyjJLwyXN2CutWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hnOKGB06; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hnOKGB06"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9E981F000E9;
	Mon, 31 Aug 2026 13:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184711;
	bh=VFh71lTkeWhmb7zpCJvWuUKP/i0ReJLV/c3smC9jPlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hnOKGB06FzrFiI9fkpugNIdTAl8M2IHKsks1bUUfsHH0hTxpexyll1wfN4t+I/iia
	 islmUW6CN/cIuhMpri92yg6ArsPrIAVJS+pjYLH/tOzonYJ4jiKznkrsiKm4igcmo8
	 ozmuW4qR7NHMhhPt81mrVDWaW+54Q72euJFSqMSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4e89b5368baba8324e07@syzkaller.appspotmail.com,
	Vasiliy Kovalev <kovalev@altlinux.org>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 12/92] jfs: add check read-only before txBeginAnon() call
Date: Mon, 31 Aug 2026 15:34:10 +0200
Message-ID: <20260831133400.132427168@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.482388899@linuxfoundation.org>
References: <20260831133359.482388899@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasiliy Kovalev <kovalev@altlinux.org>

[ Upstream commit 0176e69743ecc02961f2ae1ea42439cd2bf9ed58 ]

Added a read-only check before calling `txBeginAnon` in `extAlloc`
and `extRecord`. This prevents modification attempts on a read-only
mounted filesystem, avoiding potential errors or crashes.

Call trace:
 txBeginAnon+0xac/0x154
 extAlloc+0xe8/0xdec fs/jfs/jfs_extent.c:78
 jfs_get_block+0x340/0xb98 fs/jfs/inode.c:248
 __block_write_begin_int+0x580/0x166c fs/buffer.c:2128
 __block_write_begin fs/buffer.c:2177 [inline]
 block_write_begin+0x98/0x11c fs/buffer.c:2236
 jfs_write_begin+0x44/0x88 fs/jfs/inode.c:299

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot+4e89b5368baba8324e07@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=4e89b5368baba8324e07
Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/jfs_extent.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/jfs/jfs_extent.c b/fs/jfs/jfs_extent.c
index a82751e6c47f9..12bd89b5bd0c3 100644
--- a/fs/jfs/jfs_extent.c
+++ b/fs/jfs/jfs_extent.c
@@ -74,6 +74,11 @@ extAlloc(struct inode *ip, s64 xlen, s64 pno, xad_t * xp, bool abnr)
 	int rc;
 	int xflag;
 
+	if (isReadOnly(ip)) {
+		jfs_error(ip->i_sb, "read-only filesystem\n");
+		return -EIO;
+	}
+
 	/* This blocks if we are low on resources */
 	txBeginAnon(ip->i_sb);
 
@@ -253,6 +258,11 @@ int extRecord(struct inode *ip, xad_t * xp)
 {
 	int rc;
 
+	if (isReadOnly(ip)) {
+		jfs_error(ip->i_sb, "read-only filesystem\n");
+		return -EIO;
+	}
+
 	txBeginAnon(ip->i_sb);
 
 	mutex_lock(&JFS_IP(ip)->commit_mutex);
-- 
2.53.0



