Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 081492F0C74;
	Fri,  7 Aug 2026 15:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115666; cv=none; b=uO8caN3+RdQw3qJAqTn7StEnI7Xnsn/KnT5tTD9a5XeDhWWsD21SkexrSV7FvRREYD8c+jeiMgQGWIjX5Q0F7RDeU+jL6UsHf6/gO+tN4SUaxhxsjwms/kbMkJ2uqqh8g0T39+EVat/Fo/XJoCpVfESSv2h2L6+RXzEWM9jEioI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115666; c=relaxed/simple;
	bh=cRGCwfPPrR2vwJ0lg8gujAAWvnW5B68md2M0IUkA7LQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qzevYboT6NvWuAsZmjQA1407T/ToBL6X3+rlepfhUpAeM8RY2LpTei99Mxefvb2rYoH55eAvtyTB4JVZjmBjQxcqgq4QNMw3nWBrJQ3Taf6OGrcBnsul5bAIrBdtNmWzXyThmDUxdi8UlHBzbb1AVivEF3fZBfHTLHtHpnA12jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tW9t6mqH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tW9t6mqH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C91A1F000E9;
	Fri,  7 Aug 2026 15:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115664;
	bh=tEG/rwlqNL8bveDITZBnVux1ohK1oSbm1kUZwYTxoYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tW9t6mqH7hYN7VAqHBUCRIlcJJFg3ufN6clrq8QZaVJHEddDRyzcUYdojgk/JQr/M
	 RoQl0Z8QnX0fRHmiUxnBpr7CAUDVnvpE95QkQmg+qw55Ka4lzhawohzo8iwlAV47m1
	 ggyNdyi4Xo+qplhsXn2xzPbTcBJ33iXWcf81SCow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Wentao Guan <guanwentao@uniontech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 356/396] file: add FD_{ADD,PREPARE}()
Date: Fri,  7 Aug 2026 16:38:36 +0200
Message-ID: <20260807143431.962701214@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 011703a9acd76edc7c85d80dbccb6e50dba53aad ]

I've been playing with this to allow for moderately flexible usage of
the get_unused_fd_flags() + create file + fd_install() pattern that's
used quite extensively.

How callers allocate files is really heterogenous so it's not really
convenient to fold them into a single class. It's possibe to split them
into subclasses like for anon inodes. I think that's not necessarily
nice as well.

My take is to add two primites:
(1) FD_ADD() the simple cases a file is installed:

    fd = FD_ADD(O_CLOEXEC, open_file(some, args)));
    if (fd >= 0)
            kvm_get_kvm(vcpu->kvm);
    return fd;

(2) FD_PREPARE() that captures all the cases where access to fd or file
    or additional work before publishing the fd is needed:

    FD_PREPARE(fdf, open_flag, file_open_handle(&path, open_flag));
    if (fdf.err)
            return fdf.err;

    if (copy_to_user(/* something something */))
            return -EFAULT;

    return fd_publish(fdf);

I've converted all of the easy cases over to it and it gets rid of an
aweful lot of convoluted cleanup logic.

It's centered around struct fd_prepare. FD_PREPARE() encapsulates all of
allocation and cleanup logic and must be followed by a call to
fd_publish() which associates the fd with the file and installs it into
the callers fdtable. If fd_publish() isn't called both are deallocated.

It mandates a specific order namely that first we allocate the fd and
then instantiate the file. But that shouldn't be a problem nearly
everyone I've converted uses this exact pattern anyway.

There's a bunch of additional cases where it would be easy to convert
them to this pattern. For example, the whole sync file stuff in dma
currently retains the containing structure of the file instead of the
file itself even though it's only used to allocate files. Changing that
would make it fall into the FD_PREPARE() pattern easily. I've not done
that work yet.

There's room for extending this in a way that wed'd have subclasses for
some particularly often use patterns but as I said I'm not even sure
that's worth it.

Link: https://patch.msgid.link/20251123-work-fd-prepare-v4-1-b6efa1706cfd@kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
(cherry picked from commit 011703a9acd76edc7c85d80dbccb6e50dba53aad)
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/cleanup.h |   7 +++
 include/linux/file.h    | 126 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 133 insertions(+)

diff --git a/include/linux/cleanup.h b/include/linux/cleanup.h
index a1194e44b5276..bacefa0f1512f 100644
--- a/include/linux/cleanup.h
+++ b/include/linux/cleanup.h
@@ -261,6 +261,10 @@ const volatile void * __must_check_fn(const volatile void *val)
  * CLASS(name, var)(args...):
  *	declare the variable @var as an instance of the named class
  *
+ * CLASS_INIT(name, var, init_expr):
+ *	declare the variable @var as an instance of the named class with
+ *	custom initialization expression.
+ *
  * Ex.
  *
  * DEFINE_CLASS(fdget, struct fd, fdput(_T), fdget(fd), int fd)
@@ -290,6 +294,9 @@ static inline class_##_name##_t class_##_name##ext##_constructor(_init_args) \
 	class_##_name##_t var __cleanup(class_##_name##_destructor) =	\
 		class_##_name##_constructor
 
+#define CLASS_INIT(_name, _var, _init_expr)                             \
+        class_##_name##_t _var __cleanup(class_##_name##_destructor) = (_init_expr)
+
 #define __scoped_class(_name, var, _label, args...)        \
 	for (CLASS(_name, var)(args); ; ({ goto _label; })) \
 		if (0) {                                   \
diff --git a/include/linux/file.h b/include/linux/file.h
index af1768d934a01..cf389fde9bc28 100644
--- a/include/linux/file.h
+++ b/include/linux/file.h
@@ -127,4 +127,130 @@ extern void __fput_sync(struct file *);
 
 extern unsigned int sysctl_nr_open_min, sysctl_nr_open_max;
 
+/*
+ * fd_prepare: Combined fd + file allocation cleanup class.
+ * @err: Error code to indicate if allocation succeeded.
+ * @__fd: Allocated fd (may not be accessed directly)
+ * @__file: Allocated struct file pointer (may not be accessed directly)
+ *
+ * Allocates an fd and a file together. On error paths, automatically cleans
+ * up whichever resource was successfully allocated. Allows flexible file
+ * allocation with different functions per usage.
+ *
+ * Do not use directly.
+ */
+struct fd_prepare {
+	s32 err;
+	s32 __fd; /* do not access directly */
+	struct file *__file; /* do not access directly */
+};
+
+/* Typedef for fd_prepare cleanup guards. */
+typedef struct fd_prepare class_fd_prepare_t;
+
+/*
+ * Accessors for fd_prepare class members.
+ * _Generic() is used for zero-cost type safety.
+ */
+#define fd_prepare_fd(_fdf) \
+	(_Generic((_fdf), struct fd_prepare: (_fdf).__fd))
+
+#define fd_prepare_file(_fdf) \
+	(_Generic((_fdf), struct fd_prepare: (_fdf).__file))
+
+/* Do not use directly. */
+static inline void class_fd_prepare_destructor(const struct fd_prepare *fdf)
+{
+	if (unlikely(fdf->err)) {
+		if (likely(fdf->__fd >= 0))
+			put_unused_fd(fdf->__fd);
+		if (unlikely(!IS_ERR_OR_NULL(fdf->__file)))
+			fput(fdf->__file);
+	}
+}
+
+/* Do not use directly. */
+static inline int class_fd_prepare_lock_err(const struct fd_prepare *fdf)
+{
+	if (unlikely(fdf->err))
+		return fdf->err;
+	if (unlikely(fdf->__fd < 0))
+		return fdf->__fd;
+	if (unlikely(IS_ERR(fdf->__file)))
+		return PTR_ERR(fdf->__file);
+	if (unlikely(!fdf->__file))
+		return -ENOMEM;
+	return 0;
+}
+
+/*
+ * __FD_PREPARE_INIT - Helper to initialize fd_prepare class.
+ * @_fd_flags: flags for get_unused_fd_flags()
+ * @_file_owned: expression that returns struct file *
+ *
+ * Returns a struct fd_prepare with fd, file, and err set.
+ * If fd allocation fails, fd will be negative and err will be set. If
+ * fd succeeds but file_init_expr fails, file will be ERR_PTR and err
+ * will be set. The err field is the single source of truth for error
+ * checking.
+ */
+#define __FD_PREPARE_INIT(_fd_flags, _file_owned)                 \
+	({                                                        \
+		struct fd_prepare fdf = {                         \
+			.__fd = get_unused_fd_flags((_fd_flags)), \
+		};                                                \
+		if (likely(fdf.__fd >= 0))                        \
+			fdf.__file = (_file_owned);               \
+		fdf.err = ACQUIRE_ERR(fd_prepare, &fdf);          \
+		fdf;                                              \
+	})
+
+/*
+ * FD_PREPARE - Macro to declare and initialize an fd_prepare variable.
+ *
+ * Declares and initializes an fd_prepare variable with automatic
+ * cleanup. No separate scope required - cleanup happens when variable
+ * goes out of scope.
+ *
+ * @_fdf: name of struct fd_prepare variable to define
+ * @_fd_flags: flags for get_unused_fd_flags()
+ * @_file_owned: struct file to take ownership of (can be expression)
+ */
+#define FD_PREPARE(_fdf, _fd_flags, _file_owned) \
+	CLASS_INIT(fd_prepare, _fdf, __FD_PREPARE_INIT(_fd_flags, _file_owned))
+
+/*
+ * fd_publish - Publish prepared fd and file to the fd table.
+ * @_fdf: struct fd_prepare variable
+ */
+#define fd_publish(_fdf)                                       \
+	({                                                     \
+		struct fd_prepare *fdp = &(_fdf);              \
+		VFS_WARN_ON_ONCE(fdp->err);                    \
+		VFS_WARN_ON_ONCE(fdp->__fd < 0);               \
+		VFS_WARN_ON_ONCE(IS_ERR_OR_NULL(fdp->__file)); \
+		fd_install(fdp->__fd, fdp->__file);            \
+		fdp->__fd;                                     \
+	})
+
+/* Do not use directly. */
+#define __FD_ADD(_fdf, _fd_flags, _file_owned)            \
+	({                                                \
+		FD_PREPARE(_fdf, _fd_flags, _file_owned); \
+		s32 ret = _fdf.err;                       \
+		if (likely(!ret))                         \
+			ret = fd_publish(_fdf);           \
+		ret;                                      \
+	})
+
+/*
+ * FD_ADD - Allocate and install an fd and file in one step.
+ * @_fd_flags: flags for get_unused_fd_flags()
+ * @_file_owned: struct file to take ownership of
+ *
+ * Returns the allocated fd number, or negative error code on failure.
+ */
+#define FD_ADD(_fd_flags, _file_owned) \
+	__FD_ADD(__UNIQUE_ID(fd_prepare), _fd_flags, _file_owned)
+
 #endif /* __LINUX_FILE_H */
-- 
2.53.0



