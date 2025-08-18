Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32EC530C37D;
	Mon, 18 Aug 2025 13:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524543; cv=none; b=Fjr4mMi7CgIJ2BjWwrwfS6OWD4kWfTEskB5uNKH/uXF7DEpVbVf5KSzasPqPIV4Kk/Yzg772cDmSq3an9ShGwaszc4LUsbAiE+5S7DWrM+lFq6tJrHLX83fh2gp8PTyz9P7f8ojiDLbT1ILRv8gY7AbRaCxohULren/TRzmAK7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524543; c=relaxed/simple;
	bh=nOMz0oUsC5FS8HGxH0jH0CuEdMR5BHk3ZZxqTyc4DVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iOHlQJxFBR0RdghHqyQ+HiOhJRr9I4Ye40HKtBlwhOvpF7+F5nFQ4uAlmcGFN9VXJbxKxBxwrzYe7KOlU9pwb9U7CI9FXAzObBLfzYlvGza59gWE/fhZy9kBNiRDOu2DheIsYXM9TMx5DynEKkDTllyA1UutKyPniWWhsDOoCXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q8+rZ6E0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q8+rZ6E0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BD3CC4CEF1;
	Mon, 18 Aug 2025 13:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524543;
	bh=nOMz0oUsC5FS8HGxH0jH0CuEdMR5BHk3ZZxqTyc4DVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q8+rZ6E0TWZcFPrHS3lgyX6S/g4tXcwHHXUgivS0OCu6i4HlWNlAliVlsCuaLNmMO
	 1xjcz2pCmJpoXiVZ0POUfdUL0+nx/HSXnl93p/r6zJq3903r8bMIDZBtckrX4hlndf
	 HalUvz5Qi+IJMCvqxJermOf6lzw9oJNBH3Buz+bE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.15 473/515] btrfs: dont skip remaining extrefs if dir not found during log replay
Date: Mon, 18 Aug 2025 14:47:39 +0200
Message-ID: <20250818124516.629531986@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

commit 24e066ded45b8147b79c7455ac43a5bff7b5f378 upstream.

During log replay, at add_inode_ref(), if we have an extref item that
contains multiple extrefs and one of them points to a directory that does
not exist in the subvolume tree, we are supposed to ignore it and process
the remaining extrefs encoded in the extref item, since each extref can
point to a different parent inode. However when that happens we just
return from the function and ignore the remaining extrefs.

The problem has been around since extrefs were introduced, in commit
f186373fef00 ("btrfs: extended inode refs"), but it's hard to hit in
practice because getting extref items encoding multiple extref requires
getting a hash collision when computing the offset of the extref's
key. The offset if computed like this:

  key.offset = btrfs_extref_hash(dir_ino, name->name, name->len);

and btrfs_extref_hash() is just a wrapper around crc32c().

Fix this by moving to next iteration of the loop when we don't find
the parent directory that an extref points to.

Fixes: f186373fef00 ("btrfs: extended inode refs")
CC: stable@vger.kernel.org # 6.1+
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/tree-log.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1397,6 +1397,8 @@ static noinline int add_inode_ref(struct
 		if (log_ref_ver) {
 			ret = extref_get_fields(eb, ref_ptr, &name,
 						&ref_index, &parent_objectid);
+			if (ret)
+				goto out;
 			/*
 			 * parent object can change from one array
 			 * item to another.
@@ -1413,16 +1415,23 @@ static noinline int add_inode_ref(struct
 					 * the loop when getting the first
 					 * parent dir.
 					 */
-					if (ret == -ENOENT)
+					if (ret == -ENOENT) {
+						/*
+						 * The next extref may refer to
+						 * another parent dir that
+						 * exists, so continue.
+						 */
 						ret = 0;
+						goto next;
+					}
 					goto out;
 				}
 			}
 		} else {
 			ret = ref_get_fields(eb, ref_ptr, &name, &ref_index);
+			if (ret)
+				goto out;
 		}
-		if (ret)
-			goto out;
 
 		ret = inode_in_dir(root, path, btrfs_ino(dir), btrfs_ino(inode),
 				   ref_index, &name);
@@ -1456,10 +1465,11 @@ static noinline int add_inode_ref(struct
 		}
 		/* Else, ret == 1, we already have a perfect match, we're done. */
 
+next:
 		ref_ptr = (unsigned long)(ref_ptr + ref_struct_size) + name.len;
 		kfree(name.name);
 		name.name = NULL;
-		if (log_ref_ver) {
+		if (log_ref_ver && dir) {
 			iput(&dir->vfs_inode);
 			dir = NULL;
 		}


