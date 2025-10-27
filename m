Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A6F31BC96;
	Mon, 27 Oct 2025 19:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591609; cv=none; b=SzNiXMPmIXibTu7GbmriRbfNWAd9Q7Z5cGc0tJc4VkWBnlQxn7O3xlMx4LRtK5GI12nVva5nI2iCazq1oEt4wtVtwYMlxcFEqt0Hsr/vLW3ZEj8+v+6DhxyUH4uaA9lGxxR7cAttrw0ZDY+vnGrlM9+nHj5ufPRtIuGEfEQpJJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591609; c=relaxed/simple;
	bh=EUpB7LEeXzbfqQpIqEq+0dioOHWkCbmV1gKJgmvkjYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fB4Qt7X2AXVOC8ZL+Rvij35YhBccRxTk5Y+djIUC8COibn8utT0Nf5bWsHvfjvrJYHTWDpfB/Uell8DFy+UxmuZx6MF5EcmlF0JqnaqBKVtug8RAyLPce9z5ITDh6Tg0et/AL6HE0VRofIjYkhj7i1L8Q7FjEbDYrMWtFJ/dmdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iyL8MrqA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iyL8MrqA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A2A9C4CEF1;
	Mon, 27 Oct 2025 19:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591609;
	bh=EUpB7LEeXzbfqQpIqEq+0dioOHWkCbmV1gKJgmvkjYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iyL8MrqA1hgio7FwJZxiLUnhV+chsCkNUFX1nRlzn5Sbvz9xLQdeO7U02YeUXcGdH
	 IMSxRQr6Cmqn9+CZ3hrOo9oL+Qav9a28fqSh2ydDTw+1ryDhSfgc3AM3cBmdRcePmG
	 HoY5EDibIA9trJXZO8LBW3OdjDlvjZ/U/nC4+F1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anderson Nascimento <anderson@allelesecurity.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 231/332] btrfs: avoid potential out-of-bounds in btrfs_encode_fh()
Date: Mon, 27 Oct 2025 19:34:44 +0100
Message-ID: <20251027183530.904318939@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anderson Nascimento <anderson@allelesecurity.com>

[ Upstream commit dff4f9ff5d7f289e4545cc936362e01ed3252742 ]

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
[ replaced btrfs_root_id() calls with direct ->root->root_key.objectid access ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
+		if (BTRFS_I(inode)->root->root_key.objectid !=
+		    BTRFS_I(parent)->root->root_key.objectid)
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


