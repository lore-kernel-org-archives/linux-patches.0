Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734F432E134;
	Mon, 27 Oct 2025 19:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592140; cv=none; b=ELPI5oPuapI+PW0t+PnEHlroZiNJQS4rlWCfMCu4RYDu2OniY3tc2H9QTQKhsDj0iWjt7H7U85ivU2FQuVCFasL9D8pdgS6hJibuWlbQ0uyxcm6gwuJj8uFD9z3e277sZPPVWmurTNvgd0xb2zuDn5KJiFv07i2FwD+9AlBY9Kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592140; c=relaxed/simple;
	bh=9V8idRZlSl/OEnaUsesKG4VXGvmRozmj1GdLm5d7OqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bcAvU98gPO+BOsR+CVirSBX63pO+9p3Q++USf+qtRiq7ohj/M7dyPEx/kc9csKAyKvoz201iJij/FnccZcKB9zezygdgq+y0absMed6vwyLhF2dHAm/EFekxRQAVK341wB8SMtykBwZrKHmN8p09qMiZonTwkNmPOxkBZUrL6zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yXpFecU7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yXpFecU7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05E27C113D0;
	Mon, 27 Oct 2025 19:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592140;
	bh=9V8idRZlSl/OEnaUsesKG4VXGvmRozmj1GdLm5d7OqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yXpFecU7qati/RrNXK3vH0zTZrbHw2ulTosWAVJB7HDjUkGncgVl93Sw3IyIcD+wF
	 Ujwjkfzlvv+8TIK/r2MO7rc2txgrYKxdwx3KIPkTSQazY93+CHPtZ2Dvhg7Qnm78Gn
	 DsiFszbf2nchajT9Hy2OEAqegAIaydgOt7gXSAKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuhao Fu <sfual@cse.ust.hk>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 001/157] smb: client: Fix refcount leak for cifs_sb_tlink
Date: Mon, 27 Oct 2025 19:34:22 +0100
Message-ID: <20251027183501.271596876@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2106,8 +2106,10 @@ cifs_do_rename(const unsigned int xid, s
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
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3323,8 +3323,7 @@ get_smb2_acl_by_path(struct cifs_sb_info
 	utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
 	if (!utf16_path) {
 		rc = -ENOMEM;
-		free_xid(xid);
-		return ERR_PTR(rc);
+		goto put_tlink;
 	}
 
 	oparms = (struct cifs_open_parms) {
@@ -3356,6 +3355,7 @@ get_smb2_acl_by_path(struct cifs_sb_info
 		SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
 	}
 
+put_tlink:
 	cifs_put_tlink(tlink);
 	free_xid(xid);
 
@@ -3396,8 +3396,7 @@ set_smb2_acl(struct cifs_ntsd *pnntsd, _
 	utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
 	if (!utf16_path) {
 		rc = -ENOMEM;
-		free_xid(xid);
-		return rc;
+		goto put_tlink;
 	}
 
 	oparms = (struct cifs_open_parms) {
@@ -3418,6 +3417,7 @@ set_smb2_acl(struct cifs_ntsd *pnntsd, _
 		SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
 	}
 
+put_tlink:
 	cifs_put_tlink(tlink);
 	free_xid(xid);
 	return rc;


