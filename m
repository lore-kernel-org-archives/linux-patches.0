Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774101;
	b=c9WYAp1ZxfRkd9bbyIvohDNk6sbE0+jIuo8ZgTtK5D3axPJnE9BbHlu73uJsMRwyrK66
	 OR7GeYI+LBMD4RxsSrE4TTDXka2LgjE0smHkMFoezbuBLlOR8n3Zts6z1HwPfhBNMcgpz
	 +Icc7pa761RBNjUu2HOM9N5DYAsv020RN2GGA1DM0RSzHj/ryGrYP7GID0gZQXk4PKtXs
	 KxlZKJCWzHq0YnpwK0GLpbRoREW+/7r2kRz5jFaCKLEIBY4QWfqhRsUs4U+jJIphA9Eic
	 NZRIwcSclwnLQReFwrSh0ab47tZs8cvgnzFkDZs22VWoZ4bK37raqMbUdrdRULz4dxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774101;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GsE/Xis6rjcbuP/fUe+9k9HQYq6n1qIQOcC+du+oszo=;
	b=KQvAsh5ne4CnkAKBwhMeg4VOj9freZRG6QRXDO09HSsRLuq/lVL5p3ETE81c8KGKXZh+
	 xJVNRGBEJfrm6I0TsZnOi2VSb+W2/z5xxpRwBPREF3FtnKreSdFgpEFM1VuQlxnuZOHHa
	 en9Uf7+CU8Yhyc7uKawEhR7+gSd4M9iUThx5ZSM0ib184t2mfimYyhxZwj84zXlZGwTV3
	 jQVXcz1fgueAAr/OhnST/gleMqvds7s5snlUjIpjmE15GW4hE0IvkKVlUyBXR4kXj5zY+
	 apCHgcWYtPkLpkAUOGa8zG04ngNhGssXoo7IiP9Y+ldRIPNkkolQSyoovwUOnFle3hA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eyW7kwem;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9319606A31B;
	Fri, 23 Oct 2026 16:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eyW7kwem
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43F831F01828;
	Fri, 23 Oct 2026 16:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774100;
	bh=GsE/Xis6rjcbuP/fUe+9k9HQYq6n1qIQOcC+du+oszo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eyW7kwemHt+G/VKVpWHL/2KLQP9UmpmJM71um/mZRu1tCTWRUSbNLTfdi/C93hGij
	 0lsOw1D+x1lNaZZF/2A6xBOcrMSfWZfH8JwRsQ4TrW4Lv4xBe9PvHwqcg/oz9mhlee
	 7a/M57LI/pTqV2WqIuQbBQJLhtSqdOQauC93q1L8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Marzinski <bmarzins@redhat.com>,
	Ming-Hung Tsai <mtsai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.18 121/193] dm cache: fix demotion stats in passthrough mode
Date: Fri, 23 Oct 2026 18:36:38 +0200
Message-ID: <20261023163717.066741516@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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


