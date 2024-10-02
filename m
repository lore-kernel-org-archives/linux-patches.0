Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83831BDA95;
	Wed,  2 Oct 2024 13:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877092; cv=none; b=n6yx2ACmzZsBrSqGi0PcPsQuJ6JZi+C35oWn1OuHSQvrM7O9aad8I2llM95j/aiwTG6nvMeCVw67efPpTJBSVTWQXoX3/4SZUu0KxvHmE/55K9TC0jHlOU4JBBd4sVDHsTj+W7TaJdoi02D6X3ew0RbVy86vkp5R3+6XjLU6GA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877092; c=relaxed/simple;
	bh=ESueIXgOmJkb+FuBI4/+N7e2ZEmZXYRKmvSwriqlVLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nPHlsHCagh1FsSccl/btQ4heFSohh9/AzIJfX9lpm1mz20BnHJvLs7D76BeGIbirQDJuxjhT3F4l3/hfmX8KW+hLC18MhfLKitiN4HsJ7P6ytVSz3ThKNvcN24NKzF3yl7VXKSL53yQRnQK5sS4Iw4f/l1S4qpVqpQyIX0A2NlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gkTsZ/52; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gkTsZ/52"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BBE7C4CEC2;
	Wed,  2 Oct 2024 13:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877091;
	bh=ESueIXgOmJkb+FuBI4/+N7e2ZEmZXYRKmvSwriqlVLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gkTsZ/52M2E8Gm2VWDzSNTYkx11sCpISJh14AlSwWq3wpNehwT8CDPHu5rgQhNl3f
	 lAeBy22ADQFIuF9jwXdI+6dfugKT0RvKqiRqbTuTfrRfO5QETXwOrol/23k5bGUhTe
	 cUtjCzKs5LmOMftF1WEho1pbf81dHfUs+qf5CQ4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.11 630/695] f2fs: fix several potential integer overflows in file offsets
Date: Wed,  2 Oct 2024 15:00:28 +0200
Message-ID: <20241002125847.663444868@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

commit 1cade98cf6415897bf9342ee451cc5b40b58c638 upstream.

When dealing with large extents and calculating file offsets by
summing up according extent offsets and lengths of unsigned int type,
one may encounter possible integer overflow if the values are
big enough.

Prevent this from happening by expanding one of the addends to
(pgoff_t) type.

Found by Linux Verification Center (linuxtesting.org) with static
analysis tool SVACE.

Fixes: d323d005ac4a ("f2fs: support file defragment")
Cc: stable@vger.kernel.org
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/extent_cache.c |    4 ++--
 fs/f2fs/file.c         |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/fs/f2fs/extent_cache.c
+++ b/fs/f2fs/extent_cache.c
@@ -366,7 +366,7 @@ static unsigned int __free_extent_tree(s
 static void __drop_largest_extent(struct extent_tree *et,
 					pgoff_t fofs, unsigned int len)
 {
-	if (fofs < et->largest.fofs + et->largest.len &&
+	if (fofs < (pgoff_t)et->largest.fofs + et->largest.len &&
 			fofs + len > et->largest.fofs) {
 		et->largest.len = 0;
 		et->largest_updated = true;
@@ -456,7 +456,7 @@ static bool __lookup_extent_tree(struct
 
 	if (type == EX_READ &&
 			et->largest.fofs <= pgofs &&
-			et->largest.fofs + et->largest.len > pgofs) {
+			(pgoff_t)et->largest.fofs + et->largest.len > pgofs) {
 		*ei = et->largest;
 		ret = true;
 		stat_inc_largest_node_hit(sbi);
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2731,7 +2731,7 @@ static int f2fs_defragment_range(struct
 	 * block addresses are continuous.
 	 */
 	if (f2fs_lookup_read_extent_cache(inode, pg_start, &ei)) {
-		if (ei.fofs + ei.len >= pg_end)
+		if ((pgoff_t)ei.fofs + ei.len >= pg_end)
 			goto out;
 	}
 


