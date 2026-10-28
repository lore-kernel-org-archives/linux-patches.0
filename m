Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207406;
	b=SemcyeU5cbRTQC6mH5uFE/YevNlnjCO2fY2yRH3iGlUrPJBM6vbdE66q6+yUfXcFBEDx
	 oYwryFuhCbQrEXRsFt1Rw4C/+3ideQf8iFrvC/N0dNVfqJ09O6LLwhbKQPjHwxFt8C0vQ
	 AuGRNwWJgqlx8Qg6032e6c1GEnUbXSs51VFRfueB4UmqKcLr4r+hGDWH4PS+q/wy8+fEr
	 X9sFbPIsNky0IabfsTulwAYBT7OZ+vilu6TJWYQM6nwo6NTr3dI0eI4a1xHO3AoWfgyfn
	 DPptPE0AhX5KTpgmkl8gkvIWQSy+WhA9SQs9v9BgmuuC7oI/go3mL6fuhNiJKoO9gfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207406;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zsqeE9ITiJXkG8mND9W0HfKjmPxc5egSRD93c45wbYM=;
	b=aPy01r0I3TTcQR4FijQpY1ai+zgXbsVs7JwMyCAzxViLYnzN5yejvne+PEhWC2EVaM8R
	 Sf5tLzI3OLRq2ioiUt9o5eZlpbFMYgVXZBdJ2pEjO8BYKN772LEECRiz5OJ7xeZ8L6IcW
	 1cQLjCUEu+Gar2AZIVBU1dYM9ZlbZdFg+hWk7kKZ0eXLP3uoBMncoWew++chLkcrlYeEw
	 TeUrcClEkWJIEemPeKmkEnA+XKkZB5LL0TJAXvEQ8HAsm2UFkMlLfN/ighHBwOfHupcJO
	 fMxqXaAlZOzGatYF1GVqr/ird4L9xsnIGTioHhVSs0SKWolqIZa+xLZ0uSe/+Voaidw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xw40FS4x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B38606A31C;
	Wed, 28 Oct 2026 17:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xw40FS4x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E19631F031E2;
	Wed, 28 Oct 2026 17:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207405;
	bh=zsqeE9ITiJXkG8mND9W0HfKjmPxc5egSRD93c45wbYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xw40FS4x97UanpkmAjlu7Qg43GfGU/5cumgeg4LbbphdLOrjMjlPMhTO4LPR90PuB
	 Xbo9CWqbG9Xy5tcKVns2BLDPKL/Tjowge0tZJqggfkvgUKteeliLkqh5urNS9pmlFf
	 X88kxOYYM8Kjb4znW3vNDvIsoAkpSnJLkEbzyCFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 7.2 73/88] keys: make keyring indexes independent of kernel addresses
Date: Wed, 28 Oct 2026 18:00:21 +0100
Message-ID: <20261028165943.834680238@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.107695352@linuxfoundation.org>
References: <20261028165942.107695352@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyle Zeng <kylebot@openai.com>

commit de891c73c1cf41ac8de12c07fa2c84d6a912ad0c upstream.

KEYCTL_READ returns the serial numbers in a keyring in associative-array
traversal order.  The first word of the index is a public, deterministic
hash of the type pointer, domain pointer and description.  An unprivileged
user can therefore insert keys with known descriptions, predict their
order for each possible KASLR slide, and recover the kernel image address.
On an x86-64 build with 16 MiB alignment, 45 user keys suffice to
distinguish the candidate slides.

Remove the addresses from the whole index, not just its first hash word.
Assign each key type and domain a nonzero 64-bit ID and hash those IDs and
the description with a once-initialized SipHash key.  Use the full IDs in
the later index chunks as well.  Truncating or hashing the IDs there would
lose the guarantee that distinct type/domain/description tuples have a
differing index bit.

Allocate IDs lazily since private key types need not be registered.  Cache
them in the index key so tree walks and copies of an existing index do not
need to dereference a type descriptor that may have been unregistered.
Keep the 32-bit chunk layout and diff_objects() bit offsets consistent,
and retain the separate root slot for keyrings used by recursive search.
The key comparison, permissions and userspace data format are unchanged;
only the address-dependent in-memory ordering is replaced.

Cc: stable@vger.kernel.org
Fixes: b2a4df200d57 ("KEYS: Expand the capacity of a keyring")
Assisted-by: Codex:gpt-6-astra
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Link: https://lore.kernel.org/r/20261013231251.56170-1-kylebot@openai.com
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/key-type.h |    1 
 include/linux/key.h      |    5 +
 security/keys/keyring.c  |  150 +++++++++++++++++++++++++----------------------
 3 files changed, 86 insertions(+), 70 deletions(-)

--- a/include/linux/key-type.h
+++ b/include/linux/key-type.h
@@ -161,6 +161,7 @@ struct key_type {
 				     const void *in, const void *in2);
 
 	/* internal fields */
+	atomic64_t		index_id;	/* Opaque keyring index ID */
 	struct list_head	link;		/* link in types list */
 	struct lock_class_key	lock_class;	/* key->sem lock class */
 } __randomize_layout;
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -107,6 +107,7 @@ struct keyring_name;
 
 struct key_tag {
 	struct rcu_head		rcu;
+	atomic64_t		index_id;	/* Opaque keyring index ID */
 	refcount_t		usage;
 	bool			removed;	/* T when subject removed */
 };
@@ -129,6 +130,8 @@ struct keyring_index_key {
 	struct key_type		*type;
 	struct key_tag		*domain_tag;	/* Domain of operation */
 	const char		*description;
+	u64			type_id;	/* Cached index IDs */
+	u64			domain_id;
 };
 
 union key_payload {
@@ -251,6 +254,8 @@ struct key {
 			struct key_type	*type;		/* type of key */
 			struct key_tag	*domain_tag;	/* Domain of operation */
 			char		*description;
+			u64		type_id;
+			u64		domain_id;
 		};
 	};
 
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -14,6 +14,9 @@
 #include <linux/err.h>
 #include <linux/user_namespace.h>
 #include <linux/nsproxy.h>
+#include <linux/once.h>
+#include <linux/random.h>
+#include <linux/siphash.h>
 #include <keys/keyring-type.h>
 #include <keys/user-type.h>
 #include <linux/assoc_array_priv.h>
@@ -147,49 +150,46 @@ static int keyring_instantiate(struct ke
 }
 
 /*
- * Multiply 64-bits by 32-bits to 96-bits and fold back to 64-bit.  Ideally we'd
- * fold the carry back too, but that requires inline asm.
+ * Give key types and domains address-independent identities.  Zero means that
+ * an ID has not yet been allocated.  As with inode sequence numbers used by
+ * futexes, this relies on the 64-bit counter not wrapping in a machine's
+ * lifetime.
  */
-static u64 mult_64x32_and_fold(u64 x, u32 y)
+static u64 key_index_id(atomic64_t *id)
 {
-	u64 hi = (u64)(u32)(x >> 32) * y;
-	u64 lo = (u64)(u32)(x) * y;
-	return lo + ((u64)(u32)hi << 32) + (u32)(hi >> 32);
+	static atomic64_t next_id;
+	u64 old, new;
+
+	old = atomic64_read(id);
+	if (likely(old))
+		return old;
+
+	do {
+		new = atomic64_inc_return(&next_id);
+	} while (WARN_ON_ONCE(!new));
+
+	old = 0;
+	if (!atomic64_try_cmpxchg_relaxed(id, &old, new))
+		return old;
+	return new;
 }
 
 /*
- * Hash a key type and description.
+ * Hash a key type, domain and description.  KEYCTL_READ exposes the tree's
+ * traversal order, so no part of the index may contain kernel addresses.
  */
 static void hash_key_type_and_desc(struct keyring_index_key *index_key)
 {
 	const unsigned level_shift = ASSOC_ARRAY_LEVEL_STEP;
 	const unsigned long fan_mask = ASSOC_ARRAY_FAN_MASK;
-	const char *description = index_key->description;
-	unsigned long hash, type;
-	u32 piece;
+	static siphash_key_t hash_key __read_mostly;
+	unsigned long hash;
 	u64 acc;
-	int n, desc_len = index_key->desc_len;
 
-	type = (unsigned long)index_key->type;
-	acc = mult_64x32_and_fold(type, desc_len + 13);
-	acc = mult_64x32_and_fold(acc, 9207);
-	piece = (unsigned long)index_key->domain_tag;
-	acc = mult_64x32_and_fold(acc, piece);
-	acc = mult_64x32_and_fold(acc, 9207);
-
-	for (;;) {
-		n = desc_len;
-		if (n <= 0)
-			break;
-		if (n > 4)
-			n = 4;
-		piece = 0;
-		memcpy(&piece, description, n);
-		description += n;
-		desc_len -= n;
-		acc = mult_64x32_and_fold(acc, piece);
-		acc = mult_64x32_and_fold(acc, 9207);
-	}
+	get_random_once(&hash_key, sizeof(hash_key));
+	acc = siphash(index_key->description, index_key->desc_len, &hash_key);
+	acc = siphash_3u64(index_key->type_id, index_key->domain_id, acc,
+			   &hash_key);
 
 	/* Fold the hash down to 32 bits if need be. */
 	hash = acc;
@@ -209,7 +209,7 @@ static void hash_key_type_and_desc(struc
 
 /*
  * Finalise an index key to include a part of the description actually in the
- * index key, to set the domain tag and to calculate the hash.
+ * index key, to set the domain tag and index IDs, and to calculate the hash.
  */
 void key_set_index_key(struct keyring_index_key *index_key)
 {
@@ -225,6 +225,14 @@ void key_set_index_key(struct keyring_in
 			index_key->domain_tag = &default_domain_tag;
 	}
 
+	/* Preserve the IDs when copying an existing key's index.  In
+	 * particular, its type may already have been unregistered.
+	 */
+	if (!index_key->type_id)
+		index_key->type_id = key_index_id(&index_key->type->index_id);
+	if (!index_key->domain_id)
+		index_key->domain_id = key_index_id(&index_key->domain_tag->index_id);
+
 	hash_key_type_and_desc(index_key);
 }
 
@@ -263,15 +271,19 @@ void key_remove_domain(struct key_tag *d
 /*
  * Build the next index key chunk.
  *
+ * The hash and inline description are followed by the 64-bit type and domain
+ * IDs, low word first, and then by the rest of the description.
  * We return it one word-sized chunk at a time.
  */
 static unsigned long keyring_get_key_chunk(const void *data, int level)
 {
+	const unsigned int id_chunks = sizeof(u64) / sizeof(unsigned long);
 	const struct keyring_index_key *index_key = data;
+	int desc_len = index_key->desc_len;
 	unsigned long chunk = 0;
-	const u8 *d;
-	int desc_len = index_key->desc_len, n = sizeof(chunk);
+	int n = sizeof(chunk);
 	unsigned int offset;
+	const u8 *d;
 
 	level /= ASSOC_ARRAY_KEY_CHUNK_SIZE;
 	switch (level) {
@@ -279,27 +291,30 @@ static unsigned long keyring_get_key_chu
 		return index_key->hash;
 	case 1:
 		return index_key->x;
-	case 2:
-		return (unsigned long)index_key->type;
-	case 3:
-		return (unsigned long)index_key->domain_tag;
-	default:
-		level -= 4;
-		offset = sizeof(index_key->desc) + level * sizeof(long);
-		if (desc_len <= offset)
-			return 0;
-
-		d = index_key->description + offset;
-		desc_len -= offset;
-		if (desc_len > n)
-			desc_len = n;
-		d += desc_len;
-		do {
-			chunk <<= 8;
-			chunk |= *--d;
-		} while (--desc_len > 0);
-		return chunk;
 	}
+
+	level -= 2;
+	if (level < id_chunks)
+		return index_key->type_id >> (level * ASSOC_ARRAY_KEY_CHUNK_SIZE);
+	level -= id_chunks;
+	if (level < id_chunks)
+		return index_key->domain_id >> (level * ASSOC_ARRAY_KEY_CHUNK_SIZE);
+	level -= id_chunks;
+
+	offset = sizeof(index_key->desc) + level * sizeof(long);
+	if (desc_len <= offset)
+		return 0;
+
+	d = index_key->description + offset;
+	desc_len -= offset;
+	if (desc_len > n)
+		desc_len = n;
+	d += desc_len;
+	do {
+		chunk <<= 8;
+		chunk |= *--d;
+	} while (--desc_len > 0);
+	return chunk;
 }
 
 static unsigned long keyring_get_object_key_chunk(const void *object, int level)
@@ -331,6 +346,7 @@ static int keyring_diff_objects(const vo
 	const struct keyring_index_key *b = data;
 	unsigned long seg_a, seg_b;
 	int level, i;
+	u64 diff;
 
 	level = 0;
 	seg_a = a->hash;
@@ -339,28 +355,22 @@ static int keyring_diff_objects(const vo
 		goto differ;
 	level += ASSOC_ARRAY_KEY_CHUNK_SIZE / 8;
 
-	/* The number of bits contributed by the hash is controlled by a
-	 * constant in the assoc_array headers.  Everything else thereafter we
-	 * can deal with as being machine word-size dependent.
-	 */
+	/* The inline description contributes one machine-word-sized chunk. */
 	seg_a = a->x;
 	seg_b = b->x;
 	if ((seg_a ^ seg_b) != 0)
 		goto differ;
 	level += sizeof(unsigned long);
 
-	/* The next bit may not work on big endian */
-	seg_a = (unsigned long)a->type;
-	seg_b = (unsigned long)b->type;
-	if ((seg_a ^ seg_b) != 0)
-		goto differ;
-	level += sizeof(unsigned long);
-
-	seg_a = (unsigned long)a->domain_tag;
-	seg_b = (unsigned long)b->domain_tag;
-	if ((seg_a ^ seg_b) != 0)
-		goto differ;
-	level += sizeof(unsigned long);
+	diff = a->type_id ^ b->type_id;
+	if (diff)
+		return level * 8 + __ffs64(diff);
+	level += sizeof(u64);
+
+	diff = a->domain_id ^ b->domain_id;
+	if (diff)
+		return level * 8 + __ffs64(diff);
+	level += sizeof(u64);
 
 	i = sizeof(a->desc);
 	if (a->desc_len <= i)


