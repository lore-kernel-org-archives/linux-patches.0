Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209432;
	b=ZTjyJpgLmi15tSgwBSS3PyYVda+YvqVVgBG0VaduThEz6PEJHocNz+8SbNKpjoyXnxtz
	 V6d0v1r/dpZaDGuppi6IO/nwLU/NHWWu4hcAs7nAnu1zlFbLHBNZXOV5JT8oEvQYd6m8w
	 4wtr9Q4u+xrn7ESmozfJ3z7VgBIVfjMrumbXJuCnXlR4I87zhXwJH9GHXtwAQXtDrVu0M
	 MQXiGVPDUfkr/VWLagdzE1HZs3R5T6CV2r3dhYddd5z3oGNq2GHv8bNTjWVVbICTH0+4G
	 M4WQgQiJRD7yzKjHPZ6Gra8fL/RpDKcCpKp+6r/ivKPV28RU6PGCmAz+ZO2rC0f9XAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209432;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+C7SslD1hqSNM01oNTcDOGi1NapasizEWYvI/F/IO2o=;
	b=1ezFsC8pT9owoz9r0P2bq4kCmbdRT7dU9Enb64laYLk8D6CODn8QqtusMXCM4jEn25IZ
	 BLu2ghnO8hmSFfFK5sAmDuj2O2X3++R+hAjQmOsRR5Qlqx47EbjJOybxeC4Ks1/m47NFY
	 ZPmCPnOfm5lz6bEtSOcvb/Uylylq81/ZSFHV5YD6jGPkFLeMjCBZ+VLqd4xFqT2yXphf8
	 X0Gxtq6YVB2ychxQ0ErnXEzdQZ1x5fhG+gdy6Rpi0ijb5XOSkWx6Xjsk0+IvhS9QI2sb7
	 Txbdy0aO4VKU97ewamTYJcz8madcrgLg1nglyeU2SbJ1IXCtVQXdK2aZg4vdi9CR4jg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yo04LaJq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB23606A31D;
	Wed, 28 Oct 2026 17:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yo04LaJq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B73E1F01825;
	Wed, 28 Oct 2026 17:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209432;
	bh=+C7SslD1hqSNM01oNTcDOGi1NapasizEWYvI/F/IO2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yo04LaJq++vyBZ7i1Vtl8dRN+NKMKHr/G3x2cHu4duOJDl5+uD6VQhHdw9GtzFz3A
	 g0uyHBElDEA0VRWTasP9c5QH1SXTXkfkqAvxE1NqsgsCS51AUIB5yhy7J/2U0G5r+I
	 6xm3aUhj39wbHvZ1t5eogTOi7NZZQVyaY+7DzNEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	"Miguel Gazquez (Schneider Electric)" <miguel.gazquez@bootlin.com>
Subject: [PATCH 5.10 425/516] bpf: fix potential 32-bit overflow when accessing ARRAY map element
Date: Wed, 28 Oct 2026 17:59:37 +0100
Message-ID: <20261028170013.554854097@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[removed the changes that applied to code not yet introduced]
Signed-off-by: Miguel Gazquez (Schneider Electric) <miguel.gazquez@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/arraymap.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index 3d92e42c3895a..06f27f4bdf593 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -174,6 +174,11 @@ static struct bpf_map *array_map_alloc(union bpf_attr *attr)
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
@@ -183,7 +188,7 @@ static void *array_map_lookup_elem(struct bpf_map *map, void *key)
 	if (unlikely(index >= array->map.max_entries))
 		return NULL;
 
-	return array->value + array->elem_size * (index & array->index_mask);
+	return array->value + (u64)array->elem_size * (index & array->index_mask);
 }
 
 static int array_map_direct_value_addr(const struct bpf_map *map, u64 *imm,
@@ -335,7 +340,7 @@ static int array_map_update_elem(struct bpf_map *map, void *key, void *value,
 		       value, map->value_size);
 	} else {
 		val = array->value +
-			array->elem_size * (index & array->index_mask);
+			(u64)array->elem_size * (index & array->index_mask);
 		if (map_flags & BPF_F_LOCK)
 			copy_map_value_locked(map, val, value, false);
 		else
@@ -530,7 +535,7 @@ static void *bpf_array_map_seq_start(struct seq_file *seq, loff_t *pos)
 	index = info->index & array->index_mask;
 	if (info->percpu_value_buf)
 	       return array->pptrs[index];
-	return array->value + array->elem_size * index;
+	return array_map_elem_ptr(array, index);
 }
 
 static void *bpf_array_map_seq_next(struct seq_file *seq, void *v, loff_t *pos)
@@ -549,7 +554,7 @@ static void *bpf_array_map_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 	index = info->index & array->index_mask;
 	if (info->percpu_value_buf)
 	       return array->pptrs[index];
-	return array->value + array->elem_size * index;
+	return array_map_elem_ptr(array, index);
 }
 
 static int __bpf_array_map_seq_show(struct seq_file *seq, void *v)
-- 
2.53.0



