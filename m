Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062160;
	b=Gpi91sozFVrZyUuEKNaLTuRxHuX3FOxz74LM9P+EYYKhMiDkIya98nqxiEsBfLrxXvzs
	 567vrQfXmlbiFzHTcdTczbPGzgel4y+F3+H8jKYF1YhqRGEy0PP+MVuO9QV58yer/Faqd
	 +ShY4WlNGR4US/W5iCU/OMcX6VFiR3WMX0ivUq9DsnooMHBOSnIdIPr9d+l9rJtt1Mxap
	 fHzZyW8f6SrI8x5vbasTZ1jy2/E/Al6HDOQ8I6wk8vniL7WAqSflcqxKB6ALsGLaoww62
	 ww6Dggy1Fneal7HGzgJRluoX97Fwu7fWBs//uHzErvKJP3rIUYOSpr6n3VoOtPs8nWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062160;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=McdclI/+1XpgRgdOUWf70pZYcA57YkCR2qhVxJrbLTo=;
	b=ThoXqTohYNtieoy7Vg6ujzlkgRpYF90HAQ/ZPTfX3M9l1LSOH63FuwNXPrsFRUugkLCI
	 NeqW6qLYyFnystRZ7Q19k0peBQTSDeZBLwUXvpiF5xi4t7AxMx/B523vlx8ZIyV6CTfYH
	 pltaGmWKv2rkQOr7REmuempsK9zlWqTjwQLs8GZMPG9blWevNE2/dsp+4qChpKUzOAtpo
	 pEs14UcpYwoq11fxasolYto8DlTbWq3VQZVj/CNSRjNsuaxz/0mKbURyd73flZL2Szehr
	 e6dNJyNkvIk4O42/dsp9LELY1FKuvNr4bStkwRiS2EKVRGgQ3SgoDtovp0KwFuNo/Cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WEScl0Fp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96788606A326;
	Sat,  7 Nov 2026 14:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WEScl0Fp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53B761F0089F;
	Sat,  7 Nov 2026 14:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062160;
	bh=McdclI/+1XpgRgdOUWf70pZYcA57YkCR2qhVxJrbLTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WEScl0FpRWmX/7P7U/6iVd05KXg8Cn8yx3mw5PTC95mYVyu0uoRU8nnJWLow/qpUm
	 RWETOCbAp7HeT7WfCJ9dbMSjbOv1K0HqnWPLBbAMYFHDmNJz/01WfXgAsDQnw9Jame
	 yDT+sjpwkUehBwwboWl53QGLxgQ0ABmOnwWlhKKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1124/1536] dm-writecache: fix a quirk in statistics
Date: Sat,  7 Nov 2026 08:52:20 -0500
Message-ID: <20261107135029.278186350@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d9e0008c32372..be22d5ae696f7 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -1423,7 +1423,8 @@ static void writecache_bio_copy_ssd(struct dm_writecache *wc, struct bio *bio,
 	dm_accept_partial_bio(bio, bio_size >> SECTOR_SHIFT);
 
 	wc->stats.writes += bio->bi_iter.bi_size >> wc->block_size_bits;
-	wc->stats.writes_allocate += (bio->bi_iter.bi_size - wc->block_size) >> wc->block_size_bits;
+	if (!search_used)
+		wc->stats.writes_allocate += (bio->bi_iter.bi_size - wc->block_size) >> wc->block_size_bits;
 
 	if (unlikely(wc->uncommitted_blocks >= wc->autocommit_blocks)) {
 		wc->uncommitted_blocks = 0;
-- 
2.53.0



