Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FD563B1029;
	Wed, 30 Sep 2026 18:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791228; cv=none; b=u85lGo7LIok4GJab4Yfbn8rbqbJSK1w8/S1IMaC3gCWCVp7fcnXRYHMiBbd2ZRCrjrsNxfOWyVYyIgPvna0hc/Dov2od9Bydms+iL62MmvmYzBm9I4aWNPKZ9z9P5o941Dpo/0sRwM6SiaX/JaMX/GlU5/VgmneCwA1aTedQTow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791228; c=relaxed/simple;
	bh=oTTLnV4jBI8ATNChb4B+Up2aPs+kEUjEoed7neiCBpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A6o4n9x4DRg1YdcwF7mUIzgv/Pa60KNq4eMakP/dEcN9BAQNd/jKc8jk3SUF9GrMbbO9cE06jA/5sBCBXFfXxgFZtHutAyKEXdytDO3WD22GbglbuLrEcMGroTqfIG8vvBv4JT3uUsl++p3j55rb7MMy5zNMQstNaR6t/QL1nVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xKGKjrKQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xKGKjrKQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 688BF1F000FF;
	Wed, 30 Sep 2026 18:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791227;
	bh=zeF6rrGEjuBXvm2WtkXByd4Y3wawcX5AqvdoMp2QHn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xKGKjrKQrhDlIUsiQaCQmSJyDpqtXFvWy8c1EAl4jikK3EZXLU3mLFu+r4GCED6ER
	 QtZIoF68uUff2xVnN8Vnx94d9QqARLGc/XPfgG6t4B6HcCPVcoQI3DL8bWNZJXHVY3
	 alzCMCHTe1sCzAThekTJldi+JrED4Q/dOYZQ2VE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 173/752] ksmbd: apply create security descriptor first
Date: Wed, 30 Sep 2026 17:20:43 +0200
Message-ID: <20260930152401.946232099@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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
 fs/ksmbd/smb2pdu.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 12ca40e0f8bcd..a72ced80b5922 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -3143,14 +3143,16 @@ int smb2_open(struct ksmbd_work *work)
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
 					ksmbd_vfs_set_init_posix_acl(user_ns,
-- 
2.53.0



