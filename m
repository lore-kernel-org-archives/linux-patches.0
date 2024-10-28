Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C032A2AF07;
	Mon, 28 Oct 2024 06:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098522; cv=none; b=Cf0gEEL6Ft/x5Q0uxEA6cX4bFHLL5n3ovW64FaQbJjBHPgIzdP35XC7qEZ3WBlZbJlKtlSe7ACAd2bdSYWWEYdt5IqM2dcdKSSvSsFKdS0FH58eqoXBsEOXnkpv0KZE9q6WCtWbEqkL0Km/LYlxy+PcMjGR4pbouUzN8nkD1gWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098522; c=relaxed/simple;
	bh=EJQhaHmW3Gk72BLc4XEGYjoGiS1z3L8bNI99oCtAPRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RKuyKj2ZNwQ94rrkvGC98iQT6iLelgMDzveBNOWL29PV9Y7S2zLvev4o7qMqY7AqsXkbbNEVrStHwBJpRADt6LAlbQiWYro2vwCjExgNliJ+yUsTfbD9YClc7vlkLY878TF9xE8de1K2RkJfkZ05bDt8aVdgK8wFflOsD5ZhjDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zqIBfJ32; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zqIBfJ32"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F43FC4CEC7;
	Mon, 28 Oct 2024 06:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098522;
	bh=EJQhaHmW3Gk72BLc4XEGYjoGiS1z3L8bNI99oCtAPRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zqIBfJ32E6a8ouMm+6Yd1MFLyPMhelnuEEqd5saWYd0+EKYI0m7lEx3Pk8WfiOZIs
	 UhgOU0+BrMY4ClSAK9DKerGWUFTEmtdnMgaKMFJciiz03+bjkmZZbFFnEefHPP9Jws
	 34s7T8VZWwjwcHq6PubS2oTerYskzD1vIJSjg2FU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.11 256/261] x86: support user address masking instead of non-speculative conditional
Date: Mon, 28 Oct 2024 07:26:38 +0100
Message-ID: <20241028062318.511363521@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 2865baf54077aa98fcdb478cefe6a42c417b9374 upstream.

The Spectre-v1 mitigations made "access_ok()" much more expensive, since
it has to serialize execution with the test for a valid user address.

All the normal user copy routines avoid this by just masking the user
address with a data-dependent mask instead, but the fast
"unsafe_user_read()" kind of patterms that were supposed to be a fast
case got slowed down.

This introduces a notion of using

	src = masked_user_access_begin(src);

to do the user address sanity using a data-dependent mask instead of the
more traditional conditional

	if (user_read_access_begin(src, len)) {

model.

This model only works for dense accesses that start at 'src' and on
architectures that have a guard region that is guaranteed to fault in
between the user space and the kernel space area.

With this, the user access doesn't need to be manually checked, because
a bad address is guaranteed to fault (by some architecture masking
trick: on x86-64 this involves just turning an invalid user address into
all ones, since we don't map the top of address space).

This only converts a couple of examples for now.  Example x86-64 code
generation for loading two words from user space:

        stac
        mov    %rax,%rcx
        sar    $0x3f,%rcx
        or     %rax,%rcx
        mov    (%rcx),%r13
        mov    0x8(%rcx),%r14
        clac

where all the error handling and -EFAULT is now purely handled out of
line by the exception path.

Of course, if the micro-architecture does badly at 'clac' and 'stac',
the above is still pitifully slow.  But at least we did as well as we
could.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/uaccess_64.h |    8 ++++++++
 fs/select.c                       |    4 +++-
 include/linux/uaccess.h           |    7 +++++++
 lib/strncpy_from_user.c           |    9 +++++++++
 lib/strnlen_user.c                |    9 +++++++++
 5 files changed, 36 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -54,6 +54,14 @@ static inline unsigned long __untagged_a
 #define valid_user_address(x) ((__force long)(x) >= 0)
 
 /*
+ * Masking the user address is an alternative to a conditional
+ * user_access_begin that can avoid the fencing. This only works
+ * for dense accesses starting at the address.
+ */
+#define mask_user_address(x) ((typeof(x))((long)(x)|((long)(x)>>63)))
+#define masked_user_access_begin(x) ({ __uaccess_begin(); mask_user_address(x); })
+
+/*
  * User pointers can have tag bits on x86-64.  This scheme tolerates
  * arbitrary values in those bits rather then masking them off.
  *
--- a/fs/select.c
+++ b/fs/select.c
@@ -780,7 +780,9 @@ static inline int get_sigset_argpack(str
 {
 	// the path is hot enough for overhead of copy_from_user() to matter
 	if (from) {
-		if (!user_read_access_begin(from, sizeof(*from)))
+		if (can_do_masked_user_access())
+			from = masked_user_access_begin(from);
+		else if (!user_read_access_begin(from, sizeof(*from)))
 			return -EFAULT;
 		unsafe_get_user(to->p, &from->p, Efault);
 		unsafe_get_user(to->size, &from->size, Efault);
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -33,6 +33,13 @@
 })
 #endif
 
+#ifdef masked_user_access_begin
+ #define can_do_masked_user_access() 1
+#else
+ #define can_do_masked_user_access() 0
+ #define masked_user_access_begin(src) NULL
+#endif
+
 /*
  * Architectures should provide two primitives (raw_copy_{to,from}_user())
  * and get rid of their private instances of copy_{to,from}_user() and
--- a/lib/strncpy_from_user.c
+++ b/lib/strncpy_from_user.c
@@ -120,6 +120,15 @@ long strncpy_from_user(char *dst, const
 	if (unlikely(count <= 0))
 		return 0;
 
+	if (can_do_masked_user_access()) {
+		long retval;
+
+		src = masked_user_access_begin(src);
+		retval = do_strncpy_from_user(dst, src, count, count);
+		user_read_access_end();
+		return retval;
+	}
+
 	max_addr = TASK_SIZE_MAX;
 	src_addr = (unsigned long)untagged_addr(src);
 	if (likely(src_addr < max_addr)) {
--- a/lib/strnlen_user.c
+++ b/lib/strnlen_user.c
@@ -96,6 +96,15 @@ long strnlen_user(const char __user *str
 	if (unlikely(count <= 0))
 		return 0;
 
+	if (can_do_masked_user_access()) {
+		long retval;
+
+		str = masked_user_access_begin(str);
+		retval = do_strnlen_user(str, count, count);
+		user_read_access_end();
+		return retval;
+	}
+
 	max_addr = TASK_SIZE_MAX;
 	src_addr = (unsigned long)untagged_addr(str);
 	if (likely(src_addr < max_addr)) {


