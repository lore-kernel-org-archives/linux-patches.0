Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDFBB4F85DE;
	Thu, 17 Sep 2026 16:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664370; cv=none; b=no3pMMNGKEHJR58+kNYyIIRk5SwG8TCVhuB7uUBF/PpfdKTNOw/ZsOTAUUe+w4Wdo5rXXyjuLuF4iL7gl5CFlP4v9ieyR28EOkP1Ey7b5d4Q86YlxvWeTn0tpnaf3HFdtBT912dgRIRgaN8lN3J6uuAb/g8cK6UFNs7pUolsX/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664370; c=relaxed/simple;
	bh=1ZKuNTaq7ItrhjhoVMQ8dTse9gFwqaCKOGksgRJcFYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pwuL7Zh2blipdrUVg7YXD9O28lcduK7Tqi0QVnQ8eJdE8yp22QUvGwRQtNe3mRz995gJnfMtzOQ7ZDr+EJ1XwuIt0Tllalhf5nYTPE1/sTxzFJZ6uQ9ZY+2sNDEHnZ+Q/Uu7PMlN6fRaSr6++OGzEEqooUyzpZ+e/voYcEF8OTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hSvKvWZ7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hSvKvWZ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FA681F000FF;
	Thu, 17 Sep 2026 16:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664368;
	bh=wlzbgMw7nBXBb90p4jLT9bGRGnu1HzU5VqkLfuWt78s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hSvKvWZ705RWSLoaCAC54QYUe5PLaCZ2dEq4Q8t7ycpv5fQ+JTlH/cWghW5i7Z6n6
	 kwn/fy63Ha7S7tl3Z5+Ju3QxOHCBr7lTFUlO39hcvtsrfuyRllNG1mcdj5Qnk2cEMl
	 pZUBmc9mw8eeOrwh7tuKFjZ66db+oCGFWBAhSq+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Zhang Cen <rollkingzzc@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0350/1250] btrfs: tree-checker: validate names in ROOT_REF and ROOT_BACKREF
Date: Thu, 17 Sep 2026 16:02:25 +0100
Message-ID: <20260917151601.555917937@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Zhang Cen <rollkingzzc@gmail.com>

[ Upstream commit 0af37c217edf15fa21dac1c40822086df356c6bb ]

ROOT_REF and ROOT_BACKREF items contain a struct btrfs_root_ref followed
by the subvolume name. Several readers assume that this layout is already
valid and then use the on-disk name length directly. A corrupted item can
therefore make those readers address bytes outside the item, and
BTRFS_IOC_GET_SUBVOL_INFO can copy too many bytes into its fixed-size UAPI
name buffer.

Validate ROOT_REF and ROOT_BACKREF items in tree-checker before any reader
uses them. Reject records that do not contain a non-empty name, whose
name_len does not exactly describe the remaining item payload, or whose
name exceeds BTRFS_NAME_LEN.

For BTRFS_IOC_GET_SUBVOL_INFO, copy only the validated on-disk name_len
instead of deriving the copy length from the item size. The ioctl result is
zeroed when allocated. That leaves the existing trailing zero byte
untouched.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ioctl.c        | 11 +++++------
 fs/btrfs/tree-checker.c | 35 +++++++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index b702f625c753b..45dbfa8cce964 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2053,7 +2053,6 @@ static int btrfs_ioctl_get_subvol_info(struct inode *inode, void __user *argp)
 	struct btrfs_root_ref *rref;
 	struct extent_buffer *leaf;
 	unsigned long item_off;
-	unsigned long item_len;
 	int slot;
 	int ret = 0;
 
@@ -2128,17 +2127,17 @@ static int btrfs_ioctl_get_subvol_info(struct inode *inode, void __user *argp)
 		btrfs_item_key_to_cpu(leaf, &key, slot);
 		if (key.objectid == subvol_info->treeid &&
 		    key.type == BTRFS_ROOT_BACKREF_KEY) {
+			u16 name_len;
+
 			subvol_info->parent_id = key.offset;
 
 			rref = btrfs_item_ptr(leaf, slot, struct btrfs_root_ref);
+			name_len = btrfs_root_ref_name_len(leaf, rref);
 			subvol_info->dirid = btrfs_root_ref_dirid(leaf, rref);
 
-			item_off = btrfs_item_ptr_offset(leaf, slot)
-					+ sizeof(struct btrfs_root_ref);
-			item_len = btrfs_item_size(leaf, slot)
-					- sizeof(struct btrfs_root_ref);
+			item_off = btrfs_item_ptr_offset(leaf, slot) + sizeof(*rref);
 			read_extent_buffer(leaf, subvol_info->name,
-					   item_off, item_len);
+					   item_off, name_len);
 		} else {
 			ret = -ENOENT;
 			goto out;
diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index db7402836340a..97be0c1ed22f7 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1288,6 +1288,37 @@ static int check_root_item(struct extent_buffer *leaf, struct btrfs_key *key,
 	return 0;
 }
 
+static int check_root_ref(struct extent_buffer *leaf, struct btrfs_key *key, int slot)
+{
+	struct btrfs_root_ref *rref;
+	u32 item_size = btrfs_item_size(leaf, slot);
+	u32 name_len;
+
+	if (unlikely(item_size <= sizeof(*rref))) {
+		generic_err(leaf, slot,
+			    "invalid root ref item size for key type %u, have %u expect > %zu",
+			    key->type, item_size, sizeof(*rref));
+		return -EUCLEAN;
+	}
+
+	rref = btrfs_item_ptr(leaf, slot, struct btrfs_root_ref);
+	name_len = btrfs_root_ref_name_len(leaf, rref);
+	if (unlikely(name_len > BTRFS_NAME_LEN)) {
+		generic_err(leaf, slot,
+			    "root ref name too long for key type %u, have %u max %u",
+			    key->type, name_len, BTRFS_NAME_LEN);
+		return -EUCLEAN;
+	}
+	if (unlikely(item_size != sizeof(*rref) + name_len)) {
+		generic_err(leaf, slot,
+			    "invalid root ref item size for key type %u, have %u expect %zu",
+			    key->type, item_size, sizeof(*rref) + name_len);
+		return -EUCLEAN;
+	}
+
+	return 0;
+}
+
 __printf(3,4)
 __cold
 static void extent_err(const struct extent_buffer *eb, int slot,
@@ -1965,6 +1996,10 @@ static enum btrfs_tree_block_status check_leaf_item(struct extent_buffer *leaf,
 	case BTRFS_ROOT_ITEM_KEY:
 		ret = check_root_item(leaf, key, slot);
 		break;
+	case BTRFS_ROOT_REF_KEY:
+	case BTRFS_ROOT_BACKREF_KEY:
+		ret = check_root_ref(leaf, key, slot);
+		break;
 	case BTRFS_EXTENT_ITEM_KEY:
 	case BTRFS_METADATA_ITEM_KEY:
 		ret = check_extent_item(leaf, key, slot, prev_key);
-- 
2.53.0



