Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB041C86F4;
	Tue, 27 Aug 2024 15:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770965; cv=none; b=RlEMZfjnxBGlW7SY4Tb90IhqT+IQHELo+8S97c0/r30AatlzCvHOM2kQW27u82vvSkKcSYmtgsEGphuts4QxAj0gq8PVSeupJ/hsFM3Z1NclRjsRtiZCDnNxMj4xGw4oRReVxO+56DVOItYnTt6g6QBpfB8EYOzby43GEt2+z9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770965; c=relaxed/simple;
	bh=8OdmjgS0OJ52j3qO34VIevUUEuOOUUbODjNVErG7icY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qJ3TQDInXw6rMX6KLqOYXkwaW8PgT0y1G4yGIkuLZ6T+hfB4FmFosWO84bd6KLbYI3ckrgJ31y183LF+zxYCCuow6giw/GxM7IT4Ip5Pe1S8Sgr4Rw2/KAG4vcgvHbUcBKnSQrrixaM7xf6yRpsRgqcybczGzC7yObJk9Gy4T7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0xs4RSgJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0xs4RSgJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A27FC61042;
	Tue, 27 Aug 2024 15:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770965;
	bh=8OdmjgS0OJ52j3qO34VIevUUEuOOUUbODjNVErG7icY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0xs4RSgJMDL/zlSocxLWAaBzyt3yzkJBFiHky6WtXjJ0/KnQW8DZER8n91ucAGwSP
	 xZ/IAM3xtjfHHSjtQj8d4erzMTKtfRJ5cGSSa5L92U5DOLrfNV3Ex2WemSXslz2/hh
	 4Ho8I2LqA9edw5xAGT8w6pgMHkXjnZh/MLztpCU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Shilovsky <piastryyy@gmail.com>,
	abartlet@samba.org,
	Kevin Ottens <kevin.ottens@enioka.com>,
	David Howells <dhowells@redhat.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.10 029/273] smb3: fix lock breakage for cached writes
Date: Tue, 27 Aug 2024 16:35:53 +0200
Message-ID: <20240827143834.501950354@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve French <stfrench@microsoft.com>

commit 836bb3268db405cf9021496ac4dbc26d3e4758fe upstream.

Mandatory locking is enforced for cached writes, which violates
default posix semantics, and also it is enforced inconsistently.
This apparently breaks recent versions of libreoffice, but can
also be demonstrated by opening a file twice from the same
client, locking it from handle one and writing to it from
handle two (which fails, returning EACCES).

Since there was already a mount option "forcemandatorylock"
(which defaults to off), with this change only when the user
intentionally specifies "forcemandatorylock" on mount will we
break posix semantics on write to a locked range (ie we will
only fail the write in this case, if the user mounts with
"forcemandatorylock").

Fixes: 85160e03a79e ("CIFS: Implement caching mechanism for mandatory brlocks")
Cc: stable@vger.kernel.org
Cc: Pavel Shilovsky <piastryyy@gmail.com>
Reported-by: abartlet@samba.org
Reported-by: Kevin Ottens <kevin.ottens@enioka.com>
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/file.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -2719,6 +2719,7 @@ cifs_writev(struct kiocb *iocb, struct i
 	struct inode *inode = file->f_mapping->host;
 	struct cifsInodeInfo *cinode = CIFS_I(inode);
 	struct TCP_Server_Info *server = tlink_tcon(cfile->tlink)->ses->server;
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	ssize_t rc;
 
 	rc = netfs_start_io_write(inode);
@@ -2735,12 +2736,16 @@ cifs_writev(struct kiocb *iocb, struct i
 	if (rc <= 0)
 		goto out;
 
-	if (!cifs_find_lock_conflict(cfile, iocb->ki_pos, iov_iter_count(from),
+	if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) &&
+	    (cifs_find_lock_conflict(cfile, iocb->ki_pos, iov_iter_count(from),
 				     server->vals->exclusive_lock_type, 0,
-				     NULL, CIFS_WRITE_OP))
-		rc = netfs_buffered_write_iter_locked(iocb, from, NULL);
-	else
+				     NULL, CIFS_WRITE_OP))) {
 		rc = -EACCES;
+		goto out;
+	}
+
+	rc = netfs_buffered_write_iter_locked(iocb, from, NULL);
+
 out:
 	up_read(&cinode->lock_sem);
 	netfs_end_io_write(inode);


