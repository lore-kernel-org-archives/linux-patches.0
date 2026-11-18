Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034877;
	b=nZx+qye49EAhupN9GYKCYuJCvCj1D9Mzz0aQFA4cC8dKX7ZRxMAZC5yg5/74ThDP6Mo2
	 DQdSL9EtZnZy27m/tTMRLH7ZilCpEw4NfyATKAhcf8ZIvRk8/7wg4YEslzKinHSgUc2V+
	 rgyETKQCo96OfNb+3upwVs6IJWc4OppTSbiPe346fr86fOG6KNC3uUA1UDjtMXBtqR8GN
	 2RgN2KhvUGwIfysb8IBD8Jk8isiCTccWMYuG9+jeO7J+UqkiaRo1Y46bS9ASLspSNGCdO
	 mRmYeizSJeBM/StlcVCuLmRIEk3uBd4JV/knAya7oA8X7mCLbcF9dPX0r4R30DNE4jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034877;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dqnc1Je3/tGu2JWsat7Zd4ENXxjPGKQ5P4Ca/F7eN58=;
	b=gLM8rsXaREBUWwhAAULxsZIYkjk33+bGBxMl+neDRfq6RKtcwTGPket3WPZ76zXlwwlh
	 eAYpe2Ho8BcE/5hpN+9BVUDvMtjxgt0PTlV4ee/CDDiUPgEdluWoBz2Is75CAq0QPkXlV
	 9glrJEYI2QAg00Cc3onOpoImxdZog5IeiazNAQ4GyuzYCGKxY5cmE1FKJF9Zz6TAOZb32
	 +xBoGU5WzDYm3VE6m/J4xjRD296aXWkoAShBFoS/eZXBtD10ABRT0kyD9OawP15+Ontb0
	 Jrr/GVi6f4T3Alp7lv4RLoAhM8FdabHr3o6/kjDAp4PPCec892gMJNhKoQ2p9lUgrEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MaOj9eTl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B7AA606A320;
	Wed, 18 Nov 2026 20:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MaOj9eTl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88B961F000C4;
	Wed, 18 Nov 2026 20:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034877;
	bh=dqnc1Je3/tGu2JWsat7Zd4ENXxjPGKQ5P4Ca/F7eN58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MaOj9eTlrjPS1R6b3i04VBKf6fI5szOcvu2sOvC4sASOlbiF6OGxu0rU70igINfPY
	 BlIjatCYN1Jh0cdQvrJL3Vdg9tc6EvO/de01PPL3kUCI/0Ly5MIEliaQxmurip5wTj
	 cA26uxbUzngkQSIp1cshNT/Rs/E2a0b30j6e2JWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Christian Brauner <brauner@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0524/3318] smb: client: drain and invalidate before server-side copy/clone
Date: Wed, 18 Nov 2026 15:19:06 +0100
Message-ID: <20261118150332.915129609@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.org>

[ Upstream commit c9b1194e8ec99d95db25db45edd2fbf690f043ab ]

cifs_file_copychunk_range() and the clone (FICLONE) path of
cifs_remap_file_range() do not serialise the destination page cache
against the server-side copy the way the other server-side range
operations (smb3_zero_range(), smb3_punch_hole(), smb3_collapse_range()
and smb3_insert_range()) do.

cifs_file_copychunk_range() invalidates the destination range with
filemap_invalidate_inode(), which takes and drops the mapping's
invalidate_lock internally, so the lock is no longer held when the
copychunk ioctl is issued.  It also never drains in-flight netfs I/O on
the target.  The clone path never takes the invalidate_lock at all (only
i_rwsem), uses a bare truncate_inode_pages_range() and likewise does not
drain outstanding I/O.

As a result an asynchronous destination writeback can complete after the
server-side copy/clone has run and reinstate stale data over the region
just written by the server, corrupting the file.  This is the same class
of corruption as commit d7d2adcd022b ("smb/client: flush dirty data
before punching a hole") and has been seen randomly in generic/363
against Windows Server.

Fix both paths to follow the established ordering: hold the target
mapping's invalidate_lock across the flush and invalidation of the
destination and the server ioctl, and call netfs_wait_for_outstanding_io()
on the target to drain in-flight writes before the ioctl is issued.  Only
the target inode's invalidate_lock is required, as the source is merely
flushed and not invalidated; i_rwsem (already held via
lock_two_nondirectories()) is acquired before the invalidate_lock,
matching the VFS lock ordering.  Since filemap_invalidate_inode() takes
that same lock internally, replace it with its own unmap/flush/invalidate
steps instead of calling it, and return early on a zero-length copy to
avoid a range underflow.

Fixes: 8101d6e112e2 ("cifs: Fix copy offload to flush destination region")
Fixes: c54fc3a4f375 ("cifs: Fix flushing, invalidation and file size with FICLONE")
Reviewed-by: David Howells <dhowells@redhat.com>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
[ sashal: Kept the existing cifs_flush_folio()/truncate_inode_pages_range() flush path and dropped the netfs_wait_for_outstanding_io() call and open-coded invalidate block, since neither exists in this tree. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsfs.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index bb02e6ecd3c94..3154b21bfe8a2 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -1323,6 +1323,7 @@ static loff_t cifs_remap_file_range(struct file *src_file, loff_t off,
 	 * server could even support copy of range where source = target
 	 */
 	lock_two_nondirectories(target_inode, src_inode);
+	filemap_invalidate_lock(target_inode->i_mapping);
 
 	if (len == 0) {
 		loff_t src_size = i_size_read(src_inode);
@@ -1415,6 +1416,7 @@ static loff_t cifs_remap_file_range(struct file *src_file, loff_t off,
 	   that target is updated on the server */
 	CIFS_I(target_inode)->time = 0;
 unlock:
+	filemap_invalidate_unlock(target_inode->i_mapping);
 	/* although unlocking in the reverse order from locking is not
 	   strictly necessary here it is a little cleaner to be consistent */
 	unlock_two_nondirectories(src_inode, target_inode);
@@ -1438,6 +1440,9 @@ ssize_t cifs_file_copychunk_range(unsigned int xid,
 	unsigned long long destend, fstart, fend;
 	ssize_t rc;
 
+	if (len == 0)
+		return 0;
+
 	cifs_dbg(FYI, "copychunk range\n");
 
 	if (!src_file->private_data || !dst_file->private_data) {
@@ -1467,6 +1472,7 @@ ssize_t cifs_file_copychunk_range(unsigned int xid,
 	 * server could even support copy of range where source = target
 	 */
 	lock_two_nondirectories(target_inode, src_inode);
+	filemap_invalidate_lock(target_inode->i_mapping);
 
 	cifs_dbg(FYI, "about to flush pages\n");
 
@@ -1519,6 +1525,7 @@ ssize_t cifs_file_copychunk_range(unsigned int xid,
 	CIFS_I(target_inode)->time = 0;
 
 unlock:
+	filemap_invalidate_unlock(target_inode->i_mapping);
 	/* although unlocking in the reverse order from locking is not
 	 * strictly necessary here it is a little cleaner to be consistent
 	 */
-- 
2.53.0



