Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063126;
	b=SxWBfYMJHHALjCy/9GXMsWoADxq/KbMx6zvXBlX52RPAjpm5elnAyCJnRJUHbjkkGIAL
	 TzFEgH/a+3ZGeaRavHdwOyPzIkaxW/RmerIIHTtrj+bN0smUfJ9d6y3fs/Qg67RDu1XYX
	 3am6yPYJuRrYsfIoBbGTNtfR06ylDuBSwL9929CmK37ghovYEGt7DbrTL8q+P2+zXnpD1
	 zDdU2au5uJGPQOZKIKnycKiHtw1wZ8Sigszxqky/J70M2ojQWnZUZzPu5V7e9yCCofXCj
	 joKS6H7WAoJhAnI+rV88dU5HrMNkTOQEEowxxoOB3UF9tk7+4+cjPWvMcolu77KFp8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063126;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rgZuGQSORRMeXLERqSJd44QFgpUrPiJPE4kMDmmw8tQ=;
	b=TXGZYB/G0iJi6HpABQKDGNnliklLfkXDj1UP7KGUl/Ccjiyaq4Fe5GsZ255jiJj8wzYu
	 5hWJQR8mC9OHboTeQ5s81yHaB4AHlRFjK5rogVAVLewhoXObijFGY63bLKZgupWpd2G/F
	 E44dYrNN60BPJ4s6kA+9aUGKM5w6BGUkow+gdzgYzcDmvf9KQGsMmzYbVR1liy97yNacd
	 D5dYVa3Em1ODvJd2x3koQAmT5i1qneBJIJt8cKK1kqlR9qXnMJ1Z7YLo8VtHHLdctS+23
	 UeYA3YmDFoNBNVprs+yGCNF4Bp8zrIjBdHwy4jchth/RWRWe2Pf020iChM6xJLl1JqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y7alE9bc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 647A2606A330;
	Sat,  7 Nov 2026 14:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y7alE9bc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 125151F0089F;
	Sat,  7 Nov 2026 14:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063126;
	bh=rgZuGQSORRMeXLERqSJd44QFgpUrPiJPE4kMDmmw8tQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y7alE9bc0xJoOttgJRXJsGp4X96BVyoIwpAQI4m3K7/9E2M9hEtTou/7PYA7+j+xR
	 MdGqoiy4OgC/B5h9wUMwrWr9ZUeKPoiSNf0q4YY7T+gSd6VydE6FtqZoWPdiN0zeWj
	 g9xsEpvs3yaC3/qMCyzP9ZPszYXRwnmIZs50qUio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 317/869] dm-writecache: fix a quirk in statistics
Date: Sat,  7 Nov 2026 08:49:59 -0500
Message-ID: <20261107134903.235382083@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit c1ab80af0d99a906b60b769f2e692c37d2db1323 ]

writecache_bio_copy_ssd() unconditionally adds the number of extra blocks
in the merged bio to stats.writes_allocate. That is only correct when the
entries were taken off the freelist.

When the function is called with search_used == true -- i.e. from the
write_hits_uncommitted / write_hits_committed paths in
writecache_map_write() -- the first entry was found in the rbtree and
every following entry is picked up with rb_next(), so nothing is
allocated at all. Accordingly the writes_allocate++ that accompanies a
successful writecache_pop_from_freelist() is skipped for that case, but
the batch accounting below still adds n - 1.

An in-place overwrite of n contiguous cached blocks therefore reports n -
1 allocations that never happened. Only the dmsetup status output is
affected; there is no functional change.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-5
Cc: stable@vger.kernel.org
Fixes: b2676e1482af ("dm writecache: count number of blocks written, not number of write bios")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-writecache.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 1e32053c27172..d29f6b3abce4d 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -1424,7 +1424,8 @@ static void writecache_bio_copy_ssd(struct dm_writecache *wc, struct bio *bio,
 	dm_accept_partial_bio(bio, bio_size >> SECTOR_SHIFT);
 
 	wc->stats.writes += bio->bi_iter.bi_size >> wc->block_size_bits;
-	wc->stats.writes_allocate += (bio->bi_iter.bi_size - wc->block_size) >> wc->block_size_bits;
+	if (!search_used)
+		wc->stats.writes_allocate += (bio->bi_iter.bi_size - wc->block_size) >> wc->block_size_bits;
 
 	if (unlikely(wc->uncommitted_blocks >= wc->autocommit_blocks)) {
 		wc->uncommitted_blocks = 0;
-- 
2.53.0



