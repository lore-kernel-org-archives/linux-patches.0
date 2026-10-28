Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214938;
	b=lJdCIjfjLWvTcpazwF78M2kijG9Fi76z8TZ60XzegX4+Tok2wQefGIN7wS98tHGO8HKD
	 T0lqyRG8fqwCTzaJD2LbgECzzMAu6DtnqtRXO9hTfcjqCXM2vkPRtLyXZCoWNfcwTjejO
	 BgufRUugv9C7ym1TQEVkDvhJdlTBUFvHS7MqML6trKLm2UdYBakgrYRs29DaRpV63SuWa
	 N6KHIEqe2fsGBd+ImeOo2ga9b+TqBjHaUJDAtuu5Pw0U0M1IGK5dIgoyynsUV3icrV13D
	 WuhN1sUYif/og3EWgPQM1A+a7jVpjTL7Ut8k8bMWk/GSQYkDJ5ykUPxArZyAmJAXlvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214938;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fg/gHu9JmDajEcVXsS6puqxA0hcConXssGbh5+QIIRc=;
	b=oKvWLy+T+2xlV6hO2aZwTWnevwKnAJNomtLK5Q1OA6TKA91z78hI/Ypbj1vj/YrfHlss
	 lTW033y4ZMHA/xlgcKubGHQfsFc26/dDPZOqm7FOwPG7mreAZMULM3eIiPpjq2bt9W8qQ
	 GTDfrQEvoy21HAa0SmrRm5hLvFCqAcbQlzHdP7j5rGbXs2YzORh8x4VD1fbufkyR+/On/
	 9rJfhTXVqO1k/aePqFuO7Vt+5jQlUWKWCkIF7pdGKpNuhb45YX0Ud0sA3QUOD/0KuWbre
	 TkcFBuwfnm+lpmbpBK3Fd2QMNFjA6twtgA2VQbeGwzR7GSBOq128FATUb4gcn169tIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BQcZng9b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A390606A31F;
	Wed, 28 Oct 2026 19:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BQcZng9b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67FFC1F01825;
	Wed, 28 Oct 2026 19:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214938;
	bh=fg/gHu9JmDajEcVXsS6puqxA0hcConXssGbh5+QIIRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BQcZng9bETM3SHbTMhXuWyoUEHl/+hZFjTVV+KMO+wRtmRbdvvGk0ZMz6+pXTalIk
	 Pvtxnn5E8HbOEuA/qfa8ppEetOQfVckr9liJEnpnnd9mZtpnGDdyfJQoM4/PfzT74R
	 JW4YY8VbRUDUEzyaWEahv8LlgR/vxofeTp9AAwcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1033/1887] ext4: convert some BUG_ONs in mballoc to use WARN_RATELIMITED instead
Date: Wed, 28 Oct 2026 17:52:09 +0100
Message-ID: <20261028170522.919344949@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
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
index 4f35376134056..c1968918366ee 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1546,7 +1546,13 @@ ext4_mb_load_buddy_gfp(struct super_block *sb, ext4_group_t group,
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
@@ -1582,7 +1588,13 @@ ext4_mb_load_buddy_gfp(struct super_block *sb, ext4_group_t group,
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
@@ -2305,7 +2317,9 @@ void ext4_mb_simple_scan_group(struct ext4_allocation_context *ac,
 			continue;
 
 		buddy = mb_find_buddy(e4b, i, &max);
-		BUG_ON(buddy == NULL);
+		if (WARN_RATELIMIT(buddy == NULL,
+			 "ext4: mb_simple_scan_group: mb_find_buddy failed, (%d)\n", i))
+			continue;
 
 		k = mb_find_next_zero_bit(buddy, max, 0);
 		if (k >= max) {
@@ -4316,15 +4330,14 @@ static void ext4_discard_allocated_blocks(struct ext4_allocation_context *ac)
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
2.53.0



