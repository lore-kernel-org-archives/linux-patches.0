Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585961;
	b=2TD0D/r47mU4V9RqODK/1Fp0OxeMcr85Ho0FIMa3hJo13sk1QPD0QNuA8+kBtO6VN64I
	 M9VHc6xJvWZN08MoqaM1DD5fXuuzsVULgGGYzWED158tM81MUoYz5GBDesosQHb7ca7IQ
	 5IFmoHNILwrlipKTdsfsFVncAroUkMaCwAHLV8+OK7v2Rs+MlkTBqb7rLjIluxB5dmWDJ
	 dd+yNbcUVqm67zY52tFrjwm8rtxx7qOw6iNn3GUe5pufl8HP/EmdOI5z0iIXCKeAqwxy6
	 a5+yYU5s+fgTydkgwFot9dSnRfo/QCLzIh6+Sd//c78UzUGBULHlOmvKxPFcw04vjxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585961;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ywS+EmMnLUcg0qUuk3SQWAc2qTCxnT4qZg0iQHL+whk=;
	b=SMLOAWjsdIxNJCbTsUkmIiSCB4z2fOTqukyocXNMu2yFP9LiMv9IrxnovDDIFwYhFXZ6
	 1rFYksqpNe0bOHRNt4H/bjp0URVtqpp+82ct2oULvcwGam60gNPcbbvHy8jCwMw3MlTcj
	 2P4WeciKryMg/Y+7YpNqWh2ZyndfZo9h5RdHS1LZArODeBS5PCYFRUJwQlzIYkL2d5Ug5
	 oeGBETXO+N9huSK4ZT9YXUJRUpSffFUJjG9Xso1uRNamflbBqSo8F9tUUwzbE/D4JJyDL
	 ayj66UHbC4UCN69NL2vTNL03vlScrzsEh9idjkPWF3zu3UABzkGtkzUaWSgEMmmzslw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JoIeML5e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD6C86076E25;
	Fri, 13 Nov 2026 16:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JoIeML5e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F6661F000C4;
	Fri, 13 Nov 2026 16:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585961;
	bh=ywS+EmMnLUcg0qUuk3SQWAc2qTCxnT4qZg0iQHL+whk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JoIeML5eh09HxbFdTB8b0XtQZ3RFQowX3PuH4rUpgVK2nbzogjqjFXWepFtn/EFl8
	 mnvip6tjG2DOymRrVyZaY2Qp5cDOYsPXEVpu7axiMWhmk6EvHw1IWEfyX3VQPPLxgJ
	 Q0v+bd2ivCIWa5Sh/BuovGohDStFf2QltVPx0fP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 506/507] f2fs: fix to use bio_in_atomic() in f2fs_write_end_io()
Date: Fri, 13 Nov 2026 10:53:30 -0500
Message-ID: <20261113153814.345306671@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit e4582e5f3b439228d4e900edcf8225aa89be32b4 ]

f2fs_write_end_io() uses in_atomic() to decide whether a write bio which
exceeds max_atc_write_bio_size or max_atc_write_bio_entry_cnt should be
completed in sbi->wq rather than in the current context.

However, in_atomic() is not meant to be used outside core kernel code
(checkpatch.pl warns about it), as it only looks at preempt_count(): it
misses irqs-disabled and RCU read-side critical sections, and on kernels
without CONFIG_PREEMPT_COUNT it cannot see spinlock-held sections at all.
In those contexts, a large write bio will still be completed inline,
which defeats the purpose of the above knobs.

The block layer provides bio_in_atomic() for exactly this purpose, it
checks rcu_preempt_depth() and preemptible(), and conservatively returns
true if CONFIG_PREEMPT_COUNT is disabled, let's use it instead. The
difference is as below:

 Context                              | in_atomic()    | bio_in_atomic()
 -------------------------------------+----------------+----------------
 Hard IRQ / softirq                   | true           | true
 IRQs disabled, preempt count 0       | false (missed) | true
 RCU read lock (CONFIG_PREEMPTION)    | false (missed) | true
 Kernel w/o CONFIG_PREEMPT_COUNT      | IRQ ctx only   | always true

Note that on kernels without CONFIG_PREEMPT_COUNT, write bios exceeding
the thresholds will always be offloaded to sbi->wq, since there is no way
to tell whether the current context is atomic. The thresholds default to
UINT_MAX, so the default behavior is not changed.

Cc: stable@kernel.org
Fixes: 3de6b8094115 ("f2fs: Run f2fs_write_end_io() asynchronously")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
[ sashal: Retained the bio-size check without the entry-count condition because the required fields are absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index cc601b65163be..e0abc159b796c 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -400,7 +400,8 @@ static void f2fs_write_end_io(struct bio *bio)
 
 	sbi = bio->bi_private;
 
-	if (in_atomic() && bio->bi_iter.bi_size > sbi->max_atc_write_bio_size) {
+	if (bio_in_atomic() &&
+	    bio->bi_iter.bi_size > sbi->max_atc_write_bio_size) {
 		struct work_struct *w;
 
 		w = &container_of(bio, struct f2fs_bio, bio)->work;
-- 
2.53.0



