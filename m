Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A44372B58;
	Wed, 20 May 2026 17:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297892; cv=none; b=bhUXpakEhwsoCPVn6WlacuPjaaz6xCc3NWa3QrHuLAt/NepPoNr48uWx14faziz/R75KN2PkJI2WCKXVoU7ZM6xGRrplCqUJGfKh71ojp9OjwnoagAOr9LSit7vf5/eVLSXF5aoxXJ0y2JHL22eAEapUoygabPVgZl5O87qqKKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297892; c=relaxed/simple;
	bh=1FZSZZOvO7Dx8BFmM/Pzjb0QpzJmiQCsthWuNkQmxIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YgaNk3icS+gDG7ILPb46S51QdtQKq/ZsG4mEDXOteAuhesd0e93ZODGP/7xyLIFTcYsyUhSnGXerpUZAgvDWkMJYFjEaR0zO3Jxmp2m4r+7LNK+nEy5X+PCiar2PI0JUGmMsJzOGyaIrAPZdP3X5fyeoWm/sFSojHcj1vCIYNek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jvBfpZV3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jvBfpZV3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D8891F000E9;
	Wed, 20 May 2026 17:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297891;
	bh=n3PX7rOf/QxNX2YuBNsTQf6tpoN+pAyWbDkIx4HbWcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jvBfpZV3Ydi2fAaxuh1M+QiuOY+ZGNSBgyZz35uH8odu84rm8VVov5G4sA9XTUV8F
	 1rKtvGODmB+kCEjRcTHieWrs2zuB+IOj3J66KUkmjAc0Zk/CPeLy5OzLvdQxvYimU1
	 YlDq4/bXKqENNw+qyiS6Kq0LFuV8kmZAsxrJ1eR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming-Hung Tsai <mtsai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 202/957] dm cache: fix concurrent write failure in passthrough mode
Date: Wed, 20 May 2026 18:11:25 +0200
Message-ID: <20260520162138.926237641@linuxfoundation.org>
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

[ Upstream commit e4f66341779d0cf4c83c74793753a84094286d9e ]

When bio prison cell lock acquisition fails due to concurrent writes to
the same block in passthrough mode, dm-cache incorrectly returns an I/O
error instead of properly handling the concurrency. This can occur in
both process and workqueue contexts when invalidate_lock() is called for
exclusive access to a data block. Fix this by deferring the write bios
to ensure proper block device behavior.

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

4. Write to the first cached block concurrently. Sometimes one of the
   processes will receive I/O errors.

fio --filename=/dev/mapper/cache --name test --rw=randwrite --bs=4k \
--randrepeat=0 --direct=1 --numjobs=2 --size 64k

 <snip>
 fio-3.41
 fio: io_u error on file /dev/mapper/cache: Input/output error: write offset=4096, buflen=4096
 fio: pid=106, err=5/file:io_u.c:2008, func=io_u error, error=Input/output error
 test: (groupid=0, jobs=1): err= 0: pid=105
 test: (groupid=0, jobs=1): err= 5 (file:io_u.c:2008, func=io_u error, error=Input/output error): pid=106
 <snip>

Fixes: b29d4986d0da ("dm cache: significant rework to leverage dm-bio-prison-v2")
Signed-off-by: Ming-Hung Tsai <mtsai@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-cache-target.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index b191ea1361b40..e8709950dc49d 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -1561,6 +1561,15 @@ static int invalidate_lock(struct dm_cache_migration *mg)
 			    READ_WRITE_LOCK_LEVEL, prealloc, &mg->cell);
 	if (r < 0) {
 		free_prison_cell(cache, prealloc);
+
+		/* Defer the bio for retrying the cell lock */
+		if (mg->overwrite_bio) {
+			struct bio *bio = mg->overwrite_bio;
+
+			mg->overwrite_bio = NULL;
+			defer_bio(cache, bio);
+		}
+
 		invalidate_complete(mg, false);
 		return r;
 	}
-- 
2.53.0



