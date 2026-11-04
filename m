Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831274;
	b=t92EFLkNwXBEs6WwVhoIdgmte6MGI++gtisjOSbPYqWJrBpZyWQYxZ/nAx3D40DLcF4W
	 cH6gE0sVXSC1bN1M9a6nMzMppNiF8LgXIu7+rxUI3o7Sm8erNSAT5BKjDtLaqbWNrly6B
	 L4bLVSGd9eRvqanglOb0DIItT/QwDLIzgwsoNBhwT3knRq2TkO7NnKWqtcvBj4hdis1q7
	 HU/JHBWkUZ58Cc1BORtoH9HTyXRpgVcnHpkFl6rUbMwRGfDDPyq/vsYL155zLX2o7FnnD
	 dc9oJxF4w/q2y7ZJosfKcqFjJHAZ9LXEJ+6S0XnVC5rAbiESHXqJR3xxd18n1eAC/3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831274;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NNXYIYRsT+W566tBjg4Zxq8cZmZtyIMUZTTjScVZdeA=;
	b=Plr0Zyg1rv81E4JHva9KmvVt5Zz47ojrxMabcFYK9IcDK12+q+5t0VfKbDcVKCYlpQvh
	 5dsjUT+jnK6/kASl3U7lM3wVO95hl1vziWnXYBaxlG2msNliXQf9mdH1vI0Bq6gF5skMl
	 QBCQEvfiqTaXu0dNuc4d6qvK44Cpo1Kx8vV0PJpwxh9TPMfk44w/uMBm8Of22D8cxVsKj
	 zg1V5lb+DguKI7ASfqlIpeTiQYezI1P+VULgas35tgTqcTzZ1jGR/a6q10xEHH/gz0/j+
	 chGCZktjQTKGQMwyi+CRWTkArcrVBb9koNHXDQ0b0NaUqC+SM8KOQ92Yb45xdSjyulQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bu6RS8cO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFEA4606A329;
	Wed,  4 Nov 2026 22:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bu6RS8cO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62B171F000C1;
	Wed,  4 Nov 2026 22:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831273;
	bh=NNXYIYRsT+W566tBjg4Zxq8cZmZtyIMUZTTjScVZdeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bu6RS8cOukImxWfrOkau9rvMkiz1mU88H4fSNYMaVbobLLhyvO6jSYh65AMuUJe4l
	 i4zDw9unmU0o+9/N9W1844uxiOx37onxRZlGkC2fc1F8U+af5W00TCP/WTmbcRtIVW
	 hT7ZoG30CZVRUfD83oJoL/1DIt9JcLh2oVoW+Um0=
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
Subject: [PATCH 6.18 0606/1005] smb: client: drain and invalidate before server-side copy/clone
Date: Wed,  4 Nov 2026 16:05:39 -0500
Message-ID: <20261104211100.824828437@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adjusted context in cifs_remap_file_range() because the local i_size variable is absent, so the new netfs_wait_for_outstanding_io() call follows the truncate_inode_pages_range() call that uses i_size_read(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsfs.c | 31 ++++++++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 73a749d949f7e..23ec5c3666d3d 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -1377,6 +1377,7 @@ static loff_t cifs_remap_file_range(struct file *src_file, loff_t off,
 	 * server could even support copy of range where source = target
 	 */
 	lock_two_nondirectories(target_inode, src_inode);
+	filemap_invalidate_lock(target_inode->i_mapping);
 
 	if (len == 0) {
 		loff_t src_size = i_size_read(src_inode);
@@ -1439,6 +1440,7 @@ static loff_t cifs_remap_file_range(struct file *src_file, loff_t off,
 				   min(fstart,
 				       (unsigned long long)i_size_read(target_inode)),
 				   fend);
+	netfs_wait_for_outstanding_io(target_inode);
 
 	fscache_invalidate(cifs_inode_cookie(target_inode), NULL,
 			   i_size_read(target_inode), 0);
@@ -1478,6 +1480,7 @@ static loff_t cifs_remap_file_range(struct file *src_file, loff_t off,
 	if (rc)
 		CIFS_I(target_inode)->time = 0;
 unlock:
+	filemap_invalidate_unlock(target_inode->i_mapping);
 	/* although unlocking in the reverse order from locking is not
 	   strictly necessary here it is a little cleaner to be consistent */
 	unlock_two_nondirectories(src_inode, target_inode);
@@ -1501,6 +1504,9 @@ ssize_t cifs_file_copychunk_range(unsigned int xid,
 	struct cifs_tcon *target_tcon;
 	ssize_t rc;
 
+	if (len == 0)
+		return 0;
+
 	cifs_dbg(FYI, "copychunk range\n");
 
 	if (!src_file->private_data || !dst_file->private_data) {
@@ -1530,6 +1536,7 @@ ssize_t cifs_file_copychunk_range(unsigned int xid,
 	 * server could even support copy of range where source = target
 	 */
 	lock_two_nondirectories(target_inode, src_inode);
+	filemap_invalidate_lock(target_inode->i_mapping);
 
 	cifs_dbg(FYI, "about to flush pages\n");
 
@@ -1555,11 +1562,24 @@ ssize_t cifs_file_copychunk_range(unsigned int xid,
 	 * Start at the old EOF when extending so the folio straddling it, which
 	 * may hold data written past EOF through an mmap, is dropped too.
 	 */
-	rc = filemap_invalidate_inode(target_inode, true,
-				      min(destoff, i_size_read(target_inode)),
-				      destoff + len - 1);
-	if (rc)
-		goto unlock;
+	if (target_inode->i_mapping->nrpages) {
+		loff_t fstart = min(destoff, i_size_read(target_inode));
+		loff_t fend = destoff + len - 1;
+
+		unmap_mapping_pages(target_inode->i_mapping,
+				    fstart >> PAGE_SHIFT,
+				    (fend >> PAGE_SHIFT) -
+				    (fstart >> PAGE_SHIFT) + 1,
+				    false);
+		rc = filemap_write_and_wait_range(target_inode->i_mapping,
+						  fstart, fend);
+		if (rc)
+			goto unlock;
+		invalidate_inode_pages2_range(target_inode->i_mapping,
+					      fstart >> PAGE_SHIFT,
+					      fend >> PAGE_SHIFT);
+	}
+	netfs_wait_for_outstanding_io(target_inode);
 
 	fscache_invalidate(cifs_inode_cookie(target_inode), NULL,
 			   i_size_read(target_inode), 0);
@@ -1587,6 +1607,7 @@ ssize_t cifs_file_copychunk_range(unsigned int xid,
 	CIFS_I(target_inode)->time = 0;
 
 unlock:
+	filemap_invalidate_unlock(target_inode->i_mapping);
 	/* although unlocking in the reverse order from locking is not
 	 * strictly necessary here it is a little cleaner to be consistent
 	 */
-- 
2.53.0



