Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 004734B714B;
	Mon, 31 Aug 2026 13:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184505; cv=none; b=Sf8lt+gBVAqjL5yks7vdj1Q5NkMi9kFWE2UDtb8QRKbDuIDBWbFJyU7IrsLSav1EuplGXIKP6Vy/YDI4TJGAvr4AqJmC5Ck0c7+khsHqFJwpSHPxgYiJhXqWn07W/v5oTTM7cYPuXYiTN0jdoA2bhAjKGMiZAddtJuBsAa14WCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184505; c=relaxed/simple;
	bh=cuptdUwNKW1335nuHu13mp2XadxpZvSqEtAnPUywc4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gO7u8Kgqz8gb7Sy5qqS78I62x07mZgIEqAwtlcJhDiDTtnHwI2YUc/9I5+Kf/6FdCWO2wJzA5BV0L8yLovoWfOvZ0PaRhCDk5+y9Ys2e+/+ix7VmY86Gvl45kDsdXcNPbMjdCWbFQPT2wKeRfJDZV39+TKYcPy9RDUHec58kSdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z+Wn1l3u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z+Wn1l3u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 172DE1F00A3D;
	Mon, 31 Aug 2026 13:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184502;
	bh=/j5nuDB7aqniKEdaMSpGGa0gDJfP3wENcZQhuZ5BRMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z+Wn1l3uEl5pvUHPje+KnK+G9d+hNVJ8r4GS/vRHG9r8m3C1+PYRqD4hl5yocdyGZ
	 bm6DwwRPQJNDl1c5a3glxdAhJXJuIpM7JtQZZl1G3l5nHNcFTn6e6uLf+B7hBWLQLr
	 V77CcWtPyxG3PObVOYg3XFngGzyHpC0Svf27d0HM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4e89b5368baba8324e07@syzkaller.appspotmail.com,
	Vasiliy Kovalev <kovalev@altlinux.org>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 09/91] jfs: add check read-only before truncation in jfs_truncate_nolock()
Date: Mon, 31 Aug 2026 15:33:57 +0200
Message-ID: <20260831133359.988823008@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.468089036@linuxfoundation.org>
References: <20260831133359.468089036@linuxfoundation.org>
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

From: Vasiliy Kovalev <kovalev@altlinux.org>

[ Upstream commit b5799dd77054c1ec49b0088b006c9908e256843b ]

Added a check for "read-only" mode in the `jfs_truncate_nolock`
function to avoid errors related to writing to a read-only
filesystem.

Call stack:

block_write_begin() {
  jfs_write_failed() {
    jfs_truncate() {
      jfs_truncate_nolock() {
        txEnd() {
          ...
          log = JFS_SBI(tblk->sb)->log;
          // (log == NULL)

If the `isReadOnly(ip)` condition is triggered in
`jfs_truncate_nolock`, the function execution will stop, and no
further data modification will occur. Instead, the `xtTruncate`
function will be called with the "COMMIT_WMAP" flag, preventing
modifications in "read-only" mode.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot+4e89b5368baba8324e07@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=4e89b5368baba8324e07
Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/jfs/inode.c b/fs/jfs/inode.c
index 1e6c1d1a15a6a..953b6cb6e89ed 100644
--- a/fs/jfs/inode.c
+++ b/fs/jfs/inode.c
@@ -375,7 +375,7 @@ void jfs_truncate_nolock(struct inode *ip, loff_t length)
 
 	ASSERT(length >= 0);
 
-	if (test_cflag(COMMIT_Nolink, ip)) {
+	if (test_cflag(COMMIT_Nolink, ip) || isReadOnly(ip)) {
 		xtTruncate(0, ip, length, COMMIT_WMAP);
 		return;
 	}
-- 
2.53.0



