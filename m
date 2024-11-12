Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE8A213EFC;
	Tue, 12 Nov 2024 10:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407386; cv=none; b=Ct+ayP88FErSPC4xszcjT1naVlYwdGVk3HIorIOhfZe8CUmX6HSaL6o1avYQ3WrTHf/pxq2s5yE1b6YonfNILB2FSAyXGkZFy7MssAU47ecneCiCSk8SJvZh/DNPg/vA/RPMkhn0Px24MpVg8xyu4xdsHAdocpbn6Xrpc0sc4XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407386; c=relaxed/simple;
	bh=6dvHFLbkFyYgxXYGrYH0kdbKRB98wMss4eRp6iFkuf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hwU453oWo2dedlY5tRMEmK1ycvusxVHBHksCw9FclOdXVe8ayOVrmhMZ2i8CRCPVS1/gZ9HK2vEBQGTBsz0KI7jwAHb8VpniSzB2zPb06TgZ+Vlb1D+N7NNXl+uhqvHj/2vrQNb+e7qu7aOH9nYD6t39WEcQhMxmOUbYFflmnUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TinrR3rE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TinrR3rE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE06C4CECD;
	Tue, 12 Nov 2024 10:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407386;
	bh=6dvHFLbkFyYgxXYGrYH0kdbKRB98wMss4eRp6iFkuf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TinrR3rE5whFRvjsJeQ4HgIBrzeqzErYa1jVnIKcab1yeRnSGwA/gY08rM1CDOuSw
	 xsycl/YcR7+x+Bsqhhv+pXDkhGFvZGG7aM/TRnMVJRKHZ3mlWi8dstE7z2sI1EaKLo
	 NRXwY+WsJUwiRaSnfVJiI1LovCIaCeFq5WeRWuT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming-Hung Tsai <mtsai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Joe Thornber <thornber@redhat.com>
Subject: [PATCH 6.1 60/98] dm cache: correct the number of origin blocks to match the target length
Date: Tue, 12 Nov 2024 11:21:15 +0100
Message-ID: <20241112101846.550309156@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101844.263449965@linuxfoundation.org>
References: <20241112101844.263449965@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming-Hung Tsai <mtsai@redhat.com>

commit 235d2e739fcbe964c9ce179b4c991025662dcdb6 upstream.

When creating a cache device, the actual size of the cache origin might
be greater than the specified cache target length. In such case, the
number of origin blocks should match the cache target length, not the
full size of the origin device, since access beyond the cache target is
not possible. This issue occurs when reducing the origin device size
using lvm, as lvreduce preloads the new cache table before resuming the
cache origin, which can result in incorrect sizes for the discard bitset
and smq hotspot blocks.

Reproduce steps:

1. create a cache device consists of 4096 origin blocks

dmsetup create cmeta --table "0 8192 linear /dev/sdc 0"
dmsetup create cdata --table "0 65536 linear /dev/sdc 8192"
dmsetup create corig --table "0 524288 linear /dev/sdc 262144"
dd if=/dev/zero of=/dev/mapper/cmeta bs=4k count=1 oflag=direct
dmsetup create cache --table "0 524288 cache /dev/mapper/cmeta \
/dev/mapper/cdata /dev/mapper/corig 128 2 metadata2 writethrough smq 0"

2. reduce the cache origin to 2048 oblocks, in lvreduce's approach

dmsetup reload corig --table "0 262144 linear /dev/sdc 262144"
dmsetup reload cache --table "0 262144 cache /dev/mapper/cmeta \
/dev/mapper/cdata /dev/mapper/corig 128 2 metadata2 writethrough smq 0"
dmsetup suspend cache
dmsetup suspend corig
dmsetup suspend cdata
dmsetup suspend cmeta
dmsetup resume corig
dmsetup resume cdata
dmsetup resume cmeta
dmsetup resume cache

3. shutdown the cache, and check the number of discard blocks in
   superblock. The value is expected to be 2048, but actually is 4096.

dmsetup remove cache corig cdata cmeta
dd if=/dev/sdc bs=1c count=8 skip=224 2>/dev/null | hexdump -e '1/8 "%u\n"'

Fix by correcting the origin_blocks initialization in cache_create and
removing the unused origin_sectors from struct cache_args accordingly.

Signed-off-by: Ming-Hung Tsai <mtsai@redhat.com>
Fixes: c6b4fcbad044 ("dm: add cache target")
Cc: stable@vger.kernel.org
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Acked-by: Joe Thornber <thornber@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-cache-target.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -1980,7 +1980,6 @@ struct cache_args {
 	sector_t cache_sectors;
 
 	struct dm_dev *origin_dev;
-	sector_t origin_sectors;
 
 	uint32_t block_size;
 
@@ -2061,6 +2060,7 @@ static int parse_cache_dev(struct cache_
 static int parse_origin_dev(struct cache_args *ca, struct dm_arg_set *as,
 			    char **error)
 {
+	sector_t origin_sectors;
 	int r;
 
 	if (!at_least_one_arg(as, error))
@@ -2073,8 +2073,8 @@ static int parse_origin_dev(struct cache
 		return r;
 	}
 
-	ca->origin_sectors = get_dev_size(ca->origin_dev);
-	if (ca->ti->len > ca->origin_sectors) {
+	origin_sectors = get_dev_size(ca->origin_dev);
+	if (ca->ti->len > origin_sectors) {
 		*error = "Device size larger than cached device";
 		return -EINVAL;
 	}
@@ -2384,7 +2384,7 @@ static int cache_create(struct cache_arg
 
 	ca->metadata_dev = ca->origin_dev = ca->cache_dev = NULL;
 
-	origin_blocks = cache->origin_sectors = ca->origin_sectors;
+	origin_blocks = cache->origin_sectors = ti->len;
 	origin_blocks = block_div(origin_blocks, ca->block_size);
 	cache->origin_blocks = to_oblock(origin_blocks);
 


