Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB46C212194;
	Tue, 12 Nov 2024 10:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407084; cv=none; b=NNHZwFINde0AivJMw1hh4s9JZ6JaDQ2wXfvx5SQPZs+yMiL5XcUla+/PwXHcLD0v9f+0eXeFlO0R5YDJej4/+45j+WvVF6H1aTAN3HfvJkBjP4p4pplw2fP6rvx5KoORd6U5QqjCr++a39SasbU4lNHTDqWYRNsR3ob1nUjC8nU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407084; c=relaxed/simple;
	bh=qYWV8gYN6HLY5QLGpu4PQLo92Pnanq+D9WfGx/3Bfmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sElETX0vwWnpCdpECjc9jbn908DHcueFKs9hUoVXu/pC+kFXeTXQd9LJ4r+KtxSmlPKol8/N9cuZ7lNxyRlFoOgcbTCqfmFT55dMPjHYCB9f8EzmIXwKeMNk3AXoQNXNeWJsrS29w9my+lk3hgHej2lsbcMU87wIx5AQ1AzQ6as=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kCZrb1QB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kCZrb1QB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37C91C4CECD;
	Tue, 12 Nov 2024 10:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407084;
	bh=qYWV8gYN6HLY5QLGpu4PQLo92Pnanq+D9WfGx/3Bfmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kCZrb1QBzX0rnNZdUdeYokhb/XVDW4gtSDqJd1xnxNnbIg3EwtbcddMykZQ2QPN5A
	 Nxr4vKl/IMmpTq70Cpqk9JGxw62NbiSNvYOaC+RGjzjot3tp2XkBf6LalekAZWEZ9W
	 UUhNIP0YLue9tALdP0rpzS+Hob+0afJOcoTKKnVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming-Hung Tsai <mtsai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Joe Thornber <thornber@redhat.com>
Subject: [PATCH 5.15 45/76] dm cache: optimize dirty bit checking with find_next_bit when resizing
Date: Tue, 12 Nov 2024 11:21:10 +0100
Message-ID: <20241112101841.498281594@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101839.777512218@linuxfoundation.org>
References: <20241112101839.777512218@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2890,14 +2890,14 @@ static bool can_resize(struct cache *cac
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


