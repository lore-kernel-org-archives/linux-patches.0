Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D11CA330B20;
	Fri, 17 Oct 2025 15:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716396; cv=none; b=bq0wHwFAsY1/mwKSui8VfYpNAw4Bxl3auY4iyxd/SmSiucYwiTskXW761yXbqnvoZlVCazehnJr+j+cmKiJ7nQ2Tm8ea3NXFckoNYYZmGIdYHju9IXzvLntaqlIFRcRdfmAObIGgnXdDRWpWZoqGqPqrxJwAumVNejLj7sDuDjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716396; c=relaxed/simple;
	bh=uXh0zbTld5MHPDqXt0aS5nw/gxNmUp6lmrwqKqE0lI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VxBrfLiHrDVxZRW+CtzjjdwYyhqAlZJvOJ7ek0rPldZyKVN7Rj1UUYrATfIJwLglD2W5pYdWPnP4CE4BB6in5RUbRj/Sgruu3Pa/TGqQDvTVHyNkdFx9/EEEN7vxJiJfEfBHmC52MvPln9g5C2Tzz8W6XKHFuIN+kYa2UR6kUeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gclN0KI+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gclN0KI+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5511AC4CEE7;
	Fri, 17 Oct 2025 15:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716396;
	bh=uXh0zbTld5MHPDqXt0aS5nw/gxNmUp6lmrwqKqE0lI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gclN0KI+1/+e6TcTPBnOELJo2XyspOBgMi/cYeQqDw5udhnBNVPIkFUVW0AElU5ek
	 6DeSuLql0k7/BxKAj2lGg9omJB/XtNferGgFzTTn+82vq7vtcfM0U2eDxWa7BDd5gU
	 K3Krux33UfNhvds9cTLrMEGY1Ucp2rl5SK3A+8ak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anderson Nascimento <anderson@allelesecurity.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 175/276] btrfs: avoid potential out-of-bounds in btrfs_encode_fh()
Date: Fri, 17 Oct 2025 16:54:28 +0200
Message-ID: <20251017145148.863461386@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anderson Nascimento <anderson@allelesecurity.com>

commit dff4f9ff5d7f289e4545cc936362e01ed3252742 upstream.

The function btrfs_encode_fh() does not properly account for the three
cases it handles.

Before writing to the file handle (fh), the function only returns to the
user BTRFS_FID_SIZE_NON_CONNECTABLE (5 dwords, 20 bytes) or
BTRFS_FID_SIZE_CONNECTABLE (8 dwords, 32 bytes).

However, when a parent exists and the root ID of the parent and the
inode are different, the function writes BTRFS_FID_SIZE_CONNECTABLE_ROOT
(10 dwords, 40 bytes).

If *max_len is not large enough, this write goes out of bounds because
BTRFS_FID_SIZE_CONNECTABLE_ROOT is greater than
BTRFS_FID_SIZE_CONNECTABLE originally returned.

This results in an 8-byte out-of-bounds write at
fid->parent_root_objectid = parent_root_id.

A previous attempt to fix this issue was made but was lost.

https://lore.kernel.org/all/4CADAEEC020000780001B32C@vpn.id2.novell.com/

Although this issue does not seem to be easily triggerable, it is a
potential memory corruption bug that should be fixed. This patch
resolves the issue by ensuring the function returns the appropriate size
for all three cases and validates that *max_len is large enough before
writing any data.

Fixes: be6e8dc0ba84 ("NFS support for btrfs - v3")
CC: stable@vger.kernel.org # 3.0+
Signed-off-by: Anderson Nascimento <anderson@allelesecurity.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/export.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/btrfs/export.c
+++ b/fs/btrfs/export.c
@@ -22,7 +22,11 @@ static int btrfs_encode_fh(struct inode
 	int type;
 
 	if (parent && (len < BTRFS_FID_SIZE_CONNECTABLE)) {
-		*max_len = BTRFS_FID_SIZE_CONNECTABLE;
+		if (btrfs_root_id(BTRFS_I(inode)->root) !=
+		    btrfs_root_id(BTRFS_I(parent)->root))
+			*max_len = BTRFS_FID_SIZE_CONNECTABLE_ROOT;
+		else
+			*max_len = BTRFS_FID_SIZE_CONNECTABLE;
 		return FILEID_INVALID;
 	} else if (len < BTRFS_FID_SIZE_NON_CONNECTABLE) {
 		*max_len = BTRFS_FID_SIZE_NON_CONNECTABLE;
@@ -44,6 +48,8 @@ static int btrfs_encode_fh(struct inode
 		parent_root_id = BTRFS_I(parent)->root->root_key.objectid;
 
 		if (parent_root_id != fid->root_objectid) {
+			if (*max_len < BTRFS_FID_SIZE_CONNECTABLE_ROOT)
+				return FILEID_INVALID;
 			fid->parent_root_objectid = parent_root_id;
 			len = BTRFS_FID_SIZE_CONNECTABLE_ROOT;
 			type = FILEID_BTRFS_WITH_PARENT_ROOT;


