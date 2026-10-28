Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215299;
	b=QiXUbsMRZjs2O5z9YPsitbM+9c2b05NJRyUkowSzWXAl3qTOmtmmlloCXZTLcJWoYsAV
	 Zrz9k7klt1DfB7ye8DwvxzeXJrQVTnnarSSL5rE/PSx4hy/U6Lv66fTHlXcIBT2k7N/iU
	 Hvffm7h3avuMVVE2T24YqRVTgr8kf0wxU+jxyvxdtQ8EjXGlsWYJC44iD9JaaV1mqJtqi
	 eFL15i8/J05h4kfLQbfw3nEPFMp/u+kk0dvQxLDcqBi+ECrIt3nEvN/SNkApFMUjNHGq+
	 wxybohdjeyQAd79h3yXUz6tKyrd8wTOMxokQ9Tz1wlERxe9KymSIDYL5VNip3AJC9NQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215299;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3ifinxE8yYbi/9+kaT1CTfLdJvqXWPBgWlr0d+clNhk=;
	b=fDR7FWB9SnfNG/3EXhRAUzpoCgGcovaTJVwUbFJ8KhWKjzXr53S4XqNXJbQLFGkwahb+
	 6wPCAFOJVF3yODeXofuABBKo8r2vVd8kwvKn9UBiHIOOX3pUBYF0x1zUXF7o0zj2u+W7V
	 PhEBiam8xB/jRarobYjHx+psBuPsmsk2BF6Rpu/xZV52R+uR7+xrrQ+Gj+otZlqdGmz/P
	 nb51l7FnVOUt1GgI4i++TIfZwZgNwHfWbEA0SyckuSKm+MD+35bitdqcORx20ONSNZbaJ
	 Nw2pnmlvd5uCSTcHSgrNdb0VhMxF/qXZYmUpkAIVOkRc7SgnpPnPX0cCjZmV3sURO2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="TE8PEye/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7B94606A31E;
	Wed, 28 Oct 2026 19:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TE8PEye/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB9411F01825;
	Wed, 28 Oct 2026 19:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215298;
	bh=3ifinxE8yYbi/9+kaT1CTfLdJvqXWPBgWlr0d+clNhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TE8PEye/6cCv8xfkANsWDDNg8DDPdEvMxQjlumBHFSVOe2ppgetWV+wTLAkTtg19b
	 Z1CTrJuiX9zW1MqBUDxuKCfoJIv/vVmrC4vpuuh0h3d6/ZKmqYdS+gPa5p4YJZeVza
	 G3RtEt3dOd1vZR0Yw2GsyzDKNzv21BKZ54FqdcIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1162/1887] ksmbd: bound DACL dedup walk to copied ACEs
Date: Wed, 28 Oct 2026 17:54:18 +0100
Message-ID: <20261028170525.847997019@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 58d97fcd0bf1aee694e244cc28635b9df95b543b ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smbacl.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index c8f50de252042..2209e7e655744 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -603,7 +603,8 @@ static void parse_dacl(struct user_namespace *user_ns,
 static void set_posix_acl_entries_dacl(struct user_namespace *user_ns,
 				       struct smb_ace *pndace,
 				       struct smb_fattr *fattr, u32 *num_aces,
-				       u16 *size, u32 nt_aces_num)
+				       u16 *size, u32 existing_nt_aces,
+				       bool had_nt_aces)
 {
 	struct posix_acl_entry *pace;
 	struct smb_sid *sid;
@@ -635,14 +636,14 @@ static void set_posix_acl_entries_dacl(struct user_namespace *user_ns,
 
 			gid = posix_acl_gid_translate(user_ns, pace);
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
@@ -686,7 +687,7 @@ static void set_posix_acl_entries_dacl(struct user_namespace *user_ns,
 		kfree(sid);
 	}
 
-	if (nt_aces_num)
+	if (had_nt_aces)
 		return;
 
 posix_default_acl:
@@ -740,6 +741,7 @@ static void set_ntacl_dacl(struct user_namespace *user_ns,
 {
 	struct smb_ace *ntace, *pndace;
 	int nt_num_aces = le32_to_cpu(nt_dacl->num_aces), num_aces = 0;
+	u32 copied_nt_aces;
 	unsigned short size = 0;
 	int i;
 
@@ -780,8 +782,10 @@ static void set_ntacl_dacl(struct user_namespace *user_ns,
 		}
 	}
 
+	copied_nt_aces = num_aces;
 	set_posix_acl_entries_dacl(user_ns, pndace, fattr,
-				   &num_aces, &size, nt_num_aces);
+				   &num_aces, &size, copied_nt_aces,
+				   nt_num_aces != 0);
 	pndacl->num_aces = cpu_to_le32(num_aces);
 	pndacl->size = cpu_to_le16(le16_to_cpu(pndacl->size) + size);
 }
@@ -799,7 +803,7 @@ static void set_mode_dacl(struct user_namespace *user_ns,
 
 	if (fattr->cf_acls) {
 		set_posix_acl_entries_dacl(user_ns, pndace, fattr,
-					   &num_aces, &size, num_aces);
+					   &num_aces, &size, num_aces, false);
 		goto out;
 	}
 
-- 
2.53.0



