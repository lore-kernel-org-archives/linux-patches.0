Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C5A3350A2A;
	Tue, 21 Oct 2025 19:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076763; cv=none; b=T9m4yHOz1CvPQ/DbexoGkpKTkKLoX/WM+9KVimpr8BOvUFaxY3yUCdr7JqkP967TJEN1c5+U3XZ/AV8ad8XtZ0m3VmGJyND1dmyvtulVav5OBKXMDdVhjhh8I+8KpfgAcOuGNxeCQ64L24o+JH/0JKNfQBnS8C1KuVNwi3SjBlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076763; c=relaxed/simple;
	bh=IYsvDpUcIkw1Quog69FtGK8M3DiAl+FfFcyYLA5PPhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oiX/xljqLAl+7hAalQ298LZj3FH2jVKPaIbG9L94DsZ2i+qZ6l59mIjQdO7EPvw7z2pCYxPxQKa/4IJIDnsOgvGeVptwxbfPAxFfH6ozLkAiHbChszuhawL4609LSygvL4zM1UBbqZ3hZrIRAauPAarlOXAQAmnE5kNpVN8DHMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bmF9Liif; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bmF9Liif"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0926AC4CEF1;
	Tue, 21 Oct 2025 19:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076763;
	bh=IYsvDpUcIkw1Quog69FtGK8M3DiAl+FfFcyYLA5PPhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bmF9Liif+I27yB7Ea/GzU0LZqEDIOCzSxC+4IAEorjmq+VD1YFmMbL5Epadn5hI6Q
	 LLfj7vgasvCeO6FHc0Yb0c07yGKzfL0j6xYL0/Bj7m5PHYpiDNfwKQwl1SKjXxdXB7
	 Je5x0ht4AQtrENmJtpXjpeaoaHx55qOSN0r6aqHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuhao Fu <sfual@cse.ust.hk>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 003/136] smb: client: Fix refcount leak for cifs_sb_tlink
Date: Tue, 21 Oct 2025 21:49:51 +0200
Message-ID: <20251021195036.036928680@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
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

From: Shuhao Fu <sfual@cse.ust.hk>

commit c2b77f42205ef485a647f62082c442c1cd69d3fc upstream.

Fix three refcount inconsistency issues related to `cifs_sb_tlink`.

Comments for `cifs_sb_tlink` state that `cifs_put_tlink()` needs to be
called after successful calls to `cifs_sb_tlink()`. Three calls fail to
update refcount accordingly, leading to possible resource leaks.

Fixes: 8ceb98437946 ("CIFS: Move rename to ops struct")
Fixes: 2f1afe25997f ("cifs: Use smb 2 - 3 and cifsacl mount options getacl functions")
Fixes: 366ed846df60 ("cifs: Use smb 2 - 3 and cifsacl mount options setacl function")
Cc: stable@vger.kernel.org
Signed-off-by: Shuhao Fu <sfual@cse.ust.hk>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/inode.c   |    6 ++++--
 fs/smb/client/smb2ops.c |    8 ++++----
 2 files changed, 8 insertions(+), 6 deletions(-)

--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -2381,8 +2381,10 @@ cifs_do_rename(const unsigned int xid, s
 	tcon = tlink_tcon(tlink);
 	server = tcon->ses->server;
 
-	if (!server->ops->rename)
-		return -ENOSYS;
+	if (!server->ops->rename) {
+		rc = -ENOSYS;
+		goto do_rename_exit;
+	}
 
 	/* try path-based rename first */
 	rc = server->ops->rename(xid, tcon, from_dentry,
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3134,8 +3134,7 @@ get_smb2_acl_by_path(struct cifs_sb_info
 	utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
 	if (!utf16_path) {
 		rc = -ENOMEM;
-		free_xid(xid);
-		return ERR_PTR(rc);
+		goto put_tlink;
 	}
 
 	oparms = (struct cifs_open_parms) {
@@ -3167,6 +3166,7 @@ get_smb2_acl_by_path(struct cifs_sb_info
 		SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
 	}
 
+put_tlink:
 	cifs_put_tlink(tlink);
 	free_xid(xid);
 
@@ -3207,8 +3207,7 @@ set_smb2_acl(struct smb_ntsd *pnntsd, __
 	utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
 	if (!utf16_path) {
 		rc = -ENOMEM;
-		free_xid(xid);
-		return rc;
+		goto put_tlink;
 	}
 
 	oparms = (struct cifs_open_parms) {
@@ -3229,6 +3228,7 @@ set_smb2_acl(struct smb_ntsd *pnntsd, __
 		SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
 	}
 
+put_tlink:
 	cifs_put_tlink(tlink);
 	free_xid(xid);
 	return rc;


