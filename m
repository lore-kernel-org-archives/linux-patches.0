Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C528D45C1C;
	Mon, 14 Oct 2024 15:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918548; cv=none; b=ggbpee2QLlPIqkON4XdlNMN+fAquPNP772hLzP5DEf//JYdgoJ/xw/sMCTADnrR36RUTNYcvOa4bddQhiraDNTj8dioDxf9xG+0a92NVoeb52r2ZTEpgvrciSk4oGAwNnl38Ipd0W+Oh0yfLbm9Inna8E9Gw+DErBbXUf92+4UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918548; c=relaxed/simple;
	bh=Gqy6SHsI9P4HkeRE5P1iUV9kyheNlUDU86OTPl4ujho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E6TI6ini5VCY+QnKNxRv48RRXUkVanOGC2kWd2HTNUZTAfo5yCH7n6358qM5LVKiP1gNtO+Z+eGWq64xCt+fGocqAKANao7Re0yF2cRWfmgXLU0bheyP7iSoEl2930Wgv44ipRs4kTEg+UkOe7FQFHupZ2xh6hkcHVEj9r9UvHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gvSfMJwg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gvSfMJwg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E6BDC4CEC3;
	Mon, 14 Oct 2024 15:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918548;
	bh=Gqy6SHsI9P4HkeRE5P1iUV9kyheNlUDU86OTPl4ujho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gvSfMJwgncnMXVJ1GTTgtDeqN1R8QpsraXzwGHJU/KEmPQ3T2LMnWXoC+wXCV5qH+
	 plmk6K+679a2tdBTQqJ4lj9mtuWoKGssgsiRPziOLmuQxGc0Ry6N+7EidPdkcfnkl2
	 9ycDdflJDUuADlrL5CkbNStGDmiJ0Yf4gHepsu+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.1 327/798] f2fs: fix several potential integer overflows in file offsets
Date: Mon, 14 Oct 2024 16:14:41 +0200
Message-ID: <20241014141230.798915231@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -426,7 +426,7 @@ static unsigned int __free_extent_tree(s
 static void __drop_largest_extent(struct extent_tree *et,
 					pgoff_t fofs, unsigned int len)
 {
-	if (fofs < et->largest.fofs + et->largest.len &&
+	if (fofs < (pgoff_t)et->largest.fofs + et->largest.len &&
 			fofs + len > et->largest.fofs) {
 		et->largest.len = 0;
 		et->largest_updated = true;
@@ -505,7 +505,7 @@ static bool __lookup_extent_tree(struct
 
 	if (type == EX_READ &&
 			et->largest.fofs <= pgofs &&
-			et->largest.fofs + et->largest.len > pgofs) {
+			(pgoff_t)et->largest.fofs + et->largest.len > pgofs) {
 		*ei = et->largest;
 		ret = true;
 		stat_inc_largest_node_hit(sbi);
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2671,7 +2671,7 @@ static int f2fs_defragment_range(struct
 	 * block addresses are continuous.
 	 */
 	if (f2fs_lookup_read_extent_cache(inode, pg_start, &ei)) {
-		if (ei.fofs + ei.len >= pg_end)
+		if ((pgoff_t)ei.fofs + ei.len >= pg_end)
 			goto out;
 	}
 


