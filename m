Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C2C269B07;
	Wed, 23 Apr 2025 15:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420432; cv=none; b=axaBYxxjtavJDEX07eEy9j8EcQ8VVXP7pDebSW82RZbRoNBlr3DtQUQOXqFtTqH3ms3YcUyqJ7BVKZfgXhdoY6NWtoWn5tNW8L3GfVJJCe1nEOhKipAf4/AOPrU0D1t8GmuntOBtZX0DPP91PYchCgAF3GPANbX1NAj3lwhGsC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420432; c=relaxed/simple;
	bh=s7Fy4eXXXDuPR829HR9mpWTeRpTULyHbMq/rU+RAfkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ait3ZAxc8sEUIaUzBjS5XHR9rz+86TPuOwyQIKGIHgcLX3U0TZt90H/kNbeOLXpXKz+QIZ0j9VlZZzb6ouN/A95n7XzM7/yjQFDoWIg50Jy6l9JR0XyOH6ZpSGTbhABiNzxtfcpwspUuKD9Y9kD+53zhwu0bKi6NHOucWyamu+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UZy2W5JU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UZy2W5JU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC7B7C4CEE2;
	Wed, 23 Apr 2025 15:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420432;
	bh=s7Fy4eXXXDuPR829HR9mpWTeRpTULyHbMq/rU+RAfkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UZy2W5JUMzUat0Sy4ItTA6IZg50AFVEa1VZxN6prV858ZXgIpe2YEwCa96R5hyrcD
	 SPQqIjixNunqBSyVZWFFp/n9OCc8ecMoLwkHDrvtk5aIN0vbZ4AfvyqlOwovyBfaH7
	 28caIcW2LfbiSIuM66aHfQnzAfzL2zDBlxQJRTF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chunjie Zhu <chunjie.zhu@cloud.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 131/223] smb3 client: fix open hardlink on deferred close file error
Date: Wed, 23 Apr 2025 16:43:23 +0200
Message-ID: <20250423142622.429409369@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1002,6 +1002,11 @@ int cifs_open(struct inode *inode, struc
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
@@ -2066,6 +2071,29 @@ cifs_move_llist(struct list_head *source
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


