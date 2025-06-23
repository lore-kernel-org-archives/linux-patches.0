Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C777770838;
	Mon, 23 Jun 2025 21:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715919; cv=none; b=KnNjqS96qK2tH1rnoRxozD4sgz6c9J6JmlFjdTNNx2ki77iZbO+/aZasa5Td2cAJUc+MAzreCDxioGRxR9PFHW7Z5tKnTXc4QIxLksBOMA1wfLDxvANWA1hxJjIAjrDU7Rlw8samWat1/PDZkg/Hq/yvgCH9aXhc6Y/mJc3Siao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715919; c=relaxed/simple;
	bh=VTFOE6qqWsxf6glJ2dldK/ir8FckXw1fZwGYSBNfkMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=snNtWwDIlHo+EJyF/HB3lD1bV+Vjo/4oiRji28ixr1OE3/aJ5YaRexcZN4iKGTpNrAEGBARq/wkC3uo44J/tR9BtqEuNlHVYBNpyAXAG1kHJihyW2tegvA+WjzZoMzlVbIDLIaxIfsvJ2keL2Mww0pRh9I7X+2UgrTklEotAZso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z+PIlkqk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z+PIlkqk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA280C4CEEA;
	Mon, 23 Jun 2025 21:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715917;
	bh=VTFOE6qqWsxf6glJ2dldK/ir8FckXw1fZwGYSBNfkMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z+PIlkqkD6SUlGovj20F9B9fbdbkSeBFy8QwRRk2VTIHYHz1zkI1Otvw/N1ndaACc
	 xX9zVDyqj78cGbu7pwIDTQaGUinIjZFf5bxwmrEaqP6NOtdr02MPvAZoToooeaQU36
	 lcMqY1Eq7zLu3/Ke1kwkI/eV8hirttcDuPUwRIUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <leo.lilong@huawei.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 291/411] sunrpc: fix race in cache cleanup causing stale nextcheck time
Date: Mon, 23 Jun 2025 15:07:15 +0200
Message-ID: <20250623130640.978088296@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Long Li <leo.lilong@huawei.com>

[ Upstream commit 2298abcbe11e9b553d03c0f1d084da786f7eff88 ]

When cache cleanup runs concurrently with cache entry removal, a race
condition can occur that leads to incorrect nextcheck times. This can
delay cache cleanup for the cache_detail by up to 1800 seconds:

1. cache_clean() sets nextcheck to current time plus 1800 seconds
2. While scanning a non-empty bucket, concurrent cache entry removal can
   empty that bucket
3. cache_clean() finds no cache entries in the now-empty bucket to update
   the nextcheck time
4. This maybe delays the next scan of the cache_detail by up to 1800
   seconds even when it should be scanned earlier based on remaining
   entries

Fix this by moving the hash_lock acquisition earlier in cache_clean().
This ensures bucket emptiness checks and nextcheck updates happen
atomically, preventing the race between cleanup and entry removal.

Signed-off-by: Long Li <leo.lilong@huawei.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/cache.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/net/sunrpc/cache.c b/net/sunrpc/cache.c
index e8448e9e03d59..715f7d080f7a2 100644
--- a/net/sunrpc/cache.c
+++ b/net/sunrpc/cache.c
@@ -451,24 +451,21 @@ static int cache_clean(void)
 		}
 	}
 
+	spin_lock(&current_detail->hash_lock);
+
 	/* find a non-empty bucket in the table */
-	while (current_detail &&
-	       current_index < current_detail->hash_size &&
+	while (current_index < current_detail->hash_size &&
 	       hlist_empty(&current_detail->hash_table[current_index]))
 		current_index++;
 
 	/* find a cleanable entry in the bucket and clean it, or set to next bucket */
-
-	if (current_detail && current_index < current_detail->hash_size) {
+	if (current_index < current_detail->hash_size) {
 		struct cache_head *ch = NULL;
 		struct cache_detail *d;
 		struct hlist_head *head;
 		struct hlist_node *tmp;
 
-		spin_lock(&current_detail->hash_lock);
-
 		/* Ok, now to clean this strand */
-
 		head = &current_detail->hash_table[current_index];
 		hlist_for_each_entry_safe(ch, tmp, head, cache_list) {
 			if (current_detail->nextcheck > ch->expiry_time)
@@ -489,8 +486,10 @@ static int cache_clean(void)
 		spin_unlock(&cache_list_lock);
 		if (ch)
 			sunrpc_end_cache_remove_entry(ch, d);
-	} else
+	} else {
+		spin_unlock(&current_detail->hash_lock);
 		spin_unlock(&cache_list_lock);
+	}
 
 	return rv;
 }
-- 
2.39.5



