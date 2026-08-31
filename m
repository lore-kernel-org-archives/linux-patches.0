Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2742E4908D9;
	Mon, 31 Aug 2026 14:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788185264; cv=none; b=iU1KCN5bK2HYxMriLAuWG0JCKh6gsaQqXs9j68R/UIFzhOKUpS5T3nDR01JPhymWhRD9lautMxKEEnJxe+zB8oalo8eqCaKXrb+wnc2qbB6mWEU+IPmwXXwYTZjq9O3c/A2f8D4rL3pTAf8hdMAgr1mDCr50JFDzCk6PFGbNtFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788185264; c=relaxed/simple;
	bh=qVzVUzhQXDpjC3vo0sq3GAt7f5RDtF0v9UvlMTQ/dHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YsCa9s5GDbF01Efkps44qB3X3oDqDlDQB77b8tbpNaETetHCXOrdsAkNO+opm1Y+iWAh3KQph5tQZ6eOrNGNMlMYhkM+C4UTTzMI4hok7u20PLAiX2KyCoFvbZ9Ji+DBDSaiw1WgeuwbxqIkaSxQCQm2BLxW5+kFJNB2hNAwRKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yMZYlOxc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yMZYlOxc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FEB01F000E9;
	Mon, 31 Aug 2026 14:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788185263;
	bh=bJff/SEO/YpxVGIOkAZ+qsc0+ZWEWVcbQwIfew2HWgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yMZYlOxcWBQ4UDvlr87Tu8UoI8UGGDTf/7II6HmHnizCxPMR0fnMH/Xx289ANewv3
	 qoliduIMhGFnn0vxdpPmqFKdNk6ts/2dm6zTGhjn4p/km0Qv3dQFwEBujx4xpNj0pW
	 DS4qllFjsBhZyvxTmfJq5x6YqtiPYaGndcr+oxpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4e89b5368baba8324e07@syzkaller.appspotmail.com,
	Vasiliy Kovalev <kovalev@altlinux.org>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 08/43] jfs: add check read-only before txBeginAnon() call
Date: Mon, 31 Aug 2026 15:35:16 +0200
Message-ID: <20260831133358.908445995@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133358.571886287@linuxfoundation.org>
References: <20260831133358.571886287@linuxfoundation.org>
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
index d4e063dbb9a0b..d695157df567d 100644
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



