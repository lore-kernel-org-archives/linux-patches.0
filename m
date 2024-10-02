Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A541D0BA8;
	Wed,  2 Oct 2024 14:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880120; cv=none; b=lo58PeL+O0KueTY566Q86fYZAkR+VOFCDIuYTd9Fpx1vBN5qFkJxyw3SpltOaFD3gDPk8y/jBv+Zk9AQliWFDk8zO9XyuXsB64nI2zEpWFu7PBKwrNeiVVaCyaPoLjFgxGVWC8d3StHdBDrysOYtoC1og1ryuwaAUyqGgX16534=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880120; c=relaxed/simple;
	bh=B5vIOY1kzOVMNuCV0P31wQgjXRR3rVE2dDI5bt8xd38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mvOyaQc9ZiWG/qzyzuaGyREwOkwbhOIV2Y3PiJgn0ZAM9aB5qffoXKe67VGRGRVTecOKTUWwHFuONuqaqagF+OcEZ/Px4++sXX7/U+sEKvwnu5ANBHuxtNbM8tuSOXwpZcTdc9QIyNxAK/a+BWyK9Vk3F3sQVzj1thy1EAy9890=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g415+dZ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g415+dZ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28A52C4CEC2;
	Wed,  2 Oct 2024 14:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880120;
	bh=B5vIOY1kzOVMNuCV0P31wQgjXRR3rVE2dDI5bt8xd38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g415+dZ6ChJccFaftCLYkyck6E+U3UeI/kJ0ASigCPimEfAjtpGrebvQOghxnIIOi
	 uzCzmiAhOwE9i7g/fV6YmNhtoim/MgU8kREC8fVCtH9lnGSXV82G6JdVJnaHBY4/yd
	 AyucpxSbwN1BTK0EyEzLUOgLna5B3a8Zd363tVfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yang <yang.yang@vivo.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 350/538] lib/sbitmap: define swap_lock as raw_spinlock_t
Date: Wed,  2 Oct 2024 14:59:49 +0200
Message-ID: <20241002125806.244007873@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 65f666c6203600053478ce8e34a1db269a8701c9 ]

When called from sbitmap_queue_get(), sbitmap_deferred_clear() may be run
with preempt disabled. In RT kernel, spin_lock() can sleep, then warning
of "BUG: sleeping function called from invalid context" can be triggered.

Fix it by replacing it with raw_spin_lock.

Cc: Yang Yang <yang.yang@vivo.com>
Fixes: 72d04bdcf3f7 ("sbitmap: fix io hung due to race on sbitmap_word::cleared")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Yang Yang <yang.yang@vivo.com>
Link: https://lore.kernel.org/r/20240919021709.511329-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sbitmap.h | 2 +-
 lib/sbitmap.c           | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/sbitmap.h b/include/linux/sbitmap.h
index c09cdcc99471e..189140bf11fc4 100644
--- a/include/linux/sbitmap.h
+++ b/include/linux/sbitmap.h
@@ -40,7 +40,7 @@ struct sbitmap_word {
 	/**
 	 * @swap_lock: serializes simultaneous updates of ->word and ->cleared
 	 */
-	spinlock_t swap_lock;
+	raw_spinlock_t swap_lock;
 } ____cacheline_aligned_in_smp;
 
 /**
diff --git a/lib/sbitmap.c b/lib/sbitmap.c
index 9307bf17a8175..1d5e157486922 100644
--- a/lib/sbitmap.c
+++ b/lib/sbitmap.c
@@ -65,7 +65,7 @@ static inline bool sbitmap_deferred_clear(struct sbitmap_word *map,
 {
 	unsigned long mask, word_mask;
 
-	guard(spinlock_irqsave)(&map->swap_lock);
+	guard(raw_spinlock_irqsave)(&map->swap_lock);
 
 	if (!map->cleared) {
 		if (depth == 0)
@@ -136,7 +136,7 @@ int sbitmap_init_node(struct sbitmap *sb, unsigned int depth, int shift,
 	}
 
 	for (i = 0; i < sb->map_nr; i++)
-		spin_lock_init(&sb->map[i].swap_lock);
+		raw_spin_lock_init(&sb->map[i].swap_lock);
 
 	return 0;
 }
-- 
2.43.0



