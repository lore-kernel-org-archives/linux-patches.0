Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E75569D
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:31:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 523EBC4339B;
	Sun, 28 May 2023 19:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302282;
	bh=pUAKwf3zhXLaBNzZ0xxf0OgSjVgRAHlphqO07gg83tg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Z79ViwM466ErAJmtipnEjrNUY4zrJvgB86XetCk/MJPCi3OER7nyhk9deJnoO6z5
	 9036DZi7Fgs61hyB5BVSA1Y0EHWJ/pounxB1gsjNgrjTQLhFb4aL9iXL8UFWt+76zD
	 PhqBHveQZQPZIZfvCBRlJ8SMuWRECeur+yoQj724=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anton Protopopov <aspsk@isovalent.com>,
	Martin KaFai Lau <martin.lau@kernel.org>
Subject: [PATCH 6.3 073/127] bpf: fix a memory leak in the LRU and LRU_PERCPU hash maps
Date: Sun, 28 May 2023 20:10:49 +0100
Message-Id: <20230528190838.762707857@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190836.161231414@linuxfoundation.org>
References: <20230528190836.161231414@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Anton Protopopov <aspsk@isovalent.com>

commit b34ffb0c6d23583830f9327864b9c1f486003305 upstream.

The LRU and LRU_PERCPU maps allocate a new element on update before locking the
target hash table bucket. Right after that the maps try to lock the bucket.
If this fails, then maps return -EBUSY to the caller without releasing the
allocated element. This makes the element untracked: it doesn't belong to
either of free lists, and it doesn't belong to the hash table, so can't be
re-used; this eventually leads to the permanent -ENOMEM on LRU map updates,
which is unexpected. Fix this by returning the element to the local free list
if bucket locking fails.

Fixes: 20b6cc34ea74 ("bpf: Avoid hashtab deadlock with map_locked")
Signed-off-by: Anton Protopopov <aspsk@isovalent.com>
Link: https://lore.kernel.org/r/20230522154558.2166815-1-aspsk@isovalent.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/hashtab.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -1197,7 +1197,7 @@ static long htab_lru_map_update_elem(str
 
 	ret = htab_lock_bucket(htab, b, hash, &flags);
 	if (ret)
-		return ret;
+		goto err_lock_bucket;
 
 	l_old = lookup_elem_raw(head, hash, key, key_size);
 
@@ -1218,6 +1218,7 @@ static long htab_lru_map_update_elem(str
 err:
 	htab_unlock_bucket(htab, b, hash, flags);
 
+err_lock_bucket:
 	if (ret)
 		htab_lru_push_free(htab, l_new);
 	else if (l_old)
@@ -1320,7 +1321,7 @@ static long __htab_lru_percpu_map_update
 
 	ret = htab_lock_bucket(htab, b, hash, &flags);
 	if (ret)
-		return ret;
+		goto err_lock_bucket;
 
 	l_old = lookup_elem_raw(head, hash, key, key_size);
 
@@ -1343,6 +1344,7 @@ static long __htab_lru_percpu_map_update
 	ret = 0;
 err:
 	htab_unlock_bucket(htab, b, hash, flags);
+err_lock_bucket:
 	if (l_new)
 		bpf_lru_push_free(&htab->lru, &l_new->lru_node);
 	return ret;


