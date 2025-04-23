Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E8029CB3D;
	Wed, 23 Apr 2025 15:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422026; cv=none; b=YwGIos3ZNvFc4kDEN6ZXnTjEYDwwzaW+uuOKIAOZzHeiC1VLO5thjkzh7OzE7fU+8qStVXKGH73y8lJ+1S6H1VKn4opAKZDVDMMRrsjmB0U/hXEZmNH1Ge1Fzl2tTiSpR4SmG5SHourSyDXHyOegtQlBCKy097YGztM6d81hQOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422026; c=relaxed/simple;
	bh=zjV5rZ0C6gr86CiJrRJq2mzkmoF63x3XDgrREQHw9Xk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kP6CeBdF0tgFAOACH3QCfmH0EMAtymZ6Q+q7vVZ97cbn7TvK+0NfcapYRgIpeEQr+rHoANBW8Nz7H0yQIAbZwh08f4tDq2hNmoEt11YdyNv3hdVhm4vIohUyM/UToF+gHIQLdGDfI1p8CFHM7NuTZjkB1Scp13UASMonbJ4FUeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CJS/7sQy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CJS/7sQy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED2B7C4CEEB;
	Wed, 23 Apr 2025 15:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422026;
	bh=zjV5rZ0C6gr86CiJrRJq2mzkmoF63x3XDgrREQHw9Xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CJS/7sQyiky7wm/afHQ+kb5Y/37i3I09xx8kLvBb+C1WGQARF+c/ExzZCej/qK8n3
	 u8INqdoek54e/UO5Ju6ZrAHkL3wb2xCV2/auOpS07HPF6ZxKIIBuYJAc4i3XsD3QMu
	 KPGpDkliP5UE7NtY5Hz3UNBVjESFHfdW00Lzg2IE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chunjie Zhu <chunjie.zhu@cloud.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 220/291] smb3 client: fix open hardlink on deferred close file error
Date: Wed, 23 Apr 2025 16:43:29 +0200
Message-ID: <20250423142633.394280386@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -152,6 +152,8 @@ extern int cifs_get_writable_path(struct
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
@@ -687,6 +687,11 @@ int cifs_open(struct inode *inode, struc
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
@@ -1735,6 +1740,29 @@ cifs_move_llist(struct list_head *source
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


