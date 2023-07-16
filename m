Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9FBC8F6D
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:23:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ACCDC433C8;
	Sun, 16 Jul 2023 20:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538982;
	bh=RMp4xByG4ffeO0OOKmDWbpxiTLqmBseqZwL54lV+3dg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lhCHHJwyILsWLKKgrExPH40gXGIxvp5F4OXyWZO/4UOm6cZCof/jfrdvX9FcDeC7g
	 AHvT7mY6XcY+pbm/Kyaw1GR+IEVU7SvkIoVcMeV5UEe1yLtsFJikUXkidQt0iZujOk
	 cxdGN3tWYQQmwRlIQFRc96kqnpFQdp8j4AczEnAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Yury Norov <yury.norov@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 645/800] lib/bitmap: drop optimization of bitmap_{from,to}_arr64
Date: Sun, 16 Jul 2023 21:48:18 +0200
Message-ID: <20230716195004.096975819@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yury Norov <yury.norov@gmail.com>

[ Upstream commit c1d2ba10f594046831d14b03f194e8d05e78abad ]

bitmap_{from,to}_arr64() optimization is overly optimistic on 32-bit LE
architectures when it's wired to bitmap_copy_clear_tail().

bitmap_copy_clear_tail() takes care of unused bits in the bitmap up to
the next word boundary. But on 32-bit machines when copying bits from
bitmap to array of 64-bit words, it's expected that the unused part of
a recipient array must be cleared up to 64-bit boundary, so the last 4
bytes may stay untouched when nbits % 64 <= 32.

While the copying part of the optimization works correct, that clear-tail
trick makes corresponding tests reasonably fail:

test_bitmap: bitmap_to_arr64(nbits == 1): tail is not safely cleared: 0xa5a5a5a500000001 (must be 0x0000000000000001)

Fix it by removing bitmap_{from,to}_arr64() optimization for 32-bit LE
arches.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/lkml/20230225184702.GA3587246@roeck-us.net/
Fixes: 0a97953fd221 ("lib: add bitmap_{from,to}_arr64")
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bitmap.h | 8 +++-----
 lib/bitmap.c           | 2 +-
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
index 7d6d73b781472..03644237e1efb 100644
--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -302,12 +302,10 @@ void bitmap_to_arr32(u32 *buf, const unsigned long *bitmap,
 #endif
 
 /*
- * On 64-bit systems bitmaps are represented as u64 arrays internally. On LE32
- * machines the order of hi and lo parts of numbers match the bitmap structure.
- * In both cases conversion is not needed when copying data from/to arrays of
- * u64.
+ * On 64-bit systems bitmaps are represented as u64 arrays internally. So,
+ * the conversion is not needed when copying data from/to arrays of u64.
  */
-#if (BITS_PER_LONG == 32) && defined(__BIG_ENDIAN)
+#if BITS_PER_LONG == 32
 void bitmap_from_arr64(unsigned long *bitmap, const u64 *buf, unsigned int nbits);
 void bitmap_to_arr64(u64 *buf, const unsigned long *bitmap, unsigned int nbits);
 #else
diff --git a/lib/bitmap.c b/lib/bitmap.c
index 1c81413c51f86..ddb31015e38ae 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -1495,7 +1495,7 @@ void bitmap_to_arr32(u32 *buf, const unsigned long *bitmap, unsigned int nbits)
 EXPORT_SYMBOL(bitmap_to_arr32);
 #endif
 
-#if (BITS_PER_LONG == 32) && defined(__BIG_ENDIAN)
+#if BITS_PER_LONG == 32
 /**
  * bitmap_from_arr64 - copy the contents of u64 array of bits to bitmap
  *	@bitmap: array of unsigned longs, the destination bitmap
-- 
2.39.2



