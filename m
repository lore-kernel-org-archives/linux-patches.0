Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C799299959;
	Tue, 26 Aug 2025 11:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207336; cv=none; b=nzEhjj93CEJGlZyW/ewTNcWTSN8P0Yvbdt+cQbuHMS/pbnX1ro1XQVH1SPxl9nAot+YM5EF+ph/y4WVvuTFnT0Hs3GYP2/bxXKQ0PzCI3OxjNpc31OPY49tZYtGgqFUmyufApQ+iPKWQlOX+9X64ashrJDLvu5b+k5KwCpt2yMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207336; c=relaxed/simple;
	bh=mfojpQZkSJGeIkwmXcL7Hg8LW6Hk263CbKgF7k6M4sg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gI+ISGr2Iffsww/rG61Fu5+B6GJPgT0jTXCa3NfS1ckL+n/5DSNRwytDkeKagsN65YIEnhO96u0sF9i4plBrOFlZp1ajvGNzZhbWVSktoni558Nj0t3TE9Zqg2AWViwZXQMGlKO8WcrE7osa0AOmyGfTPCyDi50TJyULT/DTiAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B2rzwTI1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B2rzwTI1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2541C4CEF4;
	Tue, 26 Aug 2025 11:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207336;
	bh=mfojpQZkSJGeIkwmXcL7Hg8LW6Hk263CbKgF7k6M4sg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B2rzwTI1lcBf6rNEd33hl+HMCEaiecsP+d4TQzZ47WUa5d8UxkwJdE04yUtZT2nVq
	 rjouxYiEVj5IMx5xyQfnXpPTmMmcg5Yf27/r2l5LkXinVHx8bYYaLM4ZmHbQP35bpw
	 F29Z27ONAwai2C/xm9udhgcVfbRsKlwddrJldKpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Dmitriy Vyukov <dvyukov@google.com>,
	Nihar Chaithanya <niharchaithanya@gmail.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.16 115/457] kasan/test: fix protection against compiler elision
Date: Tue, 26 Aug 2025 13:06:39 +0200
Message-ID: <20250826110940.215678918@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jann Horn <jannh@google.com>

commit 475356fe2814f2f0b188da8bf0f1fcc579d81272 upstream.

The kunit test is using assignments to
"static volatile void *kasan_ptr_result" to prevent elision of memory
loads, but that's not working:
In this variable definition, the "volatile" applies to the "void", not to
the pointer.
To make "volatile" apply to the pointer as intended, it must follow
after the "*".

This makes the kasan_memchr test pass again on my system.  The
kasan_strings test is still failing because all the definitions of
load_unaligned_zeropad() are lacking explicit instrumentation hooks and
ASAN does not instrument asm() memory operands.

Link: https://lkml.kernel.org/r/20250728-kasan-kunit-fix-volatile-v1-1-e7157c9af82d@google.com
Fixes: 5f1c8108e7ad ("mm:kasan: fix sparse warnings: Should it be static?")
Signed-off-by: Jann Horn <jannh@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Nihar Chaithanya <niharchaithanya@gmail.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/kasan/kasan_test_c.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kasan/kasan_test_c.c
+++ b/mm/kasan/kasan_test_c.c
@@ -47,7 +47,7 @@ static struct {
  * Some tests use these global variables to store return values from function
  * calls that could otherwise be eliminated by the compiler as dead code.
  */
-static volatile void *kasan_ptr_result;
+static void *volatile kasan_ptr_result;
 static volatile int kasan_int_result;
 
 /* Probe for console output: obtains test_status lines of interest. */


