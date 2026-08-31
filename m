Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0F14BA9F5;
	Mon, 31 Aug 2026 14:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788185028; cv=none; b=kZ92qNwcBjypsEkrRUbAEKmUabHIbPNN42uKorB647GOg6kOIt2Pms0OuTpQCspie4SLNmf6yuEEGuS6k8duNDcV4PIodN0kuFA7zc3Q03OHzPD/KwB9M3r1Pw+EDVxKZOfia5aLpm1Kzh+uFNtWQ3j3jLjFJrFqpYhyrufZG4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788185028; c=relaxed/simple;
	bh=maYFLw8MTwQDP2ouCslACuBw/WflbsWZyu1pRoyhjXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SZ2JxlpL89Zr6bkz7lkczBrK6GfdPfHO+BGyWrWkMWLIe3yy/rmODsKXEyp2GFFSskZHtGkYuN0K/KLTpubG8RXLZO44oTIw7CIalrXrQHSBIB6TjAlAo2KSY9ghWaIpQelLAtrztY0QpiehbvH1bQ+bvhOt3QhbL7r0iG7KLiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GNW4M8y2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GNW4M8y2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D949C1F00A3E;
	Mon, 31 Aug 2026 14:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788185027;
	bh=aBBzDaQazA9unkEaLcdYBGIurhuREmpRewsPLv4lioI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GNW4M8y2BUZJazHZtl3MomjecOtoFNrVdFofMOcgvW4y1sAZPgBQBA4ADtnFSfKZz
	 6zzgiG7BIOZhb3ZPUM27qSznqrnzdzOVSPFHcphpRveWEKKkV2r/p3okAOkglIhx8V
	 zYhOzDQPFdV/lk7siDCnu66+j/13kHi8zxp+yg7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4e89b5368baba8324e07@syzkaller.appspotmail.com,
	Vasiliy Kovalev <kovalev@altlinux.org>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 07/69] jfs: add check read-only before txBeginAnon() call
Date: Mon, 31 Aug 2026 15:34:40 +0200
Message-ID: <20260831133358.905442121@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133358.601894154@linuxfoundation.org>
References: <20260831133358.601894154@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6420b6749d48f..25b5a866ee18e 100644
--- a/fs/jfs/jfs_extent.c
+++ b/fs/jfs/jfs_extent.c
@@ -77,6 +77,11 @@ extAlloc(struct inode *ip, s64 xlen, s64 pno, xad_t * xp, bool abnr)
 	int rc;
 	int xflag;
 
+	if (isReadOnly(ip)) {
+		jfs_error(ip->i_sb, "read-only filesystem\n");
+		return -EIO;
+	}
+
 	/* This blocks if we are low on resources */
 	txBeginAnon(ip->i_sb);
 
@@ -412,6 +417,11 @@ int extRecord(struct inode *ip, xad_t * xp)
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



