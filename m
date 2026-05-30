Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E2D26738C;
	Sat, 30 May 2026 18:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166389; cv=none; b=g5asEGgpGkiuyM8ej84MxtaXrjnuKgAIZW830VnOGcYLFVQ3QnCTSSnBbgeHYxe10l6d377ddG5suk2ImzjDBFzjx9arGzpL1zCAnQfUNKwrhICqzZSGT5JZ8Fti/qHZ0hcytmcEzV9Rxy6QzUt8di1lhEv+Vt/FValf54w5SeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166389; c=relaxed/simple;
	bh=aB7RXX+8k9FmiKAzurHNYjnnb5n1tki1VIOtpch2upc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PdTcDxl7kKAFkRhaFLw2pMb5Xtzwi4UEpCoEY68Mn2h7+eLFbadHxWTMKn+1cyxxMOwluHwso5PDdk2T0KO+ldRVsyY2KxSCbHOAzHfwlfMKmhadA4GPQeESTNIZ6LhIZNNB1SSJazXXHwWYG/ipKRKhm+UoAC+p7Rdm/0VYSAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0ExMrbpM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ExMrbpM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C8551F00893;
	Sat, 30 May 2026 18:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166388;
	bh=gB5O+dtN0KhmAD6gdaOX9qCdCTbMD+BXX/mtI+WtcTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0ExMrbpMtbFUA3R1e7MYMErX5tLZcdxnEu9W3siMQHmFBjRWKdK/WT87pnwWJaX8D
	 qtz54ozrmDk8cplumZLXm0Kv2Ixg1+dhwTVUXu77K8bolmFLuoVt1yLkQ30HECAzuN
	 2gJJ33fiROEeBrnVkn+rOdS+qidDzqj7N8NDZKI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming-Hung Tsai <mtsai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 324/589] dm cache policy smq: fix missing locks in invalidating cache blocks
Date: Sat, 30 May 2026 18:03:25 +0200
Message-ID: <20260530160233.441932068@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming-Hung Tsai <mtsai@redhat.com>

[ Upstream commit 2d1f7b65f5deedd2e6b09fdc6ea27f8375f24b45 ]

In passthrough mode, the policy invalidate_mapping operation is called
simultaneously from multiple workers, thus it should be protected by a
lock. Otherwise, we might end up with data races on the allocated blocks
counter, or even use-after-free issues with internal data structures
when doing concurrent writes.

Note that the existing FIXME in smq_invalidate_mapping() doesn't affect
passthrough mode since migration tasks don't exist there, but would need
attention if supporting fast device shrinking via suspend/resume without
target reloading.

Reproduce steps:

1. Create a cache device consisting of 1024 cache entries

dmsetup create cmeta --table "0 8192 linear /dev/sdc 0"
dmsetup create cdata --table "0 131072 linear /dev/sdc 8192"
dmsetup create corig --table "0 262144 linear /dev/sdc 262144"
dd if=/dev/zero of=/dev/mapper/cmeta bs=4k count=1 oflag=direct
dmsetup create cache --table "0 262144 cache /dev/mapper/cmeta \
/dev/mapper/cdata /dev/mapper/corig 128 2 metadata2 writethrough smq 0"

2. Populate the cache, and record the number of cached blocks

fio --name=populate --filename=/dev/mapper/cache --rw=randwrite --bs=4k \
--size=64m --direct=1
nr_cached=$(dmsetup status cache | awk '{split($7, a, "/"); print a[1]}')

3. Reload the cache into passthrough mode

dmsetup suspend cache
dmsetup reload cache --table "0 262144 cache /dev/mapper/cmeta \
/dev/mapper/cdata /dev/mapper/corig 128 2 metadata2 passthrough smq 0"
dmsetup resume cache

4. Write to the passthrough cache. By setting multiple jobs with I/O
   size equal to the cache block size, cache blocks are invalidated
   concurrently from different workers.

fio --filename=/dev/mapper/cache --name=test --rw=randwrite --bs=64k \
--direct=1 --numjobs=2 --randrepeat=0 --size=64m

5. Check if demoted matches cached block count. These numbers should
   match but may differ due to the data race.

nr_demoted=$(dmsetup status cache | awk '{print $12}')
echo "$nr_cached, $nr_demoted"

Fixes: b29d4986d0da ("dm cache: significant rework to leverage dm-bio-prison-v2")
Signed-off-by: Ming-Hung Tsai <mtsai@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-cache-policy-smq.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/dm-cache-policy-smq.c b/drivers/md/dm-cache-policy-smq.c
index 859073193f5b4..95b0670c32acd 100644
--- a/drivers/md/dm-cache-policy-smq.c
+++ b/drivers/md/dm-cache-policy-smq.c
@@ -1584,14 +1584,18 @@ static int smq_invalidate_mapping(struct dm_cache_policy *p, dm_cblock_t cblock)
 {
 	struct smq_policy *mq = to_smq_policy(p);
 	struct entry *e = get_entry(&mq->cache_alloc, from_cblock(cblock));
+	unsigned long flags;
 
 	if (!e->allocated)
 		return -ENODATA;
 
+	spin_lock_irqsave(&mq->lock, flags);
 	// FIXME: what if this block has pending background work?
 	del_queue(mq, e);
 	h_remove(&mq->table, e);
 	free_entry(&mq->cache_alloc, e);
+	spin_unlock_irqrestore(&mq->lock, flags);
+
 	return 0;
 }
 
-- 
2.53.0



