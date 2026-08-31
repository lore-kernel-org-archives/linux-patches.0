Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3AF2483BCB;
	Mon, 31 Aug 2026 14:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788185025; cv=none; b=KlWVWFscnAAtXf3MQjbmp7vsNw8kxe6CZ0LbIzrj+xM+tjzEscjtrav3FjV9/igyCo+0okLC09x+pfe3Y90gBnfRbMdT7E4D9IdMqTZviUbXZbd9TlUXkMNYX0X27XSopjG1kFLbrhlhJfv36uljC0l+IKt479iG8wYs8Bjnxag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788185025; c=relaxed/simple;
	bh=ZurrrxuRpqo1NbDWQu/o0cT+1JFeBsVtZYjdpKmwaf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aDgyB/ueJ75AaBtGFDJUs4FudrzDprnJ0SXPAKS9syfkHQGbuqNZupXwX+t3MJzbuUq6rwWTmu18vbxXXDL5At1p/ecRF9VJx5zDpMSh+vWYDcQTnugg/mh7cpvor3mp52UfWNtFmkawn0XkS1+OHGuBw+7KAbM6V6F+trVASNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z+OtKsHI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z+OtKsHI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 091041F000E9;
	Mon, 31 Aug 2026 14:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788185024;
	bh=+O+nhQpH+i1vBz0u//E29k0vorVI71NPY0mHt+9vyzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z+OtKsHIByJ+0cykiPb/2Ntqd7x0VpJ+XNs32DpeH6C8Vv63e8rt1Sq/ZQO939TcH
	 Z4dySl/d05qh10nO3V8+BswY8tZDLgdR9xlNnPH5f+P5EUFSgI4wBatSGvSA4Md6V0
	 5ZgfXowa1YsJylxfPk7oXoGHUu/nTmnMJYBTr/KY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4e89b5368baba8324e07@syzkaller.appspotmail.com,
	Vasiliy Kovalev <kovalev@altlinux.org>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 06/69] jfs: add check read-only before truncation in jfs_truncate_nolock()
Date: Mon, 31 Aug 2026 15:34:39 +0200
Message-ID: <20260831133358.860866060@linuxfoundation.org>
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
index 6d6425cdb1185..84e79c7574032 100644
--- a/fs/jfs/inode.c
+++ b/fs/jfs/inode.c
@@ -386,7 +386,7 @@ void jfs_truncate_nolock(struct inode *ip, loff_t length)
 
 	ASSERT(length >= 0);
 
-	if (test_cflag(COMMIT_Nolink, ip)) {
+	if (test_cflag(COMMIT_Nolink, ip) || isReadOnly(ip)) {
 		xtTruncate(0, ip, length, COMMIT_WMAP);
 		return;
 	}
-- 
2.53.0



