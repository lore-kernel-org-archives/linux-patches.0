Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5A930C143;
	Thu, 30 Jul 2026 15:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426543; cv=none; b=IsiJSFa8wc43BU+QJayw5zpAAFnLzL2lmZZbG/OvVI5chjs+U1c5UiX1mhhofDVnKwXTthvqFYTjTouJMLLHVUCRrHFmf2t1da92Ck3SkdDOSiEQYsj5r/wyExDaI/UFyiL9/KUakgfz0Hx/CoW+ZGQGB3l6rMRtBQefDUEhNrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426543; c=relaxed/simple;
	bh=nPQJP2E11s6B598kkoHTthNKutkR6GkDq3BTiGAvoFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LfnZKZplg8OtUCsucD09QvgCU09GgED8ewuq5fanD5Fyc+7ptwjoDfDqDaoLPS107uJrwsV9mnAJc69J88TLJPx2B9r+scl2Vqmr5MWY3+177hmrij5Q+Io6WUB38OvTGRoORYN6L9LarBqQvck2+oXRVZaCOUSPqIxoo8zbMJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tia5X8Nj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tia5X8Nj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F7121F000E9;
	Thu, 30 Jul 2026 15:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426541;
	bh=PK4TTc/UfMPjKEOGyBeq9oHcptrZouznwDkpdJSU/8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tia5X8NjQq1Dafw4dcTYO2salRSFwWgbXDRQLDANcQIAk6QqXSW30htSBGAUZWR2M
	 WypCFiuc5nBeLdMow+JWquQoz0N81ExOIJaby6ZH+9rYLQcpzqItILCCq4jvxlO8Uj
	 bvQr7GnnngFAV16pqJwxcDEokFaG2/l9UtKU88qs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Wentao Guan <guanwentao@uniontech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 455/602] ksmbd: bound DACL dedup walk to copied ACEs
Date: Thu, 30 Jul 2026 16:14:07 +0200
Message-ID: <20260730141445.520228900@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

commit 58d97fcd0bf1aee694e244cc28635b9df95b543b upstream.

set_ntacl_dacl() can stop copying ACEs before consuming the full input
DACL when size accounting overflows.

When that happens, num_aces reflects only the ACEs that were actually
copied into the output DACL, but set_posix_acl_entries_dacl() still
receives nt_num_aces and uses it to walk the existing ACE array during
dedup.

That makes the dedup walk scan past the copied ACE array and inspect
buffer tail that does not contain valid ACEs.

Split the two meanings currently carried by the NT ACE count. Pass the
number of copied NT ACEs to bound the dedup walk, and preserve the
original "input DACL had NT ACEs" state separately for the
Everyone/default ACL fallback.

This keeps the dedup walk aligned with the ACEs that are actually
present in the rebuilt DACL.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smbacl.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index ca0e4aab6dd87f..b0677e095c3292 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -595,7 +595,8 @@ static void parse_dacl(struct mnt_idmap *idmap,
 static void set_posix_acl_entries_dacl(struct mnt_idmap *idmap,
 				       struct smb_ace *pndace,
 				       struct smb_fattr *fattr, u16 *num_aces,
-				       u16 *size, u32 nt_aces_num)
+				       u16 *size, u16 existing_nt_aces,
+				       bool had_nt_aces)
 {
 	struct posix_acl_entry *pace;
 	struct smb_sid *sid;
@@ -627,14 +628,14 @@ static void set_posix_acl_entries_dacl(struct mnt_idmap *idmap,
 
 			gid = posix_acl_gid_translate(idmap, pace);
 			id_to_sid(gid, SIDUNIX_GROUP, sid);
-		} else if (pace->e_tag == ACL_OTHER && !nt_aces_num) {
+		} else if (pace->e_tag == ACL_OTHER && !had_nt_aces) {
 			smb_copy_sid(sid, &sid_everyone);
 		} else {
 			kfree(sid);
 			continue;
 		}
 		ntace = pndace;
-		for (j = 0; j < nt_aces_num; j++) {
+		for (j = 0; j < existing_nt_aces; j++) {
 			if (ntace->sid.sub_auth[ntace->sid.num_subauth - 1] ==
 					sid->sub_auth[sid->num_subauth - 1])
 				goto pass_same_sid;
@@ -678,7 +679,7 @@ static void set_posix_acl_entries_dacl(struct mnt_idmap *idmap,
 		kfree(sid);
 	}
 
-	if (nt_aces_num)
+	if (had_nt_aces)
 		return;
 
 posix_default_acl:
@@ -732,6 +733,7 @@ static void set_ntacl_dacl(struct mnt_idmap *idmap,
 {
 	struct smb_ace *ntace, *pndace;
 	u16 nt_num_aces = le16_to_cpu(nt_dacl->num_aces), num_aces = 0;
+	u16 copied_nt_aces;
 	unsigned short size = 0;
 	int i;
 
@@ -765,8 +767,10 @@ static void set_ntacl_dacl(struct mnt_idmap *idmap,
 		}
 	}
 
+	copied_nt_aces = num_aces;
 	set_posix_acl_entries_dacl(idmap, pndace, fattr,
-				   &num_aces, &size, nt_num_aces);
+				   &num_aces, &size, copied_nt_aces,
+				   nt_num_aces != 0);
 	pndacl->num_aces = cpu_to_le16(num_aces);
 	pndacl->size = cpu_to_le16(le16_to_cpu(pndacl->size) + size);
 }
@@ -784,7 +788,7 @@ static void set_mode_dacl(struct mnt_idmap *idmap,
 
 	if (fattr->cf_acls) {
 		set_posix_acl_entries_dacl(idmap, pndace, fattr,
-					   &num_aces, &size, num_aces);
+					   &num_aces, &size, num_aces, false);
 		goto out;
 	}
 
-- 
2.53.0



