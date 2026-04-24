Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D80BC3537DF;
	Fri, 24 Apr 2026 13:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777038230; cv=none; b=faPE8x2l9N9lYgw9zSY1i8AlVsyXMm+FsLQ2PAsiGcCT0ZULpxXJmmjn3UVsF+L18kd1cSGdarCpTkuUzoG9HpL0lIkdQWuPLY3e3Yx/tGuvtNNPwlgt6ZfOohsGVsUWKuDmCbzSHO6/HGfSjwiQ77n9UvxjOZQhOuwuq+yVu+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777038230; c=relaxed/simple;
	bh=ObikQVB//IjHqORbcXSZBzbrHibOeNbOgcg9e3ltelw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gCGx+WQ/GEdBYtXwO5x8wLeSbc4GoPLE+kg0vPOXLUIGcfg0vmNdZYT/BXgm9rF+LGirVEXvNWICG2bOZVJeZO7RmRJJaeH2Q6QnkQS4BMGkj4izH4Amf5cWeci3dCoyVtRPVeySCkrWywAlvBZyj7rLLqSy2ty6pTY2oOnHds4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z+H61YJg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z+H61YJg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6649BC19425;
	Fri, 24 Apr 2026 13:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777038230;
	bh=ObikQVB//IjHqORbcXSZBzbrHibOeNbOgcg9e3ltelw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z+H61YJgddGUFMI/RVZj4rqkpd3YUQSwtpe3rvCNLqTWYjv8oCdW6ZNCuC0dqFBMX
	 K9l0RcZRHFhtlQlBl/50uKTpMuEryP0W/y/kOVJmAT+ehU55dR4t/41eXw2H+zce2L
	 mNP0rXK2tVJaW/Ty+yDBDUVlKVONP4dPzhVu5PHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 19/35] ksmbd: require minimum ACE size in smb_check_perm_dacl()
Date: Fri, 24 Apr 2026 15:31:26 +0200
Message-ID: <20260424132415.724156906@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132411.427029259@linuxfoundation.org>
References: <20260424132411.427029259@linuxfoundation.org>
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

From: Michael Bommarito <michael.bommarito@gmail.com>

commit d07b26f39246a82399661936dd0c853983cfade7 upstream.

Both ACE-walk loops in smb_check_perm_dacl() only guard against an
under-sized remaining buffer, not against an ACE whose declared
`ace->size` is smaller than the struct it claims to describe:

  if (offsetof(struct smb_ace, access_req) > aces_size)
      break;
  ace_size = le16_to_cpu(ace->size);
  if (ace_size > aces_size)
      break;

The first check only requires the 4-byte ACE header to be in bounds;
it does not require access_req (4 bytes at offset 4) to be readable.
An attacker who has set a crafted DACL on a file they own can declare
ace->size == 4 with aces_size == 4, pass both checks, and then

  granted |= le32_to_cpu(ace->access_req);               /* upper loop */
  compare_sids(&sid, &ace->sid);                         /* lower loop */

reads access_req at offset 4 (OOB by up to 4 bytes) and ace->sid at
offset 8 (OOB by up to CIFS_SID_BASE_SIZE + SID_MAX_SUB_AUTHORITIES
* 4 bytes).

Tighten both loops to require

  ace_size >= offsetof(struct smb_ace, sid) + CIFS_SID_BASE_SIZE

which is the smallest valid on-wire ACE layout (4-byte header +
4-byte access_req + 8-byte sid base with zero sub-auths).  Also
reject ACEs whose sid.num_subauth exceeds SID_MAX_SUB_AUTHORITIES
before letting compare_sids() dereference sub_auth[] entries.

parse_sec_desc() already enforces an equivalent check (lines 441-448);
smb_check_perm_dacl() simply grew weaker validation over time.

Reachability: authenticated SMB client with permission to set an ACL
on a file.  On a subsequent CREATE against that file, the kernel
walks the stored DACL via smb_check_perm_dacl() and triggers the
OOB read.  Not pre-auth, and the OOB read is not reflected to the
attacker, but KASAN reports and kernel state corruption are
possible.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-6
Assisted-by: Codex:gpt-5-4
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smbacl.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1342,10 +1342,13 @@ int smb_check_perm_dacl(struct ksmbd_con
 		ace = (struct smb_ace *)((char *)pdacl + sizeof(struct smb_acl));
 		aces_size = acl_size - sizeof(struct smb_acl);
 		for (i = 0; i < le16_to_cpu(pdacl->num_aces); i++) {
-			if (offsetof(struct smb_ace, access_req) > aces_size)
+			if (offsetof(struct smb_ace, sid) +
+			    aces_size < CIFS_SID_BASE_SIZE)
 				break;
 			ace_size = le16_to_cpu(ace->size);
-			if (ace_size > aces_size)
+			if (ace_size > aces_size ||
+			    ace_size < offsetof(struct smb_ace, sid) +
+				       CIFS_SID_BASE_SIZE)
 				break;
 			aces_size -= ace_size;
 			granted |= le32_to_cpu(ace->access_req);
@@ -1363,13 +1366,19 @@ int smb_check_perm_dacl(struct ksmbd_con
 	ace = (struct smb_ace *)((char *)pdacl + sizeof(struct smb_acl));
 	aces_size = acl_size - sizeof(struct smb_acl);
 	for (i = 0; i < le16_to_cpu(pdacl->num_aces); i++) {
-		if (offsetof(struct smb_ace, access_req) > aces_size)
+		if (offsetof(struct smb_ace, sid) +
+		    aces_size < CIFS_SID_BASE_SIZE)
 			break;
 		ace_size = le16_to_cpu(ace->size);
-		if (ace_size > aces_size)
+		if (ace_size > aces_size ||
+		    ace_size < offsetof(struct smb_ace, sid) +
+			       CIFS_SID_BASE_SIZE)
 			break;
 		aces_size -= ace_size;
 
+		if (ace->sid.num_subauth > SID_MAX_SUB_AUTHORITIES)
+			break;
+
 		if (!compare_sids(&sid, &ace->sid) ||
 		    !compare_sids(&sid_unix_NFS_mode, &ace->sid)) {
 			found = 1;


