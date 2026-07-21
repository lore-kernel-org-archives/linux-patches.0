Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9824E256C84;
	Tue, 21 Jul 2026 15:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649356; cv=none; b=eam0c27dSJolS4OQ1pVRBbiwZmdfJzngmzxI4WSrF/twt8cC7MJ/+qbdFuV0rXojvyyzRtpbvG5deEaKXDWJuOtpWXQvreZT4M3CC4jKiaT41MDosDrUDvDRC5tPCjnTwIcaHmWiRGummi7372Wu90ogtIUreU15vhWky1CgObE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649356; c=relaxed/simple;
	bh=Oj27dsdioZPsN+9Pm5vcaFm+e8AJiJOpC8/nIodQzlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qqO3DgO4jN2vkvmAus/7cJUHOsGW2t+mwabWezO/kzoGUNyrkS58uuIjW1qGk78dQY/xVY3wvSidRnffMT/MaZjglWup6rs3u/9cxH1qH2Sm4ZBYNKWr42jvlzLBVb83ih4HvnOs+wDMc4OTz9kb+sodYc/UX1XtET6gb5ndwn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZPm3l6Ev; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZPm3l6Ev"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A0781F000E9;
	Tue, 21 Jul 2026 15:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649355;
	bh=6bCldRsBM7dflKEH+OPuwAW8/IDC5vFM+sejlwKO3r4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZPm3l6EvqjJl0KXXSOP3bpUrCTg7fZ5IJbULIVldc4yzrTA2QRkxbQ/vAwwzsxdWF
	 41gO6RIPjfGtqmKw8GaQO3RgBAyIyk5chowcmepCScWUwC6x7x1lKLrc2H05ywIDhf
	 0jcfOCQZGX1KKPXBtT0nHuL1PzKWsqbbhLkxLhfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0545/2077] ntfs: validate resident attribute lists and harden the validator
Date: Tue, 21 Jul 2026 17:03:38 +0200
Message-ID: <20260721152605.666087425@linuxfoundation.org>
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

From: Bryam Vargas <hexlabsecurity@proton.me>

[ Upstream commit 7d19e1ffee084c4f7d321a360c14ba43404f7cc8 ]

A base inode's $ATTRIBUTE_LIST is sanity-checked by load_attribute_list()
only on the non-resident path; ntfs_read_locked_inode() copies a *resident*
attribute list into ni->attr_list with a plain memcpy() and no validation
at all. Every subsequent walk of ni->attr_list --
ntfs_external_attr_find(), ntfs_inode_attach_all_extents() and
ntfs_attrlist_need() -- then trusts the entries are well-formed and reads
attr_list_entry fixed-header fields
(lowest_vcn at offset 8, mft_reference at offset 16, and the name) with
bounds that assume validation already happened. A crafted resident
attribute list therefore reaches those walks unvalidated and can drive
out-of-bounds reads of the attribute-list buffer.

load_attribute_list() itself reads ale->name_offset (offset 7),
ale->mft_reference (offset 16) and the name length under only an
"al < al_start + size" bound, so its own validation loop can over-read the
fixed header of a truncated trailing entry by a few bytes.

Factor the per-entry validation into ntfs_attr_list_entry_is_valid(),
which requires each entry's fixed header (offsetof(struct
attr_list_entry, name)) to be in range before any field is dereferenced,
that ale->length is a multiple of 8 covering the fixed header plus the
name, and that the entry is in use and carries a live MFT reference.
ntfs_attr_list_is_valid() walks the buffer with it and checks the entries
tile it exactly. Use the list validator in load_attribute_list()
(replacing the open-coded loop, closing its own over-read) and on the
resident path in ntfs_read_locked_inode() (which previously skipped
validation entirely); patches 2/3 reuse the per-entry helper at the other
two attribute-list walks.

Fixes: 1e9ea7e04472 ("Revert "fs: Remove NTFS classic"")
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/attrib.c | 78 ++++++++++++++++++++++++++++++++++++++----------
 fs/ntfs/attrib.h |  4 +++
 fs/ntfs/inode.c  |  6 ++++
 3 files changed, 73 insertions(+), 15 deletions(-)

diff --git a/fs/ntfs/attrib.c b/fs/ntfs/attrib.c
index 421c6cdcbb5307..abc0add6f0c446 100644
--- a/fs/ntfs/attrib.c
+++ b/fs/ntfs/attrib.c
@@ -843,11 +843,71 @@ char *ntfs_attr_name_get(const struct ntfs_volume *vol, const __le16 *uname,
 	return NULL;
 }
 
+/*
+ * ntfs_attr_list_entry_is_valid - sanity check one $ATTRIBUTE_LIST entry
+ * @ale:	the attribute-list entry to check
+ * @al_end:	end of the attribute-list buffer @ale lives in
+ *
+ * Verify that @ale is a well-formed attr_list_entry wholly contained in
+ * [.., @al_end): its fixed header must lie in range before any field is
+ * dereferenced, its length must be a multiple of 8 that covers the fixed
+ * header plus the name, the name must lie within the buffer, the entry must
+ * be in use and carry a live MFT reference.  Return true if valid.
+ */
+bool ntfs_attr_list_entry_is_valid(const struct attr_list_entry *ale,
+				   const u8 *al_end)
+{
+	const u8 *al = (const u8 *)ale;
+	u16 ale_len;
+
+	/* The fixed header must be in bounds before it is parsed. */
+	if (al + offsetof(struct attr_list_entry, name) > al_end)
+		return false;
+	ale_len = le16_to_cpu(ale->length);
+	/* On-disk entries are 8-byte aligned (see struct attr_list_entry). */
+	if (ale_len & 7)
+		return false;
+	if (ale->name_offset != sizeof(struct attr_list_entry))
+		return false;
+	if ((u32)ale->name_offset +
+	    (u32)ale->name_length * sizeof(__le16) > ale_len ||
+	    al + ale_len > al_end)
+		return false;
+	if (ale->type == AT_UNUSED)
+		return false;
+	if (MSEQNO_LE(ale->mft_reference) == 0)
+		return false;
+	return true;
+}
+
+/*
+ * ntfs_attr_list_is_valid - sanity check an in-memory $ATTRIBUTE_LIST
+ * @al_start:	start of the attribute list buffer
+ * @size:	length of the attribute list in bytes
+ *
+ * Verify that [@al_start, @al_start + @size) is a sequence of valid
+ * attr_list_entry records (see ntfs_attr_list_entry_is_valid()) that tile the
+ * buffer exactly.  Return true if valid, false otherwise.
+ */
+bool ntfs_attr_list_is_valid(const u8 *al_start, s64 size)
+{
+	const u8 *al = al_start;
+	const u8 *al_end = al_start + size;
+
+	while (al < al_end) {
+		const struct attr_list_entry *ale =
+				(const struct attr_list_entry *)al;
+
+		if (!ntfs_attr_list_entry_is_valid(ale, al_end))
+			return false;
+		al += le16_to_cpu(ale->length);
+	}
+	return al == al_end;
+}
+
 int load_attribute_list(struct ntfs_inode *base_ni, u8 *al_start, const s64 size)
 {
 	struct inode *attr_vi = NULL;
-	u8 *al;
-	struct attr_list_entry *ale;
 
 	if (!al_start || size <= 0)
 		return -EINVAL;
@@ -869,19 +929,7 @@ int load_attribute_list(struct ntfs_inode *base_ni, u8 *al_start, const s64 size
 	}
 	iput(attr_vi);
 
-	for (al = al_start; al < al_start + size; al += le16_to_cpu(ale->length)) {
-		ale = (struct attr_list_entry *)al;
-		if (ale->name_offset != sizeof(struct attr_list_entry))
-			break;
-		if (le16_to_cpu(ale->length) <= ale->name_offset + ale->name_length ||
-		    al + le16_to_cpu(ale->length) > al_start + size)
-			break;
-		if (ale->type == AT_UNUSED)
-			break;
-		if (MSEQNO_LE(ale->mft_reference) == 0)
-			break;
-	}
-	if (al != al_start + size) {
+	if (!ntfs_attr_list_is_valid(al_start, size)) {
 		ntfs_error(base_ni->vol->sb, "Corrupt attribute list, mft = %llu",
 			   base_ni->mft_no);
 		return -EIO;
diff --git a/fs/ntfs/attrib.h b/fs/ntfs/attrib.h
index f7acc7986b090d..e2224fbfaabe95 100644
--- a/fs/ntfs/attrib.h
+++ b/fs/ntfs/attrib.h
@@ -71,6 +71,10 @@ int ntfs_attr_lookup(const __le32 type, const __le16 *name,
 		const u32 name_len, const u32 ic,
 		const s64 lowest_vcn, const u8 *val, const u32 val_len,
 		struct ntfs_attr_search_ctx *ctx);
+bool ntfs_attr_list_entry_is_valid(const struct attr_list_entry *ale,
+				   const u8 *al_end);
+bool ntfs_attr_list_is_valid(const u8 *al_start, s64 size);
+
 int load_attribute_list(struct ntfs_inode *base_ni,
 			       u8 *al_start, const s64 size);
 
diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
index 360bebd1ee3fe6..a5f7400fd19dc4 100644
--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -848,6 +848,12 @@ static int ntfs_read_locked_inode(struct inode *vi)
 					a->data.resident.value_offset),
 					le32_to_cpu(
 					a->data.resident.value_length));
+			/* A resident list is not validated on load; check it now. */
+			if (!ntfs_attr_list_is_valid(ni->attr_list,
+						     ni->attr_list_size)) {
+				ntfs_error(vi->i_sb, "Corrupt attribute list.");
+				goto unm_err_out;
+			}
 		}
 	}
 skip_attr_list_load:
-- 
2.53.0



