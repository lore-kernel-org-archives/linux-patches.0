Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C5F28E5F3;
	Wed, 23 Apr 2025 15:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421115; cv=none; b=BjgAPkM6Nfy60hfJKsPz+XBL9osp3iPN1yhacDAxG9GI/SooCJTJoaxQpmJIyZSgwFlZvBGGuYHjLwOmxnxYXQkiBaQug0IqPtZULVhf/uaFur2OxlhzpEKTdIJ8ZeMu75oFP2i0SytE3BR37e2t88BmIs7B9Q32AT4yYz+b4k0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421115; c=relaxed/simple;
	bh=8PzN5IH8KhTuaQPVXnEdF+ePZe9QN650naIoJPV8/aE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GHK+5nScabw+7k2fBEw7uINqYj6iTm6n8gbkqn5XDUbp2+jUkvgRbSNLQQzqvFP9G7PIlVYSCBGr0EY8VPRjeek606PPOHFSYhsNjkb92jhp6043XlWIqNkPa3hc7HfuSpmMq/FCUUOTNoPaJc+6QiLIL32DKnspKY2lgkLLKGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y9NW03ZX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y9NW03ZX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49163C4CEE2;
	Wed, 23 Apr 2025 15:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421115;
	bh=8PzN5IH8KhTuaQPVXnEdF+ePZe9QN650naIoJPV8/aE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y9NW03ZXu+/A5gc39rPJ7V4dWElfFB2U3zcftL/bWQoYNmSgoxaT0071n3ionDp6W
	 yE1gy7ASeL2EXjBib6zHKT6e2CKn0HuY0v9lvOoSfDiH/6BrW2mGU5h3KPfAd3dZri
	 hQUkGKcNgbklOK/xwNp4AFI8iSicIf1L91feFPCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chunjie Zhu <chunjie.zhu@cloud.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.14 153/241] smb3 client: fix open hardlink on deferred close file error
Date: Wed, 23 Apr 2025 16:43:37 +0200
Message-ID: <20250423142626.792891577@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

From: Chunjie Zhu <chunjie.zhu@cloud.com>

commit 262b73ef442e68e53220b9d6fc5a0d08b557fa42 upstream.

The following Python script results in unexpected behaviour when run on
a CIFS filesystem against a Windows Server:

    # Create file
    fd = os.open('test', os.O_WRONLY|os.O_CREAT)
    os.write(fd, b'foo')
    os.close(fd)

    # Open and close the file to leave a pending deferred close
    fd = os.open('test', os.O_RDONLY|os.O_DIRECT)
    os.close(fd)

    # Try to open the file via a hard link
    os.link('test', 'new')
    newfd = os.open('new', os.O_RDONLY|os.O_DIRECT)

The final open returns EINVAL due to the server returning
STATUS_INVALID_PARAMETER. The root cause of this is that the client
caches lease keys per inode, but the spec requires them to be related to
the filename which causes problems when hard links are involved:

>From MS-SMB2 section 3.3.5.9.11:

"The server MUST attempt to locate a Lease by performing a lookup in the
LeaseTable.LeaseList using the LeaseKey in the
SMB2_CREATE_REQUEST_LEASE_V2 as the lookup key. If a lease is found,
Lease.FileDeleteOnClose is FALSE, and Lease.Filename does not match the
file name for the incoming request, the request MUST be failed with
STATUS_INVALID_PARAMETER"

On client side, we first check the context of file open, if it hits above
conditions, we first close all opening files which are belong to the same
inode, then we do open the hard link file.

Cc: stable@vger.kernel.org
Signed-off-by: Chunjie Zhu <chunjie.zhu@cloud.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifsproto.h |    2 ++
 fs/smb/client/file.c      |   28 ++++++++++++++++++++++++++++
 2 files changed, 30 insertions(+)

--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -160,6 +160,8 @@ extern int cifs_get_writable_path(struct
 extern struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *, bool);
 extern int cifs_get_readable_path(struct cifs_tcon *tcon, const char *name,
 				  struct cifsFileInfo **ret_file);
+extern int cifs_get_hardlink_path(struct cifs_tcon *tcon, struct inode *inode,
+				  struct file *file);
 extern unsigned int smbCalcSize(void *buf);
 extern int decode_negTokenInit(unsigned char *security_blob, int length,
 			struct TCP_Server_Info *server);
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -1007,6 +1007,11 @@ int cifs_open(struct inode *inode, struc
 		} else {
 			_cifsFileInfo_put(cfile, true, false);
 		}
+	} else {
+		/* hard link on the defeered close file */
+		rc = cifs_get_hardlink_path(tcon, inode, file);
+		if (rc)
+			cifs_close_deferred_file(CIFS_I(inode));
 	}
 
 	if (server->oplocks)
@@ -2071,6 +2076,29 @@ cifs_move_llist(struct list_head *source
 		list_move(li, dest);
 }
 
+int
+cifs_get_hardlink_path(struct cifs_tcon *tcon, struct inode *inode,
+				struct file *file)
+{
+	struct cifsFileInfo *open_file = NULL;
+	struct cifsInodeInfo *cinode = CIFS_I(inode);
+	int rc = 0;
+
+	spin_lock(&tcon->open_file_lock);
+	spin_lock(&cinode->open_file_lock);
+
+	list_for_each_entry(open_file, &cinode->openFileList, flist) {
+		if (file->f_flags == open_file->f_flags) {
+			rc = -EINVAL;
+			break;
+		}
+	}
+
+	spin_unlock(&cinode->open_file_lock);
+	spin_unlock(&tcon->open_file_lock);
+	return rc;
+}
+
 void
 cifs_free_llist(struct list_head *llist)
 {


