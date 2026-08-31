Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9225F47CC92;
	Mon, 31 Aug 2026 13:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184709; cv=none; b=emAYKDJBCbt/vHBvT+FlZVHQR/i+l4Z5VrqNzu99PQW/FJ1smx1XEoksUR6/MivuO+xoojcy+cFaMj6Fk2uNo/cVVCw/XIcpCoIxvqYO+Rko++7aHRcXJNecI2OLB5DXvTE68mNr2tlYvTS8xxHfLBF+P5g85IVkx475Zxd6OYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184709; c=relaxed/simple;
	bh=HELCzQA/+hArUpB+m9ltojwBalWv8K3zxFFUA0SYfdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oDXNykhJ4MAv65TffB/nTYExg3rMjbUAUOanO2I4eL5fFshsNeO8sUqVAoXhe0QzdVD4icSY45LHVBeQfWtap/ZD1Ipox3dXMYx9ZRwaE7vVg6TLgO3iAYEmerBPEwzkHihMyoWf0wxh+cPPDZeSeMJGPLwCaxxmVCGAXM+9gk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C4dd0z7M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C4dd0z7M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB79A1F000E9;
	Mon, 31 Aug 2026 13:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184708;
	bh=vN2iG8XckaauieEd09RZCqVIlMkbw9hrOn73Won+jK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C4dd0z7MkeWGd051aIlPpD2Fpu9fMlejrf/YiGL5VVrRzKVzNZwrxnDdi86f+d2SA
	 FTCOKq28lLwdsko65FDJ5ZqW/1MKGdKHx6mhe+6QVt6gME3FmA7Ukm0HCfHGyMk2Zu
	 JJ6Kg3BwrtHsz8gRO8tCStzs2AnMZss+/uCeLrFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4e89b5368baba8324e07@syzkaller.appspotmail.com,
	Vasiliy Kovalev <kovalev@altlinux.org>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 11/92] jfs: add check read-only before truncation in jfs_truncate_nolock()
Date: Mon, 31 Aug 2026 15:34:09 +0200
Message-ID: <20260831133400.081431366@linuxfoundation.org>
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
index 1262b3602cdaf..11e2141acda78 100644
--- a/fs/jfs/inode.c
+++ b/fs/jfs/inode.c
@@ -380,7 +380,7 @@ void jfs_truncate_nolock(struct inode *ip, loff_t length)
 
 	ASSERT(length >= 0);
 
-	if (test_cflag(COMMIT_Nolink, ip)) {
+	if (test_cflag(COMMIT_Nolink, ip) || isReadOnly(ip)) {
 		xtTruncate(0, ip, length, COMMIT_WMAP);
 		return;
 	}
-- 
2.53.0



