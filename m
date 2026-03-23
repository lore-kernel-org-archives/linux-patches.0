Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D08A1282F3A;
	Mon, 23 Mar 2026 16:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282264; cv=none; b=kFm/EUF+f9nTP5BP2dsVKP3bljqrJU0Ozv0zePOsPURriOeCkqm4GQrdRsMGrbmzY+sIzsLCCo4wHtrnGi1RkK7qwMovTHlG1qnejl4uGOKX/53aEwe36h4iAcNrEIkAEG1dekzpGJChH9OPAH84E96iEgMOoIy1esojJ7gzk9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282264; c=relaxed/simple;
	bh=6qs4Pe/64LLyw6ThE57PoPyZB1Mk2ydAxXIRPOKKVck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yd2TteJxjYidFdNvr36ZaN8wAY/xMtrJjSL9AXAW9ZgWBmci5X4tRfmO2ij6aHQQqM/EcqH92r2HVN8uq6rbBrmkRF5r2TV6pTPJ80MkMnggfDb6vCvPodRPfviG3RNez6NfU09X8DfCDClRECnxXQaElrCXKGSKmLSePlVSg+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CXo63WE8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CXo63WE8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6229BC4CEF7;
	Mon, 23 Mar 2026 16:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282264;
	bh=6qs4Pe/64LLyw6ThE57PoPyZB1Mk2ydAxXIRPOKKVck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CXo63WE8Ym0dHwOuU8CXa3IwNR6d47VlbXuKPF9mBN9GHmbjQv9IeKnRkkvkKMl3c
	 X2wfPA4rWQknm73kpeq17ykB6HFP/okIURCaiuj2ooUK0TrecHDT2SCM8pczkqQYue
	 0LIn7KcrRRjZMavtOIaeJbREYiICZl6T6cfZlmqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 049/481] ext4: convert some BUG_ONs in mballoc to use WARN_RATELIMITED instead
Date: Mon, 23 Mar 2026 14:40:31 +0100
Message-ID: <20260323134526.425174090@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

[ Upstream commit 19b8b035a776939ceb3de0f45aded4751d7849ef ]

In cases where we have an obvious way of continuing, let's use
WARN_RATELIMITED() instead of BUG_ON().

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: bdc56a9c46b2 ("ext4: fix e4b bitmap inconsistency reports")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 7431ff97a68c8..2a385dc610704 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1531,7 +1531,13 @@ ext4_mb_load_buddy_gfp(struct super_block *sb, ext4_group_t group,
 			put_page(page);
 		page = find_or_create_page(inode->i_mapping, pnum, gfp);
 		if (page) {
-			BUG_ON(page->mapping != inode->i_mapping);
+			if (WARN_RATELIMIT(page->mapping != inode->i_mapping,
+	"ext4: bitmap's paging->mapping != inode->i_mapping\n")) {
+				/* should never happen */
+				unlock_page(page);
+				ret = -EINVAL;
+				goto err;
+			}
 			if (!PageUptodate(page)) {
 				ret = ext4_mb_init_cache(page, NULL, gfp);
 				if (ret) {
@@ -1567,7 +1573,13 @@ ext4_mb_load_buddy_gfp(struct super_block *sb, ext4_group_t group,
 			put_page(page);
 		page = find_or_create_page(inode->i_mapping, pnum, gfp);
 		if (page) {
-			BUG_ON(page->mapping != inode->i_mapping);
+			if (WARN_RATELIMIT(page->mapping != inode->i_mapping,
+	"ext4: buddy bitmap's page->mapping != inode->i_mapping\n")) {
+				/* should never happen */
+				unlock_page(page);
+				ret = -EINVAL;
+				goto err;
+			}
 			if (!PageUptodate(page)) {
 				ret = ext4_mb_init_cache(page, e4b->bd_bitmap,
 							 gfp);
@@ -2286,7 +2298,9 @@ void ext4_mb_simple_scan_group(struct ext4_allocation_context *ac,
 			continue;
 
 		buddy = mb_find_buddy(e4b, i, &max);
-		BUG_ON(buddy == NULL);
+		if (WARN_RATELIMIT(buddy == NULL,
+			 "ext4: mb_simple_scan_group: mb_find_buddy failed, (%d)\n", i))
+			continue;
 
 		k = mb_find_next_zero_bit(buddy, max, 0);
 		if (k >= max) {
@@ -4312,15 +4326,14 @@ static void ext4_discard_allocated_blocks(struct ext4_allocation_context *ac)
 		if (ac->ac_f_ex.fe_len == 0)
 			return;
 		err = ext4_mb_load_buddy(ac->ac_sb, ac->ac_f_ex.fe_group, &e4b);
-		if (err) {
+		if (WARN_RATELIMIT(err,
+				   "ext4: mb_load_buddy failed (%d)", err))
 			/*
 			 * This should never happen since we pin the
 			 * pages in the ext4_allocation_context so
 			 * ext4_mb_load_buddy() should never fail.
 			 */
-			WARN(1, "mb_load_buddy failed (%d)", err);
 			return;
-		}
 		ext4_lock_group(ac->ac_sb, ac->ac_f_ex.fe_group);
 		mb_free_blocks(ac->ac_inode, &e4b, ac->ac_f_ex.fe_start,
 			       ac->ac_f_ex.fe_len);
-- 
2.51.0



