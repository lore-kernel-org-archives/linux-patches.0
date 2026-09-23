Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E0B47A88C;
	Wed, 23 Sep 2026 14:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175198; cv=none; b=Smmf0lP6UMEi3P4aDYKA/TwYQxMH9szuQRVBeHoe1J2q5sZbK+DNiScSbVYpMRAnRsDnj6Oi1IGW2AUTB9s4rJgXWeancfblvV2LkLE/XmpTnk+orcaPEEPDBXKjNNLU/gWTzoLf3VQK3uXnyDyo7vJ/DSLeahed7kqlg85fTU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175198; c=relaxed/simple;
	bh=vqjGcraLFL+A4Ghy/E0ZliTHf9ARZ1M0oxBYwhDwjHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TDWyiu1ZcbrBAtOQJzpxyHg141Zh3UDC73mLMsDdu/yl1CHb2iIZduUsYnZk1L/yBHvSyJpvJscLHvxcEWxiwmP0RS18i1RA7yhofygvhGLdIMP3Odxl97FprQt89kENgMTeM/1hVCCiEh0qG/ap+aH8bsmH5zvvgK91NzeNJh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DfqMO56l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DfqMO56l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 988831F000FF;
	Wed, 23 Sep 2026 14:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175197;
	bh=BFmB7ULHW7MK4tiLTXxtjN+VlWRC7OtvMXLtnr1ijm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DfqMO56l04EynM7onddF+l7tE3MHQtnEjgrxHnwDkUAug/Tr5dpvkvL0iGTpHmkVf
	 /TnDvr2UURQNRGnnVCVl2/6K20+9ti20vqg7DKOZ5rNEIszW558ZhpT3EFK9/Nev+z
	 V2voHAZoyexU9nBlg6vxcxsq6331EPAlkI45yRd8=
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
Subject: [PATCH 6.18 350/398] smb: client: fix unaligned access in WSL reparse point parser
Date: Wed, 23 Sep 2026 16:07:04 +0200
Message-ID: <20260923140652.504258386@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1156,9 +1156,9 @@ static bool wsl_to_fattr(struct cifs_ope
 			fattr->cf_gid = wsl_make_kgid(cifs_sb, v);
 		else if (!strncmp(name, SMB2_WSL_XATTR_MODE, nlen)) {
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
 
@@ -22,7 +23,7 @@
 
 static inline dev_t reparse_mkdev(void *ptr)
 {
-	u64 v = le64_to_cpu(*(__le64 *)ptr);
+	u64 v = get_unaligned_le64(ptr);
 
 	return MKDEV(v & 0xffffffff, v >> 32);
 }
@@ -30,7 +31,7 @@ static inline dev_t reparse_mkdev(void *
 static inline kuid_t wsl_make_kuid(struct cifs_sb_info *cifs_sb,
 				   void *ptr)
 {
-	u32 uid = le32_to_cpu(*(__le32 *)ptr);
+	u32 uid = get_unaligned_le32(ptr);
 
 	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_OVERR_UID)
 		return cifs_sb->ctx->linux_uid;
@@ -40,7 +41,7 @@ static inline kuid_t wsl_make_kuid(struc
 static inline kgid_t wsl_make_kgid(struct cifs_sb_info *cifs_sb,
 				   void *ptr)
 {
-	u32 gid = le32_to_cpu(*(__le32 *)ptr);
+	u32 gid = get_unaligned_le32(ptr);
 
 	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_OVERR_GID)
 		return cifs_sb->ctx->linux_gid;


