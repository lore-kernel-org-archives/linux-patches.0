Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048155172D2;
	Wed, 30 Sep 2026 16:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784621; cv=none; b=scv8fWlM92KOH9I9elIji8YC9BpcdJxN4KOWCTu9Ll4K+InCH2DEiZkUNSWiTbK+LrsgqAGOQSbb7nWZ1gaalR3hDMImW1pGkUR/l3qbOi68IgJCLYO3ECmIzTN6KF+/GITDH8UFmNtJXJvz9cxSrpHq/SePNNIrfOoOu+iFMxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784621; c=relaxed/simple;
	bh=pn5kLdcIzGc7+3DXFKJrCP9+3He97HzNfaSgHp+T0aM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AoLL3TFL8bpEDQiUOKifGMqlxOqxynDLvlQMAKda3s5W49cRmAbdFln+Hh0RNPmlftdnyviPUEB7JryuazyBgyjA+kCU/nAa1vlbLTpt8KiSUQkRiEgTqjx+EZZh6bY3Shu536ZkC7CYFGKsBwHoxUaGfDXTEeFTjIdx9IBY4cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EZIUfLOo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EZIUfLOo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C5EB1F00898;
	Wed, 30 Sep 2026 16:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784618;
	bh=NR1f9Mgiob4BQHCvk9RwtvTi/A3m0RZ161pBhw4opQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EZIUfLOoPSgJa2hhco3pZ5XbSDBTYCOvcHUHkzWmiITMraUi5EmoKiJzK6deit51h
	 GsLFCHKhHdPk8OMnGGiqp5m7QoTUFznM8V74XBWmbqLYjuzOx3/cX7MTuVti0+i9Gm
	 2KeyndfbZvkcS8LD8WX48WVrGmGc8TYdf8pdQPNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 220/982] ksmbd: apply create security descriptor first
Date: Wed, 30 Sep 2026 17:15:56 +0200
Message-ID: <20260930152421.528544639@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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
index e7cbc8944ca80..5e20db1d0ddd6 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3141,14 +3141,16 @@ int smb2_open(struct ksmbd_work *work)
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



