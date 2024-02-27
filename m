Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AEB42F2D;
	Tue, 27 Feb 2024 13:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040879; cv=none; b=FDwAWBLvhBnFMrJb1YHgANBVx2Kr68OGsFM/nx2KP4oafPD6YbM3PthzcqJ5VxcaWFNgRsqRH01kx8NlwfxV9p3/pHoba3SlKkboh94Aa2L71hpq+UF95P4i9w/O7PwGY/Fq3ksA3DlCaQQm2RC+6pmYYhZO6z4ANGm6etCsMAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040879; c=relaxed/simple;
	bh=FjabROoGuI/4e4jriZyTwPaQS/Pn60FqdyLaQ94c7VI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iNpYz0f0CAYTwFDz1Q6r/GtPgEjhXE/fRSV7CnZweXxJxtPogj9MnJvssJfXWsM6msUye2+acBOxC97kfiG5jWk7MN9s5HjYQBDrKH54Tx0Vfj8UpzIf4LDNCfeW9oggfHq4OHr1LSIQxfN7YvVbGsOlysgOZJ6Q5y7PYecyyxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gc8kl2XH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gc8kl2XH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 071A9C433C7;
	Tue, 27 Feb 2024 13:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040879;
	bh=FjabROoGuI/4e4jriZyTwPaQS/Pn60FqdyLaQ94c7VI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gc8kl2XHeamr21l7ssBvTGiUVQDxP2RAoNPjgv574BqRow1nViCFcdyf3/P32nygD
	 JhArAGBhKEhV2AP6s74FUm0xES+PLv5gOGO6riI7uSZwnDs0dw3Dpzkoh4xheUir6g
	 BfguEdyPGQyWqDGreqSIw6iMyHHuef9hQIFV9+zM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Daniel Vetter <daniel@ffwll.ch>,
	Maxime Ripard <mripard@kernel.org>,
	David Gow <davidgow@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 6.7 141/334] kunit: Add a macro to wrap a deferred action function
Date: Tue, 27 Feb 2024 14:19:59 +0100
Message-ID: <20240227131635.012068851@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Gow <davidgow@google.com>

commit 56778b49c9a2cbc32c6b0fbd3ba1a9d64192d3af upstream.

KUnit's deferred action API accepts a void(*)(void *) function pointer
which is called when the test is exited. However, we very frequently
want to use existing functions which accept a single pointer, but which
may not be of type void*. While this is probably dodgy enough to be on
the wrong side of the C standard, it's been often used for similar
callbacks, and gcc's -Wcast-function-type seems to ignore cases where
the only difference is the type of the argument, assuming it's
compatible (i.e., they're both pointers to data).

However, clang 16 has introduced -Wcast-function-type-strict, which no
longer permits any deviation in function pointer type. This seems to be
because it'd break CFI, which validates the type of function calls.

This rather ruins our attempts to cast functions to defer them, and
leaves us with a few options. The one we've chosen is to implement a
macro which will generate a wrapper function which accepts a void*, and
casts the argument to the appropriate type.

For example, if you were trying to wrap:
void foo_close(struct foo *handle);
you could use:
KUNIT_DEFINE_ACTION_WRAPPER(kunit_action_foo_close,
			    foo_close,
			    struct foo *);

This would create a new kunit_action_foo_close() function, of type
kunit_action_t, which could be passed into kunit_add_action() and
similar functions.

In addition to defining this macro, update KUnit and its tests to use
it.

Link: https://github.com/ClangBuiltLinux/linux/issues/1750
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: Daniel Vetter <daniel@ffwll.ch>
Reviewed-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: David Gow <davidgow@google.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/dev-tools/kunit/usage.rst |   10 +++++++---
 include/kunit/resource.h                |   21 +++++++++++++++++++++
 lib/kunit/kunit-test.c                  |    5 +----
 lib/kunit/test.c                        |    6 ++++--
 4 files changed, 33 insertions(+), 9 deletions(-)

--- a/Documentation/dev-tools/kunit/usage.rst
+++ b/Documentation/dev-tools/kunit/usage.rst
@@ -651,12 +651,16 @@ For example:
 	}
 
 Note that, for functions like device_unregister which only accept a single
-pointer-sized argument, it's possible to directly cast that function to
-a ``kunit_action_t`` rather than writing a wrapper function, for example:
+pointer-sized argument, it's possible to automatically generate a wrapper
+with the ``KUNIT_DEFINE_ACTION_WRAPPER()`` macro, for example:
 
 .. code-block:: C
 
-	kunit_add_action(test, (kunit_action_t *)&device_unregister, &dev);
+	KUNIT_DEFINE_ACTION_WRAPPER(device_unregister, device_unregister_wrapper, struct device *);
+	kunit_add_action(test, &device_unregister_wrapper, &dev);
+
+You should do this in preference to manually casting to the ``kunit_action_t`` type,
+as casting function pointers will break Control Flow Integrity (CFI).
 
 ``kunit_add_action`` can fail if, for example, the system is out of memory.
 You can use ``kunit_add_action_or_reset`` instead which runs the action
--- a/include/kunit/resource.h
+++ b/include/kunit/resource.h
@@ -391,6 +391,27 @@ void kunit_remove_resource(struct kunit
 typedef void (kunit_action_t)(void *);
 
 /**
+ * KUNIT_DEFINE_ACTION_WRAPPER() - Wrap a function for use as a deferred action.
+ *
+ * @wrapper: The name of the new wrapper function define.
+ * @orig: The original function to wrap.
+ * @arg_type: The type of the argument accepted by @orig.
+ *
+ * Defines a wrapper for a function which accepts a single, pointer-sized
+ * argument. This wrapper can then be passed to kunit_add_action() and
+ * similar. This should be used in preference to casting a function
+ * directly to kunit_action_t, as casting function pointers will break
+ * control flow integrity (CFI), leading to crashes.
+ */
+#define KUNIT_DEFINE_ACTION_WRAPPER(wrapper, orig, arg_type)	\
+	static void wrapper(void *in)				\
+	{							\
+		arg_type arg = (arg_type)in;			\
+		orig(arg);					\
+	}
+
+
+/**
  * kunit_add_action() - Call a function when the test ends.
  * @test: Test case to associate the action with.
  * @action: The function to run on test exit
--- a/lib/kunit/kunit-test.c
+++ b/lib/kunit/kunit-test.c
@@ -538,10 +538,7 @@ static struct kunit_suite kunit_resource
 #if IS_BUILTIN(CONFIG_KUNIT_TEST)
 
 /* This avoids a cast warning if kfree() is passed direct to kunit_add_action(). */
-static void kfree_wrapper(void *p)
-{
-	kfree(p);
-}
+KUNIT_DEFINE_ACTION_WRAPPER(kfree_wrapper, kfree, const void *);
 
 static void kunit_log_test(struct kunit *test)
 {
--- a/lib/kunit/test.c
+++ b/lib/kunit/test.c
@@ -819,6 +819,8 @@ static struct notifier_block kunit_mod_n
 };
 #endif
 
+KUNIT_DEFINE_ACTION_WRAPPER(kfree_action_wrapper, kfree, const void *)
+
 void *kunit_kmalloc_array(struct kunit *test, size_t n, size_t size, gfp_t gfp)
 {
 	void *data;
@@ -828,7 +830,7 @@ void *kunit_kmalloc_array(struct kunit *
 	if (!data)
 		return NULL;
 
-	if (kunit_add_action_or_reset(test, (kunit_action_t *)kfree, data) != 0)
+	if (kunit_add_action_or_reset(test, kfree_action_wrapper, data) != 0)
 		return NULL;
 
 	return data;
@@ -840,7 +842,7 @@ void kunit_kfree(struct kunit *test, con
 	if (!ptr)
 		return;
 
-	kunit_release_action(test, (kunit_action_t *)kfree, (void *)ptr);
+	kunit_release_action(test, kfree_action_wrapper, (void *)ptr);
 }
 EXPORT_SYMBOL_GPL(kunit_kfree);
 


