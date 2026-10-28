Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216381;
	b=NtqjhDznyGn9+We4z69R3Z8z47hDx+0W3TsoR9E8U4LiaeQspYwLTrcfU9io/5x05GU3
	 MJTFlkXkwGPSI4kqqyUB46QbkIgU0ma/1xmLLtd5JhRhyq61aIWnI56SMHz49lbQOZGxu
	 cj8jN+VYg70JZLh88cJTuKAoSl40k0Hb0vw1WEqkPWUBg5QfvrnmlhSQ8wV7UyUJFyqcg
	 ALajX2/6e7hmBWjXDOCqOYigttrVmaaVHj/bf+Js2CsGbAdKFHRvN6O5uQZzEC0GY2olJ
	 eCnK0bICSDzI2tt8qrQNz7PfopvfvEjXUCFtLpSTA/b5QqsibXg1T5vj3gKTNdnhpow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216381;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PA+3t4if4oMiAYNPjSvicb6nWg1trGkwjiRh8CoznJ8=;
	b=FQwuo/8rxrHDtRWSvPHFyK3z9wh13YZdf9w+OYZk6Gr2mnbDiFz3Y33AiW2AuY+cc9r1
	 Yi1xq6ZpmnRrRZW2o8MVC7c49lCs++O9nUK6CTShWqYiNE7swQvsrHMZgpioFxowzgYHR
	 hBAwO56BIdmfjLLDGbkXu1t/2j9pHUwik78D0MC6E89pac+XWYjoverTUIrbgXj8n35HH
	 kFAEOyzqQTPdcHiRWq/3tSwR8bnQUyBbxCmarjxsTjqBDXtkxomfyZC+qL3/y9CLEVgBV
	 ScIagwW7/eC5Dc2sAiaNfZxzdIFtk0/q7S5inphraeuFHHB7iVn+EH82TGuPtaqXoXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C1RkVcij;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C63D0606A31E;
	Wed, 28 Oct 2026 19:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C1RkVcij
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F8C61F01825;
	Wed, 28 Oct 2026 19:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216380;
	bh=PA+3t4if4oMiAYNPjSvicb6nWg1trGkwjiRh8CoznJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C1RkVcijcCGt0stinMrEXkHOf2kOO+qN/KJ+JVnxsx1nWLfTKLnpMBksLP2C8Gg+W
	 x4HUIvvDVJWquDcvvPpjEwjP9woYm8xRFw1n3isMjoEanEkB0Wf/AUtgLjfxDIVy0Q
	 P+wdeLtYcz2VPwncQi6TTokmz7ZAvISUpUK7CXx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hang Nan <2122295973@qq.com>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1536/1887] ksmbd: bound smb_check_perm_dacl() ACE walks by DACL size
Date: Wed, 28 Oct 2026 18:00:32 +0100
Message-ID: <20261028170534.420144300@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 98ba287e3b2ed..81926bd0e5a92 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1483,7 +1483,7 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 			DELETE;
 
 		ace = (struct smb_ace *)((char *)pdacl + sizeof(struct smb_acl));
-		aces_size = acl_size - sizeof(struct smb_acl);
+		aces_size = pdacl_size - sizeof(struct smb_acl);
 		for (i = 0; i < le32_to_cpu(pdacl->num_aces); i++) {
 			if (aces_size < offsetof(struct smb_ace, sid) +
 			    CIFS_SID_BASE_SIZE)
@@ -1507,7 +1507,7 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 	id_to_sid(uid, sid_type, &sid);
 
 	ace = (struct smb_ace *)((char *)pdacl + sizeof(struct smb_acl));
-	aces_size = acl_size - sizeof(struct smb_acl);
+	aces_size = pdacl_size - sizeof(struct smb_acl);
 	for (i = 0; i < le32_to_cpu(pdacl->num_aces); i++) {
 		if (aces_size < offsetof(struct smb_ace, sid) +
 		    CIFS_SID_BASE_SIZE)
-- 
2.53.0



