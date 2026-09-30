Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93C3C51AECC;
	Wed, 30 Sep 2026 17:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791137; cv=none; b=t8zhpNCw/oCTL5J89UlZBThccY6oPafpRoB7hEZin/Orwe/YJ0eOjXg4s2ClBjzXn83HjHzkK0TqHe3HOp/um9IMa6zSm+N2Fum7clU5GgU4gspn1QyTPqYmkOMeMhxs2ZCkmCqyAn4mgvxegyhx7kcCAAiVNUga54B0ejRwKSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791137; c=relaxed/simple;
	bh=M6oQG8OTL61rJb+TSeooEPUyZ2J3PgpFJpn/dHuT1NE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j3GzpinaNxruBsTEQqWNs4HoISKN3DYkW74xdMBnf+shUvy2gDEwU+YNdGATP439bhw8eRUCs8zuzfcVo9EYnfw+Te3pB5zeVVCkVfTKWIGkKNHsXgdfkm6wV6mM7Trptz853E1azfwgKqIaXFdWx+pxJ0Lbnkp6s3Fe9s5orPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HxqtCObL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HxqtCObL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBF841F00898;
	Wed, 30 Sep 2026 17:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791136;
	bh=3IY3d3EKv7giEqnVb29iqkYqcTO0Y/zBDKXtl8IB0+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HxqtCObLsnbnBbyKo7XdZgU/nC5yCkXA7hwMbuHsX3e0vS+vtXBAJ88yf5LEl1zTY
	 1AkpJsY02Fu+25cCxTvmTNmNXE3Nx+wcfsXdXZM3IKwFZnZBNPD9gvjnuBid/p+b9v
	 46FykATFxC6/hWsFh8HPeJ2T+4o38UXTD/kJh5oU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 197/752] ksmbd: validate SID namespace before mapping IDs
Date: Wed, 30 Sep 2026 17:21:07 +0200
Message-ID: <20260930152402.481160823@linuxfoundation.org>
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

[ Upstream commit fbe0bb2b75eb3c61e8464486506253d1b471240b ]

sid_to_id() currently treats the last subauthority of any owner or group
SID as a Unix uid or gid. For example, this maps Everyone (S-1-1-0) to
uid 0 and BUILTIN\Users (S-1-5-32-545) to gid 545.

When an SMB2 CREATE security descriptor contains those SIDs, ksmbd
attempts to change the newly created file to the bogus Unix ownership.
notify_change() then returns -EPERM, which makes smb2.create.aclfile fail
with NT_STATUS_SHARING_VIOLATION.

Validate the SID prefix before extracting its RID. Only server-domain
owner SIDs and S-1-22-2 Unix group SIDs have local ID representations.
Treat other valid Windows SIDs as unmapped so their original values can
still be preserved in the NT ACL xattr.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/smbacl.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/fs/ksmbd/smbacl.c b/fs/ksmbd/smbacl.c
index 0697574017e9d..a41964531c3ca 100644
--- a/fs/ksmbd/smbacl.c
+++ b/fs/ksmbd/smbacl.c
@@ -259,6 +259,7 @@ static int sid_to_id(struct user_namespace *user_ns,
 		     struct smb_sid *psid, uint sidtype,
 		     struct smb_fattr *fattr)
 {
+	const struct smb_sid *sid_prefix;
 	int rc = -EINVAL;
 
 	/*
@@ -275,6 +276,12 @@ static int sid_to_id(struct user_namespace *user_ns,
 		kuid_t uid;
 		uid_t id;
 
+		/* Only the server domain RID has a local uid representation. */
+		sid_prefix = &server_conf.domain_sid;
+		if (psid->num_subauth != sid_prefix->num_subauth + 1 ||
+		    compare_sids(psid, sid_prefix))
+			return -EINVAL;
+
 		id = le32_to_cpu(psid->sub_auth[psid->num_subauth - 1]);
 		uid = mapped_kuid_user(user_ns, &init_user_ns, KUIDT_INIT(id));
 		if (uid_valid(uid)) {
@@ -285,6 +292,12 @@ static int sid_to_id(struct user_namespace *user_ns,
 		kgid_t gid;
 		gid_t id;
 
+		/* Local gids are represented by S-1-22-2-<gid>. */
+		sid_prefix = &sid_unix_groups;
+		if (psid->num_subauth != sid_prefix->num_subauth + 1 ||
+		    compare_sids(psid, sid_prefix))
+			return -EINVAL;
+
 		id = le32_to_cpu(psid->sub_auth[psid->num_subauth - 1]);
 		gid = mapped_kgid_user(user_ns, &init_user_ns, KGIDT_INIT(id));
 		if (gid_valid(gid)) {
@@ -858,9 +871,9 @@ int parse_sec_desc(struct user_namespace *user_ns, struct smb_ntsd *pntsd,
 
 		rc = sid_to_id(user_ns, owner_sid_ptr, SIDOWNER, fattr);
 		if (rc) {
-			pr_err("%s: Error %d mapping Owner SID to uid\n",
-			       __func__, rc);
+			ksmbd_debug(SMB, "Owner SID has no Unix uid mapping\n");
 			owner_sid_ptr = NULL;
+			rc = 0;
 		}
 	}
 
@@ -873,9 +886,9 @@ int parse_sec_desc(struct user_namespace *user_ns, struct smb_ntsd *pntsd,
 		}
 		rc = sid_to_id(user_ns, group_sid_ptr, SIDUNIX_GROUP, fattr);
 		if (rc) {
-			pr_err("%s: Error %d mapping Group SID to gid\n",
-			       __func__, rc);
+			ksmbd_debug(SMB, "Group SID has no Unix gid mapping\n");
 			group_sid_ptr = NULL;
+			rc = 0;
 		}
 	}
 
-- 
2.53.0



