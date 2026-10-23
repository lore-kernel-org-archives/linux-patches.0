Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774855;
	b=DhN1FOoRWe6UxV4gOJWPotoxmBajb7LLgAsrmcOqw44a3v0YSLZkKzmDyC166DSV+Yno
	 zR3VrXUOR7J2dfWHv2G2Cx7MsNoUtBJMZFWH7oT2GqM0x+Z1FUUJoOQMoz2b5lZA4FAxz
	 /0AXR7/f3Q633cylVLtWhqwzUrQxnkn18zCt8ArHYd962dOYJ+TCZRyXkjs53oT/dijQ+
	 eXWQF8+I261g96OUOfz2m+R3K9nGAaLOuhjU5MS5ydQwKlM+AKZbyDrU1LmmzvrBOTr6C
	 ilmX3pnLwl+qI91NQit1G4U0AqUkVhDy4+VXvvtOsYd15bLEZZBefn2G/5u97AByeQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774855;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=asw6CN8qgNc2cLRYhO/dBOTWbKTkGVl9wp8a9L5jDvA=;
	b=Z56heHCMLmYMA4x9MqaRSU6ym381IBj1Gcr9R0BGMxifFw1UZrJbRQaNAh0d5Fs5ShFz
	 KAxq2TgWDzgAslsZIHk/6XQKwClSnbDLSJ+XK/DGU3YFnenBDBQGCOYubj4dFp7EuUlrm
	 nlfJVCuI3RlBJkZ9An858inNeRUTamkEB5NcBCaLJfWQ6PhjOsFAFmthHBsSFMEjpfaLP
	 mF4gTiM6HQIh28aDd6x1BHlglrJkdzNadXiuMiv3KKNecxi8kLgke2fBscC8OhJ7jx/dp
	 ABgXk/SDEkgho/K22OwgMCBsU1TMghQoCsvLwCBEh+A8x1g/UFpk0L9TbACZ67IV0Fg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WHLE8s1E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97AEF606A31B;
	Fri, 23 Oct 2026 17:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WHLE8s1E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E58101F01825;
	Fri, 23 Oct 2026 17:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774855;
	bh=asw6CN8qgNc2cLRYhO/dBOTWbKTkGVl9wp8a9L5jDvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WHLE8s1EesdIjzl3FDqyqhClMFkPXc27RoKKqJ+PKdOR0GLq0ighQrzbLA3kC2CKS
	 VLN4UuJ5sJTL3np8QlKwojJRuBD6DNuFvJDStYyrnTBC/GMXXkfaSyt9rzyD5yBYp6
	 mcRC3WpWQgbviHZC72sDfPXXp6XF3mWmbtV0SLXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Marzinski <bmarzins@redhat.com>,
	Ming-Hung Tsai <mtsai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.2 182/242] dm cache: fix demotion stats in passthrough mode
Date: Fri, 23 Oct 2026 18:40:24 +0200
Message-ID: <20261023163718.092402479@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1461,6 +1461,9 @@ static void invalidate_complete(struct d
 	struct bio_list bios;
 	struct cache *cache = mg->cache;
 
+	if (success)
+		atomic_inc(&cache->stats.demotion);
+
 	bio_list_init(&bios);
 	if (mg->cell) {
 		if (dm_cell_unlock_v2(cache->prison, mg->cell, &bios))
@@ -1732,7 +1735,6 @@ static int map_bio(struct cache *cache,
 		if (passthrough_mode(cache)) {
 			if (bio_data_dir(bio) == WRITE) {
 				bio_drop_shared_lock(cache, bio);
-				atomic_inc(&cache->stats.demotion);
 				invalidate_start(cache, cblock, block, bio);
 				return DM_MAPIO_SUBMITTED;
 			} else


