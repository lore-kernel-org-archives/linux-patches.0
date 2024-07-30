Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43FB41A6195;
	Tue, 30 Jul 2024 16:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357187; cv=none; b=Peru6hVZPhXF+9jQ8KfMr8mUysuTNYMsZove7SLRujbJPLuwIiv0pmCviTwo1+aF8hEvzhtgv8+wA1LQ3oVx5EoIjQZrJC1TI33s/XWcFtvNIHatNloTPpIpA2didm7OzQAb71VhUruVanpDtH+l8MFk/Dz3TRjFZYa3YQIaZTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357187; c=relaxed/simple;
	bh=ibVCS+aHQZzIehd3HxS4C3XV2htWSV4Nn6fUEa9jhTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JpVaUXeN8VZA+/WbG7Td0+9N2u7hw3ZPbK+fbIQ4khHQS48iyJMUwrLl49FOMhPorV3gHSD8Yb8etEJegSSdnbKLjQ+tMLNENCxtL24/sdzO2dOFZvLzp4yB1/N+BHAgsRV9JRMmc+PU26/QEeSGgZzqew7+HTLqRORXXPbTQa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vaCdq1eu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vaCdq1eu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A62D3C32782;
	Tue, 30 Jul 2024 16:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357187;
	bh=ibVCS+aHQZzIehd3HxS4C3XV2htWSV4Nn6fUEa9jhTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vaCdq1eukNwKwJTdiRo5GJIq7ulOU4Enq76TubuDVTKIaBwHGrDfT2BH8j674dqCD
	 ZZYO3ikFFooZ0aHDWvFR7gVDk1VrrAsOcidrH1r3QQ76zpv/xO+Ca1lZ5cd8EcyVsI
	 Oo15BbGHoI/QMST+MyeeA8WpSamDXYAW3azGDOFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 267/440] sbitmap: rewrite sbitmap_find_bit_in_index to reduce repeat code
Date: Tue, 30 Jul 2024 17:48:20 +0200
Message-ID: <20240730151626.267645157@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

From: Kemeng Shi <shikemeng@huaweicloud.com>

[ Upstream commit 08470a98a7d7e32c787b23b87353f13b03c23195 ]

Rewrite sbitmap_find_bit_in_index as following:
1. Rename sbitmap_find_bit_in_index to sbitmap_find_bit_in_word
2. Accept "struct sbitmap_word *" directly instead of accepting
"struct sbitmap *" and "int index" to get "struct sbitmap_word *".
3. Accept depth/shallow_depth and wrap for __sbitmap_get_word from caller
to support need of both __sbitmap_get_shallow and __sbitmap_get.

With helper function sbitmap_find_bit_in_word, we can remove repeat
code in __sbitmap_get_shallow to find bit considring deferred clear.

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Link: https://lore.kernel.org/r/20230116205059.3821738-4-shikemeng@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 72d04bdcf3f7 ("sbitmap: fix io hung due to race on sbitmap_word::cleared")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/sbitmap.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/lib/sbitmap.c b/lib/sbitmap.c
index b9dd0a0a28f89..b942f2ba9a415 100644
--- a/lib/sbitmap.c
+++ b/lib/sbitmap.c
@@ -167,15 +167,16 @@ static int __sbitmap_get_word(unsigned long *word, unsigned long depth,
 	return nr;
 }
 
-static int sbitmap_find_bit_in_index(struct sbitmap *sb, int index,
-				     unsigned int alloc_hint)
+static int sbitmap_find_bit_in_word(struct sbitmap_word *map,
+				    unsigned int depth,
+				    unsigned int alloc_hint,
+				    bool wrap)
 {
-	struct sbitmap_word *map = &sb->map[index];
 	int nr;
 
 	do {
-		nr = __sbitmap_get_word(&map->word, __map_depth(sb, index),
-					alloc_hint, !sb->round_robin);
+		nr = __sbitmap_get_word(&map->word, depth,
+					alloc_hint, wrap);
 		if (nr != -1)
 			break;
 		if (!sbitmap_deferred_clear(map))
@@ -203,7 +204,9 @@ static int __sbitmap_get(struct sbitmap *sb, unsigned int alloc_hint)
 		alloc_hint = 0;
 
 	for (i = 0; i < sb->map_nr; i++) {
-		nr = sbitmap_find_bit_in_index(sb, index, alloc_hint);
+		nr = sbitmap_find_bit_in_word(&sb->map[index],
+					      __map_depth(sb, index),
+					      alloc_hint, !sb->round_robin);
 		if (nr != -1) {
 			nr += index << sb->shift;
 			break;
@@ -246,20 +249,17 @@ static int __sbitmap_get_shallow(struct sbitmap *sb,
 	alloc_hint = SB_NR_TO_BIT(sb, alloc_hint);
 
 	for (i = 0; i < sb->map_nr; i++) {
-again:
-		nr = __sbitmap_get_word(&sb->map[index].word,
-					min_t(unsigned int,
-					      __map_depth(sb, index),
-					      shallow_depth),
-					alloc_hint, true);
+		nr = sbitmap_find_bit_in_word(&sb->map[index],
+					      min_t(unsigned int,
+						    __map_depth(sb, index),
+						    shallow_depth),
+					      alloc_hint, true);
+
 		if (nr != -1) {
 			nr += index << sb->shift;
 			break;
 		}
 
-		if (sbitmap_deferred_clear(&sb->map[index]))
-			goto again;
-
 		/* Jump to next index. */
 		alloc_hint = 0;
 		if (++index >= sb->map_nr)
-- 
2.43.0



