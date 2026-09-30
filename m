Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BED16560AAB;
	Wed, 30 Sep 2026 17:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790402; cv=none; b=uwJpHwSXaB8J8IGaSSrq/nDuQboT7Ix+oYFHi20eYltB/xNFXYzNGFYcAzXXRowA4FYl6hHETppl3eZGHAjqW/tmxDa5tUceUPwEhGm/XxzOVaDPUONsAOcQlKI0nzfiPNA2xasRXO+uFeFPxJhcnu5Az/riUvPauEJoLDra2DE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790402; c=relaxed/simple;
	bh=gY3WefJG065pPvsTsoQFAQtEBMC+dGRkgMQ7bgt60u4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QCJ+xzV5Ut0/UZI62yAn34c0CzjZVf3czYt85RHdZVY8nCBb0MxEv6SsOVqEqcNGbMnSvRxsvCw6HMTnMuct8uYuaquWDFuCTPjAJryZ69hHcu+Z/T0AZZ/+L9cqcEj6jKIaKlTLUdfrva5S12Py6YHpm9KWCm3qlUHufCqVbSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TBrtt6U6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TBrtt6U6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 259631F00898;
	Wed, 30 Sep 2026 17:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790400;
	bh=UI3dSCSDe3G/onu1kfuTgICp0GRmlcNQLgRpMiFSp9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TBrtt6U6SOKXDZXhN91frQbzS2VIg+GMiOe1wdEtCAWBfnHirguKFaT3ajAIbw2fK
	 kmQKe7tuxUD3Zkchl7yC3RmfNIvqr072TNjYzd3La8c6pOHQ3KV7ZDJ5UHUqSmFr8E
	 g98hS6Jw3T5i5dOkV7XTjvXo+ImG8uxWObLXITx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	April Cardenas <april.cardenas@canonical.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Bharath S M <bharathsm@microsoft.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 815/877] smb/client: send lease break ACKs thru correct session for multiuser mounts
Date: Wed, 30 Sep 2026 17:28:46 +0200
Message-ID: <20260930152432.310133718@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: April Cardenas <april.cardenas@canonical.com>

[ Upstream commit ebc5660132ddd244b57f03ed324922013a3d7363 ]

Currently, when cifs_oplock_break handles a break request from the server
it searches for the appropriate tlink to handle the request
but incorrectly uses the current fsuid as the search key, eventually
causing read errors for users with multiuser mounts on NetApp.
Fix this by using the tlink from the cfile struct instead to respond
through the correct session.

As breaks are handled in a worker thread, the current fsuid
isn't guaranteed to match the session that the break is intended for.
This means that cifs_sb_tlink may search the rbtree using the wrong fsuid,
and return a tlink with an incorrect session than
the lease break was intended for. As a result, the breaks
may be ACKed through an incorrect session.

While it seems that Samba/Windows Servers 2016-2025 ignore this as long as
the lease key is correct, we ran into a case where if you're using
NetApp ONTAP or Azure NetApp Files they will reject the ACK
and return `STATUS_LOCK_NOT_GRANTED` errors on any future read requests
a user may initiate through their still held open file handle,
and the server will eventually close the file.

In the dmesg logs, the user may see errors like these:

CIFS: Status code returned 0xc0000128 STATUS_FILE_CLOSED
CIFS: VFS: Send error in read = -9

With a multiuser mount using NetApp, this issue is really easy
for users to hit on a wide variety of kernel versions
by attempting to copy a file from the share
to the local machine through GNOME Files/Nautilus.
This copy will always result in Nautilus throwing
a `Bad File Descriptor` error to the user and fail.
With this fix, you can copy files through Nautilus without issue.

>>From looking at the traces, it seems that glib will
open the file first, and call listxattr before actually attempting
to copy the file data. The listxattr call always triggers a break,
causing the copy to fail.

The proposed fix returns to the way the client grabbed the tlink before
commit e8f5f849ffce2 ("cifs: fix potential oops in cifs_oplock_break").

The bulk of that commit (checking for list empty) remains untouched, and
I think the change to using cifs_sb_tlink was intended to avoid a
NULL/ERR deference on the tlink as well as update the reference count.

I believe this fix should preserve those safety properties, but of course
I'd appreciate any corrections here.

Fixes: e8f5f849ffce2 ("cifs: fix potential oops in cifs_oplock_break")
Cc: stable@vger.kernel.org
Signed-off-by: April Cardenas <april.cardenas@canonical.com>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Reviewed-by: Bharath S M <bharathsm@microsoft.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
[ Removed now-unused sb and cifs_sb declarations from cifs_oplock_break(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/file.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -3067,8 +3067,6 @@ void cifs_oplock_break(struct work_struc
 	struct cifsFileInfo *cfile = container_of(work, struct cifsFileInfo,
 						  oplock_break);
 	struct inode *inode = d_inode(cfile->dentry);
-	struct super_block *sb = inode->i_sb;
-	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 	struct cifsInodeInfo *cinode = CIFS_I(inode);
 	struct cifs_tcon *tcon;
 	struct TCP_Server_Info *server;
@@ -3081,8 +3079,8 @@ void cifs_oplock_break(struct work_struc
 	wait_on_bit(&cinode->flags, CIFS_INODE_PENDING_WRITERS,
 			TASK_UNINTERRUPTIBLE);
 
-	tlink = cifs_sb_tlink(cifs_sb);
-	if (IS_ERR(tlink)) {
+	tlink = cifs_get_tlink(cfile->tlink);
+	if (IS_ERR_OR_NULL(tlink)) {
 		/* drop the reference taken when the break was queued */
 		_cifsFileInfo_put(cfile, false /* do not wait for ourself */, false);
 		goto out;


