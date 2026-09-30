Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80F2D51DDFB;
	Wed, 30 Sep 2026 17:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790288; cv=none; b=FMf493O8hoSiDuGyp4XRoh6BtcPXVya9NF4NVg8VrJB70XkvR7SbwKbcmbZpO1S1kgX6HjtPW9jvtDzMBUC9QJmExu1ZqYydmpUVO7I1WNaLzKHFd51KLaCX5voBc/4YkGZN7ek1vugQTx3asheua4wHc48bpqodgHwI9rxOHjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790288; c=relaxed/simple;
	bh=ctjP7tpOlfJiP+G/u7BCT0+/4+v0KxMKzzLRWsDthJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pIy0aapGTyjzAxdsyFMBupulOi4XdkQ1aG946mtN/4VFB5lX3dd2ldnAvsvn3ewXZHmMIndfiAO1jW2rIOORQQnIf6OZO8f2wiUYpVoZxjQqvHDLyaOGUOIfnyO8JpBtuPVoYa2ex9dVtwKX5eiYWbT2hRBzjMZhE55Z06sfwCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DlSCUIvL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DlSCUIvL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA1DA1F00898;
	Wed, 30 Sep 2026 17:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790287;
	bh=tetfT+lYogwWOntpxs9/tNss9M6J//9LKCv0uaoxcdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DlSCUIvLdsSof2uQBMHzcCJTj0xPChjN+X1Kz2jjKbUkIMTiEKEb81RAeKfdtUkBc
	 4GwndhZBUZp8NyAKhF6iYqoFyzpOqs9YT762SBd2gzimEyG+bKgTImglTZ8R0Ced/I
	 I+4nsGB1hOCeGY+1SqGkadw1+fY+c0rG0ZMIgHN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ralph Boehme <slow@samba.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 774/877] smb: client: refactor ACL setting control flow in id_mode_to_cifs_acl()
Date: Wed, 30 Sep 2026 17:28:05 +0200
Message-ID: <20260930152431.415883145@linuxfoundation.org>
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

From: Ralph Boehme <slow@samba.org>

[ Upstream commit a540a64c4801fe02e452ee37e961018106418260 ]

Refactor the control flow in id_mode_to_cifs_acl() to reduce nesting and
prevent error code overwriting.

Instead of wrapping the call to ops->set_acl() in a conditional block,
introduce early exits (goto id_mode_to_cifs_acl_exit) when build_sec_desc()
fails or ops->set_acl is NULL. This ensures that any actual error returned
by build_sec_desc() is not overwritten with -EOPNOTSUPP.

Signed-off-by: Ralph Boehme <slow@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: d05045177a85 ("smb: client: fail DACL rewrite when the new DACL exceeds 64K")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifsacl.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -1798,14 +1798,18 @@ id_mode_to_cifs_acl(struct inode *inode,
 
 	cifs_dbg(NOISY, "build_sec_desc rc: %d\n", rc);
 
-	if (ops->set_acl == NULL)
-		rc = -EOPNOTSUPP;
+	if (rc != 0)
+		goto id_mode_to_cifs_acl_exit;
 
-	if (!rc) {
-		/* Set the security descriptor */
-		rc = ops->set_acl(pnntsd, nsecdesclen, inode, path, aclflag);
-		cifs_dbg(NOISY, "set_cifs_acl rc: %d\n", rc);
+	if (ops->set_acl == NULL) {
+		rc = -EOPNOTSUPP;
+		goto id_mode_to_cifs_acl_exit;
 	}
+
+	/* Set the security descriptor */
+	rc = ops->set_acl(pnntsd, nsecdesclen, inode, path, aclflag);
+	cifs_dbg(NOISY, "set_cifs_acl rc: %d\n", rc);
+
 id_mode_to_cifs_acl_exit:
 	cifs_put_tlink(tlink);
 


