Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D131A619E;
	Tue, 30 Jul 2024 16:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358354; cv=none; b=BOEkPhEdlWAF3KnD57HkQvrOczscoHxv9X7Kr5CtGg1o2hycRfZxAXKXlzJvA+wE12s7/Ny9AfNrQip5eIwg2wDbtbL59vrUTV0H97k/GctpfXTlTNIyHbMqNeRxIv7nv4LshvJeSkg4RIq4DCU20N+qNovwa125vH36tn92E5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358354; c=relaxed/simple;
	bh=D3yevytANEwQe6x4oE720RuexFSZN9folyPdDgidZK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oR2CkPRKkmoonEasLNtvcw4clj375clU6ydgwOKi3yn/Fz6yVTS3YyZ5VmpbDGY/HNtLLdVU7M006+NWn778AmPqoss+P6IMqO+yBFpF4QZuBJo9iQ5k2nQ2uyBCBYRDyqG/zyI/nJBFkfiyBO5Ygb0ppDRIVKF6gHbNs8eS4Lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IifFBoWm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IifFBoWm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D21F1C32782;
	Tue, 30 Jul 2024 16:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358354;
	bh=D3yevytANEwQe6x4oE720RuexFSZN9folyPdDgidZK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IifFBoWmOs4L257bObUcWVeCUx9+ZddrCJM0HJi6TambFdP6GJklDBOFjuD3UkvIC
	 QdTAQ8rlAeSOmWcfHkp3ZpeBBwEZbWJGA9E0gEAgbeFGl1M4cuI50LzTl1bME/2+q1
	 a5K6hmixAkLi5EdZiowmza4OnKq8XYGTSbz5NSQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linke li <lilinke99@qq.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 354/568] sbitmap: use READ_ONCE to access map->word
Date: Tue, 30 Jul 2024 17:47:41 +0200
Message-ID: <20240730151653.702927655@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: linke li <lilinke99@qq.com>

[ Upstream commit 6ad0d7e0f4b68f87a98ea2b239123b7d865df86b ]

In __sbitmap_queue_get_batch(), map->word is read several times, and
update atomically using atomic_long_try_cmpxchg(). But the first two read
of map->word is not protected.

This patch moves the statement val = READ_ONCE(map->word) forward,
eliminating unprotected accesses to map->word within the function.
It is aimed at reducing the number of benign races reported by KCSAN in
order to focus future debugging effort on harmful races.

Signed-off-by: linke li <lilinke99@qq.com>
Link: https://lore.kernel.org/r/tencent_0B517C25E519D3D002194E8445E86C04AD0A@qq.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 72d04bdcf3f7 ("sbitmap: fix io hung due to race on sbitmap_word::cleared")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/sbitmap.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/lib/sbitmap.c b/lib/sbitmap.c
index d0a5081dfd122..d1247f34d584e 100644
--- a/lib/sbitmap.c
+++ b/lib/sbitmap.c
@@ -499,18 +499,18 @@ unsigned long __sbitmap_queue_get_batch(struct sbitmap_queue *sbq, int nr_tags,
 		struct sbitmap_word *map = &sb->map[index];
 		unsigned long get_mask;
 		unsigned int map_depth = __map_depth(sb, index);
+		unsigned long val;
 
 		sbitmap_deferred_clear(map);
-		if (map->word == (1UL << (map_depth - 1)) - 1)
+		val = READ_ONCE(map->word);
+		if (val == (1UL << (map_depth - 1)) - 1)
 			goto next;
 
-		nr = find_first_zero_bit(&map->word, map_depth);
+		nr = find_first_zero_bit(&val, map_depth);
 		if (nr + nr_tags <= map_depth) {
 			atomic_long_t *ptr = (atomic_long_t *) &map->word;
-			unsigned long val;
 
 			get_mask = ((1UL << nr_tags) - 1) << nr;
-			val = READ_ONCE(map->word);
 			while (!atomic_long_try_cmpxchg(ptr, &val,
 							  get_mask | val))
 				;
-- 
2.43.0



