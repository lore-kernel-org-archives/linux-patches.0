Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211827;
	b=M9b2Rf25yDte+41lcZ3APwqa38jk6LAN+PPPbgyfGyDskNSfR8V2W9YFMk/sEWbv3jAT
	 JhKou4Ub5DnfwQaw1yl0BduTy1oqrC6gOWcbTZtBRZ0r/9q/v2Va4Tta6p+PQGhPG3AJ2
	 A2ylQKTvTaP6snJieijjqp9lo0DEiBE2qfG767QLP93OdCchZrIHIkwlorXAzvatHJIW2
	 /Imv/ZBMzZLpb4XbH116Bj3ZuhQet8VkCIkH2BdcamGSv5eAxdWq/I9gr+N2zFtnrk2OO
	 LVdAQulQTd9o11Hu4W3sgVgj6YsPj2vKf7tvBTDQUdwpprELCMzSoqIpyI+gOiznYAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211827;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XBoLJkDGq0S93smg0G5Z9jjv//Sot8OHsF24HCYtAPM=;
	b=U6/RgbLpJ5gd4dDgtv02OD0+SYSUVzGpj9jW7fh8nH9N95CiEr4RcSlvmRYb8dD4FgF0
	 6ty3d8HlVt1VvmIkZpd7Wma8Z0dKO3apxlJsvj90wvcVdCpUS5lBpMTtwsrGyt4FvbOc9
	 pNjrkIw89cPyYmWVNdv3T7WNP/sMCNG2q3U2LgDe0yaetc1oRCQ1FqLA8tq/7QOwGw16D
	 KuckKFgjyFrPtIOAua8WImH5MuAv9qhy/stjxSu8V1Iw0joUOS0d8K+VT9kY4HoiBUqNW
	 cwfBINUl1v1vnR9lVo3/aNGVawyxSuGObtCnt39y+I4adx2Q/fqCGivxsELI6p+6L3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HBqdX2kd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E332360A2605;
	Wed, 28 Oct 2026 18:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HBqdX2kd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DB851F01825;
	Wed, 28 Oct 2026 18:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211826;
	bh=XBoLJkDGq0S93smg0G5Z9jjv//Sot8OHsF24HCYtAPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HBqdX2kdgx2xA0AN2wTeR06IItl8HHXJR/DzGLQ7vu+UwrtY8gjKS+VPHJYyg5bDm
	 bS3cOlhNIeR+kQIEVAKUhsQl3rBRYfrx1H0n/iWJy0VGq6fxHvwJscvDVa6KLAAilm
	 9IVY9T9CTvwvH6g2uOULXgZzNSgXSCRMVJS9NAnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	"Miguel Gazquez (Schneider Electric)" <miguel.gazquez@bootlin.com>
Subject: [PATCH 5.15 468/571] bpf: fix potential 32-bit overflow when accessing ARRAY map element
Date: Wed, 28 Oct 2026 18:00:15 +0100
Message-ID: <20261028170019.126829509@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 87ac0d600943994444e24382a87aa19acc4cd3d4 ]

If BPF array map is bigger than 4GB, element pointer calculation can
overflow because both index and elem_size are u32. Fix this everywhere
by forcing 64-bit multiplication. Extract this formula into separate
small helper and use it consistently in various places.

Speculative-preventing formula utilizing index_mask trick is left as is,
but explicit u64 casts are added in both places.

Fixes: c85d69135a91 ("bpf: move memory size checks to bpf_map_charge_init()")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/r/20220715053146.1291891-2-andrii@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Miguel Gazquez (Schneider Electric) <miguel.gazquez@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/arraymap.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index dc42970dda975..a13a270c9aa25 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -158,6 +158,11 @@ static struct bpf_map *array_map_alloc(union bpf_attr *attr)
 	return &array->map;
 }
 
+static void *array_map_elem_ptr(struct bpf_array* array, u32 index)
+{
+	return array->value + (u64)array->elem_size * index;
+}
+
 /* Called from syscall or from eBPF program */
 static void *array_map_lookup_elem(struct bpf_map *map, void *key)
 {
@@ -167,7 +172,7 @@ static void *array_map_lookup_elem(struct bpf_map *map, void *key)
 	if (unlikely(index >= array->map.max_entries))
 		return NULL;
 
-	return array->value + array->elem_size * (index & array->index_mask);
+	return array->value + (u64)array->elem_size * (index & array->index_mask);
 }
 
 static int array_map_direct_value_addr(const struct bpf_map *map, u64 *imm,
@@ -325,7 +330,7 @@ static int array_map_update_elem(struct bpf_map *map, void *key, void *value,
 		       value, map->value_size);
 	} else {
 		val = array->value +
-			array->elem_size * (index & array->index_mask);
+			(u64)array->elem_size * (index & array->index_mask);
 		if (map_flags & BPF_F_LOCK)
 			copy_map_value_locked(map, val, value, false);
 		else
@@ -393,8 +398,7 @@ static void array_map_free_timers(struct bpf_map *map)
 		return;
 
 	for (i = 0; i < array->map.max_entries; i++)
-		bpf_timer_cancel_and_free(array->value + array->elem_size * i +
-					  map->timer_off);
+		bpf_timer_cancel_and_free(array_map_elem_ptr(array, i) + map->timer_off);
 }
 
 /* Called when map->refcnt goes to zero, either from workqueue or from syscall */
@@ -534,7 +538,7 @@ static void *bpf_array_map_seq_start(struct seq_file *seq, loff_t *pos)
 	index = info->index & array->index_mask;
 	if (info->percpu_value_buf)
 	       return array->pptrs[index];
-	return array->value + array->elem_size * index;
+	return array_map_elem_ptr(array, index);
 }
 
 static void *bpf_array_map_seq_next(struct seq_file *seq, void *v, loff_t *pos)
@@ -553,7 +557,7 @@ static void *bpf_array_map_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 	index = info->index & array->index_mask;
 	if (info->percpu_value_buf)
 	       return array->pptrs[index];
-	return array->value + array->elem_size * index;
+	return array_map_elem_ptr(array, index);
 }
 
 static int __bpf_array_map_seq_show(struct seq_file *seq, void *v)
@@ -674,7 +678,7 @@ static int bpf_for_each_array_elem(struct bpf_map *map, void *callback_fn,
 		if (is_percpu)
 			val = this_cpu_ptr(array->pptrs[i]);
 		else
-			val = array->value + array->elem_size * i;
+			val = array_map_elem_ptr(array, i);
 		num_elems++;
 		key = i;
 		ret = BPF_CAST_CALL(callback_fn)((u64)(long)map,
-- 
2.53.0



