Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774973;
	b=fOFWNPV9BV3eFY6fv3wKC6jqpmbK0nOyvaM+sS3kMZitDjQAWJwKDz5U75M7ICQfBYtq
	 tf1DSxgrd6AqMwoCjQRWtw9bDkMicsYIgbzJ4yQGYic2bLDppiuFM8zBL3w15MH7slAbH
	 bt964DUA3+DjH5bcoGC5+b1LFWdX/k166qevf0uFmutJO4BKwb/edXWvIMLLCjkz1naKs
	 4YF5Wy9YZlVEsvYVlH7PodD4775PN7czIk9ggJSrgqKvy6RWDXxq3EPZRnWZhoPs9Yecn
	 Dmqo4qRHf2GUyemM1CKXT5nbtQOQ21ICWcpgdfnSSi3on/mMC2irmKRNKhYLXLWq3Uw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774973;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vO8AU9HwWioirwTBbbS6akq8rCLXfBOdkhT9uEcvuCY=;
	b=d81IkBlWvbjqQGr6SuP2Ufkuzw2r8N/vzcRplrb3AL60oneX76SmDyY95QOQWwWEyPmF
	 7cUmuQzct+DmwuAGEWTZYkLRPesApeUhGjAXV6SsLAfmzNk6WBilUi8LTcgAaZnSC6R0q
	 yDrixecw+SLy0nz+6KcVEw9PKUezs0QV0rI+o2V2r56he7fQkbtettdissjrvIgn5pdL4
	 I15h7GNhWZtDAoXSWjq55551Zf2GJp7xlYzGqqk7Asepu0Xc6KNiG5RwfGDqJLgWFREUM
	 TCWTUISj4klfEYkR73eM3admzxDhQZ4UDzd4eNMUiB0ju1eTLUGsWpjkws/yUaLrXwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xuyweluo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FAA2606A31A;
	Fri, 23 Oct 2026 17:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xuyweluo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 783EE1F01825;
	Fri, 23 Oct 2026 17:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774973;
	bh=vO8AU9HwWioirwTBbbS6akq8rCLXfBOdkhT9uEcvuCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xuyweluout49lC3QXGjelb89lT2O8P5yxnAWT7P0OblQXUT+i8i9MhNaWI8LUKabe
	 ImvZL87vFwwFPs4KNwzb6XKUhBvZhnCUHXK5tqvLXj2DtpHm3t/nrWVDCzC6jFn0dS
	 gMHE4rfvpUhkk1IGH3vFioOMHq28dnEJ+O25GbuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH 7.2 220/242] smb: client: fix data corruption with concurrent writes and O_TRUNC
Date: Fri, 23 Oct 2026 18:41:02 +0200
Message-ID: <20261023163719.021933586@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.org>

commit a8603b52b39f520ea8a34def74c23fba87396d3e upstream.

cifs_do_truncate() flushes dirty pages with filemap_write_and_wait()
and truncates the file on the server, but in the old code both
operations ran without holding i_rwsem or invalidate_lock.  A
concurrent buffered write via netfs_perform_write() -- which only
needs i_rwsem shared -- could dirty new pages after the flush but
before the local truncation, and those pages would be silently
discarded by cifs_setsize() -> truncate_pagecache().

Fix by acquiring inode_lock (exclusive i_rwsem) and
filemap_invalidate_lock at the top of cifs_do_truncate(), so the
entire flush-truncate-resize sequence is atomic with respect to:

  - buffered writes (blocked by exclusive i_rwsem, since
    netfs_start_io_write takes i_rwsem shared),
  - read page faults (blocked by exclusive invalidate_lock, since
    filemap_fault takes it shared),
  - writeback collection (blocked by netfs_wb_begin/netfs_wb_end
    around the server truncate and local resize, since
    netfs_writepages also acquires the wb lock).

Fixes: 110fee6b9bb5 ("smb: client: fix missing timestamp updates with O_TRUNC")
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/file.c |   28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -999,42 +999,50 @@ static int cifs_do_truncate(const unsign
 	struct cifs_tcon *tcon;
 	int rc;
 
-	rc = filemap_write_and_wait(inode->i_mapping);
-	if (is_interrupt_error(rc))
+	rc = inode_lock_killable(inode);
+	if (rc)
 		return -ERESTARTSYS;
+
+	filemap_invalidate_lock(inode->i_mapping);
+
+	rc = filemap_write_and_wait(inode->i_mapping);
+	if (is_interrupt_error(rc)) {
+		rc = -ERESTARTSYS;
+		goto out;
+	}
 	mapping_set_error(inode->i_mapping, rc);
 
 	cfile = find_writable_file(cinode, FIND_FSUID_ONLY);
 	rc = cifs_file_flush(xid, inode, cfile);
 	if (!rc) {
 		if (cfile) {
+			struct netfs_inode *ictx = netfs_inode(inode);
+
 			tcon = tlink_tcon(cfile->tlink);
 			server = tcon->ses->server;
+			netfs_wb_begin(ictx, false);
 			rc = server->ops->set_file_size(xid, tcon,
 							cfile, 0, false);
 			if (!rc) {
-				inode_lock(inode);
-				filemap_invalidate_lock(inode->i_mapping);
 				netfs_resize_file(&cinode->netfs, 0, true);
 				cifs_setsize(inode, 0);
-				filemap_invalidate_unlock(inode->i_mapping);
-				inode_unlock(inode);
 				cifs_invalidate_cache(inode, 0);
 			}
+			netfs_wb_end(ictx);
 		} else {
 			/*
 			 * No cached handle; evict stale pages so they can't
 			 * be served after the file is later extended; let
 			 * the server's O_TRUNC open response set the i_size
 			 */
-			inode_lock(inode);
-			filemap_invalidate_lock(inode->i_mapping);
 			truncate_inode_pages(inode->i_mapping, 0);
-			filemap_invalidate_unlock(inode->i_mapping);
-			inode_unlock(inode);
 			cifs_invalidate_cache(inode, 0);
 		}
 	}
+
+out:
+	filemap_invalidate_unlock(inode->i_mapping);
+	inode_unlock(inode);
 	if (cfile)
 		cifsFileInfo_put(cfile);
 	return rc;


