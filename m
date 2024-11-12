Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42F621A6E1;
	Tue, 12 Nov 2024 10:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407796; cv=none; b=UleccPsTzzb6gUpIh0KoxK2wL58UFWl8rYzL4WFhufiYi3Luh6anxNcbjmg7khY1uOLzDJPPq66vuVXVW53bsJUt2H6Qrohl/lh22C4FeCZAUo65hUrouBOX6uBPmLDgklYJSgrDjTc2w/DT9n9xB6pn0IjKMrPxAmv+OyQ0heQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407796; c=relaxed/simple;
	bh=mzMTVLZEHaXLE2Jak7pHs01MyLYItFE+XsXbGPIiyBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GXVkUfU0yqO9/Lkedr2ONS5gjUMJGBk7dtv/6xsJKVTGZFaze9Uk7S9lQCplHy8ky5iu0nwcVr+Il161i2R0VS2hz3ojr5jtarPGytRL+3IHgjCyd1XNd1JSYD1AvUaA3oKCg2zJXz/AvsEQ0K6OeKESXp7jCj5HV7S6xZlZfMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LRzUct9s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LRzUct9s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7FECC4CED6;
	Tue, 12 Nov 2024 10:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407796;
	bh=mzMTVLZEHaXLE2Jak7pHs01MyLYItFE+XsXbGPIiyBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LRzUct9snKO99GC3jxB6PzSaQA/rJgskOpnVINYlgt4DCSQQ/4+exMDOjNfkqHn9r
	 xKUqCf1/zmZKq9Vj8FEMUU8duTxumTLebKJhwgzjxF+GsFFIBPE6qiXRfFtFh47TXs
	 oyllEErUqEFXt4/bgI5dSzk7gVGXDqcL3iNA5n9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming-Hung Tsai <mtsai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Joe Thornber <thornber@redhat.com>
Subject: [PATCH 6.6 085/119] dm cache: optimize dirty bit checking with find_next_bit when resizing
Date: Tue, 12 Nov 2024 11:21:33 +0100
Message-ID: <20241112101851.965234776@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2915,14 +2915,14 @@ static bool can_resize(struct cache *cac
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


