Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F1A1632DA;
	Fri, 15 Nov 2024 06:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731652814; cv=none; b=CxyKtGBkp7+bFc/pkc4HaIP37P44yRit5JIPgMJmS3VPyvfo9++cpTDfwK+YTfDBwJOMByzWWm0/uSt7G/yCSKfUIZ6v8RlPvue7Cj9jPplabFZyzMGJQiDgEaJ6YWecyu50rCkHOmjIpQ79OWGWg/vRDsAUrrtAB3+DQWanBvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731652814; c=relaxed/simple;
	bh=a8x4g/arWZ6Z4EPFkBP9P0Gg6pHigIfURRi4Se0UGCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Df0wVgxbZ4VrsTEwhp9H0c67XwjUagz37u9IFVJVGn6FIb+mL2NHVtASROzBsyTuVUK5hRcOLYQQfx7FQKsYZ2zZKiycrdHXw6CAahQo5SmmwtTnKm6zF91jIarP/9fC7CsgJH0v3BLMe1mtc/KHznZ27uXMOazAkMRxsc2EIhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C/17ipV2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C/17ipV2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4E84C4CED0;
	Fri, 15 Nov 2024 06:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731652814;
	bh=a8x4g/arWZ6Z4EPFkBP9P0Gg6pHigIfURRi4Se0UGCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C/17ipV2ubcrDcVfuB1xun8VUdfuou4xqqC+MHHmHmE7MyAE6eODz13XntJiUbOVm
	 AVRq30BdzSGXGpVcauBAfshSQkkDPGljMEzfkzHEnj8dBLXH+iFifBYrXrUxLWK0UE
	 ObSD+huLOKpfOJFZXob2VICCFcnih2XlCmta8rfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming-Hung Tsai <mtsai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Joe Thornber <thornber@redhat.com>
Subject: [PATCH 4.19 22/52] dm cache: optimize dirty bit checking with find_next_bit when resizing
Date: Fri, 15 Nov 2024 07:37:35 +0100
Message-ID: <20241115063723.658090508@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.845867306@linuxfoundation.org>
References: <20241115063722.845867306@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3001,14 +3001,14 @@ static bool can_resize(struct cache *cac
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


