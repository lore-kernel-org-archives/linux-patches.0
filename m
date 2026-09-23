Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34A73A255A;
	Wed, 23 Sep 2026 14:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174048; cv=none; b=RnRkQ0y0xLxNfger57SLrRtXvlan/L+yAftUnRnx24aslVoH1KwRw/gpoFYxzh+K6c+14Y11SOmGUstG5re74MXpj45MXihpPz3teOiYHHrHO6wK3+V8nNkZqhIw63XPgrntF6andnEJzMsFf86pUXSYy6azZHH0uDAjbLi1V1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174048; c=relaxed/simple;
	bh=zGKZVDdlmq+1qRR+fQ3z0dOJ0X3XRu81LFzJGJW6Frs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ln8lL2wXFG7L6Cnk4JfETBgH2rbuIQ4T/fTmenXowSyH2h6BbKkzpUpMu4Aa51z7GZbL/mxWxae8i7hYJyTS7HSf6SEfQfq2jDTT1Czq5Ldi9KQxUZ3Ts2EJS+A9diY2cIj8XKRHNX6UAssyiAoh+piX2ethlf2IA56LrrVdiA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FcmLmHwI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FcmLmHwI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53C8A1F000FF;
	Wed, 23 Sep 2026 14:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174046;
	bh=+ahyLUPyEkxC60sTZWDMsC+oUsLYsgd5qu/0m5WC9ic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FcmLmHwIHbbJj5KqcUXVsTBBooKGbK0HrFjRoG27qCDTGmr/eUIMtklJwyvewFzr/
	 CXo5EVVzM2K8Eiovy62HiiM13ITu0epxLfhebpC3zwS/zcfOX66is63HBWKBM6KwyO
	 ygP4tKsmOcEr3RjDki15aZOQUmY2yOYU/pkb7pcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	Tom Talpey <tom@talpey.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH 7.2 419/438] smb: client: fix unaligned access in WSL reparse point parser
Date: Wed, 23 Sep 2026 16:07:20 +0200
Message-ID: <20260923140655.771849660@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

From: Paulo Alcantara <pc@manguebit.org>

commit e1aeaf79dea51e6065da56924bc07e22d59012ac upstream.

When wsl_to_fattr() parses WSL extended attributes, it computes a
payload pointer from ea->ea_data + ea_name_length + 1.  Since the
smb2_file_full_ea_info struct is __packed and all WSL xattr names are
6 bytes long, the value pointer always lands at an odd byte offset,
never satisfying __le32 or __le64 alignment requirements.

The code then casts this pointer to __le32 * or __le64 * and
dereferences it directly, which may cause alignment faults on some
architectures.

Replace all such casts with get_unaligned_le32() and
get_unaligned_le64() in reparse_mkdev(), wsl_make_kuid(),
wsl_make_kgid() and wsl_to_fattr().

Closes: https://sashiko.dev/#/patchset/20260906200517.725015-1-pc%40manguebit.org
Fixes: 78e26bec4d6d ("smb: client: parse uid, gid, mode and dev from WSL reparse points")
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/reparse.c |    4 ++--
 fs/smb/client/reparse.h |    7 ++++---
 2 files changed, 6 insertions(+), 5 deletions(-)

--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -1201,9 +1201,9 @@ static bool wsl_to_fattr(struct cifs_ope
 				fattr->cf_gid = wsl_make_kgid(cifs_sb, v);
 		} else if (!strncmp(name, SMB2_WSL_XATTR_MODE, nlen)) {
 			/* File type in reparse point tag and in xattr mode must match. */
-			if (S_DT(fattr->cf_mode) != S_DT(le32_to_cpu(*(__le32 *)v)))
+			if (S_DT(fattr->cf_mode) != S_DT(get_unaligned_le32(v)))
 				return false;
-			fattr->cf_mode = (umode_t)le32_to_cpu(*(__le32 *)v);
+			fattr->cf_mode = (umode_t)get_unaligned_le32(v);
 		} else if (!strncmp(name, SMB2_WSL_XATTR_DEV, nlen)) {
 			fattr->cf_rdev = reparse_mkdev(v);
 			have_xattr_dev = true;
--- a/fs/smb/client/reparse.h
+++ b/fs/smb/client/reparse.h
@@ -9,6 +9,7 @@
 #include <linux/fs.h>
 #include <linux/stat.h>
 #include <linux/uidgid.h>
+#include <linux/unaligned.h>
 #include "fs_context.h"
 #include "cifsglob.h"
 #include "../common/smbfsctl.h"
@@ -23,7 +24,7 @@
 
 static inline dev_t reparse_mkdev(void *ptr)
 {
-	u64 v = le64_to_cpu(*(__le64 *)ptr);
+	u64 v = get_unaligned_le64(ptr);
 
 	return MKDEV(v & 0xffffffff, v >> 32);
 }
@@ -31,7 +32,7 @@ static inline dev_t reparse_mkdev(void *
 static inline kuid_t wsl_make_kuid(struct cifs_sb_info *cifs_sb,
 				   void *ptr)
 {
-	u32 uid = le32_to_cpu(*(__le32 *)ptr);
+	u32 uid = get_unaligned_le32(ptr);
 
 	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_OVERR_UID)
 		return cifs_sb->ctx->linux_uid;
@@ -41,7 +42,7 @@ static inline kuid_t wsl_make_kuid(struc
 static inline kgid_t wsl_make_kgid(struct cifs_sb_info *cifs_sb,
 				   void *ptr)
 {
-	u32 gid = le32_to_cpu(*(__le32 *)ptr);
+	u32 gid = get_unaligned_le32(ptr);
 
 	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_OVERR_GID)
 		return cifs_sb->ctx->linux_gid;


