Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C9014600A;
	Thu, 11 Apr 2024 10:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829918; cv=none; b=WcIakStyT6dlTtaKbwQKBUX1BB6yEZnaT6ye3nRMSnBd9N0YV4Sm80atd1W9xx1pY9IJ79ydqQ+/9s4EhJcWxWzwytc7PsiiDBe7MBBDIkoDFonY+TQoj5vNVw+Lx43t97yx8acjXCCJxmCmY52jL9tj/qrbSstjSTARgqmTTq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829918; c=relaxed/simple;
	bh=w24IojX4/Q/DJ/EQR880p51X+eH7bv7IROuRn+sWal4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mKMhT3/lOKaHDVeronFAxHUpa8vg9V5gOTlYmF8+STqBLgwjSTpMS2lDSZQZvTjfwZvp+BmpKKL0q0W/xrA6NtqggYUnUeff5lNme2J0nLa3knfSiS7ByC9kVmfhe5KedRgtxQmn/zygbGbX5RWBQimjb1Islnqvxx30Jni6OZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lvLL51bs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lvLL51bs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30170C433F1;
	Thu, 11 Apr 2024 10:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829917;
	bh=w24IojX4/Q/DJ/EQR880p51X+eH7bv7IROuRn+sWal4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lvLL51bstx+JKK7qBU6WbefhdEc17XchJ71iYi+DHkZtQNPjgKRCQCxstOgaSCCTy
	 nd652MW6+5yn72k5XMOPuHfgzVnFRNw0NeFw4R8LTVDV7BxCja0P13QQ+VXcCw3DVP
	 uuNpdg0napLUme6LwMZZV0HCUgJOgy6r9jegd+SQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Anand Jain <anand.jain@oracle.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 149/175] btrfs: handle chunk tree lookup error in btrfs_relocate_sys_chunks()
Date: Thu, 11 Apr 2024 11:56:12 +0200
Message-ID: <20240411095424.048475234@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Sterba <dsterba@suse.com>

[ Upstream commit 7411055db5ce64f836aaffd422396af0075fdc99 ]

The unhandled case in btrfs_relocate_sys_chunks() loop is a corruption,
as it could be caused only by two impossible conditions:

- at first the search key is set up to look for a chunk tree item, with
  offset -1, this is an inexact search and the key->offset will contain
  the correct offset upon a successful search, a valid chunk tree item
  cannot have an offset -1

- after first successful search, the found_key corresponds to a chunk
  item, the offset is decremented by 1 before the next loop, it's
  impossible to find a chunk item there due to alignment and size
  constraints

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/volumes.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index ceced5e56c5a9..30b5646b2c0de 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2948,7 +2948,17 @@ static int btrfs_relocate_sys_chunks(struct btrfs_fs_info *fs_info)
 			mutex_unlock(&fs_info->delete_unused_bgs_mutex);
 			goto error;
 		}
-		BUG_ON(ret == 0); /* Corruption */
+		if (ret == 0) {
+			/*
+			 * On the first search we would find chunk tree with
+			 * offset -1, which is not possible. On subsequent
+			 * loops this would find an existing item on an invalid
+			 * offset (one less than the previous one, wrong
+			 * alignment and size).
+			 */
+			ret = -EUCLEAN;
+			goto error;
+		}
 
 		ret = btrfs_previous_item(chunk_root, path, key.objectid,
 					  key.type);
-- 
2.43.0



