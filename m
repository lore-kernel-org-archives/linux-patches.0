Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD0EA414413;
	Wed, 23 Sep 2026 14:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173062; cv=none; b=StuFnyLzybgReoJx35p4dmRHQcJlbWjefcZj/y+nq+OmtnENrcXVq9wBw4HephdRLp7T6iovwKW6HJR8VjZ8iLJ5uhiXzbGUWX5PD1A7vrzOjL6AHBfm8tDXlJEzpICZonZ108ICaylrYvugsarykCQUVwcAcqF44ZVqC2Ol75o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173062; c=relaxed/simple;
	bh=r1sPVIu2yLu64IU6ernWB0y8h41be6CPRlrLvX/zZKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QAQVxb2kKg319iwOv6xJgFMaav0HPw5gQJLIJ39IlB57xfuKsrpOAqZqyfhwXjTXa/MJ1kLKGdt1UFQsUp5gLduz5/9A1zcONcWVc1wUolGIXAxqzEsoPXjrtAdw8EFx5aor5iXCJPXAX5CYtA+JXF8R2FXtVvkvNzmMSefIwLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vqSuSZiY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vqSuSZiY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F8951F000FF;
	Wed, 23 Sep 2026 14:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173061;
	bh=rET1Yze1cUqYus5NojZKMz2kaqzUnPJA6y8iUimsauE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vqSuSZiYHF/UdslZRxglxatMugrDHkfgmGeQPzUf/LowBQ4BPamjRemW2DxHQLlBY
	 Z2TQrURO7kXXdHP2jsixCDNQi9cBA4yVEeoYcwKE+WmBfhUmgbEGqo9oob5o4X2Wax
	 IqMCRdxKpyTEwgOZy3KmBNeXFQ6qhBV6W/GQu2iI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 113/438] smb: client: validate absolute native symlink targets before NT fixups
Date: Wed, 23 Sep 2026 16:02:14 +0200
Message-ID: <20260923140647.709374247@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

[ Upstream commit 23c240d9509e15f72e4112fc95f0160ab32ec430 ]

With symlinkroot unset, an absolute target is copied without conversion
to an NT drive path. Later code still assumes an NT prefix is present
when modifying the target and calculating the print name length.

For "/ab", this causes two failures: sym[5] and path[5] are written
past their allocations, and plen -= 2 * poff subtracts an assumed
8-byte prefix from a 6-byte UTF-16 target, wrapping u16 plen to 65534.
That underflow causes another overflow: memcpy() copies 65534 bytes
into a 24-byte buffer. A user with write access to a mounted share
can trigger these bugs with default settings.

Validate the NT drive prefix, including an ASCII drive letter, before
accessing fixed offsets or subtracting the prefix length.

Fixes: 3363da82e02f ("smb: client: fix native SMB symlink traversal")
Assisted-by: Codex:gpt-5
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/reparse.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 8a1b9e8be5ba7..9e31fce7e0a52 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -3,6 +3,7 @@
  * Copyright (c) 2024 Paulo Alcantara <pc@manguebit.com>
  */
 
+#include <linux/ctype.h>
 #include <linux/fs.h>
 #include <linux/stat.h>
 #include <linux/slab.h>
@@ -159,15 +160,24 @@ static int create_native_symlink(const unsigned int xid, struct inode *inode,
 		convert_delimiter(sym, sep);
 
 	/*
-	 * For absolute NT symlinks it is required to pass also leading
-	 * backslash and to not mangle NT object prefix "\\??\\" and not to
-	 * mangle colon in drive letter. But cifs_convert_path_to_utf16()
-	 * removes leading backslash and replaces '?' and ':'. So temporary
-	 * mask these characters in NT object prefix by '_' and then change
-	 * them back.
+	 * Absolute NT symlinks must retain the leading backslash, "\\??\\"
+	 * prefix and drive-letter colon. cifs_convert_path_to_utf16() strips
+	 * the leading backslash and maps '?' and ':', so temporarily mask
+	 * these characters with '_' and restore them after conversion.
+	 *
+	 * When symlinkroot is unset, sym comes directly from the caller.
+	 * Validate the complete "\\??\\X:" prefix before using fixed offsets
+	 * or subtracting the NT prefix length below. Require an ASCII drive
+	 * letter so the prefix occupies six characters in UTF-16 too.
 	 */
-	if (!(sbflags & CIFS_MOUNT_POSIX_PATHS) && symname[0] == '/')
+	if (!(sbflags & CIFS_MOUNT_POSIX_PATHS) && symname[0] == '/') {
+		if (!strstarts(sym, "\\??\\") || !isascii(sym[4]) ||
+		    !isalpha(sym[4]) || sym[5] != ':') {
+			rc = -EINVAL;
+			goto out;
+		}
 		sym[0] = sym[1] = sym[2] = sym[5] = '_';
+	}
 
 	/*
 	 * On a POSIX paths mount the symlink target is stored verbatim, so
-- 
2.53.0



