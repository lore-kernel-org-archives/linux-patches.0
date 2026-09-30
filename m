Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 821FA5158B3;
	Wed, 30 Sep 2026 17:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789094; cv=none; b=SYE7mO/UeP3SpHS+/+ANyaK5n2uJBykHrT9h62Mr3AZ5Q6pFYlfRQpepW8HKmbLkKVox2ljeeZRusfvNGDrTx0Xw9YE2xgyyoMXkAD1zUNKmcmDe3z96qSgrIG4JbG8sQa7mLJZaPPlHBzhRwZ3Ur70f4fayGsB5PtwypSYu5EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789094; c=relaxed/simple;
	bh=ks1rZjNLOGv3UlT4SGawXxTLd0tLwatLihAv4/C081w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L4SnXf8iJnc3kVQmD7evythwz0FA7haUXbOGrB3+rl+OwFK/lgwa/fD4XpXXmMcwTlqioMyliXO7HZqytkVVwCRnvHVr6LtqATHCO11v8MekTesFNftmq29Uni8Xf8iXQgh+wR4d73vFZCn+G85L9mIwF+L3EGHZ8zlxrsfh7dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U3P5N4P9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U3P5N4P9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A39611F000FF;
	Wed, 30 Sep 2026 17:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789093;
	bh=GefnL4mAxz1A4UV7LcILm5yH5/qSEWi0NNjJLsB4Xhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U3P5N4P94WsXCcZnD/g+/rZNW58vR2SCqbULmlHThMGG2829KTHWxCWvYX6h0Xbph
	 WnV0W4RHciBdxkURw/1sQOFfg8O6ZVtTKLwnVfhmAod7EF+ip8+iAzXWyMiwyZV3Zy
	 0S3md2yR6uf2SY+m6OPEVzEwGSJcZLzUTssQOQ6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 312/877] bpf: Bail out early in __htab_map_lookup_and_delete_elem()
Date: Wed, 30 Sep 2026 17:20:23 +0200
Message-ID: <20260930152421.426171243@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit 588c6ead325aecc9894c9925cf1f771b77437bee ]

Use goto statement to bail out early when the target element is not
found, instead of using a large else branch to handle the more likely
case. This change doesn't affect functionality and simply make the code
cleaner.

Signed-off-by: Hou Tao <houtao1@huawei.com>
Reviewed-by: Toke Høiland-Jørgensen <toke@kernel.org>
Link: https://lore.kernel.org/r/20250117101816.2101857-3-houtao@huaweicloud.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: 1c21452d02ee ("bpf: Fix UAF due to concurrent consumption of ttrace lists in alloc_bulk")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/hashtab.c | 51 ++++++++++++++++++++++----------------------
 1 file changed, 26 insertions(+), 25 deletions(-)

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 6df745abb88a7..22cc255519ce8 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -1637,37 +1637,38 @@ static int __htab_map_lookup_and_delete_elem(struct bpf_map *map, void *key,
 	l = lookup_elem_raw(head, hash, key, key_size);
 	if (!l) {
 		ret = -ENOENT;
-	} else {
-		if (is_percpu) {
-			u32 roundup_value_size = round_up(map->value_size, 8);
-			void __percpu *pptr;
-			int off = 0, cpu;
+		goto out_unlock;
+	}
 
-			pptr = htab_elem_get_ptr(l, key_size);
-			for_each_possible_cpu(cpu) {
-				copy_map_value_long(&htab->map, value + off, per_cpu_ptr(pptr, cpu));
-				check_and_init_map_value(&htab->map, value + off);
-				off += roundup_value_size;
-			}
-		} else {
-			u32 roundup_key_size = round_up(map->key_size, 8);
+	if (is_percpu) {
+		u32 roundup_value_size = round_up(map->value_size, 8);
+		void __percpu *pptr;
+		int off = 0, cpu;
 
-			if (flags & BPF_F_LOCK)
-				copy_map_value_locked(map, value, l->key +
-						      roundup_key_size,
-						      true);
-			else
-				copy_map_value(map, value, l->key +
-					       roundup_key_size);
-			/* Zeroing special fields in the temp buffer */
-			check_and_init_map_value(map, value);
+		pptr = htab_elem_get_ptr(l, key_size);
+		for_each_possible_cpu(cpu) {
+			copy_map_value_long(&htab->map, value + off, per_cpu_ptr(pptr, cpu));
+			check_and_init_map_value(&htab->map, value + off);
+			off += roundup_value_size;
 		}
+	} else {
+		u32 roundup_key_size = round_up(map->key_size, 8);
 
-		hlist_nulls_del_rcu(&l->hash_node);
-		if (!is_lru_map)
-			free_htab_elem(htab, l);
+		if (flags & BPF_F_LOCK)
+			copy_map_value_locked(map, value, l->key +
+					      roundup_key_size,
+					      true);
+		else
+			copy_map_value(map, value, l->key +
+				       roundup_key_size);
+		/* Zeroing special fields in the temp buffer */
+		check_and_init_map_value(map, value);
 	}
+	hlist_nulls_del_rcu(&l->hash_node);
+	if (!is_lru_map)
+		free_htab_elem(htab, l);
 
+out_unlock:
 	htab_unlock_bucket(htab, b, hash, bflags);
 
 	if (is_lru_map && l)
-- 
2.53.0



