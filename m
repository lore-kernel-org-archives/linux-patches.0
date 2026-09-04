Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A5AE3B95FA;
	Fri,  4 Sep 2026 05:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500130; cv=none; b=O3jYr/lJS/1yRqkbysEpYyLpzcNdRf7y7cLt4MYrT6IHDfSYfxgmDcWHoS20tHJWQYwxMJ57odxqRyo5pyOc0vIc4Q1PGiFy5mMJYx4yzEaI06q94bfH7w7P4KlqzLa1IsuHJRFUP31Dtogj2IH0D/GyORpFA0jM5GagWH1jyu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500130; c=relaxed/simple;
	bh=JAhyB4wBGIUrjXQar9KSOCVZKUueluYouKnnkZAnDC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d2judJGgDje9IQbUwKejlIPJfEYS2QNSzyovNnlcVNCilCYjzOAo+MX0KEejOwOpRuO7kJOIVEa7OgvVsZj7JFdH3BCBZHFQ46jOGcGBNMMFGzyPQ9hy2aHbnMQOAihxvFQMS8qH0MgoGETp1Y98TcxXN9M7UYFE2hA5ty+3L3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cLCa4i7R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cLCa4i7R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8F3C1F00A3D;
	Fri,  4 Sep 2026 05:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500129;
	bh=KJYD5nyT1T/BhwZFWs3LEJYRm2fSaotBa1cmDV8TRwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cLCa4i7RdQTf9jjYAO8MBFW5UebCrPFxQ5P8T77+Y3g3VnFMmOzWPn2BQdZePu+ji
	 CglszuKoxlJkA6K6kWFiXPQ0/NQNShaCFWr6hJLs1ws/N9cOm6U1Ibn9yE2XmzC6yd
	 ybxI/VrZCMaxPrQeUe3o5kN9wrGk2WYvJYtFf8SU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianyun Gao <jianyungao89@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.2 661/713] dm-pcache: fix implicit u8 truncation of gc_percent in message handler
Date: Fri,  4 Sep 2026 07:00:29 +0200
Message-ID: <20260904045818.653025295@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianyun Gao <jianyungao89@gmail.com>

commit fb9e17287a4ea1cbbcedc77e6866978ecc2a7b55 upstream.

When setting gc_percent via message, kstrtoul parses the input into an
unsigned long, which is then implicitly truncated to u8 when passed to
pcache_cache_set_gc_percent(). For example, value 266 (0x10A) silently
truncates to 10 (0x0A), successfully bypassing the > 90 upper bound
check in pcache_cache_set_gc_percent(), and setting a different value
than the user intended.

Use kstrtou8 directly instead of kstrtoul, so that overflow values are
properly rejected.

Cc: stable@vger.kernel.org
Fixes: 1d57628ff95b ("dm-pcache: add persistent cache target in device-mapper")
Signed-off-by: Jianyun Gao <jianyungao89@gmail.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-pcache/dm_pcache.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-pcache/dm_pcache.c
+++ b/drivers/md/dm-pcache/dm_pcache.c
@@ -439,13 +439,13 @@ static int dm_pcache_message(struct dm_t
 			     char **argv, char *result, unsigned int maxlen)
 {
 	struct dm_pcache *pcache = ti->private;
-	unsigned long val;
+	u8 val;
 
 	if (argc != 2)
 		goto err;
 
 	if (!strcasecmp(argv[0], "gc_percent")) {
-		if (kstrtoul(argv[1], 10, &val))
+		if (kstrtou8(argv[1], 10, &val))
 			goto err;
 
 		return pcache_cache_set_gc_percent(&pcache->cache, val);


