Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31D4C3515C5;
	Wed, 30 Sep 2026 18:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794573; cv=none; b=XoieRIAXZwW4JCcwOvRw9vmFjXjgw97L06yuc8vwZPtw8GImMWrxu1wDBbyk1MUcPRMkSMv1sY+bM6KptsXc18+R14agkpUxvdSvcT1ZojQGK0W3msJWA0he8rIFA6WtYsQudDCphzLCxbLRN23mZsJ+65N8rVIU2wTXsypVIcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794573; c=relaxed/simple;
	bh=kaIDEFiHDDM6r9kpYmceaBiwU5cl8sd3TF2R7efCkJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NvFDwbVDSQhHCH70LuO7+QY1KpEHM7/Aio359yuOkWCBzEzJlxHL8zOQ5FrlRCriWAGaISD2yeg5/skjj92yv7rOsbojlDo3Xf9Jrg8ayEGTlhtjzxm4A5ndnnUpxAMxNiYDc1mcxW9A8/mqLhpX2ldA0eky1Na49e9XeJvbQJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M52JjHy5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M52JjHy5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D1041F000FF;
	Wed, 30 Sep 2026 18:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794572;
	bh=9ZbJOvrSJTMFZvx69HBekvgwSAFIGoLq2FOxcSCaRtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M52JjHy55EqfLt5YbuATNq6XBpxooj/L9g2S/ISDO+tNggqsuIV5ajTc8D+2knEki
	 4miAvJoaSz1ETZsZ2LH3x+MDz6yOKIFyUsqA3RmZSYGMhlFf0jHpL7POmMbutNarcs
	 Jabs2n4LapFf4QcqH1Jzgt+PHtWY0nhdWaDSumAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0257/1193] ksmbd: apply create security descriptor first
Date: Wed, 30 Sep 2026 17:15:41 +0200
Message-ID: <20260930152439.884559936@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index 5a1d9932b4cd5..6c6da0125c4f8 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3383,14 +3383,16 @@ int smb2_open(struct ksmbd_work *work)
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



