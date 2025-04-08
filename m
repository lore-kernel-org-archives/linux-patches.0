Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0DF0214205;
	Tue,  8 Apr 2025 11:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110559; cv=none; b=i9n3GdBemrTqm4XvW+jKFz6ICwKtESrPYerXXjKEpLGjhDkY3dyRCbNMN2+gGrSTREp9VA4z1hh5emfi5s0I/0L027zvcV1+3RW0Uw8pcXJzXJcG35o8UGbmoWaGwj2iQRHQ58DvuyTKMXQlBrGc470NOju+3Vysy9jVFHxuvNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110559; c=relaxed/simple;
	bh=GT6PMqI10ZHrr7Kh5w+z4kP8bw9NnrDplK20uCXzlTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c0KSQxz7guKZJ6SX9vOxH0tpDETaCdPK5w5Xjwo3dzKpQv7rm2tHArhX7J90mdjjjMH0XdkZyCWsXoLPVL/s7smF1ItlSFKCGDbFVIdzn68jqxLFSYsA+4ddeG3RSSzOkaHzRgOw81N1vKXp2slC4U71T5wU14Gnt2vD2p8LvvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yP2WCyqd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yP2WCyqd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50C66C4CEE5;
	Tue,  8 Apr 2025 11:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110559;
	bh=GT6PMqI10ZHrr7Kh5w+z4kP8bw9NnrDplK20uCXzlTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yP2WCyqdKostQeXAZ6WcKric34zBlSAwUerjPURTYsH9TPrVFOnMS13XMCturQwny
	 lSvKmiRMSJiCIUQyQWbv8MCy2ZVWT3h+8DxoJmwNwDqoONgzVO9GyDbUvF00JWrDNX
	 qfWGGjxNCZwoDlxXBbo4JKuoBCrkKBRJBr7IY7os=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4e89b5368baba8324e07@syzkaller.appspotmail.com,
	Vasiliy Kovalev <kovalev@altlinux.org>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 109/731] jfs: add check read-only before truncation in jfs_truncate_nolock()
Date: Tue,  8 Apr 2025 12:40:06 +0200
Message-ID: <20250408104916.812882931@linuxfoundation.org>
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
index 07cfdc4405968..60fc92dee24d2 100644
--- a/fs/jfs/inode.c
+++ b/fs/jfs/inode.c
@@ -369,7 +369,7 @@ void jfs_truncate_nolock(struct inode *ip, loff_t length)
 
 	ASSERT(length >= 0);
 
-	if (test_cflag(COMMIT_Nolink, ip)) {
+	if (test_cflag(COMMIT_Nolink, ip) || isReadOnly(ip)) {
 		xtTruncate(0, ip, length, COMMIT_WMAP);
 		return;
 	}
-- 
2.39.5



