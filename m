Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B06285CBA;
	Wed, 20 May 2026 18:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301973; cv=none; b=IooZ0AH0naLEzNynuzFO3y7tUw3Bf47O32he8ZNFQf1fQG8xZJAD5Ld55d+6Et1hHs1bRRJOql8DYrueTCnFvh+eqwftU4jny80Y04re/6Ky4ZmMDzYrD6Bjd6sq+x0Yev302FAyCiIQnmf2DdMzAFQKq2PBFyVELutDBEA06u0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301973; c=relaxed/simple;
	bh=mYS4/5Oryq5oG8fJgFovj8Of4siLofh0s4Y8EKF4wSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ueDylHCBo0fILJA5CoSrixVNleg1QQtw1VRAyz3+MWMNHRWPNqvfOBP4SgHat7F8P5Qlj53Bxpc9Ysa8/qZD+gMNxSeZ5RNwnDgu6HPAar/MlPEi8ja4Kxo1by2sgd8d8+OEaOLE5lGcI9t1lPexOXE/jz4xj6Ed48ATjJYDoWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xlPBD6pG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xlPBD6pG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5DD21F000E9;
	Wed, 20 May 2026 18:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301972;
	bh=KRPPlO1SVOeu/JzvBXyOIwfKtwq9PAM+9VwPSyvmwUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xlPBD6pGCdOOFyBTiZhPMEpf0PQZeVQezJFsJAjs+Hcu0KUkKGKXLWxvuCb2qqRUJ
	 PMK+Fh747r/CUaA34Zu4hBn+eoIXwH5wHcAsoA4WS38jeupi9KWvo1g4c9an/I+XxW
	 vnJSYYLUmTQr3L7FNhcmjGUEuAlBiAQZJNsqjmpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming-Hung Tsai <mtsai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 091/508] dm cache: fix null-deref with concurrent writes in passthrough mode
Date: Wed, 20 May 2026 18:18:34 +0200
Message-ID: <20260520162100.587631008@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming-Hung Tsai <mtsai@redhat.com>

[ Upstream commit 7d1f98d668ee34c1d15bdc0420fdd062f24a27c0 ]

In passthrough mode, when dm-cache starts to invalidate a cache
entry and bio prison cell lock fails due to concurrent write to
the same cached block, mg->cell remains NULL. The error path in
invalidate_complete() attempts to unlock and free the cell
unconditionally, causing a NULL pointer dereference:

KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 0 UID: 0 PID: 134 Comm: fio Not tainted 6.19.0-rc7 #3 PREEMPT
RIP: 0010:dm_cell_unlock_v2+0x3f/0x210
<snip>
Call Trace:
 invalidate_complete+0xef/0x430
 map_bio+0x130f/0x1a10
 cache_map+0x320/0x6b0
 __map_bio+0x458/0x510
 dm_submit_bio+0x40e/0x16d0
 __submit_bio+0x419/0x870
<snip>

Reproduce steps:

1. Create a cache device

dmsetup create cmeta --table "0 8192 linear /dev/sdc 0"
dmsetup create cdata --table "0 131072 linear /dev/sdc 8192"
dmsetup create corig --table "0 262144 linear /dev/sdc 262144"
dd if=/dev/zero of=/dev/mapper/cmeta bs=4k count=1 oflag=direct
dmsetup create cache --table "0 262144 cache /dev/mapper/cmeta \
/dev/mapper/cdata /dev/mapper/corig 128 2 metadata2 writethrough smq 0"

2. Promote the first data block into cache

fio --filename=/dev/mapper/cache --name=populate --rw=write --bs=4k \
--direct=1 --size=64k

3. Reload the cache into passthrough mode

dmsetup suspend cache
dmsetup reload cache --table "0 262144 cache /dev/mapper/cmeta \
/dev/mapper/cdata /dev/mapper/corig 128 2 metadata2 passthrough smq 0"
dmsetup resume cache

4. Write to the first cached block concurrently

fio --filename=/dev/mapper/cache --name test --rw=randwrite --bs=4k \
--randrepeat=0 --direct=1 --numjobs=2 --size 64k

Fix by checking if mg->cell is valid before attempting to unlock it.

Fixes: b29d4986d0da ("dm cache: significant rework to leverage dm-bio-prison-v2")
Signed-off-by: Ming-Hung Tsai <mtsai@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-cache-target.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 0d002d50329da..9c4aa5180a70e 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -1458,8 +1458,10 @@ static void invalidate_complete(struct dm_cache_migration *mg, bool success)
 	struct cache *cache = mg->cache;
 
 	bio_list_init(&bios);
-	if (dm_cell_unlock_v2(cache->prison, mg->cell, &bios))
-		free_prison_cell(cache, mg->cell);
+	if (mg->cell) {
+		if (dm_cell_unlock_v2(cache->prison, mg->cell, &bios))
+			free_prison_cell(cache, mg->cell);
+	}
 
 	if (!success && mg->overwrite_bio)
 		bio_io_error(mg->overwrite_bio);
-- 
2.53.0



