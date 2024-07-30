Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC0A91A6192;
	Tue, 30 Jul 2024 16:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357196; cv=none; b=eSp7IRO9vxl4IqU19RdS/rxMi90dZlha2LiuQKXndYDszjeYEKe6hfM7OsVfHqt5Z1EXTHLL74rr0vz5ldMOY7h+GnKUUVQ6NhfeOomDNTXiRqeFUbGtQPow+rvlTJ2N7YVVToRuPlTkZxWlB1eO89FSzEyvQK6SfByZl3i0tU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357196; c=relaxed/simple;
	bh=D57W64CB1oznOWpaj7Qjpp1eCbW8XhQWLjrpl2p9Rdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uGHm/C7LvcElziB26QEw6mUbEUYaM3MpOP5IInUKkowRXYO5fc3JbV50a/6zvbkgE0IX/wQQ3V+l5TOHq9dl4vMdT5mUfPbpncwEldu+DDy/oBsanj4pDXl1VVbUAZ0fuvuAJaX+547wy01gNxDpYWIk6q89VGqecIdwTWTW1VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pN44LNCc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pN44LNCc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C10FC32782;
	Tue, 30 Jul 2024 16:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357196;
	bh=D57W64CB1oznOWpaj7Qjpp1eCbW8XhQWLjrpl2p9Rdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pN44LNCc/CvKnOo78fD9q6YlGiByHhq014kRqAEHYf6KhlWGr2NuTRBqE/QsKd8jV
	 odPtt1zWbShmhvZ/yyd8cNJnd7iP3ZqluFlDQPygla/+hYOQiVl21/99iLxzj8NWZa
	 ExuO/z5sTFk4v67XdU75zzXYsbZlnZbs7e8Z2PLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linke li <lilinke99@qq.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 268/440] sbitmap: use READ_ONCE to access map->word
Date: Tue, 30 Jul 2024 17:48:21 +0200
Message-ID: <20240730151626.306632582@linuxfoundation.org>
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
index b942f2ba9a415..a727d0b12763a 100644
--- a/lib/sbitmap.c
+++ b/lib/sbitmap.c
@@ -503,18 +503,18 @@ unsigned long __sbitmap_queue_get_batch(struct sbitmap_queue *sbq, int nr_tags,
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



