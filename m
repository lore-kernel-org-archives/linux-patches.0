Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D3F611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:38:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D531C433EF;
	Sun, 28 May 2023 19:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302692;
	bh=YMAGm+Zl7FrEdpRChvMmH56GMMCkGdXuYlN0aXEiHvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LhMtRHE3BHo/PRXehPaMfIwOcbUmop8lIzmmOO45KRWI2c5rMjEDMxpyNxJyboa0O
	 5wCy5C8VE4P0/lKTn6fqbdVUptSTldtpO5Xn++j+7tvYMynLI3by7lRa/t9TmUF8Cp
	 /tM4p7x/cicNZO5ltamnfr69a3/9Sx6IpdFp3NJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anton Protopopov <aspsk@isovalent.com>,
	Martin KaFai Lau <martin.lau@kernel.org>
Subject: [PATCH 6.1 069/119] bpf: fix a memory leak in the LRU and LRU_PERCPU hash maps
Date: Sun, 28 May 2023 20:11:09 +0100
Message-Id: <20230528190837.802890017@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190835.386670951@linuxfoundation.org>
References: <20230528190835.386670951@linuxfoundation.org>
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
@@ -1203,7 +1203,7 @@ static int htab_lru_map_update_elem(stru
 
 	ret = htab_lock_bucket(htab, b, hash, &flags);
 	if (ret)
-		return ret;
+		goto err_lock_bucket;
 
 	l_old = lookup_elem_raw(head, hash, key, key_size);
 
@@ -1224,6 +1224,7 @@ static int htab_lru_map_update_elem(stru
 err:
 	htab_unlock_bucket(htab, b, hash, flags);
 
+err_lock_bucket:
 	if (ret)
 		htab_lru_push_free(htab, l_new);
 	else if (l_old)
@@ -1326,7 +1327,7 @@ static int __htab_lru_percpu_map_update_
 
 	ret = htab_lock_bucket(htab, b, hash, &flags);
 	if (ret)
-		return ret;
+		goto err_lock_bucket;
 
 	l_old = lookup_elem_raw(head, hash, key, key_size);
 
@@ -1349,6 +1350,7 @@ static int __htab_lru_percpu_map_update_
 	ret = 0;
 err:
 	htab_unlock_bucket(htab, b, hash, flags);
+err_lock_bucket:
 	if (l_new)
 		bpf_lru_push_free(&htab->lru, &l_new->lru_node);
 	return ret;


