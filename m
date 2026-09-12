Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E569E478865;
	Sat, 12 Sep 2026 11:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211713; cv=none; b=MhggaO3V7y09+bMWdr6yS1q64pbkUNXiLUd9a9uPNOQWZ0I7Sss4/eAiIuLy1GhyIwBuV4S8iG0ztc8jpyyZQls9ZTkMd/0aEk+8QO4Cvna1Eih77lCHZXRe8IZYoelziq2nQOuCnId9OPHLe47N5q50AwB/xkECkslJ91GbG/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211713; c=relaxed/simple;
	bh=NfTNr7xWXkvLU4t9xrHoAgQkZLkuYBZ8C6oACPBdmsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kELBxLdGNScoyWKDCasLR4S6fPHekfvHiJWZB8J/R64d2IlE5TVsbjseFrjPBXMbZ2fbp0ewAvuuuY19NX0MWYfLbGY8JKUDAiYCLNeKLUAB9lFZWJoRGpqECW7u2oBsuHjIUDeXJHj8nWLXe0LATPSB3jYS+sTG1lUwj6FuUNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=olKr2QjV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="olKr2QjV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64E051F000FF;
	Sat, 12 Sep 2026 11:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211711;
	bh=Dt5gqRTkf7lKt+i1lDRT32EBSxXYQ7yLLpAyNhOpecU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=olKr2QjV+aWB/xnhSHyktm68tu6r62WRsABscU4QwUvlQQbC8yPjPz7rSWEfQHBYX
	 IJMfS6cJyxND7DZhaLrXr+7rhTenA5doo6UtUsay9Ns/TVBdWhdny98KpgzS4jdGcr
	 K+0ZExiMm/a1imTsaaPmVMbKXPWjifWRULRjP2ts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hang Nan <2122295973@qq.com>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1244/1518] ksmbd: bound smb_check_perm_dacl() ACE walks by DACL size
Date: Sat, 12 Sep 2026 08:56:53 +0200
Message-ID: <20260912065651.649111712@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hang Nan <2122295973@qq.com>

[ Upstream commit 79decd88dd3f0d42e7fb0689b1a7853bfa302459 ]

smb_check_perm_dacl() validates that the DACL fits inside the NT
security descriptor, but then bounds its two ACE walks by the
remaining NTSD length (acl_size) rather than the DACL's declared
size (pdacl_size).

When pdacl->size is smaller than the trailing NTSD buffer, bytes
after the declared DACL boundary - still inside the stored security
descriptor - are parsed as ACEs during access checks.  A crafted
DACL can place an access-granting ACE beyond pdacl->size, and the
current code accepts it during SMB2_CREATE access validation, while
parse_dacl() and smb_inherit_dacl() stop at pdacl_size.

Bound both ACE walks by pdacl_size to match the DACL boundary
semantics used elsewhere in the server.

Validation:
- semantic KUnit harness shows the post-boundary ACE is selected
  before the fix and rejected (EACCES) after it
- linux master (7.2-rc6), x86_64

Fixes: 8f0541186e9a ("ksmbd: fix heap-based overflow in set_ntacl_dacl()")
Signed-off-by: Hang Nan <2122295973@qq.com>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smbacl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index d3d0a22620f96..0879012aa63c8 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1471,7 +1471,7 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 			DELETE;
 
 		ace = (struct smb_ace *)((char *)pdacl + sizeof(struct smb_acl));
-		aces_size = acl_size - sizeof(struct smb_acl);
+		aces_size = pdacl_size - sizeof(struct smb_acl);
 		for (i = 0; i < le16_to_cpu(pdacl->num_aces); i++) {
 			if (aces_size < offsetof(struct smb_ace, sid) +
 			    CIFS_SID_BASE_SIZE)
@@ -1495,7 +1495,7 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 	id_to_sid(uid, sid_type, &sid);
 
 	ace = (struct smb_ace *)((char *)pdacl + sizeof(struct smb_acl));
-	aces_size = acl_size - sizeof(struct smb_acl);
+	aces_size = pdacl_size - sizeof(struct smb_acl);
 	for (i = 0; i < le16_to_cpu(pdacl->num_aces); i++) {
 		if (aces_size < offsetof(struct smb_ace, sid) +
 		    CIFS_SID_BASE_SIZE)
-- 
2.53.0



