Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590584;
	b=fzVLceNVvmFa/UoyH80Zo16gI7VnJa4jS9W5oXz19qn6i1PSM21hww06x2bM3SAtzcrE
	 W6xVcNudcOZMuj0ZFkr1E2KAXX2cc9leonsFdO6NzqlcCeZl86ioFQn0oZocltmxMwA8U
	 3sKpHWwLxK+YadocqcRDLdSNl93husFeKpGZa7ugPhtfZnyqwx2D8kQ3ma+L2kB25Hr5K
	 6o8Mj7/AekayEFGufhocUN0fTZ2jQfO8bD1VMpvwBsrZFmwLbtO4zbNKf8jS8t58Z/x9I
	 0YfkOJlAsEDK4QNmrNbUf/qM0CnGUwG2/KXiD3WW2aOQ5v2Zjo10sHs9WEp+eK4ZNXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590584;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CM9xsoMfPUgyBB2XMegBAKPVttU7PGmZzOdZ62tplAo=;
	b=XAGf2gZPWDP0nAgHOHVrii+4rkmoiGjuyj68UewjOVsuXIYIYpdLojgfzuKDElgFtvQp
	 cD2aR/MD3GxGn8LcX/h49rv9epTURh43443BH2fO1NXr1iXKsHIK1wE6Hg3lfNXruFAdG
	 EDQN9oXuo1epUeAZYTD3+hIFJUjSHK7cyvY6VUiv7L8SS4c5y2s2phhn7mYDuOqOM6ol6
	 VLa8dpc8mNZi1NDm8K36IhmbskrLgROHGzdIA7YevUgu3HhHB+f+uhMQ2lqdDFauIaQkm
	 1+AkDTpZZ8xOZeq9ILuQUd23gZn+ht9ABYKFlKLsKjJDi5cy4bqbguvm7ivv7jlyhmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BZLU0q8u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7061F606BD38;
	Fri, 13 Nov 2026 17:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BZLU0q8u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D5131F000C4;
	Fri, 13 Nov 2026 17:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590584;
	bh=CM9xsoMfPUgyBB2XMegBAKPVttU7PGmZzOdZ62tplAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BZLU0q8uCeMXECCUNWYFkQznUq2+q78BdsjP5ZTh8aXqYGECn4DV7M/wM5gJp1BZW
	 tNE4+TLYzFIEBmUrlr3idNTBys33TIISkhlnID+nRyO8HGxKn1bjt6SpeegMxmM3IP
	 q5gDCafys7kygM5KiUpgfu5Z6z3XYhpyUBKU1WRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 517/686] f2fs: fix to check continuousness in f2fs_sync_meta_pages() correctly
Date: Fri, 13 Nov 2026 10:50:50 -0500
Message-ID: <20261113153838.686117131@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 1383cff4ccf3c8833c6255edffa29eb67c6419bb ]

In f2fs_sync_meta_pages(), whenever i becomes zero inside while loop,
below check may be skipped, it failed to check the continuousness:

	if (nr_to_write != LONG_MAX && i != 0 &&
		folio->index != prev +
		folio_nr_pages(fbatch.folios[i-1])) {

Cc: stable@kernel.org
Fixes: 580e7a492608 ("f2fs: convert f2fs_sync_meta_pages() to use filemap_get_folios_tag()")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
[ sashal: Adapted cached-block continuity tracking to the folio-based f2fs_sync_meta_pages() implementation. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/checkpoint.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 4c54d75c8981e..14db6b571bc28 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -411,7 +411,7 @@ long f2fs_sync_meta_pages(struct f2fs_sb_info *sbi, enum page_type type,
 				long nr_to_write, enum iostat_type io_type)
 {
 	struct address_space *mapping = META_MAPPING(sbi);
-	pgoff_t index = 0, prev = ULONG_MAX;
+	pgoff_t index = 0, next = ULONG_MAX;
 	struct folio_batch fbatch;
 	long nwritten = 0;
 	int nr_folios;
@@ -430,9 +430,8 @@ long f2fs_sync_meta_pages(struct f2fs_sb_info *sbi, enum page_type type,
 		for (i = 0; i < nr_folios; i++) {
 			struct folio *folio = fbatch.folios[i];
 
-			if (nr_to_write != LONG_MAX && i != 0 &&
-					folio->index != prev +
-					folio_nr_pages(fbatch.folios[i-1])) {
+			if (nr_to_write != LONG_MAX && next != ULONG_MAX &&
+					folio->index != next) {
 				folio_batch_release(&fbatch);
 				goto stop;
 			}
@@ -460,7 +459,7 @@ long f2fs_sync_meta_pages(struct f2fs_sb_info *sbi, enum page_type type,
 				break;
 			}
 			nwritten += folio_nr_pages(folio);
-			prev = folio->index;
+			next = folio->index + folio_nr_pages(folio);
 			if (unlikely(nwritten >= nr_to_write))
 				break;
 		}
-- 
2.53.0



