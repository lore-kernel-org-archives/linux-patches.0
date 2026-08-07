Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A4EF339387;
	Fri,  7 Aug 2026 15:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116581; cv=none; b=dsyY8jnsl4NEKj3JcWYYlcJSoRzp5kSf7O0rboxs1EjMkFeiz58ABLYEX6483pSZxtbnq4DzwWxfbmot0PSPZeQN8YhsbnfXUfepcKHKAPY0Ew8P8VnsI5s4G8KTgiO7EwDIoAWo98qjYFQtRp2ow5rARf6zphG0frjXpqCDRjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116581; c=relaxed/simple;
	bh=ASDE9N5fAwkubyLMApw/Dpj9rCR8DAf9a1MtwuCRFcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=buBuemfgHkiiQIttcRcbuxDla+IA5kiC+XkY/CA7oqCVR4KodB8NeAdI5bZY6d0tpxy0+BVgIdKDOMsBzgc+NevuEN2TZhaMFTmvq0emfcgJT1rIrCRitcUDkUpQtDzSAjbMc+zzuAdVTHgEeFwZQPSQxmUJo26PrGrDMBK14Hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1dZf+VaK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1dZf+VaK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75F911F000E9;
	Fri,  7 Aug 2026 15:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116580;
	bh=JiztB6PqqzPBVEhYNn7EwTj/r6OAN0yArT5FxbMzt4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1dZf+VaKqS8VFhB5+NmWFVEUCg1/IyzVOU9ZnGGAoIQ45nfyuqnQT8p/6djrJJhWf
	 mS3o+n8oMVSiBtGk4p+/kJFtozrGEwnegHIIpJPq6tnqbNyRPPMXPUxrH/PCltAnur
	 gpSRxpVSC/tA8wt9bRyQ+rRl9Y8m1ULze1QXC7t0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Harry Yoo (Oracle)" <harry@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 003/438] lib/alloc_tag: introduce mem_alloc_profiling_permanently_disabled()
Date: Fri,  7 Aug 2026 16:33:19 +0200
Message-ID: <20260807143428.083763145@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Harry Yoo <harry@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/alloc_tag.h | 3 +++
 lib/alloc_tag.c           | 9 +++++++++
 2 files changed, 12 insertions(+)

diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
index 02de2ede560f..7e7cdc7612be 100644
--- a/include/linux/alloc_tag.h
+++ b/include/linux/alloc_tag.h
@@ -134,6 +134,8 @@ static inline bool mem_alloc_profiling_enabled(void)
 				   &mem_alloc_profiling_key);
 }
 
+bool mem_alloc_profiling_permanently_disabled(void);
+
 static inline struct alloc_tag_counters alloc_tag_read(struct alloc_tag *tag)
 {
 	struct alloc_tag_counters v = { 0, 0 };
@@ -239,6 +241,7 @@ static inline bool alloc_tag_is_inaccurate(struct alloc_tag *tag)
 
 #define DEFINE_ALLOC_TAG(_alloc_tag)
 static inline bool mem_alloc_profiling_enabled(void) { return false; }
+static inline bool mem_alloc_profiling_permanently_disabled(void) { return true; }
 static inline void alloc_tag_add(union codetag_ref *ref, struct alloc_tag *tag,
 				 size_t bytes) {}
 static inline void alloc_tag_sub(union codetag_ref *ref, size_t bytes) {}
diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
index a9ab88f416b9..e3a923594604 100644
--- a/lib/alloc_tag.c
+++ b/lib/alloc_tag.c
@@ -26,6 +26,15 @@ static bool mem_profiling_support = true;
 static bool mem_profiling_support;
 #endif
 
+/*
+ * Memory allocation profiling is permanently disabled and cannot be enabled.
+ * Must be called after setup_early_mem_profiling().
+ */
+bool mem_alloc_profiling_permanently_disabled(void)
+{
+	return !mem_profiling_support;
+}
+
 static struct codetag_type *alloc_tag_cttype;
 
 #ifdef CONFIG_ARCH_MODULE_NEEDS_WEAK_PER_CPU
-- 
2.53.0



