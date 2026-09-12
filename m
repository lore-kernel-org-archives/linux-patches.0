Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201EA3AC17;
	Sat, 12 Sep 2026 15:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225735; cv=none; b=HLEXZ5JSqkEPpISP3abu4HJzq52rNNqMCFMr+NF3l6po2oQPmgfCUUztagYjRTdZC0l+1xn12yR7bvYmgFU0IMAF9UVfv8KgnWGkTsmm53d74/M8KApkKqQgsw4x+b5/KhPu7W8boewVbGH1ae1r4qsrpICqoyuKmDHRMqB7Btc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225735; c=relaxed/simple;
	bh=yqowbl3H67f8T1mu+50/ZoPDzWoPkcuBxKKyw3+mQeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aglRFOGSQBKPPJcCe/PpectNoLLENLTglz7hhY+1CmYJHroAY1nbhMY454vZDIz7twTzZe3CEU2Ot7ci+znFQwRLN3HQ+v67svkJIojAj3JXsYg+ah6YDEqCzBgmQvMITdYRhIYMUutJhlvwZlPYYw0eTPpiclINg2qY1rDcUNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D1STwor5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D1STwor5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E677A1F00898;
	Sat, 12 Sep 2026 15:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225734;
	bh=R2yne416flGyD8WsPkzYqv2R9vjHObokfls0C4Motzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D1STwor5dNnttSFdvz1rblIIiqCIQfVtPWKUGktnPWxd3WiWmwGJL+G49YAU4+BpN
	 ao/avKf1JlkVHVqFK/Fp6Dn9XrLe0glawHPvDkZD73zyuEDe6H1o9Pxss7QwgM4q7t
	 xnGgYFAE9G+VWiHfGWzrazMjOrJrkLfs7tTjxciQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hang Nan <2122295973@qq.com>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1257/1424] ksmbd: bound smb_check_perm_dacl() ACE walks by DACL size
Date: Sat, 12 Sep 2026 09:01:29 +0200
Message-ID: <20260912065635.430452875@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a70b6f535d86f..cf72d0942e16e 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1418,7 +1418,7 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 			DELETE;
 
 		ace = (struct smb_ace *)((char *)pdacl + sizeof(struct smb_acl));
-		aces_size = acl_size - sizeof(struct smb_acl);
+		aces_size = pdacl_size - sizeof(struct smb_acl);
 		for (i = 0; i < le16_to_cpu(pdacl->num_aces); i++) {
 			if (aces_size < offsetof(struct smb_ace, sid) +
 			    CIFS_SID_BASE_SIZE)
@@ -1442,7 +1442,7 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 	id_to_sid(uid, sid_type, &sid);
 
 	ace = (struct smb_ace *)((char *)pdacl + sizeof(struct smb_acl));
-	aces_size = acl_size - sizeof(struct smb_acl);
+	aces_size = pdacl_size - sizeof(struct smb_acl);
 	for (i = 0; i < le16_to_cpu(pdacl->num_aces); i++) {
 		if (aces_size < offsetof(struct smb_ace, sid) +
 		    CIFS_SID_BASE_SIZE)
-- 
2.53.0



