Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6AB46D2B9;
	Tue, 21 Jul 2026 17:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653770; cv=none; b=DLvaWF0LRhTc7cg9g07Ml1SQrr99kKnjXqtOylnReCX1+MjZIUhM9hcY+jFvzqIcWkvBQGPBrfSzSKV1W9SjwuNFXe/2FZpYYDZkIn3GRy+E4cIiQgIezAz9rxISluuLIpLKtF+AZ15BynIzFk+kWWLDi3WKRidj2LzL/dOZd4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653770; c=relaxed/simple;
	bh=ZFRCPKxA0LSF5UdCiHltw6GOt/7KrH+sWV0V+ZCd3sk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iOg2nNuPM84Mt6WmNciHZpNXk7M+Hv1GxDzbVD6m9pJj3izMlyK/cZe59Xm11QPvi2O2RXFTJo1q3K/La6pfPcJoaCXE+GRA5ZXvLHlX+zpzBAO6/XbtAeZAcGhEfFGG0NkiAc9y8G1pngpQ3XaUFK371k23Ffl6bJyKpYCBnUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zh+vPNGA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zh+vPNGA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E3191F00A3D;
	Tue, 21 Jul 2026 17:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653768;
	bh=qUXDAUpeP0MIq071a6k02ISKg0aWsjEzhJ2eSgPn1K4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zh+vPNGADMIP4gHeK8XO99rEiAAhax2WBoEYLJgv8y7ZR72iiXa0lPeGP9CmChQyy
	 fgReMSB25MsAjEGz8Cdwsqd72lVyrRZDGZMuTs1/TMM/IeXH0jftbNuygBmlpDFjqc
	 VSG3krUOSmK7b1cUq/3kQxrNnVVdpB826X2BtJZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Ralph Boehme <slow@samba.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1452/2077] smb: client: preserve leading slash for POSIX absolute symlink targets
Date: Tue, 21 Jul 2026 17:18:45 +0200
Message-ID: <20260721152627.046644705@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve French <stfrench@microsoft.com>

[ Upstream commit dce002f685e04e0c94e088cb66cb4021311cc6b5 ]

When creating a native SMB symbolic link (CIFS_SYMLINK_TYPE_NATIVE) whose
target is an absolute path on a mount that uses POSIX paths, the leading
path separator was silently dropped from the stored symlink target.

create_native_symlink() converted the target to UTF-16 with
cifs_convert_path_to_utf16().  That helper was intended for share-relative
SMB paths and therefore unconditionally strips a leading path separator.
For an absolute POSIX symlink target the leading '/' is significant, so a
target of "/foo/bar" was stored and read back as "foo/bar", even
though the reparse point was still flagged as absolute
(SYMLINK_FLAG_RELATIVE cleared).

On a POSIX paths mount the symlink target is stored verbatim, so convert
it directly with cifs_strndup_to_utf16() instead.  This preserves the
leading separator, avoids the leading-backslash stripping that
cifs_convert_path_to_utf16() also performs (a backslash is a valid POSIX
filename character), and uses NO_MAP_UNI_RSVD to match the readback path
in smb2_parse_native_symlink(), which always converts the target with
cifs_strndup_from_utf16() / NO_MAP_UNI_RSVD.  This mirrors how the NFS and
WSL reparse symlink creators convert their targets.

The NT-style absolute symlink handling, which needs the "\??\" prefix and
drive-letter colon preserved, continues to use cifs_convert_path_to_utf16()
together with the existing masking of those bytes.

Fixes: 12b466eb52d9 ("cifs: Fix creating and resolving absolute NT-style symlinks")
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Acked-by: Ralph Boehme <slow@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/reparse.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index cd1e1eaee67a6b..5cc5b0410d4894 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -67,6 +67,7 @@ static int create_native_symlink(const unsigned int xid, struct inode *inode,
 	char *sym = NULL;
 	struct kvec iov;
 	bool directory;
+	int path_len;
 	int rc = 0;
 
 	if (strlen(symname) > REPARSE_SYM_PATH_MAX)
@@ -168,7 +169,21 @@ static int create_native_symlink(const unsigned int xid, struct inode *inode,
 	if (!(sbflags & CIFS_MOUNT_POSIX_PATHS) && symname[0] == '/')
 		sym[0] = sym[1] = sym[2] = sym[5] = '_';
 
-	path = cifs_convert_path_to_utf16(sym, cifs_sb);
+	/*
+	 * On a POSIX paths mount the symlink target is stored verbatim, so
+	 * convert it with cifs_strndup_to_utf16().  cifs_convert_path_to_utf16()
+	 * must not be used here: it strips a leading path separator (it is
+	 * meant for share-relative SMB paths), which would corrupt an absolute
+	 * POSIX symlink target such as "/foo/bar".  Using NO_MAP_UNI_RSVD also
+	 * matches the readback path in smb2_parse_native_symlink().
+	 */
+	if (sbflags & CIFS_MOUNT_POSIX_PATHS)
+		path = cifs_strndup_to_utf16(sym, strlen(sym), &path_len,
+					     cifs_sb->local_nls,
+					     NO_MAP_UNI_RSVD);
+	else
+		path = cifs_convert_path_to_utf16(sym, cifs_sb);
+
 	if (!path) {
 		rc = -ENOMEM;
 		goto out;
-- 
2.53.0



