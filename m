Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D02188015;
	Fri, 15 Nov 2024 06:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653785; cv=none; b=DK5c2fqsOlG9NLR/yW5BxdNtQwdG7wZUm60TI/15HI1PuPARR0RuyL5/2wsdTMEI9Dwqii1UNGUBUWkAOuqPLB9TpxEeFhFD9nh2HTlgSub06SO/Sqc5kOqYrp+DzTEhfL1fM1b10T/CC9V8SLOrMJWhoSGMxnbqJ4sAZRaly2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653785; c=relaxed/simple;
	bh=WGeNGJZShgQTRJ3xNCxfGWqAmaf29I7zer13DV3GHDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GhXWeCb5kRQxM497/O9xhpgHWduaMyrnQOBE6x8P9pRyi774d2uo8LjmQA06vn9M50m+6gLR87jqbR6OsJeDnrEZJuhLFwVhJjoAi0Xe/m4sae/x1/eyjfRXU1f/fKfqOyWFGIfoHIDcI4vdeaLpN+26D2mSbzp0Upm7Pkkdu18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TLwTGsHB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TLwTGsHB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A27B3C4CECF;
	Fri, 15 Nov 2024 06:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653785;
	bh=WGeNGJZShgQTRJ3xNCxfGWqAmaf29I7zer13DV3GHDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TLwTGsHBwpXiZqxIjWXofKvCVYSsFlXqQ/Ggs5v55t3CPKReYyZ4IpdF41DBUZA91
	 lvXUEblDHN9yVPvbAokLbDFzjfVPY033YsZITMcdaLNSfX0J4tjK6sbYmzHLKlm3lT
	 XkQoyGStX1T6HlfD2XvMimNythETrtZrJbx7ZWis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming-Hung Tsai <mtsai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Joe Thornber <thornber@redhat.com>
Subject: [PATCH 5.10 36/82] dm cache: correct the number of origin blocks to match the target length
Date: Fri, 15 Nov 2024 07:38:13 +0100
Message-ID: <20241115063726.863793388@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.561151311@linuxfoundation.org>
References: <20241115063725.561151311@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2058,7 +2058,6 @@ struct cache_args {
 	sector_t cache_sectors;
 
 	struct dm_dev *origin_dev;
-	sector_t origin_sectors;
 
 	uint32_t block_size;
 
@@ -2140,6 +2139,7 @@ static int parse_cache_dev(struct cache_
 static int parse_origin_dev(struct cache_args *ca, struct dm_arg_set *as,
 			    char **error)
 {
+	sector_t origin_sectors;
 	int r;
 
 	if (!at_least_one_arg(as, error))
@@ -2152,8 +2152,8 @@ static int parse_origin_dev(struct cache
 		return r;
 	}
 
-	ca->origin_sectors = get_dev_size(ca->origin_dev);
-	if (ca->ti->len > ca->origin_sectors) {
+	origin_sectors = get_dev_size(ca->origin_dev);
+	if (ca->ti->len > origin_sectors) {
 		*error = "Device size larger than cached device";
 		return -EINVAL;
 	}
@@ -2462,7 +2462,7 @@ static int cache_create(struct cache_arg
 
 	ca->metadata_dev = ca->origin_dev = ca->cache_dev = NULL;
 
-	origin_blocks = cache->origin_sectors = ca->origin_sectors;
+	origin_blocks = cache->origin_sectors = ti->len;
 	origin_blocks = block_div(origin_blocks, ca->block_size);
 	cache->origin_blocks = to_oblock(origin_blocks);
 


