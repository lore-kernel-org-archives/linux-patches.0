Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B1ED15A842;
	Mon,  6 Jan 2025 15:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177125; cv=none; b=VMbW+/rJYT4liRyU3Ui32oEOVXi8rO8pb6uwmpuQElsDQ19UKYTBGeTn6EVylEIzi403eDHHVhY0OAD3YyNkWj3mQcNIA2n8RzaAyMIy3mc97Ez7/2FsF2qDR8HHy2/7bKGBVBpf+jUSa1PF375+5DAZF+J8nSbyJ/evHhLJ0Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177125; c=relaxed/simple;
	bh=QOS+WtMdlYdnGTliJeN3unNo/LekunBVL/yF8BVEEL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pq7f9cZKkoaFwQWxtbWclGcO1xmARmhsntoUFk1KO6Q4dmutcNT3ffGpZV7olyQP4H73zm6SPT0Q07ENGaRxyzOfaV4rdRGI/UW6TYJXuQYbA4HdzZgdmxgLxj4EwDgWlvb6b3HQ8Mkc3vO9p9BECoqkZNhRfZe+38m0EkTawN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zY4MoPYz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zY4MoPYz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB235C4CED2;
	Mon,  6 Jan 2025 15:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177125;
	bh=QOS+WtMdlYdnGTliJeN3unNo/LekunBVL/yF8BVEEL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zY4MoPYz9hogvThFQKs7xDxNyd7U17I3A7SANEqKVAWjULCMA2DYmS6swxbn+cYt5
	 oKO0eh9wBgO6rkiU+nVcXlBc2JoKEP3bCJTN3mWWj5YqdVUbXla/XXESGMBWLXal4k
	 fD8XThB/C+TFFvlj9UPvGoovOwIvebBo9GsKPdxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 027/222] cleanup: Adjust scoped_guard() macros to avoid potential warning
Date: Mon,  6 Jan 2025 16:13:51 +0100
Message-ID: <20250106151151.629422119@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Przemek Kitszel <przemyslaw.kitszel@intel.com>

[ Upstream commit fcc22ac5baf06dd17193de44b60dbceea6461983 ]

Change scoped_guard() and scoped_cond_guard() macros to make reasoning
about them easier for static analysis tools (smatch, compiler
diagnostics), especially to enable them to tell if the given usage of
scoped_guard() is with a conditional lock class (interruptible-locks,
try-locks) or not (like simple mutex_lock()).

Add compile-time error if scoped_cond_guard() is used for non-conditional
lock class.

Beyond easier tooling and a little shrink reported by bloat-o-meter
this patch enables developer to write code like:

int foo(struct my_drv *adapter)
{
	scoped_guard(spinlock, &adapter->some_spinlock)
		return adapter->spinlock_protected_var;
}

Current scoped_guard() implementation does not support that,
due to compiler complaining:
error: control reaches end of non-void function [-Werror=return-type]

Technical stuff about the change:
scoped_guard() macro uses common idiom of using "for" statement to declare
a scoped variable. Unfortunately, current logic is too hard for compiler
diagnostics to be sure that there is exactly one loop step; fix that.

To make any loop so trivial that there is no above warning, it must not
depend on any non-const variable to tell if there are more steps. There is
no obvious solution for that in C, but one could use the compound
statement expression with "goto" jumping past the "loop", effectively
leaving only the subscope part of the loop semantics.

More impl details:
one more level of macro indirection is now needed to avoid duplicating
label names;
I didn't spot any other place that is using the
"for (...; goto label) if (0) label: break;" idiom, so it's not packed for
reuse beyond scoped_guard() family, what makes actual macros code cleaner.

There was also a need to introduce const true/false variable per lock
class, it is used to aid compiler diagnostics reasoning about "exactly
1 step" loops (note that converting that to function would undo the whole
benefit).

Big thanks to Andy Shevchenko for help on this patch, both internal and
public, ranging from whitespace/formatting, through commit message
clarifications, general improvements, ending with presenting alternative
approaches - all despite not even liking the idea.

Big thanks to Dmitry Torokhov for the idea of compile-time check for
scoped_cond_guard() (to use it only with conditional locsk), and general
improvements for the patch.

Big thanks to David Lechner for idea to cover also scoped_cond_guard().

Signed-off-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Link: https://lkml.kernel.org/r/20241018113823.171256-1-przemyslaw.kitszel@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/cleanup.h | 52 +++++++++++++++++++++++++++++++++--------
 1 file changed, 42 insertions(+), 10 deletions(-)

diff --git a/include/linux/cleanup.h b/include/linux/cleanup.h
index 6d7bfa899df0..f0c6d1d45e67 100644
--- a/include/linux/cleanup.h
+++ b/include/linux/cleanup.h
@@ -113,14 +113,20 @@ static inline class_##_name##_t class_##_name##ext##_constructor(_init_args) \
  *      similar to scoped_guard(), except it does fail when the lock
  *      acquire fails.
  *
+ *      Only for conditional locks.
  */
 
+#define __DEFINE_CLASS_IS_CONDITIONAL(_name, _is_cond)	\
+static __maybe_unused const bool class_##_name##_is_conditional = _is_cond
+
 #define DEFINE_GUARD(_name, _type, _lock, _unlock) \
+	__DEFINE_CLASS_IS_CONDITIONAL(_name, false); \
 	DEFINE_CLASS(_name, _type, if (_T) { _unlock; }, ({ _lock; _T; }), _type _T); \
 	static inline void * class_##_name##_lock_ptr(class_##_name##_t *_T) \
 	{ return *_T; }
 
 #define DEFINE_GUARD_COND(_name, _ext, _condlock) \
+	__DEFINE_CLASS_IS_CONDITIONAL(_name##_ext, true); \
 	EXTEND_CLASS(_name, _ext, \
 		     ({ void *_t = _T; if (_T && !(_condlock)) _t = NULL; _t; }), \
 		     class_##_name##_t _T) \
@@ -131,17 +137,40 @@ static inline class_##_name##_t class_##_name##ext##_constructor(_init_args) \
 	CLASS(_name, __UNIQUE_ID(guard))
 
 #define __guard_ptr(_name) class_##_name##_lock_ptr
+#define __is_cond_ptr(_name) class_##_name##_is_conditional
 
-#define scoped_guard(_name, args...)					\
-	for (CLASS(_name, scope)(args),					\
-	     *done = NULL; __guard_ptr(_name)(&scope) && !done; done = (void *)1)
-
-#define scoped_cond_guard(_name, _fail, args...) \
-	for (CLASS(_name, scope)(args), \
-	     *done = NULL; !done; done = (void *)1) \
-		if (!__guard_ptr(_name)(&scope)) _fail; \
-		else
-
+/*
+ * Helper macro for scoped_guard().
+ *
+ * Note that the "!__is_cond_ptr(_name)" part of the condition ensures that
+ * compiler would be sure that for the unconditional locks the body of the
+ * loop (caller-provided code glued to the else clause) could not be skipped.
+ * It is needed because the other part - "__guard_ptr(_name)(&scope)" - is too
+ * hard to deduce (even if could be proven true for unconditional locks).
+ */
+#define __scoped_guard(_name, _label, args...)				\
+	for (CLASS(_name, scope)(args);					\
+	     __guard_ptr(_name)(&scope) || !__is_cond_ptr(_name);	\
+	     ({ goto _label; }))					\
+		if (0) {						\
+_label:									\
+			break;						\
+		} else
+
+#define scoped_guard(_name, args...)	\
+	__scoped_guard(_name, __UNIQUE_ID(label), args)
+
+#define __scoped_cond_guard(_name, _fail, _label, args...)		\
+	for (CLASS(_name, scope)(args); true; ({ goto _label; }))	\
+		if (!__guard_ptr(_name)(&scope)) {			\
+			BUILD_BUG_ON(!__is_cond_ptr(_name));		\
+			_fail;						\
+_label:									\
+			break;						\
+		} else
+
+#define scoped_cond_guard(_name, _fail, args...)	\
+	__scoped_cond_guard(_name, _fail, __UNIQUE_ID(label), args)
 /*
  * Additional helper macros for generating lock guards with types, either for
  * locks that don't have a native type (eg. RCU, preempt) or those that need a
@@ -197,14 +226,17 @@ static inline class_##_name##_t class_##_name##_constructor(void)	\
 }
 
 #define DEFINE_LOCK_GUARD_1(_name, _type, _lock, _unlock, ...)		\
+__DEFINE_CLASS_IS_CONDITIONAL(_name, false);				\
 __DEFINE_UNLOCK_GUARD(_name, _type, _unlock, __VA_ARGS__)		\
 __DEFINE_LOCK_GUARD_1(_name, _type, _lock)
 
 #define DEFINE_LOCK_GUARD_0(_name, _lock, _unlock, ...)			\
+__DEFINE_CLASS_IS_CONDITIONAL(_name, false);				\
 __DEFINE_UNLOCK_GUARD(_name, void, _unlock, __VA_ARGS__)		\
 __DEFINE_LOCK_GUARD_0(_name, _lock)
 
 #define DEFINE_LOCK_GUARD_1_COND(_name, _ext, _condlock)		\
+	__DEFINE_CLASS_IS_CONDITIONAL(_name##_ext, true);		\
 	EXTEND_CLASS(_name, _ext,					\
 		     ({ class_##_name##_t _t = { .lock = l }, *_T = &_t;\
 		        if (_T->lock && !(_condlock)) _T->lock = NULL;	\
-- 
2.39.5



