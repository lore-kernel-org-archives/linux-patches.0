Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEEF62DFF03;
	Tue, 17 Jun 2025 16:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176189; cv=none; b=PEv8o01roo+JzWLbR6HUxFxehMIdZNq5s2/opKRDvedUqwXZCDOCbPDt4lyGpJoYcpUqKP32qW8Ghu4maOQa9Xtu+bJm2rLMiHh7hLzwDdZMyMokY0zIoogNivZOkC+P3Pv3xnIhd1wHzRIXY4YDquIQYPcvDBf6GYQCAB0SqP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176189; c=relaxed/simple;
	bh=GtFdO1Zi0adLfrh7//JCQE4+8Mfk60MARHj1z/Ikt00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xf0GHH3FIzj06ALET2toPnGleYUtKPEKNdGd/EikA4plHMrdbLUYN2tcm+uDrWeyUXsXJW24hAH+KDWAI93E3oL5ugLDxW72Qit3lU/B8vBbUgS3pQxSLOM/6Hl24ScAS1okjukSPqcqzAWmYK4nMl24mhCv2NJbMONrycBwOrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H8RaJzH8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H8RaJzH8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D261C4CEE3;
	Tue, 17 Jun 2025 16:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176189;
	bh=GtFdO1Zi0adLfrh7//JCQE4+8Mfk60MARHj1z/Ikt00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H8RaJzH8kh+fd9xBGph0N93DhPu1A+Yr1t1oSV5B1YIpzzpIMQxwVeKqfzmUqTAYl
	 WY5OcYTqC3EWw3X676/zpQiDpUxG+RhMvJ1kt06NELlTBFsZ7XKY3L9j7OnEeOwW4+
	 5FbOhn+Oyo4lRMb54X4uDwHgFysrV6V4E0/gmwKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Llamas <cmllamas@google.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 163/780] libbpf: Fix implicit memfd_create() for bionic
Date: Tue, 17 Jun 2025 17:17:51 +0200
Message-ID: <20250617152458.125460932@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carlos Llamas <cmllamas@google.com>

[ Upstream commit 75011ad69bc54396703867b5434f1622343a848e ]

Since memfd_create() is not consistently available across different
bionic libc implementations, using memfd_create() directly can break
some Android builds:

  tools/lib/bpf/linker.c:576:7: error: implicit declaration of function 'memfd_create' [-Werror,-Wimplicit-function-declaration]
    576 |         fd = memfd_create(filename, 0);
        |              ^

To fix this, relocate and inline the sys_memfd_create() helper so that
it can be used in "linker.c". Similar issues were previously fixed by
commit 9fa5e1a180aa ("libbpf: Call memfd_create() syscall directly").

Fixes: 6d5e5e5d7ce1 ("libbpf: Extend linker API to support in-memory ELF files")
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20250330211325.530677-1-cmllamas@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c          | 9 ---------
 tools/lib/bpf/libbpf_internal.h | 9 +++++++++
 tools/lib/bpf/linker.c          | 2 +-
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 6b85060f07b3b..37d563e140515 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1725,15 +1725,6 @@ static Elf64_Sym *find_elf_var_sym(const struct bpf_object *obj, const char *nam
 	return ERR_PTR(-ENOENT);
 }
 
-/* Some versions of Android don't provide memfd_create() in their libc
- * implementation, so avoid complications and just go straight to Linux
- * syscall.
- */
-static int sys_memfd_create(const char *name, unsigned flags)
-{
-	return syscall(__NR_memfd_create, name, flags);
-}
-
 #ifndef MFD_CLOEXEC
 #define MFD_CLOEXEC 0x0001U
 #endif
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
index 76669c73dcd16..477a3b3389a09 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -667,6 +667,15 @@ static inline int sys_dup3(int oldfd, int newfd, int flags)
 	return syscall(__NR_dup3, oldfd, newfd, flags);
 }
 
+/* Some versions of Android don't provide memfd_create() in their libc
+ * implementation, so avoid complications and just go straight to Linux
+ * syscall.
+ */
+static inline int sys_memfd_create(const char *name, unsigned flags)
+{
+	return syscall(__NR_memfd_create, name, flags);
+}
+
 /* Point *fixed_fd* to the same file that *tmp_fd* points to.
  * Regardless of success, *tmp_fd* is closed.
  * Whatever *fixed_fd* pointed to is closed silently.
diff --git a/tools/lib/bpf/linker.c b/tools/lib/bpf/linker.c
index 800e0ef09c378..56f5068e2ebab 100644
--- a/tools/lib/bpf/linker.c
+++ b/tools/lib/bpf/linker.c
@@ -573,7 +573,7 @@ int bpf_linker__add_buf(struct bpf_linker *linker, void *buf, size_t buf_sz,
 
 	snprintf(filename, sizeof(filename), "mem:%p+%zu", buf, buf_sz);
 
-	fd = memfd_create(filename, 0);
+	fd = sys_memfd_create(filename, 0);
 	if (fd < 0) {
 		ret = -errno;
 		pr_warn("failed to create memfd '%s': %s\n", filename, errstr(ret));
-- 
2.39.5



