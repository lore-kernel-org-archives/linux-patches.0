Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211821;
	b=2lGx2ga/FOqUes0wIao80WuPb4h9n7/TC+idZJbc34+Qkj+V0uM/CxhyfI/zhqMoe8CF
	 QFHwBMBzukGRPNgB7v/cIwkX2OJXkYXOBckzZFGAb/T/sKgxEaM6O+KexdqO8kjCbnG8d
	 tH7JXXDXoVMQojlWlf1f0TJ2BsHDJTsNgZVGy5dx0go/oF+SCKI9LgTFT3lfY3bQsgQAg
	 /PowQqRZpDm7+ZPYg74ZZGGguAEwgUp0NceC6onDgRFGQXN3tocc0YRGR8/UUWFmFmuXt
	 NcBkMc7LCWnmX+WxU2WKLMUhBI1MWaeQsuC+5HZd2OgcJ4kpav9Qm2q8Q4PMVx1jpMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211821;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c8WVqqRgPIOFitjG/5w+DXez1ML60mHQ5NKKhbY6oY8=;
	b=GYF5h03KWY+J9Ret/V6TspFdfZQ6Zu5t4u4l6L1ZfM6tfbkprqHHM0MymZitxMyQadoQ
	 piDj6vQhDPVk32j58yQz6/CQLm32PcZVN+OK0qEYra7aWG7V00Q4Ab+ca03j59jukir+0
	 ASTXkrxBV/NPV5CAeqadhlgKN31/RefItgLSpAeePv29lR4FrPQgiSjGf7F97x4WMLAbw
	 1RlRDDGgnpttIgy0525nlfVlecDHpi9Qj/BmPeCL+fuqim9t5fJnTsOYikmKh4T2Ac2uU
	 RcCCJmuuJ4TSt9O0ldC2pjdjrNJ5efRtXPoPY0bMYxiUFPVkvO9OOAK9peLdAGCQ5BQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pnGe+mBr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24BE860A2626;
	Wed, 28 Oct 2026 18:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pnGe+mBr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 750CF1F031E8;
	Wed, 28 Oct 2026 18:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211821;
	bh=c8WVqqRgPIOFitjG/5w+DXez1ML60mHQ5NKKhbY6oY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pnGe+mBrTlBVjgxgMEeIIX9HZeZ0UKYP2b/y5xBZOJZLBDJHzDA4uN3tzbBW6lccI
	 S5uDtYvhn+KPRtY8biohqCDRvSOZm/qsnbEdEuXQjillyqGG0Ai8BM6P2wphpMt8lJ
	 XD4HR+nUze8f4DJw0TOpxcp/it6zudeLr4L89u7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Marzinski <bmarzins@redhat.com>,
	Ming-Hung Tsai <mtsai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.15 510/571] dm cache: fix demotion stats in passthrough mode
Date: Wed, 28 Oct 2026 18:00:57 +0100
Message-ID: <20261028170020.130775280@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming-Hung Tsai <mtsai@redhat.com>

commit 2ccb8878c149443c6acf628b438c9c942c20abb2 upstream.

The demotion counter is incremented per incoming write bio before the
invalidation begins, causing the demotion count to exceed the actual
number of cached blocks when multiple bios target the same cached
block. Additionally, the counter is incremented unconditionally
regardless of invalidation failure.

Reproduce steps:

1. Create a cache device consisting of 512 cache entries

modprobe brd rd_size=262144
dmsetup create cmeta --table "0 8192 linear /dev/ram0 0"
dmsetup create cdata --table "0 65536 linear /dev/ram0 8192"
dmsetup create corig --table "0 65536 linear /dev/ram0 262144"
dd if=/dev/zero of=/dev/mapper/cmeta bs=4k count=1 oflag=direct
dmsetup create cache --table "0 65536 cache /dev/mapper/cmeta \
/dev/mapper/cdata /dev/mapper/corig 128 2 metadata2 writethrough smq 0"

2. Populate the cache, and record the number of cached blocks

fio --name=populate --filename=/dev/mapper/cache --rw=randwrite --bs=4k \
--direct=1 --ioengine=libaio --iodepth=32 --io_size=2048m
nr_cached=$(dmsetup status cache | awk '{split($7, a, "/"); print a[1]}')

3. Reload the cache into passthrough mode

dmsetup suspend cache
dmsetup reload cache --table "0 65536 cache /dev/mapper/cmeta \
/dev/mapper/cdata /dev/mapper/corig 128 2 metadata2 passthrough smq 0"
dmsetup resume cache

4. Write to the passthrough cache with multiple jobs to trigger
   multiple bios hitting the same cached block.

fio --filename=/dev/mapper/cache --name=test --rw=write --bs=4k \
--direct=1 --ioengine=libaio --iodepth=32 --numjobs=4

5. Check if demoted matches cached block count. These numbers should
   match but may differ due to overcounting per bio.

nr_demoted=$(dmsetup status cache | awk '{print $12}')
echo "$nr_cached, $nr_demoted"

Fix by moving the demotion counter increment into invalidate_complete(),
gated on the success flag.

Reported-by: Ben Marzinski <bmarzins@redhat.com>
Fixes: b29d4986d0da ("dm cache: significant rework to leverage dm-bio-prison-v2")
Cc: stable@vger.kernel.org
Signed-off-by: Ming-Hung Tsai <mtsai@redhat.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-cache-target.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -1453,6 +1453,9 @@ static void invalidate_complete(struct d
 	struct bio_list bios;
 	struct cache *cache = mg->cache;
 
+	if (success)
+		atomic_inc(&cache->stats.demotion);
+
 	bio_list_init(&bios);
 	if (mg->cell) {
 		if (dm_cell_unlock_v2(cache->prison, mg->cell, &bios))
@@ -1697,7 +1700,6 @@ static int map_bio(struct cache *cache,
 		if (passthrough_mode(cache)) {
 			if (bio_data_dir(bio) == WRITE) {
 				bio_drop_shared_lock(cache, bio);
-				atomic_inc(&cache->stats.demotion);
 				invalidate_start(cache, cblock, block, bio);
 				return DM_MAPIO_SUBMITTED;
 			} else


