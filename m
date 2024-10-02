Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A96791D07AC;
	Wed,  2 Oct 2024 13:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876453; cv=none; b=POSgh1D1mcEkViQRGh1NHUAUOowRPqqa3CgHAOZ/9u5ttRlDaPnkLWHpNIThOm6EFnEACEw20IPVmmuGPbI6CF88GqtEW7eKJ1GbVF+4fNWnFRAEdcHJXxqARmAW39RoFYkdl0/xlGkoe+9Nx/llcmLp8Jms7z0tOJ6ZScrG9Ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876453; c=relaxed/simple;
	bh=yyBP4vKJgSQNpkpRaDIDRTzO2bGXjWq1AUSBpGDZd3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mFItytQS6iNa47wR6ikx4miJ67q1wJUzGd9FOBEJZeJ/+SKKcm8IzBRRQp9d0cpUII5SFdqsCY35eCU+GHdy5DZd9hTn4uCtxtEbqPODqgRnl0R/sp6TBhiVTj3IP6XCCFsUCXPmM/dEi3ci7q6cfiyMLcTqNiq8lfqYzUmPvKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wgHGfrdd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wgHGfrdd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D88C4CECE;
	Wed,  2 Oct 2024 13:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876453;
	bh=yyBP4vKJgSQNpkpRaDIDRTzO2bGXjWq1AUSBpGDZd3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wgHGfrddQmmT/xNwxybj2ly4Cnp2NMR7D9GUK7b4gWR+LXjntIUopbV68HSqYHImc
	 MFWkb4ShckB08t7L5RQvv4UtFeUMnkJl7GjaIVcLRmjRDSoqt5bV55PM9WMhmpjQvQ
	 2MzVJn37P6iQqBuswx00y5k2dBwJi6TBrz4wJ5Ag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yang <yang.yang@vivo.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 449/695] lib/sbitmap: define swap_lock as raw_spinlock_t
Date: Wed,  2 Oct 2024 14:57:27 +0200
Message-ID: <20241002125840.382984985@linuxfoundation.org>
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
index 5e2e93307f0d0..d3412984170c0 100644
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



