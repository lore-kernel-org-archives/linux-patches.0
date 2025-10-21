Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E0F1A00CE;
	Tue, 21 Oct 2025 20:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077135; cv=none; b=kurnYrbAlRkJLMZEYS9jpRbQo9m61xecv50gllYKT7J2uaGOJ2LVANTaXGgL0vwcEFh6xdc7UJU4inL34ls59iQ2Jwe3fzQTyI/2q96ZDnuBn7BJGOuPz63YWcKLiBZmGpalqwycgrpp+U8Sj8DQnMqDDMYm71pQtaRu7CRWjQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077135; c=relaxed/simple;
	bh=ZdYtQ/48npZv70BlWvEucvNDJxTZxRiiPnHUYSosHE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cxjH2bzxSLf7nn5cjL2MI2DZnmi+CAN3owQgIDyHDM9nHWZO1JrERGDU5hDz4jIYYgscWj0yqFBNPby/uCrgpL3R04QkpB+zD0ZXvScrWpiFBsxTVfobkvrMU9mD8YLH/m0W4kJ6iVqxKaUEcr9KKzBUplUfJNQCrtIyi0VgrE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xPkdOz8C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xPkdOz8C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32F3AC4CEF1;
	Tue, 21 Oct 2025 20:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077135;
	bh=ZdYtQ/48npZv70BlWvEucvNDJxTZxRiiPnHUYSosHE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xPkdOz8C1Nuurnq8az7NNe+3+ijMfzUFyWz79dpGRca/ANJrJXKmDghd+0U78x5ct
	 g40OizRr9Lzk0evJo1l+0qize0f08M2uE4Ca13JeYaaYiyE/3nG+Php2ABpIzpG9R2
	 h/s1M229ChuoU/oiVF42wVzVClnNxzGFxUA65Ufc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuhao Fu <sfual@cse.ust.hk>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.17 011/159] smb: client: Fix refcount leak for cifs_sb_tlink
Date: Tue, 21 Oct 2025 21:49:48 +0200
Message-ID: <20251021195043.455255829@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2431,8 +2431,10 @@ cifs_do_rename(const unsigned int xid, s
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
@@ -3129,8 +3129,7 @@ get_smb2_acl_by_path(struct cifs_sb_info
 	utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
 	if (!utf16_path) {
 		rc = -ENOMEM;
-		free_xid(xid);
-		return ERR_PTR(rc);
+		goto put_tlink;
 	}
 
 	oparms = (struct cifs_open_parms) {
@@ -3162,6 +3161,7 @@ get_smb2_acl_by_path(struct cifs_sb_info
 		SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
 	}
 
+put_tlink:
 	cifs_put_tlink(tlink);
 	free_xid(xid);
 
@@ -3202,8 +3202,7 @@ set_smb2_acl(struct smb_ntsd *pnntsd, __
 	utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
 	if (!utf16_path) {
 		rc = -ENOMEM;
-		free_xid(xid);
-		return rc;
+		goto put_tlink;
 	}
 
 	oparms = (struct cifs_open_parms) {
@@ -3224,6 +3223,7 @@ set_smb2_acl(struct smb_ntsd *pnntsd, __
 		SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
 	}
 
+put_tlink:
 	cifs_put_tlink(tlink);
 	free_xid(xid);
 	return rc;


