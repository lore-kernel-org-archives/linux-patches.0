Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6B657C726;
	Mon, 31 Aug 2026 13:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184178; cv=none; b=SJ+HayGohRvtpwUoXVFd4L4vsqXZX74vGaYZoOpsRJwUmmOBeto3qDdnXLAhITOHpJ9j16BxVpmXhgj+QlQ/g652SmDHCazBXQXji3/ERe9Kx/OEOYm/3Z//qCZNkEhjVhmLqjZ6i1MY95CZc2+LXVTI/JaGCH6ptgVdAywFujs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184178; c=relaxed/simple;
	bh=OkGoHYDLVSRX4snqQGogXfkNq/5wvFJ2Oyu1MjLs9vY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MBKHsV+abFixbhDT/0iNNrlSTwbCryqf9wGVdZXLRVQKxorhIc18voRTYITkQq381UMDKlmLuDokEw1aXmmcIlvBk1hFPtuTDWNuB0Z5EPW9iUridA7rYzQudp4eTvOb6/fU8W6OXbT/Y35P1q60G//KDS0i5Ir7p0B6wZl0cO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VTZ2lNxe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VTZ2lNxe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB3491F000E9;
	Mon, 31 Aug 2026 13:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184176;
	bh=V3emr1EN3Br7QZtRcuXrgJOba/und/m5mpFzjd0kTrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VTZ2lNxeKO+4nq3m5MZynljVXE8IExL7H2eBGz+50UvUg9593NkII85uEcLM3MLwA
	 QkGoZKXEmo7BHhtC2hzCAvQo1zYFPAu4mpgIOy/XjDQqY22j/SMNCKMwMeZY1pH/QQ
	 hB6r9d78o9/+qkEkwsNwWcq+1+QEWUrkQeUtTLb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4e89b5368baba8324e07@syzkaller.appspotmail.com,
	Vasiliy Kovalev <kovalev@altlinux.org>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 17/99] jfs: add check read-only before txBeginAnon() call
Date: Mon, 31 Aug 2026 15:33:46 +0200
Message-ID: <20260831133400.719857821@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.740409777@linuxfoundation.org>
References: <20260831133359.740409777@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 63d21822d309b..46529bcc8297e 100644
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



