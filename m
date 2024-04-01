Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C3C4C624;
	Mon,  1 Apr 2024 15:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986659; cv=none; b=Lpg1goryg/XOlX8vB6abwIghostITzUUDVHONpDrCnEFmaohOCbBxkhD0umKOfiuPHTaAsMck9r61Kpb/B9/qnaqIqZzmuQWlNFMPxa/jkyM6Eat/glvyaHACGHbvIn88cwa4oNuGwo/MKQwJ+6E8xD9KBULSulmLoJlfYdEzyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986659; c=relaxed/simple;
	bh=YSIb0m9Y78h5TmAshpwyvnJwgG2Q++2qrhN+kFA2WaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z88QEKRgIeS9op+MLC/69IELGRNo2lmR9mTKSwK83u2IcMwna4Br17uFvwT4MwB53NbUklVY/LI8q0AnaOpMxtWsQc0vq8ZzFd16PbV5ymuW6V2fSi+4M0l5pxdWXIzIRWwqUzuRL4tCMQmSDOt6ROiYsWI4JQfCkan9CjMZrmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fUYFFUGX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fUYFFUGX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3971CC433F1;
	Mon,  1 Apr 2024 15:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986659;
	bh=YSIb0m9Y78h5TmAshpwyvnJwgG2Q++2qrhN+kFA2WaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fUYFFUGXeA7fledxyl5uyfxegzaPXT0oPYQ0ky1ZIV8WC5aysn+Syz7+UkW0rCx6U
	 5QEwjHCSs/0UfHq0UjloBxkTZnWK61ovRa8ReJG3hFZhm+14Q0xlU6odBW1N7InahJ
	 cI/xqDAm4BF41djhVZRE9ESkZz/EKrhXs0VqRf4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Marco Elver <elver@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 045/399] kasan/test: avoid gcc warning for intentional overflow
Date: Mon,  1 Apr 2024 17:40:11 +0200
Message-ID: <20240401152550.520783876@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit e10aea105e9ed14b62a11844fec6aaa87c6935a3 ]

The out-of-bounds test allocates an object that is three bytes too short
in order to validate the bounds checking.  Starting with gcc-14, this
causes a compile-time warning as gcc has grown smart enough to understand
the sizeof() logic:

mm/kasan/kasan_test.c: In function 'kmalloc_oob_16':
mm/kasan/kasan_test.c:443:14: error: allocation of insufficient size '13' for type 'struct <anonymous>' with size '16' [-Werror=alloc-size]
  443 |         ptr1 = kmalloc(sizeof(*ptr1) - 3, GFP_KERNEL);
      |              ^

Hide the actual computation behind a RELOC_HIDE() that ensures
the compiler misses the intentional bug.

Link: https://lkml.kernel.org/r/20240212111609.869266-1-arnd@kernel.org
Fixes: 3f15801cdc23 ("lib: add kasan test module")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/kasan/kasan_test.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/kasan/kasan_test.c b/mm/kasan/kasan_test.c
index 971cfff4ca0b7..e26a2583a6643 100644
--- a/mm/kasan/kasan_test.c
+++ b/mm/kasan/kasan_test.c
@@ -440,7 +440,8 @@ static void kmalloc_oob_16(struct kunit *test)
 	/* This test is specifically crafted for the generic mode. */
 	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_GENERIC);
 
-	ptr1 = kmalloc(sizeof(*ptr1) - 3, GFP_KERNEL);
+	/* RELOC_HIDE to prevent gcc from warning about short alloc */
+	ptr1 = RELOC_HIDE(kmalloc(sizeof(*ptr1) - 3, GFP_KERNEL), 0);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr1);
 
 	ptr2 = kmalloc(sizeof(*ptr2), GFP_KERNEL);
-- 
2.43.0



