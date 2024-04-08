Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5092E62C;
	Mon,  8 Apr 2024 13:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581448; cv=none; b=a09AepmVjbLzQDLCaFEsGRSzKPXgs1zzvpmFkPNbjiaBgI2La0qV4sfpPcldfo13rWSseFK+y0aiqqjBWLE7wVUz4d+FKMS9b3PV733oqPMkXdJCtjxYOt6zsUz4Q3O+k3HJIyVAUjQGwPgfUMdCmNKqN05ONpOZUPEoKadCIAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581448; c=relaxed/simple;
	bh=77MVwSq0bPpA7rFgxiaRn7wCOFilcBBd7hT8/iqM5fM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f6WAY4L9nHuYO5aoqjz5Zhg2XA+Dc4lcu+PqZg1zMW/3civwlTX+EmaJlCCb/iXWdGKFyquUftby0FqQMN+XXIJVPyDU2srdpGaoCMZv/ojDlHB5tH8sSKmYNsqft0rUijp3QTHTPViA0VjHcqanB6xt+ODgRNVe6v9LpXJHIRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zJ7J2wuY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zJ7J2wuY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18E75C433C7;
	Mon,  8 Apr 2024 13:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581448;
	bh=77MVwSq0bPpA7rFgxiaRn7wCOFilcBBd7hT8/iqM5fM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zJ7J2wuYACna4VEsYKnFvK2rHAybh8dQyiWSn6lkHTR9OvaDDNQ0p8ECx52rQ1dc4
	 I7GfgRaGBerVeHeUSQkY43t9vysnduG2HosQ5qlq7y5vfgnvd5noucXpIRA7AmP8UR
	 71yYNnMxtErRaJ5W7vvzdBUos+dW8hTIw4ihsSJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Collingbourne <pcc@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Marco Elver <elver@google.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Evgenii Stepanov <eugenis@google.com>,
	Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 027/690] kasan: test: add memcpy test that avoids out-of-bounds write
Date: Mon,  8 Apr 2024 14:48:13 +0200
Message-ID: <20240408125400.547268136@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Collingbourne <pcc@google.com>

[ Upstream commit 758cabae312d3aded781aacc6d0c946b299c52df ]

With HW tag-based KASAN, error checks are performed implicitly by the
load and store instructions in the memcpy implementation.  A failed
check results in tag checks being disabled and execution will keep
going.  As a result, under HW tag-based KASAN, prior to commit
1b0668be62cf ("kasan: test: disable kmalloc_memmove_invalid_size for
HW_TAGS"), this memcpy would end up corrupting memory until it hits an
inaccessible page and causes a kernel panic.

This is a pre-existing issue that was revealed by commit 285133040e6c
("arm64: Import latest memcpy()/memmove() implementation") which changed
the memcpy implementation from using signed comparisons (incorrectly,
resulting in the memcpy being terminated early for negative sizes) to
using unsigned comparisons.

It is unclear how this could be handled by memcpy itself in a reasonable
way.  One possibility would be to add an exception handler that would
force memcpy to return if a tag check fault is detected -- this would
make the behavior roughly similar to generic and SW tag-based KASAN.
However, this wouldn't solve the problem for asynchronous mode and also
makes memcpy behavior inconsistent with manually copying data.

This test was added as a part of a series that taught KASAN to detect
negative sizes in memory operations, see commit 8cceeff48f23 ("kasan:
detect negative size in memory operation function").  Therefore we
should keep testing for negative sizes with generic and SW tag-based
KASAN.  But there is some value in testing small memcpy overflows, so
let's add another test with memcpy that does not destabilize the kernel
by performing out-of-bounds writes, and run it in all modes.

Link: https://linux-review.googlesource.com/id/I048d1e6a9aff766c4a53f989fb0c83de68923882
Link: https://lkml.kernel.org/r/20210910211356.3603758-1-pcc@google.com
Signed-off-by: Peter Collingbourne <pcc@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Acked-by: Marco Elver <elver@google.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Stable-dep-of: e10aea105e9e ("kasan/test: avoid gcc warning for intentional overflow")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/test_kasan.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/lib/test_kasan.c b/lib/test_kasan.c
index 89f444cabd4a8..f0b8b05ccf194 100644
--- a/lib/test_kasan.c
+++ b/lib/test_kasan.c
@@ -500,7 +500,7 @@ static void kmalloc_oob_in_memset(struct kunit *test)
 	kfree(ptr);
 }
 
-static void kmalloc_memmove_invalid_size(struct kunit *test)
+static void kmalloc_memmove_negative_size(struct kunit *test)
 {
 	char *ptr;
 	size_t size = 64;
@@ -522,6 +522,21 @@ static void kmalloc_memmove_invalid_size(struct kunit *test)
 	kfree(ptr);
 }
 
+static void kmalloc_memmove_invalid_size(struct kunit *test)
+{
+	char *ptr;
+	size_t size = 64;
+	volatile size_t invalid_size = size;
+
+	ptr = kmalloc(size, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
+
+	memset((char *)ptr, 0, 64);
+	KUNIT_EXPECT_KASAN_FAIL(test,
+		memmove((char *)ptr, (char *)ptr + 4, invalid_size));
+	kfree(ptr);
+}
+
 static void kmalloc_uaf(struct kunit *test)
 {
 	char *ptr;
@@ -1139,6 +1154,7 @@ static struct kunit_case kasan_kunit_test_cases[] = {
 	KUNIT_CASE(kmalloc_oob_memset_4),
 	KUNIT_CASE(kmalloc_oob_memset_8),
 	KUNIT_CASE(kmalloc_oob_memset_16),
+	KUNIT_CASE(kmalloc_memmove_negative_size),
 	KUNIT_CASE(kmalloc_memmove_invalid_size),
 	KUNIT_CASE(kmalloc_uaf),
 	KUNIT_CASE(kmalloc_uaf_memset),
-- 
2.43.0



