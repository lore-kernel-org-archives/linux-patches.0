Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F3087DA9E;
	Thu, 15 Aug 2024 13:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729733; cv=none; b=Ciyf+TS2TCAaDuUlng9Fviu4iujBC8xDdTSRHSsT74KQaB6NRDv2Unp2Y16EO2qdUywVIGSjt0xwI/cHrJ0BbzyAtqVMgAEE6IZb1dgXxQ6UoYfZ1gqvCa6DlIUkDxtdb+cIrIkAxM8SwYfAxj2wGyq4Gl6HZQZL/Gsufrsk24Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729733; c=relaxed/simple;
	bh=CWfLDloqP3hTIkxl3nqbVGLS/MPPR02F7OKqHZFiexc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TGqoVID0Dn1+kIirkoqNbB95SxX21/PMPryctaFsQFVczVsGRr+QxFJG4iG8XlYmj+ofnJ260iPK74L81vOOsdrBUPl0rwOJo+9JeW2HElGSm42N5Enmnxh3lpr59IZnCXFgWQdwkgA2HTQN7unn1utRcwPf6H/7YV5dOJtPJSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eLv+Feak; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eLv+Feak"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93506C32786;
	Thu, 15 Aug 2024 13:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729733;
	bh=CWfLDloqP3hTIkxl3nqbVGLS/MPPR02F7OKqHZFiexc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eLv+Feak8X9qjPw11BraP4oljCvid/BT9M1UfbqRWOa+kKo8R6m73bGRjnIYb59xJ
	 iIcmLpV6GwL6+cc/CxI5iyBda32ccoWFoOJxzJXgIJdcFg+B0x5U/AtBAA/p0CQ4qr
	 3xTCCnC6yBMjntCmBg+MBxmEWjkzzDG4JDkP3gjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5f682cd029581f9edfd1@syzkaller.appspotmail.com,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 5.15 190/484] udf: Avoid using corrupted block bitmap buffer
Date: Thu, 15 Aug 2024 15:20:48 +0200
Message-ID: <20240815131948.751782197@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit a90d4471146de21745980cba51ce88e7926bcc4f upstream.

When the filesystem block bitmap is corrupted, we detect the corruption
while loading the bitmap and fail the allocation with error. However the
next allocation from the same bitmap will notice the bitmap buffer is
already loaded and tries to allocate from the bitmap with mixed results
(depending on the exact nature of the bitmap corruption). Fix the
problem by using BH_verified bit to indicate whether the bitmap is valid
or not.

Reported-by: syzbot+5f682cd029581f9edfd1@syzkaller.appspotmail.com
CC: stable@vger.kernel.org
Link: https://patch.msgid.link/20240617154201.29512-2-jack@suse.cz
Fixes: 1e0d4adf17e7 ("udf: Check consistency of Space Bitmap Descriptor")
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/balloc.c |   15 +++++++++++++--
 fs/udf/super.c  |    3 ++-
 2 files changed, 15 insertions(+), 3 deletions(-)

--- a/fs/udf/balloc.c
+++ b/fs/udf/balloc.c
@@ -68,8 +68,12 @@ static int read_block_bitmap(struct supe
 	}
 
 	for (i = 0; i < count; i++)
-		if (udf_test_bit(i + off, bh->b_data))
+		if (udf_test_bit(i + off, bh->b_data)) {
+			bitmap->s_block_bitmap[bitmap_nr] =
+							ERR_PTR(-EFSCORRUPTED);
+			brelse(bh);
 			return -EFSCORRUPTED;
+		}
 	return 0;
 }
 
@@ -85,8 +89,15 @@ static int __load_block_bitmap(struct su
 			  block_group, nr_groups);
 	}
 
-	if (bitmap->s_block_bitmap[block_group])
+	if (bitmap->s_block_bitmap[block_group]) {
+		/*
+		 * The bitmap failed verification in the past. No point in
+		 * trying again.
+		 */
+		if (IS_ERR(bitmap->s_block_bitmap[block_group]))
+			return PTR_ERR(bitmap->s_block_bitmap[block_group]);
 		return block_group;
+	}
 
 	retval = read_block_bitmap(sb, bitmap, block_group, block_group);
 	if (retval < 0)
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -266,7 +266,8 @@ static void udf_sb_free_bitmap(struct ud
 	int nr_groups = bitmap->s_nr_groups;
 
 	for (i = 0; i < nr_groups; i++)
-		brelse(bitmap->s_block_bitmap[i]);
+		if (!IS_ERR_OR_NULL(bitmap->s_block_bitmap[i]))
+			brelse(bitmap->s_block_bitmap[i]);
 
 	kvfree(bitmap);
 }


