Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 146C6384233;
	Sat, 12 Sep 2026 09:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204085; cv=none; b=he0O43bG9u99AFUf+0HFta/UrUsptcJVH/4xZCXDfdUH9ACb29Y+xEqTEp/nynlJSGHJA+Xq/r74ycLW2s+4v1wwFjgITm5r2hGrF/05P5x/raa2DndWPFlJM5/VQ370iKlOuMXpoXlfQRfRVwf2MKemWV1evFnFPuKc79bmIy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204085; c=relaxed/simple;
	bh=/KJytrCVZpGxiMxZVobr4GhFSBpFG1YoUP2cvGHIyb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P0z5y28l+EEPwaXUNDayUD7fsi12ajD83FLHSlViKqF4/XDhyu949qo+VcX+ZfoNRK+WZBaAk7ZuwRdKNximzQSkjAOHHed7tS+B/JWexjq+tyqKvWYM/J/OEqFGcajlu2ekGva5cJPeSOU0YV/hjEYYplVFhnZjoVM/GxA6UBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0uxSrgNh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0uxSrgNh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB4111F000FF;
	Sat, 12 Sep 2026 09:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204084;
	bh=8XO+z2mWGRK26oAuTxb1f64e6MrHUSD85oYjRj8qmBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0uxSrgNhjQ/uwltM7OXoDkGVPbpkP+ZwPTcVrNVn28hOPVhrZsa9U1qv8NGk87Wz9
	 ph1Y8z8UFnCtrkupIeUEHqG4p7BLPYEs4ynONP75GH5muklAORIdkxNVR5mmHA2hy0
	 ZHjQ0MdO/aOzu91iBiIKXvpUE/h+1pAu8Unl7fnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hang Nan <2122295973@qq.com>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1539/1815] ksmbd: bound smb_check_perm_dacl() ACE walks by DACL size
Date: Sat, 12 Sep 2026 08:54:49 +0200
Message-ID: <20260912065725.138385714@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 88bf7b97042f8..33825c1356b47 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1489,7 +1489,7 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 		access_bits = READ_CONTROL | WRITE_DAC | FILE_READ_ATTRIBUTES |
 			DELETE;
 		ace = (struct smb_ace *)((char *)pdacl + sizeof(struct smb_acl));
-		aces_size = acl_size - sizeof(struct smb_acl);
+		aces_size = pdacl_size - sizeof(struct smb_acl);
 		for (i = 0; i < le16_to_cpu(pdacl->num_aces); i++) {
 			if (aces_size < offsetof(struct smb_ace, sid) +
 			    CIFS_SID_BASE_SIZE)
@@ -1536,7 +1536,7 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 	}
 
 	ace = (struct smb_ace *)((char *)pdacl + sizeof(struct smb_acl));
-	aces_size = acl_size - sizeof(struct smb_acl);
+	aces_size = pdacl_size - sizeof(struct smb_acl);
 	for (i = 0; i < le16_to_cpu(pdacl->num_aces); i++) {
 		if (aces_size < offsetof(struct smb_ace, sid) +
 		    CIFS_SID_BASE_SIZE)
-- 
2.53.0



