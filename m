Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC65E34389C;
	Sat, 12 Sep 2026 09:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204573; cv=none; b=GPY/afIIsTP6hGqJpj4RQiHzpBvwO2JvbmO0zxS0vzgBQ300JhYV76bIHAg1Q1w1gLTU+6BZPne7d0pZdSKGCEraslqqZosnOyxJrsC5ftZjrzWZcMKswnv7Y+sPM7+ji8Ww/Kw22fbAnpbWUBbzQv2+LyJjuOC93v8qfD8folc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204573; c=relaxed/simple;
	bh=F+eH3RRJTfyO/BINUHZU1Q/3ypFi3Z5ME/7D1I7m5TY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VwyiL0xxHqxj0qApKAqsVhChhBHiB4D/eZMOI9V769meWoxqY9N+dD8Rx9kr2HpicQZDefnGxD/k/22NbNonmKkoo3YU+jWpPzUwkrseWeRced4wg32qnEBhzWtCo0TxUjIATW2drcPs+otWFj9ddj4pJDyJ9U5wvChdymuWQww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1yV4WbgX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1yV4WbgX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0CD01F000FF;
	Sat, 12 Sep 2026 09:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204569;
	bh=//KpJzHFDegJosD7Jv9xkbie1AI/fGtL/Fxmd1xUgTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1yV4WbgX/U9U2c/dPJJUejMb9xUYhxvStDXrtQMjkABAe4y4mGbKE+SRSf36oHAiu
	 JsE7ce//q33U9OdfYMmok8ReGzARmPM+CSo6N3+TNbcwlEmDAq/DY4YG0RSA0g7RlD
	 59tEYBqWuGbzWtsnLGJ3pFdwMg/Cr4D2RuCYRxHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1603/1815] ntfs: rewrite EA stream before updating metadata
Date: Sat, 12 Sep 2026 08:55:53 +0200
Message-ID: <20260912065726.621577800@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

[ Upstream commit 41e1cf4ec10d2338f9a206af0300c34ca63160c7 ]

Updating an EA removes the old record and appends its replacement.
Build the complete $EA stream in memory and rewrite it from offset zero,
rather than committing a compacted stream followed by a separate append.
generic/642 shows that the append path can leave an invalid record layout
on disk, including when a new EA entry is added.

When removing an EA, write the compacted stream before updating
$EA_INFORMATION and restore the original pair if the metadata update
fails.

When the final EA entry is removed the $EA/$EA_INFORMATION pair is torn
down. If removing $EA_INFORMATION fails after $EA has already been
removed, the original $EA is restored so the two attributes stay
consistent.

Fixes: fc053f05ca28 ("ntfs: add reparse and ea operations")
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/ea.c | 65 +++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 46 insertions(+), 19 deletions(-)

diff --git a/fs/ntfs/ea.c b/fs/ntfs/ea.c
index 88bfd65606920..d0044c61152af 100644
--- a/fs/ntfs/ea.c
+++ b/fs/ntfs/ea.c
@@ -196,6 +196,9 @@ static int ntfs_set_ea(struct inode *inode, const char *name, size_t name_len,
 	struct ea_attr *p_ea;
 	u32 ea_info_qsize = 0;
 	char *ea_buf = NULL;
+	char *new_ea_buf;
+	char *old_ea_buf = NULL;
+	struct ea_information old_ea_info;
 	size_t new_ea_size = ALIGN(struct_size(p_ea, ea_name, 1 + name_len + val_size), 4);
 	s64 ea_off, ea_info_size, all_ea_size, ea_size;
 
@@ -249,6 +252,14 @@ static int ntfs_set_ea(struct inode *inode, const char *name, size_t name_len,
 			err = -EEXIST;
 			goto out;
 		}
+		if ((flags & XATTR_REPLACE) && !val_size) {
+			old_ea_info = *p_ea_info;
+			old_ea_buf = kvmemdup(ea_buf, all_ea_size, GFP_NOFS);
+			if (!old_ea_buf) {
+				err = -ENOMEM;
+				goto out;
+			}
+		}
 
 		/* Check the final $EA size before removing the old entry. */
 		if (val_size &&
@@ -281,20 +292,33 @@ static int ntfs_set_ea(struct inode *inode, const char *name, size_t name_len,
 				goto out;
 
 			err = ntfs_attr_remove(ni, AT_EA_INFORMATION, AT_UNNAMED, 0);
+			if (err) {
+				/* Restore the original $EA if $EA_INFORMATION removal failed. */
+				ntfs_attr_add(ni, AT_EA, AT_UNNAMED, 0, old_ea_buf,
+					      all_ea_size);
+				ea_info_qsize = le32_to_cpu(old_ea_info.ea_query_length);
+			}
 			goto out;
 		}
 
-		err = ntfs_write_ea(ni, AT_EA_INFORMATION, (char *)p_ea_info, 0,
-				sizeof(struct ea_information), false);
-		if (err)
-			goto out;
-
-		err = ntfs_write_ea(ni, AT_EA, ea_buf, 0, ea_info_qsize, true);
-		if (err)
-			goto out;
-
 		if ((flags & XATTR_REPLACE) && !val_size) {
-			/* Remove xattr. */
+			err = ntfs_write_ea(ni, AT_EA, ea_buf, 0, ea_info_qsize,
+					true);
+			if (err) {
+				ntfs_write_ea(ni, AT_EA, old_ea_buf, 0,
+					      all_ea_size, false);
+				goto out;
+			}
+
+			err = ntfs_write_ea(ni, AT_EA_INFORMATION, (char *)p_ea_info,
+					0, sizeof(struct ea_information), false);
+			if (err) {
+				ntfs_write_ea(ni, AT_EA, old_ea_buf, 0,
+					      all_ea_size, false);
+				ntfs_write_ea(ni, AT_EA_INFORMATION,
+					      (char *)&old_ea_info, 0,
+					      sizeof(old_ea_info), false);
+			}
 			goto out;
 		}
 	} else {
@@ -309,21 +333,23 @@ static int ntfs_set_ea(struct inode *inode, const char *name, size_t name_len,
 			goto out;
 		}
 	}
-	kvfree(ea_buf);
-
 alloc_new_ea:
-	ea_buf = kzalloc(new_ea_size, GFP_NOFS);
-	if (!ea_buf) {
+	new_ea_buf = kvzalloc(ea_info_qsize + new_ea_size, GFP_NOFS);
+	if (!new_ea_buf) {
 		err = -ENOMEM;
 		goto out;
 	}
+	if (ea_info_qsize)
+		memcpy(new_ea_buf, ea_buf, ea_info_qsize);
+	kvfree(ea_buf);
+	ea_buf = new_ea_buf;
+	p_ea = (struct ea_attr *)(ea_buf + ea_info_qsize);
 
 	/*
 	 * EA and REPARSE_POINT compatibility not checked any more,
 	 * required by Windows 10, but having both may lead to
 	 * problems with earlier versions.
 	 */
-	p_ea = (struct ea_attr *)ea_buf;
 	memcpy(p_ea->ea_name, name, name_len);
 	p_ea->ea_name_length = name_len;
 	p_ea->ea_name[name_len] = 0;
@@ -344,13 +370,13 @@ static int ntfs_set_ea(struct inode *inode, const char *name, size_t name_len,
 	 * no EA or EA_INFORMATION : add them
 	 */
 	if (!ntfs_attr_exist(ni, AT_EA, AT_UNNAMED, 0)) {
-		err = ntfs_attr_add(ni, AT_EA, AT_UNNAMED, 0, (char *)p_ea,
-				new_ea_size);
+		err = ntfs_attr_add(ni, AT_EA, AT_UNNAMED, 0, ea_buf,
+				ea_info_qsize + new_ea_size);
 		if (err)
 			goto out;
 	} else {
-		err = ntfs_write_ea(ni, AT_EA, (char *)p_ea, ea_info_qsize,
-				new_ea_size, false);
+		err = ntfs_write_ea(ni, AT_EA, ea_buf, 0,
+				ea_info_qsize + new_ea_size, true);
 		if (err)
 			goto out;
 	}
@@ -370,6 +396,7 @@ static int ntfs_set_ea(struct inode *inode, const char *name, size_t name_len,
 		NInoClearHasEA(ni);
 
 	kvfree(ea_buf);
+	kvfree(old_ea_buf);
 	kvfree(p_ea_info);
 
 	return err;
-- 
2.53.0



