Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC03547061;
	Thu, 17 Sep 2026 18:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668230; cv=none; b=YaICa1BxtwKt+URAyv12EeS0Ri667tILRA3Quky/6GaHwr86ISQSJx4GyHNwcQ9Q5yrzCPfyw3iEhWIEtIyUnh+PZKl7OmfJy9NAyTWqu6OtmLulNpxWuIKci47OV4/5fg7jjMFZ4vLBycgHLS3LM100CEvlByZdBjnagaLqgHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668230; c=relaxed/simple;
	bh=9QGMC+iHY/Wg9iEm33j7BGvYwxcYPshtD5NmwKbIKAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GvAhJQqJD38JC2rf9WUhmT4cgnusN112p2fj1XrynZV7+xtnmjyQbVBHI9gPqqn60444I30qb1jDZWIViqCW6zrdlzcmLmpXYan54sDMBLoBIrB5zRDg63pfcdx7kAs9YGi8pTQAd/UluDTg7xkiziVHE/+TLvALLR8UC60AG4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RAwdzp+F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RAwdzp+F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A00B1F000FF;
	Thu, 17 Sep 2026 18:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668229;
	bh=Ij+KBvCaDLbBZ/JrGyVUTqZSvcSdF6s7Lv7zFjAXlQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RAwdzp+FMgV9cGNE1kSSoTdhLj4yTn670ED5rZCHXYL7wnXPO6grYyQ031zxrs0wb
	 FeZkdq4Di5i0bVq1uVugWjuyX8nMfjJ+nsfOQ3Q8zBiSivkN0J3oCE0WytI5OeWdiO
	 FJjCsKs7CNiDsbfq6ZeKAT/pDh/8qpGcCne6KxlQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0355/1102] ksmbd: apply create security descriptor first
Date: Thu, 17 Sep 2026 16:04:58 +0100
Message-ID: <20260917151548.559082544@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit ba3cf6ee4f0eacc1f8c607b80188e3b32ef5e0e3 ]

smb2.create.aclfile creates files with an SMB2_CREATE_SD_BUFFER create
context and expects the resulting security descriptor to match
the descriptor supplied by the client.

ksmbd currently tries to inherit the parent DACL first and only parses
the SMB2_CREATE_SD_BUFFER context when DACL inheritance fails.
If inheritance succeeds, the explicit security descriptor supplied on
create is ignored. This breaks create requests that include owner/group
information in the security descriptor.

Apply the create security descriptor first when the context is present.
Fall back to the existing inherited/default ACL path only when no create
security descriptor was supplied.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 5345298759f7c..09c97814fc9c0 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3404,14 +3404,16 @@ int smb2_open(struct ksmbd_work *work)
 		if (posix_acl_rc)
 			ksmbd_debug(SMB, "inherit posix acl failed : %d\n", posix_acl_rc);
 
-		if (test_share_config_flag(work->tcon->share_conf,
-					   KSMBD_SHARE_FLAG_ACL_XATTR)) {
-			rc = smb_inherit_dacl(conn, &path, sess->user->uid,
-					      sess->user->gid);
-		}
+		rc = smb2_create_sd_buffer(work, req, &path);
+		if (rc && rc != -ENOENT)
+			goto err_out;
 
-		if (rc) {
-			rc = smb2_create_sd_buffer(work, req, &path);
+		if (rc == -ENOENT) {
+			if (test_share_config_flag(work->tcon->share_conf,
+						   KSMBD_SHARE_FLAG_ACL_XATTR)) {
+				rc = smb_inherit_dacl(conn, &path, sess->user->uid,
+						      sess->user->gid);
+			}
 			if (rc) {
 				if (posix_acl_rc)
 					ksmbd_vfs_set_init_posix_acl(idmap,
-- 
2.53.0



