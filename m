Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B717145353;
	Thu, 11 Apr 2024 10:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830977; cv=none; b=XEv5ZNIGMWMSq23FM62gvd3ri2+/dt7Mc+48UMTLj76zWQfttgMgibSoZ5qvdvF55Lv0DAquL1ppnZadY1kq8Rt/SgEC390Y6EmktfQHcmvWgeY7GS6p38LthOxzfmPrNgTrr4SgKVwGGsMSLv868Wl0SBNVx3b2tF8ZV8kBdHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830977; c=relaxed/simple;
	bh=ORZsXPmfcLgBi4n1HAzya7vmNuBKnKdUg1CM2uV02SU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dO8PHf0CBTtoaFrxXIIh/dpMLKj/WYXlFvXwmzCUzI47vIG8Hht3X4TmsMw6orM3iKvhN19iEDO+QT2lxEwFrnjbC8PmIuUaV9mB5+DRiemJcxWvrwbfZpwFXz5mQqj57L21b7mVKqfnnwrtMZqdIksG32vBi9sXTr+/zf10DcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wytjAI2Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wytjAI2Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3F84C433F1;
	Thu, 11 Apr 2024 10:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830977;
	bh=ORZsXPmfcLgBi4n1HAzya7vmNuBKnKdUg1CM2uV02SU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wytjAI2Y8PtsdcedwRn22Wz8kT5lZA6oWXxnS80iRM8XPuK31UwiCl7U+fSykKPpN
	 HFRYSelalan1JW8ggl4sihdvVnO04p/FpeDmCvcrD9TqCi/a4n34CSrii4R2/oamF2
	 A+x8lELByYV1pqd1sqlnSEylVp4L8ZNPj0/r0+Eo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Anand Jain <anand.jain@oracle.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 181/215] btrfs: handle chunk tree lookup error in btrfs_relocate_sys_chunks()
Date: Thu, 11 Apr 2024 11:56:30 +0200
Message-ID: <20240411095430.309516230@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 5539e672d70a3..d7014b2b28d6a 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3268,7 +3268,17 @@ static int btrfs_relocate_sys_chunks(struct btrfs_fs_info *fs_info)
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



