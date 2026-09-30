Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF624E9C21;
	Wed, 30 Sep 2026 16:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784033; cv=none; b=scDAAMczbPiPUq9UaPaPjId85so49UUMTSNvzYZMCUlVPIqOTrEW0FAyaii8qmMGVIG4VYh6Ky4iqvYtdvwpb07zZ8vUWwwiRlXbhNvivItNxXC+ukHvg31SsRtkgK8JUT6TE0IfebDv3nYGpciIjklvw7QmhDFCp5QMbMQ7VTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784033; c=relaxed/simple;
	bh=erEm1caXaePh914hRVh2uDSfEgPLnpSNLW7zBCuvN6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D3dOLtdWrUwyU5efxz68i5fH3zliIYGuykgGaDqpS5bsi1+g0hLd3pNl0g5rCG4JheTZOihGNovDaXDKZZLs1q7fK+CNr9DHLtiyYts6qkKvgN4mjLj0UpRIEzd9a9fKNojLXaBW2QJWcfKg9Z1H+J3MOm3AvOP2LXs76grL3LM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Xeqzbd9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Xeqzbd9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13C601F00899;
	Wed, 30 Sep 2026 16:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784028;
	bh=SoIAWWq1/R022OerpE0hvu1F+PeWhO1BVlVA2oR8PQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Xeqzbd9D1r3xSGi2qvukJVQ4xSpyJ1Vs5uKLQqQbgPbtGqRDWUaiaGPVKg4rovlI
	 HWnB2SKAKDgSTlkfoJvZzLdW7WEqo3aCsmmDLoxMg1Cyy49utQU2WYcRGwxo33llbW
	 /2fGGcED2sDB61nUkyP79o/2vpc3LGW6M4telTig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Marco Elver <elver@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 012/982] kcsan: Silence -Wmaybe-uninitialized when calling __kcsan_check_access()
Date: Wed, 30 Sep 2026 17:12:28 +0200
Message-ID: <20260930152417.051352321@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marco Elver <elver@google.com>

[ Upstream commit 07a1a6562ce29e2e0c134a57882d6e52e8758492 ]

Some subsystems enable -Wmaybe-uninitialized [1], which can trigger
false positives when KCSAN is enabled. Specifically, passing an
uninitialized variable to functions that instrument accesses (e.g.,
copy_from_user()) results in calls to __kcsan_check_access().

Because __kcsan_check_access() takes a `const volatile void *ptr`, GCC
infers that the function may only read the memory location, and thus
warns if the passed variable is uninitialized.

However, KCSAN is a dynamic analysis tool for data race detection; while
it does read the memory location to detect concurrent modifications, the
"initialized'ness" of the memory location is irrelevant for its analysis.

Use absolute_pointer() in __kcsan_check_write(), kcsan_check_write(),
and kcsan_check_atomic_write() to hide the pointer from the compiler,
preventing it from concluding that the pointer passed points to
uninitialized memory.

This fixes warnings like:

|   CC      fs/ntfs3/file.o
| In file included from include/asm-generic/rwonce.h:27,
|                  from arch/arm64/include/asm/rwonce.h:81,
|                  from include/linux/compiler.h:369,
|                  from include/linux/array_size.h:5,
|                  from include/linux/kernel.h:16,
|                  from include/linux/backing-dev.h:12,
|                  from fs/ntfs3/file.c:10:
| In function 'instrument_copy_from_user_before',
|     inlined from '_inline_copy_from_user' at include/linux/uaccess.h:184:2,
|     inlined from 'copy_from_user' at include/linux/uaccess.h:221:9,
|     inlined from 'ntfs_ioctl_fitrim' at fs/ntfs3/file.c:77:6,
|     inlined from 'ntfs_ioctl' at fs/ntfs3/file.c:164:10:
| include/linux/kcsan-checks.h:220:28: error: 'range' may be used uninitialized [-Werror=maybe-uninitialized]
|   220 | #define kcsan_check_access __kcsan_check_access
|       |                            ^
| include/linux/kcsan-checks.h:311:9: note: in expansion of macro 'kcsan_check_access'
|   311 |         kcsan_check_access(ptr, size, KCSAN_ACCESS_WRITE)
|       |         ^~~~~~~~~~~~~~~~~~
| include/linux/instrumented.h:147:9: note: in expansion of macro 'kcsan_check_write'
|   147 |         kcsan_check_write(to, n);
|       |         ^~~~~~~~~~~~~~~~~
| include/linux/kcsan-checks.h: In function 'ntfs_ioctl':
| include/linux/kcsan-checks.h:37:6: note: by argument 1 of type 'const volatile void *' to '__kcsan_check_access' declared here
|    37 | void __kcsan_check_access(const volatile void *ptr, size_t size, int type);
|       |      ^~~~~~~~~~~~~~~~~~~~
| fs/ntfs3/file.c:65:29: note: 'range' declared here
|    65 |         struct fstrim_range range;
|       |                             ^~~~~

Link: https://lore.kernel.org/all/5da10cca-875b-418d-b54e-6be3ea32c266@app.fastmail.com/ [1]
Reported-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Tested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Marco Elver <elver@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/kcsan-checks.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/kcsan-checks.h b/include/linux/kcsan-checks.h
index 92f3843d9ebb8..e135dacaa90f3 100644
--- a/include/linux/kcsan-checks.h
+++ b/include/linux/kcsan-checks.h
@@ -282,7 +282,7 @@ static inline void __kcsan_disable_current(void) { }
  * @size: size of access
  */
 #define __kcsan_check_write(ptr, size)                                         \
-	__kcsan_check_access(ptr, size, KCSAN_ACCESS_WRITE)
+	__kcsan_check_access(absolute_pointer(ptr), size, KCSAN_ACCESS_WRITE)
 
 /**
  * __kcsan_check_read_write - check regular read-write access for races
@@ -308,7 +308,7 @@ static inline void __kcsan_disable_current(void) { }
  * @size: size of access
  */
 #define kcsan_check_write(ptr, size)                                           \
-	kcsan_check_access(ptr, size, KCSAN_ACCESS_WRITE)
+	kcsan_check_access(absolute_pointer(ptr), size, KCSAN_ACCESS_WRITE)
 
 /**
  * kcsan_check_read_write - check regular read-write access for races
@@ -331,7 +331,7 @@ static inline void __kcsan_disable_current(void) { }
 #define kcsan_check_atomic_read(ptr, size)                                     \
 	kcsan_check_access(ptr, size, KCSAN_ACCESS_ATOMIC)
 #define kcsan_check_atomic_write(ptr, size)                                    \
-	kcsan_check_access(ptr, size, KCSAN_ACCESS_ATOMIC | KCSAN_ACCESS_WRITE)
+	kcsan_check_access(absolute_pointer(ptr), size, KCSAN_ACCESS_ATOMIC | KCSAN_ACCESS_WRITE)
 #define kcsan_check_atomic_read_write(ptr, size)                               \
 	kcsan_check_access(ptr, size, KCSAN_ACCESS_ATOMIC | KCSAN_ACCESS_WRITE | KCSAN_ACCESS_COMPOUND)
 #endif
-- 
2.53.0



