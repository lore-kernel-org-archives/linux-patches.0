Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CCFB34CFDE;
	Wed, 30 Sep 2026 19:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795004; cv=none; b=IqSo2sp1LG31/hgjZthUjjk75tZoDQ4eMXzZO6POeS680u9m1aHofrZ9rBEIviixEn/ZPkt/qC3lUJzQ5jJYRDiHYKy1KH9BXGALDBj8ctzf0phVcr7TyTfo8p8jl/OceeuAEgqMQ/8lCyBiP0KPxLWj9tqdmntRiGAtRkTbc+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795004; c=relaxed/simple;
	bh=J2whcQ2FBDTCjyVvBo2uwr3wgDy7iXfFUGtajeowCbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QhVDjHQuUqhp4BexHAg/UUNUA6PDBLw2/LMJoOi9le5f63h4vTG+JdmnRg9coCJ2KVKMhUaMIgB0A95d8HG6jKTWzgk8zc+/KyNam8BemjDIcF+H/13TB4HWxfEFTykzbico/gmVj2NJ8BZJ/dmHabsjLuApSE0nofQx5QI/JZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nNCb7+cv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nNCb7+cv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7AD81F000FF;
	Wed, 30 Sep 2026 19:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795003;
	bh=VdL/nptxJNtX3wRWU+o9nm9zs6cRUMwRmMBSUvc6VKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nNCb7+cvPMMiTAzXDCk86ZCm1VpWK6qa/RdrsrcCNTiZQThV9xzSwxPqpkkaQ7QXP
	 GQRLVT3iTInjTkp2OmYxdmawyu6kWOGWMt0tTADaalwQ/6ieqoYjP4GbqN15Rl4b4P
	 WQlLHWSWjLdKd6EqMA/aCh+lqJ0HESyYnCrZfM5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0408/1193] s390/checksum: provide and use cksm() inline assembly
Date: Wed, 30 Sep 2026 17:18:12 +0200
Message-ID: <20260930152443.264209432@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 3a74f44de2c901e1536d227d29257cae1a6ed18f ]

Convert those callers of csum_partial() to use the cksm instruction,
which are either very early or in critical paths, like panic/dump, so
they don't have to rely on a working kernel infrastructure, which will
be introduced with a subsequent patch.

Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Stable-dep-of: 7f918871112e ("s390/ipl: Fix NULL deref in kdump without re-IPL parm block")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/checksum.h | 27 ++++++++++++++++-----------
 arch/s390/kernel/ipl.c           |  3 +--
 arch/s390/kernel/os_info.c       |  6 +++---
 3 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/arch/s390/include/asm/checksum.h b/arch/s390/include/asm/checksum.h
index fcef9ae433a7a..414264b3ed6c0 100644
--- a/arch/s390/include/asm/checksum.h
+++ b/arch/s390/include/asm/checksum.h
@@ -15,6 +15,21 @@
 #include <linux/instrumented.h>
 #include <linux/in6.h>
 
+static inline __wsum cksm(const void *buff, int len, __wsum sum)
+{
+	union register_pair rp = {
+		.even = (unsigned long)buff,
+		.odd = (unsigned long)len,
+	};
+
+	instrument_read(buff, len);
+	asm volatile("\n"
+		"0:	cksm	%[sum],%[rp]\n"
+		"	jo	0b\n"
+		: [sum] "+&d" (sum), [rp] "+&d" (rp.pair) : : "cc", "memory");
+	return sum;
+}
+
 /*
  * Computes the checksum of a memory block at buff, length len,
  * and adds in "sum" (32-bit).
@@ -29,17 +44,7 @@
  */
 static inline __wsum csum_partial(const void *buff, int len, __wsum sum)
 {
-	union register_pair rp = {
-		.even = (unsigned long) buff,
-		.odd = (unsigned long) len,
-	};
-
-	instrument_read(buff, len);
-	asm volatile(
-		"0:	cksm	%[sum],%[rp]\n"
-		"	jo	0b\n"
-		: [sum] "+&d" (sum), [rp] "+&d" (rp.pair) : : "cc", "memory");
-	return sum;
+	return cksm(buff, len, sum);
 }
 
 /*
diff --git a/arch/s390/kernel/ipl.c b/arch/s390/kernel/ipl.c
index 005aa9f694b35..a8d20fb88a01c 100644
--- a/arch/s390/kernel/ipl.c
+++ b/arch/s390/kernel/ipl.c
@@ -1965,8 +1965,7 @@ static void dump_reipl_run(struct shutdown_trigger *trigger)
 	    reipl_type == IPL_TYPE_UNKNOWN)
 		os_info_flags |= OS_INFO_FLAG_REIPL_CLEAR;
 	os_info_entry_add(OS_INFO_FLAGS_ENTRY, &os_info_flags, sizeof(os_info_flags));
-	csum = (__force unsigned int)
-	       csum_partial(reipl_block_actual, reipl_block_actual->hdr.len, 0);
+	csum = (__force unsigned int)cksm(reipl_block_actual, reipl_block_actual->hdr.len, 0);
 	abs_lc = get_abs_lowcore();
 	abs_lc->ipib = __pa(reipl_block_actual);
 	abs_lc->ipib_checksum = csum;
diff --git a/arch/s390/kernel/os_info.c b/arch/s390/kernel/os_info.c
index 6e1824141b29e..a801e6bd53417 100644
--- a/arch/s390/kernel/os_info.c
+++ b/arch/s390/kernel/os_info.c
@@ -29,7 +29,7 @@ static struct os_info os_info __page_aligned_data;
 u32 os_info_csum(struct os_info *os_info)
 {
 	int size = sizeof(*os_info) - offsetof(struct os_info, version_major);
-	return (__force u32)csum_partial(&os_info->version_major, size, 0);
+	return (__force u32)cksm(&os_info->version_major, size, 0);
 }
 
 /*
@@ -49,7 +49,7 @@ void os_info_entry_add(int nr, void *ptr, u64 size)
 {
 	os_info.entry[nr].addr = __pa(ptr);
 	os_info.entry[nr].size = size;
-	os_info.entry[nr].csum = (__force u32)csum_partial(ptr, size, 0);
+	os_info.entry[nr].csum = (__force u32)cksm(ptr, size, 0);
 	os_info.csum = os_info_csum(&os_info);
 }
 
@@ -98,7 +98,7 @@ static void os_info_old_alloc(int nr, int align)
 		msg = "copy failed";
 		goto fail_free;
 	}
-	csum = (__force u32)csum_partial(buf_align, size, 0);
+	csum = (__force u32)cksm(buf_align, size, 0);
 	if (csum != os_info_old->entry[nr].csum) {
 		msg = "checksum failed";
 		goto fail_free;
-- 
2.53.0



