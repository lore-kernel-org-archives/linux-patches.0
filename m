Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0044D18893C;
	Fri, 15 Nov 2024 06:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653014; cv=none; b=eu4cRsWv7hHYh2p7wRGzcDhnwVbTvtkGurX8GjGkOy+6bqEjUZzCWXd5BIo5C58BZZDp3uSYjAB2st0YfA3sF7hXj4husIK3HHKbM2tDpwmmOCZfVcpVRutruDHHcdkNqLpL6fm6/EGf217d4nvLUsyO2sv4Q76J7qfziSSrc9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653014; c=relaxed/simple;
	bh=iptLyuJ6nMekJ/P5zDbSIi+1YCrFQNS/KNuAuxoNH54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tNURpkKe+lXszKlVlIJQHMqoybKXCobgu9kpenUat4kYZyI5Hba9hS8FbnS24T1n/7gCPD7VcUB2SfpKJwnDVWtUskuA0Jhzm+c8R9bpACzMe2fJ10VZcT0EnD9rf8giZ9eu5OI/llOJBLp2OuuSITZu2+st4XDhuAUh4XBUtN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iihTPETX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iihTPETX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6037AC4CECF;
	Fri, 15 Nov 2024 06:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653013;
	bh=iptLyuJ6nMekJ/P5zDbSIi+1YCrFQNS/KNuAuxoNH54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iihTPETXVwDLjpi8jBMve6CV3WmhjvYz1hcfr0ZdS2QyRlmk66yM8FBRJ0glP7HpM
	 10zg0AEbvKKTNkIYk6GvTQBlwcKB2tc5+bNv4p6bVH5n+prq+u7L4r2IG4xh2IESsS
	 Qzlwh9H1joJE2em7CK1vW9YSSD6IvaXFjZIq66nk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming-Hung Tsai <mtsai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Joe Thornber <thornber@redhat.com>
Subject: [PATCH 5.4 29/66] dm cache: optimize dirty bit checking with find_next_bit when resizing
Date: Fri, 15 Nov 2024 07:37:38 +0100
Message-ID: <20241115063723.894340994@linuxfoundation.org>
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

commit f484697e619a83ecc370443a34746379ad99d204 upstream.

When shrinking the fast device, dm-cache iteratively searches for a
dirty bit among the cache blocks to be dropped, which is less efficient.
Use find_next_bit instead, as it is twice as fast as the iterative
approach with test_bit.

Signed-off-by: Ming-Hung Tsai <mtsai@redhat.com>
Fixes: f494a9c6b1b6 ("dm cache: cache shrinking support")
Cc: stable@vger.kernel.org
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Acked-by: Joe Thornber <thornber@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-cache-target.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -3009,14 +3009,14 @@ static bool can_resize(struct cache *cac
 	/*
 	 * We can't drop a dirty block when shrinking the cache.
 	 */
-	while (from_cblock(new_size) < from_cblock(cache->cache_size)) {
-		if (is_dirty(cache, new_size)) {
-			DMERR("%s: unable to shrink cache; cache block %llu is dirty",
-			      cache_device_name(cache),
-			      (unsigned long long) from_cblock(new_size));
-			return false;
-		}
-		new_size = to_cblock(from_cblock(new_size) + 1);
+	new_size = to_cblock(find_next_bit(cache->dirty_bitset,
+					   from_cblock(cache->cache_size),
+					   from_cblock(new_size)));
+	if (new_size != cache->cache_size) {
+		DMERR("%s: unable to shrink cache; cache block %llu is dirty",
+		      cache_device_name(cache),
+		      (unsigned long long) from_cblock(new_size));
+		return false;
 	}
 
 	return true;


