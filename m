Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B9A0188591;
	Fri, 15 Nov 2024 06:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653010; cv=none; b=U3oVQQrAEdlEaXIVy8BCDikK9UdJESESS3/5z0vrCcCuvz+wAZyQe8B8/npadZrTkW8mq6FyiKly8mzCulhG7sdERSUGnsBhxJuOb/8VlMjJ9T5bU589GSPN9SmjhlYp6iiBQSPEjuZ2xX/rU4H6EiCay2fnid5PbfZB6h4FZyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653010; c=relaxed/simple;
	bh=b9QWmRXj/2Kdq4QVUahKwbic/fcDxRFKCzBT6hC5JcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RiSx/bNDn3j7cybdJCKN0nMYWiGEs/TNpDPb2KqtbF7qkdALlAQOZQO+K9BE7xy3A20S4IiB7YPO/+0mZ3toqzU1pSPoAj2wEjhFtwozRsZi7L+a18LNjkFf3zbExBAnuyYo6aLyKgNzTUnteheXJzbNjFR4PoVEakdg9MVhzVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M5mR361/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M5mR361/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6BE5C4CECF;
	Fri, 15 Nov 2024 06:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653010;
	bh=b9QWmRXj/2Kdq4QVUahKwbic/fcDxRFKCzBT6hC5JcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M5mR361/guXQnROsDF++HNJnIpScWWZL4FjYF6lL8p9QCt5B3BVQmiZNxqh+RSF95
	 tzn+Pz+yh1fExnOqS0H4QtD+LjYKjNJqEIUCFPfPYiG3Fd3iZtrEmczyI9EprN8x0H
	 SCRk/BQw2Z5dv4fjq9FXqvjK+BKH9To5DaZkYgD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming-Hung Tsai <mtsai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Joe Thornber <thornber@redhat.com>
Subject: [PATCH 5.4 28/66] dm cache: fix out-of-bounds access to the dirty bitset when resizing
Date: Fri, 15 Nov 2024 07:37:37 +0100
Message-ID: <20241115063723.858556398@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.834793938@linuxfoundation.org>
References: <20241115063722.834793938@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming-Hung Tsai <mtsai@redhat.com>

commit 792227719725497ce10a8039803bec13f89f8910 upstream.

dm-cache checks the dirty bits of the cache blocks to be dropped when
shrinking the fast device, but an index bug in bitset iteration causes
out-of-bounds access.

Reproduce steps:

1. create a cache device of 1024 cache blocks (128 bytes dirty bitset)

dmsetup create cmeta --table "0 8192 linear /dev/sdc 0"
dmsetup create cdata --table "0 131072 linear /dev/sdc 8192"
dmsetup create corig --table "0 524288 linear /dev/sdc 262144"
dd if=/dev/zero of=/dev/mapper/cmeta bs=4k count=1 oflag=direct
dmsetup create cache --table "0 524288 cache /dev/mapper/cmeta \
/dev/mapper/cdata /dev/mapper/corig 128 2 metadata2 writethrough smq 0"

2. shrink the fast device to 512 cache blocks, triggering out-of-bounds
   access to the dirty bitset (offset 0x80)

dmsetup suspend cache
dmsetup reload cdata --table "0 65536 linear /dev/sdc 8192"
dmsetup resume cdata
dmsetup resume cache

KASAN reports:

  BUG: KASAN: vmalloc-out-of-bounds in cache_preresume+0x269/0x7b0
  Read of size 8 at addr ffffc900000f3080 by task dmsetup/131

  (...snip...)
  The buggy address belongs to the virtual mapping at
   [ffffc900000f3000, ffffc900000f5000) created by:
   cache_ctr+0x176a/0x35f0

  (...snip...)
  Memory state around the buggy address:
   ffffc900000f2f80: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
   ffffc900000f3000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  >ffffc900000f3080: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
                     ^
   ffffc900000f3100: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
   ffffc900000f3180: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8

Fix by making the index post-incremented.

Signed-off-by: Ming-Hung Tsai <mtsai@redhat.com>
Fixes: f494a9c6b1b6 ("dm cache: cache shrinking support")
Cc: stable@vger.kernel.org
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Acked-by: Joe Thornber <thornber@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-cache-target.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -3010,13 +3010,13 @@ static bool can_resize(struct cache *cac
 	 * We can't drop a dirty block when shrinking the cache.
 	 */
 	while (from_cblock(new_size) < from_cblock(cache->cache_size)) {
-		new_size = to_cblock(from_cblock(new_size) + 1);
 		if (is_dirty(cache, new_size)) {
 			DMERR("%s: unable to shrink cache; cache block %llu is dirty",
 			      cache_device_name(cache),
 			      (unsigned long long) from_cblock(new_size));
 			return false;
 		}
+		new_size = to_cblock(from_cblock(new_size) + 1);
 	}
 
 	return true;


