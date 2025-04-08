Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18080268C72;
	Tue,  8 Apr 2025 11:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110557; cv=none; b=cpFyAvuk4OoLR9fHsxP+lOcc3s+iwodI9qk/QFahP1py6D/MCeXQwvTNs9gmTgNV3xgG0WmAdOsKROPofcNKPg/VI+NFzo6dFkPJgv5YA/LFm8Og8wn0fKaMPE01qmOuPLehVExQYYijRhlX5aqOr32DwPKAnPa3mCDxsxPLTfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110557; c=relaxed/simple;
	bh=ypaqfAc7QxR+ma4gdZO7aW00RGBqdOFcomfX5+TQjYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=drNrbyF8k6g4uVWAB35j9bxSA7ziNAf3mjJ5dG8n62vABfqszYMlfJTrQDopKT8ZMtfRmCLWSB31t4COSRYkC9j6PYOrpUCzcg6bHdLRpVS6Enrs1UaL0+N67Af45QMVDdRo8ZcTj5zPnkHXiBaRnjWV+vX8hhUacitVCPleRVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B1barimA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B1barimA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F9E9C4CEE5;
	Tue,  8 Apr 2025 11:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110557;
	bh=ypaqfAc7QxR+ma4gdZO7aW00RGBqdOFcomfX5+TQjYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B1barimAjCYaDIMCdM+I2jaWF27YMNFBIuTGS0qoXzFrG/7EwVltd3AAyDcVM0UVJ
	 KuCyDqNehfhWY8zQGjsBA1xTEQo+l29/NHdawvpbvIpwVC1St63VXn+eqPiWXX9obE
	 LYpawDOifX6J5NVUMB4sEJDo4kAuB0W+0xLniLFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4e89b5368baba8324e07@syzkaller.appspotmail.com,
	Vasiliy Kovalev <kovalev@altlinux.org>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 108/731] jfs: add check read-only before txBeginAnon() call
Date: Tue,  8 Apr 2025 12:40:05 +0200
Message-ID: <20250408104916.788925572@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
2.39.5



