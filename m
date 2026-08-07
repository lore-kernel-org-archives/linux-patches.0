Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84BC4340280;
	Fri,  7 Aug 2026 14:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114516; cv=none; b=hZqZZZmxHaJsr5XyqwaaTExT0v4r6+7CeLDbW030NUnF88v5B9rzfuTJ/dYAQoOPtGS8MHFdSrrnwrbxiEo2VRc7Z3PqHllA1oQrCTRipSpP497HIt66cLhVyFRdAoMq8x+F+Eb6KzSvOwVWUUWM92QrYFMjSET0oXK2317w1Ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114516; c=relaxed/simple;
	bh=Nqr71HAcDSKXqp45wpHUtaAtAdRyb/4qODKzFqT7PM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qGxbLSL/jbX0waeJqFL3xfZiRZ2Zzroa1nejRO0YNIxMXlpiZ3lauqOmRKxMTGJlaQYrxImDsN39sTTwo4RpFqiLTHAiXKe+eq/bA+DqX5HKG6VZQXF7S5OeofNDva6+2TbjgUhEm50nY8eSIOb4/O4wBqpKPMyUWD2SjVQEpnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=suqQrTNQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="suqQrTNQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFFE91F00A3A;
	Fri,  7 Aug 2026 14:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114507;
	bh=PSv9nYPMYNCwu1leWmSyv7it/XiePE3TT3pYaX77NAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=suqQrTNQ6SyQ+iyNKyL+ypcXocPfh37PifOQ28eKw0QQuR7XA0BXV/gUOziEv0EiC
	 tYgNvvjHQC3lWvbfiZ2DJ4whFTRFUEzW55uy3iIpPeKjdscICBDLiE0js9yp8tRxEf
	 se6Sj3QsyOaJeHANWeKbx1MB5wz7FEK7CPjrgXsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Harry Yoo (Oracle)" <harry@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 288/337] lib/alloc_tag: introduce mem_alloc_profiling_permanently_disabled()
Date: Fri,  7 Aug 2026 16:38:11 +0200
Message-ID: <20260807143424.777059354@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harry Yoo (Oracle) <harry@kernel.org>

commit a37b0066a10aabf3c968b4566706fb866eaf9a85 upstream.

mem_alloc_profiling_enabled() tells whether memalloc profiling is
currently enabled. However, even when this function returns false,
it can be enabled later.

However, this is not enough. Some optimizations can be applied only when
memalloc profiling is permanently disabled. For example, to skip the
creation of KMALLOC_NO_OBJ_EXT caches at boot time, mem_profiling must
be set to "never", "0" w/ debugging on, or have been shutdown so that
it can no longer be enabled.

Introduce mem_alloc_profiling_permanently_disabled() for this purpose.

Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Link: https://patch.msgid.link/20260713-kmalloc-no-objext-v3-3-47c7bd138de7@kernel.org
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
[ harry@kernel.org: Move the definition of
  mem_alloc_profiling_permanently_disabled() after
  mem_profiling_support.

  Unlike 6.18 and later kernels, mem_profiling_support is marked
  __init and gets freed after boot. Since the function is needed
  only when creating kmalloc caches, mark it __init as well. ]
Signed-off-by: Harry Yoo <harry@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/alloc_tag.h | 3 +++
 lib/alloc_tag.c           | 9 +++++++++
 2 files changed, 12 insertions(+)

diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
index 6073a8f13c413..70025f8e24990 100644
--- a/include/linux/alloc_tag.h
+++ b/include/linux/alloc_tag.h
@@ -105,6 +105,8 @@ static inline bool mem_alloc_profiling_enabled(void)
 				   &mem_alloc_profiling_key);
 }
 
+bool __init mem_alloc_profiling_permanently_disabled(void);
+
 static inline struct alloc_tag_counters alloc_tag_read(struct alloc_tag *tag)
 {
 	struct alloc_tag_counters v = { 0, 0 };
@@ -198,6 +200,7 @@ static inline void alloc_tag_sub(union codetag_ref *ref, size_t bytes)
 
 #define DEFINE_ALLOC_TAG(_alloc_tag)
 static inline bool mem_alloc_profiling_enabled(void) { return false; }
+static inline bool mem_alloc_profiling_permanently_disabled(void) { return true; }
 static inline void alloc_tag_add(union codetag_ref *ref, struct alloc_tag *tag,
 				 size_t bytes) {}
 static inline void alloc_tag_sub(union codetag_ref *ref, size_t bytes) {}
diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
index e76c40bf29d06..a0d11582029ef 100644
--- a/lib/alloc_tag.c
+++ b/lib/alloc_tag.c
@@ -183,6 +183,15 @@ static bool mem_profiling_support __meminitdata = true;
 static bool mem_profiling_support __meminitdata;
 #endif
 
+/*
+ * Memory allocation profiling is permanently disabled and cannot be enabled.
+ * Must be called after setup_early_mem_profiling().
+ */
+bool __init mem_alloc_profiling_permanently_disabled(void)
+{
+	return !mem_profiling_support;
+}
+
 static int __init setup_early_mem_profiling(char *str)
 {
 	bool enable;
-- 
2.53.0



