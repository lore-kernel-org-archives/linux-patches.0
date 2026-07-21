Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C83B269D18;
	Tue, 21 Jul 2026 18:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659178; cv=none; b=oh8LdaLPKc0etX4oZkCtBt5X6VKOX3Hm/e/czC6Zx9qhCRcBI702KjfSY7p9PgEukvECzIu6Uz877UP/QbR5/pQX9mBBHRA+4YOsGdkTPAQmhdP/jRSpR1rOUk9trQ3IIDrNejcxhVQb2wnatPkokHSMKubbmYs5qTOXfI6XnUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659178; c=relaxed/simple;
	bh=awwtx+c8Qiqits60chngBcC3FFn8AE1UiwKpagytZFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pLyF+G82GSMTr51vusDnNqEFjyNNcI8O7hqmcocVE+++7KFdyXQASTeOhiJZgkFitkz2Q/001FYW/f1wDKHu0mdKuOHG7GVIlrIwaXt6E5v8F1qkOw8FGKPSZMWst0CSdy7WfJ/RE0JBWr7XCVBLAigC1lYNCmoQj/q9abiW9gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D4tvb/1g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D4tvb/1g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81B2F1F000E9;
	Tue, 21 Jul 2026 18:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659176;
	bh=F3n2qD2lL868yQjDris9DVqtCi/QgtD5Eoy+uKqB5g4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D4tvb/1g/BJsG2bKGt6JYjVUZjTwe/HdZUw55d7gTqkbnGQHHDTQ4pk61aKr23txg
	 WUV6h6o3oXGj2AuEV9MYZQ6v0tYGeqeVGTdYtmeFMECNYNo4fQhbaBmvDvCR482He7
	 zf9/392sm5Os+6xDxOE824rJ7d5NsN7jtyfhEEqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>
Subject: [PATCH 6.18 1421/1611] selftests/bpf: Add simple strscpy() implementation
Date: Tue, 21 Jul 2026 17:25:37 +0200
Message-ID: <20260721152547.399562203@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Ihor Solodrai <ihor.solodrai@linux.dev>

commit 63c49efc987afefc6b9bb7de083eb8748e0b1789 upstream.

Replace bpf_strlcpy() in bpf_util.h with a sized_strscpy(), which is a
simplified sized_strscpy() from the kernel (lib/string.c [1]). It:
  * takes a count (destination size) parameter
  * guarantees NULL-termination
  * returns the number of characters copied or -E2BIG

Re-define strscpy macro similar to in-kernel implementation [2]: allow
the count parameter to be optional.

Add #ifdef-s to tools/include/linux/args.h, as they may be defined in
other system headers (for example, __CONCAT in sys/cdefs.h).

Fixup the single existing bpf_strlcpy() call in cgroup_helpers.c

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/lib/string.c?h=v6.19#n113
[2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/include/linux/string.h?h=v6.19#n91

Signed-off-by: Ihor Solodrai <ihor.solodrai@linux.dev>
Link: https://lore.kernel.org/r/20260223190736.649171-2-ihor.solodrai@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Cc: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/include/linux/args.h                   |    4 ++
 tools/testing/selftests/bpf/bpf_util.h       |   45 +++++++++++++++++++--------
 tools/testing/selftests/bpf/cgroup_helpers.c |    2 -
 3 files changed, 37 insertions(+), 14 deletions(-)

--- a/tools/include/linux/args.h
+++ b/tools/include/linux/args.h
@@ -22,7 +22,11 @@
 #define COUNT_ARGS(X...) __COUNT_ARGS(, ##X, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0)
 
 /* Concatenate two parameters, but allow them to be expanded beforehand. */
+#ifndef __CONCAT
 #define __CONCAT(a, b) a ## b
+#endif
+#ifndef CONCATENATE
 #define CONCATENATE(a, b) __CONCAT(a, b)
+#endif
 
 #endif	/* _LINUX_ARGS_H */
--- a/tools/testing/selftests/bpf/bpf_util.h
+++ b/tools/testing/selftests/bpf/bpf_util.h
@@ -8,6 +8,7 @@
 #include <errno.h>
 #include <syscall.h>
 #include <bpf/libbpf.h> /* libbpf_num_possible_cpus */
+#include <linux/args.h>
 
 static inline unsigned int bpf_num_possible_cpus(void)
 {
@@ -21,25 +22,43 @@ static inline unsigned int bpf_num_possi
 	return possible_cpus;
 }
 
-/* Copy up to sz - 1 bytes from zero-terminated src string and ensure that dst
- * is zero-terminated string no matter what (unless sz == 0, in which case
- * it's a no-op). It's conceptually close to FreeBSD's strlcpy(), but differs
- * in what is returned. Given this is internal helper, it's trivial to extend
- * this, when necessary. Use this instead of strncpy inside libbpf source code.
+/*
+ * Simplified strscpy() implementation. The kernel one is in lib/string.c
  */
-static inline void bpf_strlcpy(char *dst, const char *src, size_t sz)
+static inline ssize_t sized_strscpy(char *dest, const char *src, size_t count)
 {
-	size_t i;
+	long res = 0;
 
-	if (sz == 0)
-		return;
+	if (count == 0)
+		return -E2BIG;
 
-	sz--;
-	for (i = 0; i < sz && src[i]; i++)
-		dst[i] = src[i];
-	dst[i] = '\0';
+	while (count > 1) {
+		char c;
+
+		c = src[res];
+		dest[res] = c;
+		if (!c)
+			return res;
+		res++;
+		count--;
+	}
+
+	/* Force NUL-termination. */
+	dest[res] = '\0';
+
+	/* Return E2BIG if the source didn't stop */
+	return src[res] ? -E2BIG : res;
 }
 
+#define __strscpy0(dst, src, ...)	\
+	sized_strscpy(dst, src, sizeof(dst))
+#define __strscpy1(dst, src, size)	\
+	sized_strscpy(dst, src, size)
+
+#undef strscpy /* Redefine the placeholder from tools/include/linux/string.h */
+#define strscpy(dst, src, ...)	\
+	CONCATENATE(__strscpy, COUNT_ARGS(__VA_ARGS__))(dst, src, __VA_ARGS__)
+
 #define __bpf_percpu_val_align	__attribute__((__aligned__(8)))
 
 #define BPF_DECLARE_PERCPU(type, name)				\
--- a/tools/testing/selftests/bpf/cgroup_helpers.c
+++ b/tools/testing/selftests/bpf/cgroup_helpers.c
@@ -86,7 +86,7 @@ static int __enable_controllers(const ch
 		enable[len] = 0;
 		close(fd);
 	} else {
-		bpf_strlcpy(enable, controllers, sizeof(enable));
+		strscpy(enable, controllers);
 	}
 
 	snprintf(path, sizeof(path), "%s/cgroup.subtree_control", cgroup_path);


