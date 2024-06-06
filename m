Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA88A196C68;
	Thu,  6 Jun 2024 14:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683146; cv=none; b=IIsxw0hXioE5ReFiuKF+nQANeTBe4nvBVRLt6JZmHJr33kPRN/r8mc9/NmwIhLQlp7OWdSuHP8KvkXSA1Nt0jDU9EtlFVNgHo5byUGH/nsrZS79xB/CPYuS3xA9W37N0gTTdJWlLjkO8CAJAzU9+cfL/LvnaqaOfye7xMlpsqKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683146; c=relaxed/simple;
	bh=rRCGLEomZDDrkuMmgTwiXAaqj4zPx3uY783UxhMl/Ks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HHpf1R7brg7eINDFpZGrDFZ3EOX2X/VV0cYLXCFM1KwyXpFMbbqFckALFKRpznabS/K3yfZZeHXgBxq00tvIurkrdS4EapztFwljw5n9Ctk8o48JnIBmDGh6iUlZFPeWCPn65n/nG9M4lZYcRwTN8nfjFwwQ1cxWH2WIeN0K3Lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fi6blKCT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fi6blKCT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2937C2BD10;
	Thu,  6 Jun 2024 14:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683146;
	bh=rRCGLEomZDDrkuMmgTwiXAaqj4zPx3uY783UxhMl/Ks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fi6blKCTSLSL3JNwVZokW90ele/hEU+vkec/hEna7gSkQjVtdsW+RtObCTay1Ddix
	 AKeolW8dd26PeMvLheH4Hl3tQ1pKdG3Dcg2E6aR57sMf7wR9/jzn49zeE1JYtGgrPa
	 BQHQ33UWn27ueLcQhZjczN6KB2zIWwppTohfBL58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.1 018/473] fs/ntfs3: Taking DOS names into account during link counting
Date: Thu,  6 Jun 2024 15:59:07 +0200
Message-ID: <20240606131700.445828652@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

commit 110b24eb1a749bea3440f3ca2ff890a26179050a upstream.

When counting and checking hard links in an ntfs file record,

  struct MFT_REC {
    struct NTFS_RECORD_HEADER rhdr; // 'FILE'
    __le16 seq;		    // 0x10: Sequence number for this record.
>>  __le16 hard_links;	// 0x12: The number of hard links to record.
    __le16 attr_off;	// 0x14: Offset to attributes.
  ...

the ntfs3 driver ignored short names (DOS names), causing the link count
to be reduced by 1 and messages to be output to dmesg.

For Windows, such a situation is a minor error, meaning chkdsk does not report
errors on such a volume, and in the case of using the /f switch, it silently
corrects them, reporting that no errors were found. This does not affect
the consistency of the file system.

Nevertheless, the behavior in the ntfs3 driver is incorrect and
changes the content of the file system. This patch should fix that.

PS: most likely, there has been a confusion of concepts
MFT_REC::hard_links and inode::__i_nlink.

Fixes: 82cae269cfa95 ("fs/ntfs3: Add initialization of super block")
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/inode.c  |    7 ++++---
 fs/ntfs3/record.c |   11 ++---------
 2 files changed, 6 insertions(+), 12 deletions(-)

--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -37,7 +37,7 @@ static struct inode *ntfs_read_mft(struc
 	bool is_dir;
 	unsigned long ino = inode->i_ino;
 	u32 rp_fa = 0, asize, t32;
-	u16 roff, rsize, names = 0;
+	u16 roff, rsize, names = 0, links = 0;
 	const struct ATTR_FILE_NAME *fname = NULL;
 	const struct INDEX_ROOT *root;
 	struct REPARSE_DATA_BUFFER rp; // 0x18 bytes
@@ -190,11 +190,12 @@ next_attr:
 		    rsize < SIZEOF_ATTRIBUTE_FILENAME)
 			goto out;
 
+		names += 1;
 		fname = Add2Ptr(attr, roff);
 		if (fname->type == FILE_NAME_DOS)
 			goto next_attr;
 
-		names += 1;
+		links += 1;
 		if (name && name->len == fname->name_len &&
 		    !ntfs_cmp_names_cpu(name, (struct le_str *)&fname->name_len,
 					NULL, false))
@@ -421,7 +422,7 @@ end_enum:
 		ni->mi.dirty = true;
 	}
 
-	set_nlink(inode, names);
+	set_nlink(inode, links);
 
 	if (S_ISDIR(mode)) {
 		ni->std_fa |= FILE_ATTRIBUTE_DIRECTORY;
--- a/fs/ntfs3/record.c
+++ b/fs/ntfs3/record.c
@@ -485,16 +485,9 @@ bool mi_remove_attr(struct ntfs_inode *n
 	if (aoff + asize > used)
 		return false;
 
-	if (ni && is_attr_indexed(attr)) {
+	if (ni && is_attr_indexed(attr) && attr->type == ATTR_NAME) {
 		u16 links = le16_to_cpu(ni->mi.mrec->hard_links);
-		struct ATTR_FILE_NAME *fname =
-			attr->type != ATTR_NAME ?
-				NULL :
-				resident_data_ex(attr,
-						 SIZEOF_ATTRIBUTE_FILENAME);
-		if (fname && fname->type == FILE_NAME_DOS) {
-			/* Do not decrease links count deleting DOS name. */
-		} else if (!links) {
+		if (!links) {
 			/* minor error. Not critical. */
 		} else {
 			ni->mi.mrec->hard_links = cpu_to_le16(links - 1);


