Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A272C15FCE6;
	Mon, 27 May 2024 18:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836385; cv=none; b=taF2v4vABua8ChQqp40rtFKIwtQipie85yH3zJUgoGblmrjUmcfBDW1YifxIm8ll4UT+93N5D8bGzEeL3NjM19HdEX0Iw2OyhFtKEpCgzqtJzFw3NtEjbObvWzvhjF5BbWG7kcI5ZJnO1vFPJ8d9k7R03MS0s88l7XMYdW+5xtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836385; c=relaxed/simple;
	bh=SGwAFllA3gKFvO1Y461z5PZbyA6K7j2p3E3bCvP/iqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T4kXhdEmb3rIFlrMBZXKJWOTgkWzLEB8MTZXJmLgCKhTGhTWQGbUE2jSF1wn1nEiokKQ/ZCoZpLhFTp1nVPrVCj1e7tJtjFVPJyuPYYCAS8P1QXUYm/MWj/ukzRKagJKaLATgJicrf7rhdH72s+ISlwL8yyExdvBv4E7qfz7VcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OYuORyVd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OYuORyVd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37883C2BBFC;
	Mon, 27 May 2024 18:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836385;
	bh=SGwAFllA3gKFvO1Y461z5PZbyA6K7j2p3E3bCvP/iqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OYuORyVdwrvSaP1mLxZDEVfB7TWpisiBXnwoVfuG1W6Sb8yOqr74iK9HLtJ13Lq6W
	 jasqh2pdLFNsOf7L2ox92mMZ4EgCepPVZTXuocJ3LDCvTQAFmWZt4nqj3QkALpMEMx
	 OPnaPsRDTCN7hBzWC/d0IenVCKMmdVkO4zJZb348=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.9 032/427] fs/ntfs3: Taking DOS names into account during link counting
Date: Mon, 27 May 2024 20:51:19 +0200
Message-ID: <20240527185604.667243570@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
@@ -200,11 +200,12 @@ next_attr:
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
@@ -429,7 +430,7 @@ end_enum:
 		ni->mi.dirty = true;
 	}
 
-	set_nlink(inode, names);
+	set_nlink(inode, links);
 
 	if (S_ISDIR(mode)) {
 		ni->std_fa |= FILE_ATTRIBUTE_DIRECTORY;
--- a/fs/ntfs3/record.c
+++ b/fs/ntfs3/record.c
@@ -534,16 +534,9 @@ bool mi_remove_attr(struct ntfs_inode *n
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


