Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D34463A380C;
	Sat, 17 Oct 2026 18:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260756; cv=none; b=AG+ByNumq9ssTc5V4h1ttuNTINaDAe4wKGjM46bFV6uehxoh/vhmx6wC8qLWoYTslaRVu65ulrPUD79EPLpQXTzEOlc2sXK818y2mEAqXN1ti57jJ5Aqfjz7v6wZyOOXzcNn8+VBawuVvW21RcFVEVTvMGvKtu71iQyzAyiQyYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260756; c=relaxed/simple;
	bh=2H3Gg+yWwB/0Rsym0UAV+cvBQ3IbcUbQs1Q4LxFc5G8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nj3z/kId3AqEmVNO6EfNjV/nGz82za5J6IT0eiVN/5QCFtKdgGZkjR9UETut/Z2GQKxZEokcONWaSPA3ZeE4VbEMKniQ1rPPu3Hi33xawCJzKZ1FNp2HCs8dhWVhneYmcWVWBg1UGEk3+ZaguM7mrm6KVvyuIvbV/5EGDv3kydg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rGsYjpqK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rGsYjpqK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29CAE1F000C4;
	Sat, 17 Oct 2026 18:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260755;
	bh=yX4NsP1RXPuSQQX7M3VyK6MoXk9+GN6HJmAX9NHuF9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rGsYjpqKZz4UbczOLZR/M6FBZsSMy2qPmE9w0FUmT7M+DEpWtS/k16kZFHroRbLRP
	 RZlP8oqM3mTouKHXPQLAVsoBQn/q35XK0grYXDIedRZSnGiGTVmFoi8z6Z7EE9U6IS
	 IY0OAaS5WGiR/QJdPHUvgrbuKT8duwGBbk/luWeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheryl Babcock <cheryl@renat.io>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1650/1674] ksmbd: propagate DACL parsing errors
Date: Sat, 17 Oct 2026 18:05:22 +0200
Message-ID: <20261017160513.422544630@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
index 8f206061c91a0..da7bf23a2db0d 100644
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
 
 	ppace = kmalloc_array(num_aces, sizeof(struct smb_ace *), GFP_KERNEL);
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
 					acl_state.groups->n + 4, GFP_KERNEL);
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
 				default_acl_state.groups->n + 4, GFP_KERNEL);
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



