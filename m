Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9D318C91B;
	Tue, 10 Sep 2024 09:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961327; cv=none; b=VlE+lb/+AZpZov9goj8sscNCP+AU3UHzebrXvAzqeqgerGPMdFxtQ+mpCovZ6LNf4K/AK0OppdZKrTiVopcCyDxBX/DsNt86+OseD4STGzlCTuflUrT0lBnCIg5jBm9xq6nxGAwZNz7si9uXmG0yH2QCKOEqTcph1mEVbvb0aG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961327; c=relaxed/simple;
	bh=ZKJbdoMae/ztHh35b/5h2T3/a0eIt+Xy+NCjf0pqwU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O7dJ8dWxHEQ6yPiWc7jsw2qu3Y4f001vsH3b0rWkgArWUkwER0DBfWHrweOKFXnip+O75ArvfIq98gh0GR5gUlr4+Ik+r/enlh1Lnt1n/p5X65NXXrbGtnl824wQjh8XiWi0CCD9JhQq4vzLy6A62/U+pkhyQUTDyTotrWFAGJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iWGdf/xD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iWGdf/xD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E1BBC4CEC3;
	Tue, 10 Sep 2024 09:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961326;
	bh=ZKJbdoMae/ztHh35b/5h2T3/a0eIt+Xy+NCjf0pqwU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iWGdf/xDMKQLnfJ7L/RmOIbwuGvZT0dTxUVuzo5FymF37WyJLm8yvJGkOhCIoTFa/
	 QA5T/PPbvdeTz/5HyOzF3K3s36WpZM4ZTyHC9+UrBtb83nEYStpju0JXW5LOwHP0ol
	 Po5PJfJHgCt7iY9tSawo2xAYUmmV0Yc7mxePt1SY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Jeff Xu <jeffxu@chromium.org>,
	Kees Cook <kees@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.10 032/375] selftests: mm: fix build errors on armhf
Date: Tue, 10 Sep 2024 11:27:09 +0200
Message-ID: <20240910092623.314101083@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Usama Anjum <usama.anjum@collabora.com>

commit b808f629215685c1941b1cd567c7b7ccb3c90278 upstream.

The __NR_mmap isn't found on armhf.  The mmap() is commonly available
system call and its wrapper is present on all architectures.  So it should
be used directly.  It solves problem for armhf and doesn't create problem
for other architectures.

Remove sys_mmap() functions as they aren't doing anything else other than
calling mmap().  There is no need to set errno = 0 manually as glibc
always resets it.

For reference errors are as following:

  CC       seal_elf
seal_elf.c: In function 'sys_mmap':
seal_elf.c:39:33: error: '__NR_mmap' undeclared (first use in this function)
   39 |         sret = (void *) syscall(__NR_mmap, addr, len, prot,
      |                                 ^~~~~~~~~

mseal_test.c: In function 'sys_mmap':
mseal_test.c:90:33: error: '__NR_mmap' undeclared (first use in this function)
   90 |         sret = (void *) syscall(__NR_mmap, addr, len, prot,
      |                                 ^~~~~~~~~

Link: https://lkml.kernel.org/r/20240809082511.497266-1-usama.anjum@collabora.com
Fixes: 4926c7a52de7 ("selftest mm/mseal memory sealing")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/mm/mseal_test.c |   37 +++++++++++---------------------
 tools/testing/selftests/mm/seal_elf.c   |   13 -----------
 2 files changed, 14 insertions(+), 36 deletions(-)

--- a/tools/testing/selftests/mm/mseal_test.c
+++ b/tools/testing/selftests/mm/mseal_test.c
@@ -128,17 +128,6 @@ static int sys_mprotect_pkey(void *ptr,
 	return sret;
 }
 
-static void *sys_mmap(void *addr, unsigned long len, unsigned long prot,
-	unsigned long flags, unsigned long fd, unsigned long offset)
-{
-	void *sret;
-
-	errno = 0;
-	sret = (void *) syscall(__NR_mmap, addr, len, prot,
-		flags, fd, offset);
-	return sret;
-}
-
 static int sys_munmap(void *ptr, size_t size)
 {
 	int sret;
@@ -219,7 +208,7 @@ static void setup_single_address(int siz
 {
 	void *ptr;
 
-	ptr = sys_mmap(NULL, size, PROT_READ, MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	ptr = mmap(NULL, size, PROT_READ, MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
 	*ptrOut = ptr;
 }
 
@@ -228,7 +217,7 @@ static void setup_single_address_rw(int
 	void *ptr;
 	unsigned long mapflags = MAP_ANONYMOUS | MAP_PRIVATE;
 
-	ptr = sys_mmap(NULL, size, PROT_READ | PROT_WRITE, mapflags, -1, 0);
+	ptr = mmap(NULL, size, PROT_READ | PROT_WRITE, mapflags, -1, 0);
 	*ptrOut = ptr;
 }
 
@@ -252,7 +241,7 @@ bool seal_support(void)
 	void *ptr;
 	unsigned long page_size = getpagesize();
 
-	ptr = sys_mmap(NULL, page_size, PROT_READ, MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	ptr = mmap(NULL, page_size, PROT_READ, MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
 	if (ptr == (void *) -1)
 		return false;
 
@@ -528,8 +517,8 @@ static void test_seal_zero_address(void)
 	int prot;
 
 	/* use mmap to change protection. */
-	ptr = sys_mmap(0, size, PROT_NONE,
-			MAP_ANONYMOUS | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	ptr = mmap(0, size, PROT_NONE,
+		   MAP_ANONYMOUS | MAP_PRIVATE | MAP_FIXED, -1, 0);
 	FAIL_TEST_IF_FALSE(ptr == 0);
 
 	size = get_vma_size(ptr, &prot);
@@ -1256,8 +1245,8 @@ static void test_seal_mmap_overwrite_pro
 	}
 
 	/* use mmap to change protection. */
-	ret2 = sys_mmap(ptr, size, PROT_NONE,
-			MAP_ANONYMOUS | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	ret2 = mmap(ptr, size, PROT_NONE,
+		    MAP_ANONYMOUS | MAP_PRIVATE | MAP_FIXED, -1, 0);
 	if (seal) {
 		FAIL_TEST_IF_FALSE(ret2 == MAP_FAILED);
 		FAIL_TEST_IF_FALSE(errno == EPERM);
@@ -1287,8 +1276,8 @@ static void test_seal_mmap_expand(bool s
 	}
 
 	/* use mmap to expand. */
-	ret2 = sys_mmap(ptr, size, PROT_READ,
-			MAP_ANONYMOUS | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	ret2 = mmap(ptr, size, PROT_READ,
+		    MAP_ANONYMOUS | MAP_PRIVATE | MAP_FIXED, -1, 0);
 	if (seal) {
 		FAIL_TEST_IF_FALSE(ret2 == MAP_FAILED);
 		FAIL_TEST_IF_FALSE(errno == EPERM);
@@ -1315,8 +1304,8 @@ static void test_seal_mmap_shrink(bool s
 	}
 
 	/* use mmap to shrink. */
-	ret2 = sys_mmap(ptr, 8 * page_size, PROT_READ,
-			MAP_ANONYMOUS | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	ret2 = mmap(ptr, 8 * page_size, PROT_READ,
+		    MAP_ANONYMOUS | MAP_PRIVATE | MAP_FIXED, -1, 0);
 	if (seal) {
 		FAIL_TEST_IF_FALSE(ret2 == MAP_FAILED);
 		FAIL_TEST_IF_FALSE(errno == EPERM);
@@ -1697,7 +1686,7 @@ static void test_seal_discard_ro_anon_on
 	ret = fallocate(fd, 0, 0, size);
 	FAIL_TEST_IF_FALSE(!ret);
 
-	ptr = sys_mmap(NULL, size, PROT_READ, mapflags, fd, 0);
+	ptr = mmap(NULL, size, PROT_READ, mapflags, fd, 0);
 	FAIL_TEST_IF_FALSE(ptr != MAP_FAILED);
 
 	if (seal) {
@@ -1727,7 +1716,7 @@ static void test_seal_discard_ro_anon_on
 	int ret;
 	unsigned long mapflags = MAP_ANONYMOUS | MAP_SHARED;
 
-	ptr = sys_mmap(NULL, size, PROT_READ, mapflags, -1, 0);
+	ptr = mmap(NULL, size, PROT_READ, mapflags, -1, 0);
 	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
 
 	if (seal) {
--- a/tools/testing/selftests/mm/seal_elf.c
+++ b/tools/testing/selftests/mm/seal_elf.c
@@ -61,17 +61,6 @@ static int sys_mseal(void *start, size_t
 	return sret;
 }
 
-static void *sys_mmap(void *addr, unsigned long len, unsigned long prot,
-	unsigned long flags, unsigned long fd, unsigned long offset)
-{
-	void *sret;
-
-	errno = 0;
-	sret = (void *) syscall(__NR_mmap, addr, len, prot,
-		flags, fd, offset);
-	return sret;
-}
-
 static inline int sys_mprotect(void *ptr, size_t size, unsigned long prot)
 {
 	int sret;
@@ -87,7 +76,7 @@ static bool seal_support(void)
 	void *ptr;
 	unsigned long page_size = getpagesize();
 
-	ptr = sys_mmap(NULL, page_size, PROT_READ, MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	ptr = mmap(NULL, page_size, PROT_READ, MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
 	if (ptr == (void *) -1)
 		return false;
 


