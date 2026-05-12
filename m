Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC633EDE68;
	Tue, 12 May 2026 18:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609210; cv=none; b=EgwPafyfSYi5hqlCqMcqvusF9d1xnlWRLL3/2A2sTntnbgv4m8SprkRXvtmAI8qpgOivyY1zWJ3gzuXSTmHJq9s13qp16Nkl9JTfTZAlC7MQELbBk2JjfSr53msJ8OtXcoUeI3wzGhseMB5phg1HLJrHxjZL7CMhnSZ44+4XtKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609210; c=relaxed/simple;
	bh=7PX58gXgbTb9kHd++5Fo8a2LJEyrGVTZLLyvfmBj2Oc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iL2ACza+Nvg+XTZfLStmSMIQGNWR+6BLYTnEvpLa/dQBPwmQqs3cdnq//iwJWNV1DwymJ4IWViHlSjN+gJ5fe3nSivttvyMZSKRTKdnjucvph2XEo4x9Pt94tlaCVKSmCAn+upLSV6oOXteDehYIVOsKjOmcD5af1Bsifjz0qes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yXeBcx+Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yXeBcx+Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2066DC2BCB0;
	Tue, 12 May 2026 18:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609210;
	bh=7PX58gXgbTb9kHd++5Fo8a2LJEyrGVTZLLyvfmBj2Oc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yXeBcx+YxbYlufpYEdLZuwW0MtpP4/wGa4+9tBGNyETuoYTqBdBJAdC8VaBnb1S1F
	 jgNte7Mjhi4/5Fec5AQphk0Wgw+SiQbbDYEcN13EBj7U6Vulh0OALftYNYJRkbY4lN
	 Gi9VhhOFfOENNUF2VA3nJzkct2NJ6UHc3quzIMdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Dmitry Vyukov <dvyukov@google.com>
Subject: [PATCH 7.0 106/307] selftests/rseq: Make registration flexible for legacy and optimized mode
Date: Tue, 12 May 2026 19:38:21 +0200
Message-ID: <20260512173942.362880375@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@kernel.org>

commit d97cb2ef0b221b068e90b6058aa97faa0626bdab upstream.

rseq_register_current_thread() either uses the glibc registered RSEQ region
or registers it's own region with the legacy size of 32 bytes.

That worked so far, but becomes a problem when the kernel implements a
distinction between legacy and performance optimized behavior based on the
registration size as that does not allow to test both modes with the self
test suite.

Add two arguments to the function. One to enforce that the registration is
not using libc provided mode and one to tell the registration to use the
legacy size and not the kernel advertised size.

Rename it and make the original one a inline wrapper which preserves the
existing behavior.

Fixes: 566d8015f7ee ("rseq: Avoid CPU/MM CID updates when no event pending")
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Tested-by: Dmitry Vyukov <dvyukov@google.com>
Link: https://patch.msgid.link/20260428224427.677889423%40kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/rseq/rseq-abi.h |    7 ++++-
 tools/testing/selftests/rseq/rseq.c     |   39 ++++++++++++++------------------
 tools/testing/selftests/rseq/rseq.h     |    8 +++++-
 3 files changed, 31 insertions(+), 23 deletions(-)

--- a/tools/testing/selftests/rseq/rseq-abi.h
+++ b/tools/testing/selftests/rseq/rseq-abi.h
@@ -192,9 +192,14 @@ struct rseq_abi {
 	struct rseq_abi_slice_ctrl slice_ctrl;
 
 	/*
+	 * Place holder to push the size above 32 bytes.
+	 */
+	__u8 __reserved;
+
+	/*
 	 * Flexible array member at end of structure, after last feature field.
 	 */
 	char end[];
-} __attribute__((aligned(4 * sizeof(__u64))));
+} __attribute__((aligned(256)));
 
 #endif /* _RSEQ_ABI_H */
--- a/tools/testing/selftests/rseq/rseq.c
+++ b/tools/testing/selftests/rseq/rseq.c
@@ -56,6 +56,7 @@ ptrdiff_t rseq_offset;
  * unsuccessful.
  */
 unsigned int rseq_size = -1U;
+static unsigned int rseq_alloc_size;
 
 /* Flags used during rseq registration.  */
 unsigned int rseq_flags;
@@ -115,29 +116,17 @@ bool rseq_available(void)
 	}
 }
 
-/* The rseq areas need to be at least 32 bytes. */
-static
-unsigned int get_rseq_min_alloc_size(void)
-{
-	unsigned int alloc_size = rseq_size;
-
-	if (alloc_size < ORIG_RSEQ_ALLOC_SIZE)
-		alloc_size = ORIG_RSEQ_ALLOC_SIZE;
-	return alloc_size;
-}
-
 /*
  * Return the feature size supported by the kernel.
  *
  * Depending on the value returned by getauxval(AT_RSEQ_FEATURE_SIZE):
  *
- * 0:   Return ORIG_RSEQ_FEATURE_SIZE (20)
+ *   0: Return ORIG_RSEQ_FEATURE_SIZE (20)
  * > 0: Return the value from getauxval(AT_RSEQ_FEATURE_SIZE).
  *
  * It should never return a value below ORIG_RSEQ_FEATURE_SIZE.
  */
-static
-unsigned int get_rseq_kernel_feature_size(void)
+static unsigned int get_rseq_kernel_feature_size(void)
 {
 	unsigned long auxv_rseq_feature_size, auxv_rseq_align;
 
@@ -152,15 +141,24 @@ unsigned int get_rseq_kernel_feature_siz
 		return ORIG_RSEQ_FEATURE_SIZE;
 }
 
-int rseq_register_current_thread(void)
+int __rseq_register_current_thread(bool nolibc, bool legacy)
 {
+	unsigned int size;
 	int rc;
 
 	if (!rseq_ownership) {
 		/* Treat libc's ownership as a successful registration. */
-		return 0;
+		return nolibc ? -EBUSY : 0;
 	}
-	rc = sys_rseq(&__rseq.abi, get_rseq_min_alloc_size(), 0, RSEQ_SIG);
+
+	/* The minimal allocation size is 32, which is the legacy allocation size */
+	size = get_rseq_kernel_feature_size();
+	if (legacy || size < ORIG_RSEQ_ALLOC_SIZE)
+		rseq_alloc_size = ORIG_RSEQ_ALLOC_SIZE;
+	else
+		rseq_alloc_size = size;
+
+	rc = sys_rseq(&__rseq.abi, rseq_alloc_size, 0, RSEQ_SIG);
 	if (rc) {
 		/*
 		 * After at least one thread has registered successfully
@@ -179,9 +177,8 @@ int rseq_register_current_thread(void)
 	 * The first thread to register sets the rseq_size to mimic the libc
 	 * behavior.
 	 */
-	if (RSEQ_READ_ONCE(rseq_size) == 0) {
-		RSEQ_WRITE_ONCE(rseq_size, get_rseq_kernel_feature_size());
-	}
+	if (RSEQ_READ_ONCE(rseq_size) == 0)
+		RSEQ_WRITE_ONCE(rseq_size, size);
 
 	return 0;
 }
@@ -194,7 +191,7 @@ int rseq_unregister_current_thread(void)
 		/* Treat libc's ownership as a successful unregistration. */
 		return 0;
 	}
-	rc = sys_rseq(&__rseq.abi, get_rseq_min_alloc_size(), RSEQ_ABI_FLAG_UNREGISTER, RSEQ_SIG);
+	rc = sys_rseq(&__rseq.abi, rseq_alloc_size, RSEQ_ABI_FLAG_UNREGISTER, RSEQ_SIG);
 	if (rc)
 		return -1;
 	return 0;
--- a/tools/testing/selftests/rseq/rseq.h
+++ b/tools/testing/selftests/rseq/rseq.h
@@ -8,6 +8,7 @@
 #ifndef RSEQ_H
 #define RSEQ_H
 
+#include <assert.h>
 #include <stdint.h>
 #include <stdbool.h>
 #include <pthread.h>
@@ -142,7 +143,12 @@ static inline struct rseq_abi *rseq_get_
  * succeed. A restartable sequence executed from a non-registered
  * thread will always fail.
  */
-int rseq_register_current_thread(void);
+int __rseq_register_current_thread(bool nolibc, bool legacy);
+
+static inline int rseq_register_current_thread(void)
+{
+	return __rseq_register_current_thread(false, false);
+}
 
 /*
  * Unregister rseq for current thread.


