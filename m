Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB6A8181B86;
	Sun,  1 Sep 2024 16:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209355; cv=none; b=EcqG9Ohj4kKGFz1gHybkxEd+wLTns4MTLsjFS77XnS0ZekL6do63lOoS0J678/+uI/Yhm7Ps0oWq1vgBKV9V1GZxUUs9PftS8B9JdEIFPw5BaoxR01V5IGR+3saZCrbu6DUvYbUJXyyVTUxpyvFfXDAdCoRNOIDrclK6mj0F81E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209355; c=relaxed/simple;
	bh=Ujw47HTiM+m4sajf+9l/P+4V0qNyGVc/pPXdNr7Ku/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mrJGqGui+Vq+kaRuTP6NkIsSUqcJEUgzgNbd5Gf3h89fjzBhvQqbPO2pxdQ861VOnSC44SlUsYbBkLOgp7fFqRWTaRR+PyGsm83iTSarPbmUe4f6uZW6EQThrM8fCrlaRehdqyjXT8q0IRMF9lFOc1VRmYpUH5mgQe660t44uKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qJEPV6Tl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qJEPV6Tl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AF2BC4CEC3;
	Sun,  1 Sep 2024 16:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209354;
	bh=Ujw47HTiM+m4sajf+9l/P+4V0qNyGVc/pPXdNr7Ku/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qJEPV6TlBYQU5dZfH1Zn9HBYp01farpn3ig1WJ99Bs++XcQ0Gy1/yngfYQ0rPVcGr
	 Cnb2o+3XUFYwaD4tdrjAvmV4tioNdQLVWP2RiWZkf8orXNcKny2YZP0I0fmShbNhPp
	 JG4w0RJ2yg3tLTAHBrbYrTSF2TTlLzmB9D0WCluM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Yury Norov <yury.norov@gmail.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 010/151] bitmap: introduce generic optimized bitmap_size()
Date: Sun,  1 Sep 2024 18:16:10 +0200
Message-ID: <20240901160814.487196331@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Lobakin <aleksander.lobakin@intel.com>

commit a37fbe666c016fd89e4460d0ebfcea05baba46dc upstream.

The number of times yet another open coded
`BITS_TO_LONGS(nbits) * sizeof(long)` can be spotted is huge.
Some generic helper is long overdue.

Add one, bitmap_size(), but with one detail.
BITS_TO_LONGS() uses DIV_ROUND_UP(). The latter works well when both
divident and divisor are compile-time constants or when the divisor
is not a pow-of-2. When it is however, the compilers sometimes tend
to generate suboptimal code (GCC 13):

48 83 c0 3f          	add    $0x3f,%rax
48 c1 e8 06          	shr    $0x6,%rax
48 8d 14 c5 00 00 00 00	lea    0x0(,%rax,8),%rdx

%BITS_PER_LONG is always a pow-2 (either 32 or 64), but GCC still does
full division of `nbits + 63` by it and then multiplication by 8.
Instead of BITS_TO_LONGS(), use ALIGN() and then divide by 8. GCC:

8d 50 3f             	lea    0x3f(%rax),%edx
c1 ea 03             	shr    $0x3,%edx
81 e2 f8 ff ff 1f    	and    $0x1ffffff8,%edx

Now it shifts `nbits + 63` by 3 positions (IOW performs fast division
by 8) and then masks bits[2:0]. bloat-o-meter:

add/remove: 0/0 grow/shrink: 20/133 up/down: 156/-773 (-617)

Clang does it better and generates the same code before/after starting
from -O1, except that with the ALIGN() approach it uses %edx and thus
still saves some bytes:

add/remove: 0/0 grow/shrink: 9/133 up/down: 18/-538 (-520)

Note that we can't expand DIV_ROUND_UP() by adding a check and using
this approach there, as it's used in array declarations where
expressions are not allowed.
Add this helper to tools/ as well.

Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Acked-by: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-clone-metadata.c |    5 -----
 drivers/s390/cio/idset.c       |    2 +-
 include/linux/bitmap.h         |    8 +++++---
 include/linux/cpumask.h        |    2 +-
 lib/math/prime_numbers.c       |    2 --
 tools/include/linux/bitmap.h   |    7 ++++---
 6 files changed, 11 insertions(+), 15 deletions(-)

--- a/drivers/md/dm-clone-metadata.c
+++ b/drivers/md/dm-clone-metadata.c
@@ -471,11 +471,6 @@ static void __destroy_persistent_data_st
 
 /*---------------------------------------------------------------------------*/
 
-static size_t bitmap_size(unsigned long nr_bits)
-{
-	return BITS_TO_LONGS(nr_bits) * sizeof(long);
-}
-
 static int __dirty_map_init(struct dirty_map *dmap, unsigned long nr_words,
 			    unsigned long nr_regions)
 {
--- a/drivers/s390/cio/idset.c
+++ b/drivers/s390/cio/idset.c
@@ -18,7 +18,7 @@ struct idset {
 
 static inline unsigned long bitmap_size(int num_ssid, int num_id)
 {
-	return BITS_TO_LONGS(num_ssid * num_id) * sizeof(unsigned long);
+	return bitmap_size(size_mul(num_ssid, num_id));
 }
 
 static struct idset *idset_new(int num_ssid, int num_id)
--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -240,22 +240,24 @@ extern int bitmap_print_to_pagebuf(bool
 #define small_const_nbits(nbits) \
 	(__builtin_constant_p(nbits) && (nbits) <= BITS_PER_LONG && (nbits) > 0)
 
+#define bitmap_size(nbits)	(ALIGN(nbits, BITS_PER_LONG) / BITS_PER_BYTE)
+
 static inline void bitmap_zero(unsigned long *dst, unsigned int nbits)
 {
-	unsigned int len = BITS_TO_LONGS(nbits) * sizeof(unsigned long);
+	unsigned int len = bitmap_size(nbits);
 	memset(dst, 0, len);
 }
 
 static inline void bitmap_fill(unsigned long *dst, unsigned int nbits)
 {
-	unsigned int len = BITS_TO_LONGS(nbits) * sizeof(unsigned long);
+	unsigned int len = bitmap_size(nbits);
 	memset(dst, 0xff, len);
 }
 
 static inline void bitmap_copy(unsigned long *dst, const unsigned long *src,
 			unsigned int nbits)
 {
-	unsigned int len = BITS_TO_LONGS(nbits) * sizeof(unsigned long);
+	unsigned int len = bitmap_size(nbits);
 	memcpy(dst, src, len);
 }
 
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -690,7 +690,7 @@ static inline int cpulist_parse(const ch
  */
 static inline unsigned int cpumask_size(void)
 {
-	return BITS_TO_LONGS(nr_cpumask_bits) * sizeof(long);
+	return bitmap_size(nr_cpumask_bits);
 }
 
 /*
--- a/lib/math/prime_numbers.c
+++ b/lib/math/prime_numbers.c
@@ -6,8 +6,6 @@
 #include <linux/prime_numbers.h>
 #include <linux/slab.h>
 
-#define bitmap_size(nbits) (BITS_TO_LONGS(nbits) * sizeof(unsigned long))
-
 struct primes {
 	struct rcu_head rcu;
 	unsigned long last, sz;
--- a/tools/include/linux/bitmap.h
+++ b/tools/include/linux/bitmap.h
@@ -30,13 +30,14 @@ void bitmap_clear(unsigned long *map, un
 #define small_const_nbits(nbits) \
 	(__builtin_constant_p(nbits) && (nbits) <= BITS_PER_LONG)
 
+#define bitmap_size(nbits)	(ALIGN(nbits, BITS_PER_LONG) / BITS_PER_BYTE)
+
 static inline void bitmap_zero(unsigned long *dst, int nbits)
 {
 	if (small_const_nbits(nbits))
 		*dst = 0UL;
 	else {
-		int len = BITS_TO_LONGS(nbits) * sizeof(unsigned long);
-		memset(dst, 0, len);
+		memset(dst, 0, bitmap_size(nbits));
 	}
 }
 
@@ -122,7 +123,7 @@ static inline int test_and_clear_bit(int
  */
 static inline unsigned long *bitmap_alloc(int nbits)
 {
-	return calloc(1, BITS_TO_LONGS(nbits) * sizeof(unsigned long));
+	return calloc(1, bitmap_size(nbits));
 }
 
 /*


