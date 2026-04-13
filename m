Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F35D24E4A1;
	Mon, 13 Apr 2026 16:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098367; cv=none; b=EZ/ivIiPSk/LANa1Bl9YL51KTt/TUgOxtG4UsWCkrTtfgb4R7WS0EYbmAOkw44BZR4uzTHfpOWsMRBjaGmma9tPbtt+08QxDLPqUqY80Yp448IT6QtUe4zxLitTZI3QtjWfc/o7t0XCZJnzMHIKf9spwDLMgGe4nqGl9BweXwJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098367; c=relaxed/simple;
	bh=phngn7FRYXmpyvSFK7JPhAs3FXrTy8huf6+3Yjtz1sU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AvvIKoPg9BkvK6E6H1F9zrW6b/pzTe/TAIDW4+YSfYSrDpxRgEZ2bXNwHBjOwT8jMNVkzwiiR0B0dXSWJY2zYpbNsiRUvyGFEkLpVYF1AIxzILEc51e6YIVer2R7u6+ij/jHUze/sheXFX5yFTuE8uMiFGa2BgKp6471bc+vuO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZNvKYm5p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZNvKYm5p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1525AC2BCAF;
	Mon, 13 Apr 2026 16:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098367;
	bh=phngn7FRYXmpyvSFK7JPhAs3FXrTy8huf6+3Yjtz1sU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZNvKYm5p856WeAJ3sqUT3Bc9Omes5KS7FDIp0xXc7yQMmB29T6eKRoFavjwZwwDjL
	 KnJEeCyR8Ny82Kv/isPd5VQCPBf4k2VNGggwSG7SWfNDCwvoBp9xOj1pMiaLREsHIN
	 gt9YapaMwNYMnzIsW0TCTNgOb6+dXox8lL8V5vkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuhao Fu <sfual@cse.ust.hk>,
	Steve French <stfrench@microsoft.com>,
	Johnny Hao <johnny_haocn@sina.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 497/570] smb: client: Fix refcount leak for cifs_sb_tlink
Date: Mon, 13 Apr 2026 18:00:28 +0200
Message-ID: <20260413155849.074959208@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuhao Fu <sfual@cse.ust.hk>

[ Upstream commit c2b77f42205ef485a647f62082c442c1cd69d3fc ]

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
Signed-off-by: Johnny Hao <johnny_haocn@sina.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/inode.c   | 6 ++++--
 fs/cifs/smb2ops.c | 8 ++++----
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 30a9a89c141bb..bb0b172c5a74d 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -2023,8 +2023,10 @@ cifs_do_rename(const unsigned int xid, struct dentry *from_dentry,
 	tcon = tlink_tcon(tlink);
 	server = tcon->ses->server;
 
-	if (!server->ops->rename)
-		return -ENOSYS;
+	if (!server->ops->rename) {
+		rc = -ENOSYS;
+		goto do_rename_exit;
+	}
 
 	/* try path-based rename first */
 	rc = server->ops->rename(xid, tcon, from_path, to_path, cifs_sb);
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 619905fc694e4..0a62720590daf 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -3437,8 +3437,7 @@ get_smb2_acl_by_path(struct cifs_sb_info *cifs_sb,
 	utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
 	if (!utf16_path) {
 		rc = -ENOMEM;
-		free_xid(xid);
-		return ERR_PTR(rc);
+		goto put_tlink;
 	}
 
 	oparms.tcon = tcon;
@@ -3466,6 +3465,7 @@ get_smb2_acl_by_path(struct cifs_sb_info *cifs_sb,
 		SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
 	}
 
+put_tlink:
 	cifs_put_tlink(tlink);
 	free_xid(xid);
 
@@ -3506,8 +3506,7 @@ set_smb2_acl(struct cifs_ntsd *pnntsd, __u32 acllen,
 	utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
 	if (!utf16_path) {
 		rc = -ENOMEM;
-		free_xid(xid);
-		return rc;
+		goto put_tlink;
 	}
 
 	oparms.tcon = tcon;
@@ -3527,6 +3526,7 @@ set_smb2_acl(struct cifs_ntsd *pnntsd, __u32 acllen,
 		SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
 	}
 
+put_tlink:
 	cifs_put_tlink(tlink);
 	free_xid(xid);
 	return rc;
-- 
2.53.0



