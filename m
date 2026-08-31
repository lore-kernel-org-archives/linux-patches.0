Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9430557D21A;
	Mon, 31 Aug 2026 13:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184175; cv=none; b=GnG72FF4Y76laRf4j1X4G188FZuv2KrMHxehNOHufCx/IYMN7ubix4M9w3bet+JbERvF6t94Fkyq21qw1VLkb+Y7AbWrK+PN+NAkCYOA6ePfnj9CkmrOJpKY8PWdjE0PiuXlhG3N3BKaHJndGIFYuUjprPp4b+GAw0BbM7rgXyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184175; c=relaxed/simple;
	bh=PEXhMsSBFlyrwGnvR+ckfzz7fOqzPQsHbn65IWYhHLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=br2Kjca4osXcJQiqSrr/3fIUctKgrQQVA+eBQs5138KupjBLQVaGACyKHYDaL25oLTTRqp/h/yJVtXRh1LZ0vv9HgUi+Re0Qh72PDyE82K5ZuR4d81qFS5jE+BJsUazj+bs1A/dE4M9tW9UiRyMXImdMXjAB878N6Yzrh8hvKyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=frPWZrrI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="frPWZrrI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE4A61F00A3D;
	Mon, 31 Aug 2026 13:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184173;
	bh=JrTj5h4h/+tQuCm9IKPqEtXe9eG+e56b9XkVXFggF3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=frPWZrrID5mPq2RGHFk/EKQuv//dSATbmLfh1QTOWLsD7WOaqFTqGy3Kf6cMPoLdU
	 zeKva/YxGQq338SLbdy5gwK+2UVVddSiQOpabV8IzjxWz180KiDfFu+el9SFo6Js4h
	 UaXVjN6Spsum6PReFj0ZhiT1RnwsC4YBmhfDB3sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4e89b5368baba8324e07@syzkaller.appspotmail.com,
	Vasiliy Kovalev <kovalev@altlinux.org>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 16/99] jfs: add check read-only before truncation in jfs_truncate_nolock()
Date: Mon, 31 Aug 2026 15:33:45 +0200
Message-ID: <20260831133400.672270763@linuxfoundation.org>
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
index 8ee653aa07ced..cfc37b6789a29 100644
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



