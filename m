Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B67274CDDF6;
	Thu, 17 Sep 2026 15:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658973; cv=none; b=u3Ypsq/2M89pyGyaUR5J82TOnlgMmWiOrgOz3Kp3tROKM18/O4YUsgdL99+9CP5/ZBQo/EF1uvehVmnYFfVjT/PwnZNOqd//3ksc3przwmEwaBAixiA04r9wLMn0Cqy+XFxPXwWUigzEFcXu520I/ojVX2VcvxsVxyuNexb4a9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658973; c=relaxed/simple;
	bh=IMXJ85yWtZUjJXaQkZW85OKWyDNG+Hg/Gtw4RCbKzpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=poBqRcifKhztpvAVSgJtvgtfQhSrkblu4UpX8OkI/fZEbx3SGwo83JVXSTGbK3sd25+gGjhisr16wmrfY3HW0Xrh02+OnSKkXT4OjS0UTCbmYTo9c6sKdTL8O8Bp7hKpMjGGOIyvG8hlvOK8g9kbHso6VmyEFD5Rsk28ygzSH/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PE1Dvgm6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PE1Dvgm6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31E371F0089A;
	Thu, 17 Sep 2026 15:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658962;
	bh=Pg/V1GkvuFW6X8P0O9x0m5LffmQ/XA0tZVRT9lrp2wU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PE1Dvgm69cymlpKAUWcu+/+q9meq873+1tpYoPgKxFx+TLoLmKEmskcOs+zFILFt2
	 kKqy+MNMrVc54isJHrEzlINHXzKXYjaQCGNIUkwbT85Z/x9IQ5f0/T/6cIre3BYOEp
	 E/nNK4nqdqn21JauJBBROzDzEclvHG7wIUc38M84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheryl Babcock <cheryl@renat.io>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 097/733] ksmbd: propagate DACL parsing errors
Date: Thu, 17 Sep 2026 16:06:45 +0100
Message-ID: <20260917151353.360927558@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit c61dc7b1b4a3234b4aa3965502908a292238805c ]

parse_dacl() silently accepts truncated ACEs and allocation failures,
allowing set_info_sec() to continue with an incomplete ACL conversion.

Return parsing and allocation errors to parse_sec_desc() so malformed
security descriptors are rejected before inode attributes or ACL xattrs
are updated.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Reported-by: Cheryl Babcock <cheryl@renat.io>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smbacl.c | 63 +++++++++++++++++++++++++-----------------
 1 file changed, 38 insertions(+), 25 deletions(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index 33825c1356b47..7830f4fa836bb 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -380,10 +380,10 @@ void free_acl_state(struct posix_acl_state *state)
 	kfree(state->groups);
 }
 
-static void parse_dacl(struct mnt_idmap *idmap,
-		       struct smb_acl *pdacl, char *end_of_acl,
-		       struct smb_sid *pownersid, struct smb_sid *pgrpsid,
-		       struct smb_fattr *fattr)
+static int parse_dacl(struct mnt_idmap *idmap,
+		      struct smb_acl *pdacl, char *end_of_acl,
+		      struct smb_sid *pownersid, struct smb_sid *pgrpsid,
+		      struct smb_fattr *fattr)
 {
 	int i, ret;
 	u16 num_aces = 0;
@@ -397,13 +397,13 @@ static void parse_dacl(struct mnt_idmap *idmap,
 	bool owner_found = false, group_found = false, others_found = false;
 
 	if (!pdacl)
-		return;
+		return 0;
 
 	/* validate that we do not go past end of acl */
 	if (end_of_acl < (char *)pdacl + sizeof(struct smb_acl) ||
 	    end_of_acl < (char *)pdacl + le16_to_cpu(pdacl->size)) {
 		pr_err("ACL too small to parse DACL\n");
-		return;
+		return -EINVAL;
 	}
 
 	ksmbd_debug(SMB, "DACL revision %d size %d num aces %d\n",
@@ -415,31 +415,31 @@ static void parse_dacl(struct mnt_idmap *idmap,
 
 	num_aces = le16_to_cpu(pdacl->num_aces);
 	if (num_aces <= 0)
-		return;
+		return 0;
 
 	dacl_size = le16_to_cpu(pdacl->size);
 	if (dacl_size < sizeof(struct smb_acl))
-		return;
+		return -EINVAL;
 
 	if (num_aces > (dacl_size - sizeof(struct smb_acl)) /
 			(offsetof(struct smb_ace, sid) +
 			 offsetof(struct smb_sid, sub_auth) + sizeof(__le16)))
-		return;
+		return -EINVAL;
 
 	ret = init_acl_state(&acl_state, num_aces);
 	if (ret)
-		return;
+		return ret;
 	ret = init_acl_state(&default_acl_state, num_aces);
 	if (ret) {
 		free_acl_state(&acl_state);
-		return;
+		return ret;
 	}
 
 	ppace = kmalloc_objs(struct smb_ace *, num_aces, KSMBD_DEFAULT_GFP);
 	if (!ppace) {
 		free_acl_state(&default_acl_state);
 		free_acl_state(&acl_state);
-		return;
+		return -ENOMEM;
 	}
 
 	/*
@@ -448,8 +448,10 @@ static void parse_dacl(struct mnt_idmap *idmap,
 	 * user/group/other have no permissions
 	 */
 	for (i = 0; i < num_aces; ++i) {
-		if (end_of_acl - acl_base < acl_size)
-			break;
+		if (end_of_acl - acl_base < acl_size) {
+			ret = -EINVAL;
+			goto out;
+		}
 
 		ppace[i] = (struct smb_ace *)(acl_base + acl_size);
 		acl_base = (char *)ppace[i];
@@ -462,8 +464,10 @@ static void parse_dacl(struct mnt_idmap *idmap,
 		    (end_of_acl - acl_base <
 		     acl_size + sizeof(__le32) * ppace[i]->sid.num_subauth) ||
 		    (le16_to_cpu(ppace[i]->size) <
-		     acl_size + sizeof(__le32) * ppace[i]->sid.num_subauth))
-			break;
+		     acl_size + sizeof(__le32) * ppace[i]->sid.num_subauth)) {
+			ret = -EINVAL;
+			goto out;
+		}
 
 		acl_size = le16_to_cpu(ppace[i]->size);
 		ppace[i]->access_req =
@@ -538,7 +542,6 @@ static void parse_dacl(struct mnt_idmap *idmap,
 				((acl_mode & 0700) >> 6) | 0004;
 		}
 	}
-	kfree(ppace);
 
 	if (owner_found) {
 		/* The owner must be set to at least read-only. */
@@ -581,10 +584,12 @@ static void parse_dacl(struct mnt_idmap *idmap,
 			fattr->cf_acls =
 				posix_acl_alloc(acl_state.users->n +
 					acl_state.groups->n + 4, KSMBD_DEFAULT_GFP);
-			if (fattr->cf_acls) {
-				cf_pace = fattr->cf_acls->a_entries;
-				posix_state_to_acl(&acl_state, cf_pace);
+			if (!fattr->cf_acls) {
+				ret = -ENOMEM;
+				goto out;
 			}
+			cf_pace = fattr->cf_acls->a_entries;
+			posix_state_to_acl(&acl_state, cf_pace);
 		}
 	}
 
@@ -595,14 +600,20 @@ static void parse_dacl(struct mnt_idmap *idmap,
 			fattr->cf_dacls =
 				posix_acl_alloc(default_acl_state.users->n +
 				default_acl_state.groups->n + 4, KSMBD_DEFAULT_GFP);
-			if (fattr->cf_dacls) {
-				cf_pdace = fattr->cf_dacls->a_entries;
-				posix_state_to_acl(&default_acl_state, cf_pdace);
+			if (!fattr->cf_dacls) {
+				ret = -ENOMEM;
+				goto out;
 			}
+			cf_pdace = fattr->cf_dacls->a_entries;
+			posix_state_to_acl(&default_acl_state, cf_pdace);
 		}
 	}
+	ret = 0;
+out:
+	kfree(ppace);
 	free_acl_state(&acl_state);
 	free_acl_state(&default_acl_state);
+	return ret;
 }
 
 static void set_posix_acl_entries_dacl(struct mnt_idmap *idmap,
@@ -963,8 +974,10 @@ int parse_sec_desc(struct mnt_idmap *idmap, struct smb_ntsd *pntsd,
 		if (dacloffset < sizeof(struct smb_ntsd))
 			return -EINVAL;
 
-		parse_dacl(idmap, dacl_ptr, end_of_acl,
-			   owner_sid_ptr, group_sid_ptr, fattr);
+		rc = parse_dacl(idmap, dacl_ptr, end_of_acl,
+				owner_sid_ptr, group_sid_ptr, fattr);
+		if (rc)
+			return rc;
 	}
 
 	return 0;
-- 
2.53.0



