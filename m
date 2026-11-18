Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044175;
	b=4DCPCtwb/1W+R0F0XMwesDwvWRLDvnEJ0gFDYSE8lBe7f7BfiV1jwB5qT5Dq/NBYOBcK
	 MsyPPcPBcNGz1tYFRvqSWI3B76Hqs95U/pW6CPlWts5CUEA3MvKq8XvHZ+47ffQ0f4Exz
	 wmfbgkYChTN2hwWnWAfkifaFV0aNrQxk3TkiyG1BsJ7akbKnJp8fdx6KpTmiBSfjqPQBU
	 BfYc4plozmfL1r1weQUZLf3jVeS1cbuSsKTGCIpAwvxDMCicqOXiBFQSDt60GdtdjBfNt
	 VslSMuIVtbs5l9elVCfdVO8JAatl1C5Tlbs6x3yaYXjXFgNUqzFtmipqOM9BEi+EKyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044175;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=shp6ZVicYdHbRTcUYxptLoF5qVoqsRcpvh+4Hl7yfk0=;
	b=OxvxcMoekrCbEjV9ZwG2hRC6SogAqwuqJUqpRlyPS81m1a50dVgOG0DXxve5xZR79ivn
	 /Iy/awtbOWBCNLIUSMAsgEq3yizA5nW/qf++lSjG+06kYTuK/GEmOWeRVk87eZJYMRuwq
	 s1w1TvqXDy7/0mP052v5qV/EIEANzv2gvoOKu19zbyhIfuZwtDJSxNeKnOpVE4N7U2U4K
	 w8OE/5vRskwaTl7+4fvmYYCgSKGLDwPBmvunumxz0q6glrIcQMuqXZQZnKfa85E2z/ysZ
	 yrV7HXKPyiRwVQjvLXMZuYCVVHbRp3zp/UI5clu5/wZvuW76WLIxHyj5qdKyO52IRKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hnFvJNXM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E10606A31C;
	Wed, 18 Nov 2026 23:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hnFvJNXM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61DA81F000C4;
	Wed, 18 Nov 2026 23:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044174;
	bh=shp6ZVicYdHbRTcUYxptLoF5qVoqsRcpvh+4Hl7yfk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hnFvJNXMXKoo7FCmHgSqo502WMDTHFFKWhdGxO1DZ8A8IdsNSXQDKphosBpqFiRN5
	 CKlVOFNv0N3KBWh/gIBIWti87f/vytTKzgp+bsDFz10yrPlhl0dFANN8ooli5D56Tr
	 Br2oWpVRBdOP2QW9nh2l9bluMU6Mk/GjzgelKnHc=
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
Subject: [PATCH 6.1 0475/2857] smb: client: drain and invalidate before server-side copy/clone
Date: Wed, 18 Nov 2026 15:25:09 +0100
Message-ID: <20261118150218.546000100@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Dropped the netfs_wait_for_outstanding_io() drain and the filemap_invalidate_inode() block, which don't exist in this tree, keeping only the invalidate_lock and zero-length guard on the older flush/truncate code. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsfs.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 01b4f34a23ad0..d369528532c39 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -1317,6 +1317,7 @@ static loff_t cifs_remap_file_range(struct file *src_file, loff_t off,
 	 * server could even support copy of range where source = target
 	 */
 	lock_two_nondirectories(target_inode, src_inode);
+	filemap_invalidate_lock(target_inode->i_mapping);
 
 	if (len == 0) {
 		loff_t src_size = i_size_read(src_inode);
@@ -1409,6 +1410,7 @@ static loff_t cifs_remap_file_range(struct file *src_file, loff_t off,
 	   that target is updated on the server */
 	CIFS_I(target_inode)->time = 0;
 unlock:
+	filemap_invalidate_unlock(target_inode->i_mapping);
 	/* although unlocking in the reverse order from locking is not
 	   strictly necessary here it is a little cleaner to be consistent */
 	unlock_two_nondirectories(src_inode, target_inode);
@@ -1432,6 +1434,9 @@ ssize_t cifs_file_copychunk_range(unsigned int xid,
 	unsigned long long destend, fstart, fend;
 	ssize_t rc;
 
+	if (len == 0)
+		return 0;
+
 	cifs_dbg(FYI, "copychunk range\n");
 
 	if (!src_file->private_data || !dst_file->private_data) {
@@ -1461,6 +1466,7 @@ ssize_t cifs_file_copychunk_range(unsigned int xid,
 	 * server could even support copy of range where source = target
 	 */
 	lock_two_nondirectories(target_inode, src_inode);
+	filemap_invalidate_lock(target_inode->i_mapping);
 
 	cifs_dbg(FYI, "about to flush pages\n");
 
@@ -1513,6 +1519,7 @@ ssize_t cifs_file_copychunk_range(unsigned int xid,
 	CIFS_I(target_inode)->time = 0;
 
 unlock:
+	filemap_invalidate_unlock(target_inode->i_mapping);
 	/* although unlocking in the reverse order from locking is not
 	 * strictly necessary here it is a little cleaner to be consistent
 	 */
-- 
2.53.0



