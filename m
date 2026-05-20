Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB51372B58;
	Wed, 20 May 2026 17:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297881; cv=none; b=kGkKEUhROV/8LKz3n41INy6ENWKYsbqPmNxNKEAJRySZEtAUSppmeN1W6sryQXlAoHqvmBF3tDztXU0AJr87H2uw/nLsTuj/NFrGQSxqV3Q0s+gpCMfZ+4g3KO7Y4/WEhp75Rj0Tm4E+DDOyuRpRPINlHpjDKe7CmHYvlVfsIjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297881; c=relaxed/simple;
	bh=CDo+YTRUWNfT3HZfjlfVZ+X+JHv2z4zoXJcx95Cdilk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uD2lWC6k8kuRTs0zvty/qTnLD2/+HXGP1bQGf5iGamGwni9J619hm4c+EfI6O7oL1xpBwzY+t+y2tNBYFmqdrVdjYFiae92ga12L1OtgKZ7PqRGgsI8PMmNrEK0M74LcHa3tUtgZv54w/ldcbEiezH5GC4NQuXbhP3ryqJJ3WjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cEB0VbCn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cEB0VbCn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C9991F00893;
	Wed, 20 May 2026 17:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297880;
	bh=bIZ8dA62MlNoeoZGuXlM2hcoitCuuICVkSBF+x/EmYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cEB0VbCnVItFOYuuo4I16sA3AeafKhrM8ckR4O37+6sF3uw6YU4Fk7hdV8LhvTxTu
	 ol+aF830G9AG82r00StT6Z3fz49CjAhxDvzyjloEJG7PSCI9rRh8cBe0PI1S9CGNnp
	 wpMYWYpnoNAIC+H4+YW1Z4qLF9m4t6XKyntmtnMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming-Hung Tsai <mtsai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 199/957] dm cache: fix write path cache coherency in passthrough mode
Date: Wed, 20 May 2026 18:11:22 +0200
Message-ID: <20260520162138.863485725@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming-Hung Tsai <mtsai@redhat.com>

[ Upstream commit 0c5eef0aad508231d8e43ff8392692925e131b68 ]

In passthrough mode, dm-cache defers write bio submission until cache
invalidation completes to maintain existing coherency, requiring the
target map function to return DM_MAPIO_SUBMITTED. The current map_bio()
returns DM_MAPIO_REMAPPED, violating the required ordering constraint.

Reproduce steps:

1. Create a cache device

dmsetup create cmeta --table "0 8192 linear /dev/sdc 0"
dmsetup create cdata --table "0 131072 linear /dev/sdc 8192"
dmsetup create corig --table "0 262144 linear /dev/sdc 262144"
dd if=/dev/zero of=/dev/mapper/cmeta bs=4k count=1 oflag=direct
dmsetup create cache --table "0 262144 cache /dev/mapper/cmeta \
/dev/mapper/cdata /dev/mapper/corig 128 2 metadata2 writethrough smq 0"

2. Promote the first data block into the cache

fio --filename=/dev/mapper/cache --name=populate --rw=write --bs=4k \
--direct=1 --size=64k

3. Reload the cache into passthrough mode

dmsetup suspend cache
dmsetup reload cache --table "0 262144 cache /dev/mapper/cmeta \
/dev/mapper/cdata /dev/mapper/corig 128 2 metadata2 passthrough smq 0"
dmsetup resume cache

4. Write to the first data block, and check io ordering using ftrace

echo 1 > /sys/kernel/debug/tracing/events/block/block_bio_queue/enable
echo 1 > /sys/kernel/debug/tracing/events/block/block_bio_complete/enable
echo 1 > /sys/kernel/debug/tracing/events/block/block_rq_complete/enable
fio --filename=/dev/mapper/cache --name=test --rw=write --bs=64k \
--direct=1 --size 64k

5. ftrace logs show that write operations to the cache origin (252:2)
   and metadata operations (252:0) are unsynchronized: the origin write
   occurs before metadata commit.

 <snip>
       fio-146  [000] .....  420.139562: block_bio_queue: 252,3 WS 0 + 128 [fio]
       fio-146  [000] .....  420.149395: block_bio_queue: 252,2 WS 0 + 128 [fio]
       fio-146  [000] .....  420.149763: block_bio_queue: 8,32 WS 262144 + 128 [fio]
       fio-146  [000] dNh1.  420.151446: block_rq_complete: 8,32 WS () 262144 + 128 be,0,4 [0]
       fio-146  [000] dNh1.  420.152731: block_bio_complete: 252,2 WS 0 + 128 [0]
       fio-146  [000] dNh1.  420.154229: block_bio_complete: 252,3 WS 0 + 128 [0]
 kworker/0:0-9  [000] .....  420.160530: block_bio_queue: 252,0 W 408 + 8 [kworker/0:0]
 kworker/0:0-9  [000] .....  420.161641: block_bio_queue: 8,32 W 408 + 8 [kworker/0:0]
 kworker/0:0-9  [000] .....  420.162533: block_bio_queue: 252,0 W 416 + 8 [kworker/0:0]
 kworker/0:0-9  [000] .....  420.162821: block_bio_queue: 8,32 W 416 + 8 [kworker/0:0]
 <snip>

Fixes: b29d4986d0da ("dm cache: significant rework to leverage dm-bio-prison-v2")
Signed-off-by: Ming-Hung Tsai <mtsai@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-cache-target.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 1296965cf94cf..69fa2f6479318 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -1703,6 +1703,7 @@ static int map_bio(struct cache *cache, struct bio *bio, dm_oblock_t block,
 				bio_drop_shared_lock(cache, bio);
 				atomic_inc(&cache->stats.demotion);
 				invalidate_start(cache, cblock, block, bio);
+				return DM_MAPIO_SUBMITTED;
 			} else
 				remap_to_origin_clear_discard(cache, bio, block);
 		} else {
-- 
2.53.0



