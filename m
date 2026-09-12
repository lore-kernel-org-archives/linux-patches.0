Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF6382AEEB;
	Sat, 12 Sep 2026 15:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227197; cv=none; b=RH26cbQuZd4MpwEmkCFYhppY++nzetEo7f6kO2S/wBLkD62jxGLynWBxqYOJefZXjEIQUeHFaN/RdPEItINqIcxo1X12Cz+J1hiYVxEf4meI4rKmgU5J5XA96S4EPg5kQgFWJeOLY6Htn4fkSyaxSUVE4RqUIKJOgfvIMrHRRbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227197; c=relaxed/simple;
	bh=vOFwlqnOucAfLXNF4mWEu5MGjLxyubnYOC6X2NtNhFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TkzLbfi1W64wpCMUCx9Rfj1k0AkWsCm72z2BByfLg8iS/OS84lg0X7ta/Im4UQR5o00icUK1RuPj609WwzSROYbIXeRO+DDzO4iaVICLO3tvm4K5iaO+PK93DYNjIDQw2fhaUyGpOOhLc9lI6LWOaiAXOwr+H4hWwtktB6owr7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zz3u7cjj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zz3u7cjj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A5961F000FF;
	Sat, 12 Sep 2026 15:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227195;
	bh=hJQ3Ym4llFrSd7p5hpxosWYHSpFe4Q9NBetzm8U634g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zz3u7cjj0at6eMdCD1xVVc1otuRtJgyvMRg5/5hPl4kmifX45nPY5aGNDIy9XxIkg
	 Dr5kjSUhZqFxDPNiheRVNgIFM2k8W5PP+5VmO+qtCr2+ZlXLX6rY2A5frB66bkYoQy
	 A14fYXdD2KFUvuFo7kH90VHz6Ngvr2SDt4ZfoH2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Andrii Nakryiko <andrii@kernel.org>
Subject: [PATCH 6.1 0104/1191] bpf: Harden bloom filter sizing and indexing on 32-bit kernels
Date: Sat, 12 Sep 2026 08:47:12 +0200
Message-ID: <20260912065550.520568755@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

commit 11c1e836710dcba03e50454a4eedfdbaf8d3050e upstream.

bloom_map_alloc() has two 32-bit-specific problems when the computed
bitmap reaches the U32_MAX fallback case.

First, BITS_TO_BYTES(U32_MAX) is evaluated with 32-bit arithmetic. The
addition performed by DIV_ROUND_UP wraps, so the map allocates only the
fixed-size bloom filter object while keeping bitset_mask == U32_MAX.
Subsequent updates can then write past the allocated object.

Second, fixing only the allocation size is not sufficient. The bloom hash
is a u32, but set_bit() takes a signed long bit number and x86 test_bit()
eventually feeds the index to variable_test_bit(long, ...). On 32-bit
kernels, hashes in [0x80000000, U32_MAX] therefore become negative bit
offsets. x86 bt/bts with a memory operand interpret those offsets relative
to the supplied base, so a map with bitset_mask == U32_MAX can read or
write before bloom->bitset even after allocating the full 512 MiB bitmap.

Keep the U32_MAX fallback, but split each hash into a word pointer and an
in-word bit number before calling test_bit() or set_bit(). The bitops
argument is then always in [0, BITS_PER_LONG - 1], while BIT_WORD(h) still
selects the intended word in the full bitmap.

Compute the bitset size from (u64)bitset_mask + 1 before passing the final
size to bpf_map_area_alloc(). This fixes the original under-allocation and
keeps the allocated storage consistent with the addressable bitset.

Exploitation note: local privilege escalation is possible on a 32-bit x86
kernel using the under-allocation bug from a binary with CAP_BPF.

Fixes: 9330986c0300 ("bpf: Add bloom filter map implementation")
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/bpf/20260805060228.2703051-1-Jeremy.Jean@oss.cyber.gouv.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Assisted-by: Codex:gpt-5
---
 kernel/bpf/bloom_filter.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

--- a/kernel/bpf/bloom_filter.c
+++ b/kernel/bpf/bloom_filter.c
@@ -49,7 +49,7 @@ static int bloom_map_peek_elem(struct bp
 
 	for (i = 0; i < bloom->nr_hash_funcs; i++) {
 		h = hash(bloom, value, map->value_size, i);
-		if (!test_bit(h, bloom->bitset))
+		if (!test_bit(h % BITS_PER_LONG, bloom->bitset + BIT_WORD(h)))
 			return -ENOENT;
 	}
 
@@ -65,9 +65,13 @@ static int bloom_map_push_elem(struct bp
 	if (flags != BPF_ANY)
 		return -EINVAL;
 
+	/*
+	 * On 32-bit architectures, hashes larger than INT_MAX would be
+	 * treated as negative by set_bit().
+	 */
 	for (i = 0; i < bloom->nr_hash_funcs; i++) {
 		h = hash(bloom, value, map->value_size, i);
-		set_bit(h, bloom->bitset);
+		set_bit(h % BITS_PER_LONG, bloom->bitset + BIT_WORD(h));
 	}
 
 	return 0;
@@ -102,9 +106,10 @@ static int bloom_map_alloc_check(union b
 
 static struct bpf_map *bloom_map_alloc(union bpf_attr *attr)
 {
-	u32 bitset_bytes, bitset_mask, nr_hash_funcs, nr_bits;
+	u32 bitset_mask, nr_hash_funcs, nr_bits;
 	int numa_node = bpf_map_attr_numa_node(attr);
 	struct bpf_bloom_filter *bloom;
+	u64 bitset_bytes;
 
 	if (!bpf_capable())
 		return ERR_PTR(-EPERM);
@@ -138,22 +143,16 @@ static struct bpf_map *bloom_map_alloc(u
 	if (check_mul_overflow(attr->max_entries, nr_hash_funcs, &nr_bits) ||
 	    check_mul_overflow(nr_bits / 5, (u32)7, &nr_bits) ||
 	    nr_bits > (1UL << 31)) {
-		/* The bit array size is 2^32 bits but to avoid overflowing the
-		 * u32, we use U32_MAX, which will round up to the equivalent
-		 * number of bytes
-		 */
-		bitset_bytes = BITS_TO_BYTES(U32_MAX);
 		bitset_mask = U32_MAX;
 	} else {
 		if (nr_bits <= BITS_PER_LONG)
 			nr_bits = BITS_PER_LONG;
 		else
 			nr_bits = roundup_pow_of_two(nr_bits);
-		bitset_bytes = BITS_TO_BYTES(nr_bits);
 		bitset_mask = nr_bits - 1;
 	}
 
-	bitset_bytes = roundup(bitset_bytes, sizeof(unsigned long));
+	bitset_bytes = BITS_TO_LONGS((u64)bitset_mask + 1) * sizeof(unsigned long);
 	bloom = bpf_map_area_alloc(sizeof(*bloom) + bitset_bytes, numa_node);
 
 	if (!bloom)


