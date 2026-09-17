Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59E2D4CDDE1;
	Thu, 17 Sep 2026 15:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660008; cv=none; b=aFr2P3MHbLeLac/rVDg6DJRxrfIkRhR/p0YB3iMopjNCWsbJonoK28xbWls9nd05H2Ihs9GkQe5+MtujvoLZoy6rRGqNcghDKNjoyjkGAA71JYaeP/ajNUQmr6JRvyLS36glOilksgoTKKrP/+AibUMKKO8O2Q0sjokbQy8N3ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660008; c=relaxed/simple;
	bh=7E59Jd4cjAzq0VmwBs9IwOu2Hp4Pq4SVq/bVjUIQcLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GpFrZ/Yu2//BQwuE+3g1cytv3GW6PSyAmPSHGRpKiMTjNvUsrOdk5oNijK6POuFluXXtwA7bmTXl1nAlST1C33F/3J8IaHWMRrXmg56oJsDm/hO7uzC/zpF9R78cMeq2P6uuuyg+NDHxhLlKqrKf1yOGT94+pr3Jz7HuC9IkhnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f151Dgw4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f151Dgw4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C2111F000FF;
	Thu, 17 Sep 2026 15:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660003;
	bh=N7dzYvArPn+DYZ3Sq/Qf4+WsDJnGesFL6vYECMFVi+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f151Dgw4+9eJSKwiFYYkCJfetUc16nU6Pbn9LZUJXFyK28Gn+6F8etsZ/O8lyKufb
	 pcA+mQ8sDf0Z2lNUOKTjCRuJmp6lyZO2zlNRqvXYxBua/+eWpljGlnhPJ9ae84fKt9
	 pDJwDj4BrF+cjqU1BsdWCqYgts1vUIl2oNnp1Ew4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Donnefort <vdonnefort@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 445/733] tracing/remotes: Account for ring buffer page header in size calculation
Date: Thu, 17 Sep 2026 16:12:33 +0100
Message-ID: <20260917151402.976096927@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Donnefort <vdonnefort@google.com>

[ Upstream commit 442ffa742daa65a0e8fe003abe9fbe472366e4de ]

trace_buffer_desc_size() and trace_remote_alloc_buffer() undercount the
required pages because every ring buffer page contains a header
(BUF_PAGE_HDR_SIZE). Account for that header to ensure allocated remote
ring buffers aren't smaller than requested by the user.

The newly introduced helper __calc_nr_pages_ring_buffer_desc() can
return a value that overflows the descriptor nr_pages field (32 bits).

Link: https://patch.msgid.link/20260911193937.602202-2-vdonnefort@google.com
Fixes: 2e67fabd8b77 ("ring-buffer: Introduce ring-buffer remotes")
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ring_buffer.h | 15 +++++++++++++--
 kernel/trace/trace_remote.c |  2 +-
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index afc7daa6ee7dc..11bffb6a142d1 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -3,8 +3,9 @@
 #define _LINUX_RING_BUFFER_H
 
 #include <linux/mm.h>
-#include <linux/seq_file.h>
 #include <linux/poll.h>
+#include <linux/ring_buffer_types.h>
+#include <linux/seq_file.h>
 
 #include <uapi/linux/trace_mmap.h>
 
@@ -279,9 +280,19 @@ static inline struct ring_buffer_desc *__first_ring_buffer_desc(struct trace_buf
 	return (struct ring_buffer_desc *)(&desc->__data[0]);
 }
 
+/*
+ * Returns the number of pages for a ring_buffer_desc. The caller must ensure it
+ * does not overflow ring_buffer_desc::nr_page_va.
+ */
+static inline unsigned long __calc_nr_pages_ring_buffer_desc(size_t size)
+{
+	/* Takes into account the reader page */
+	return max(DIV_ROUND_UP(size, PAGE_SIZE - BUF_PAGE_HDR_SIZE), 2UL) + 1;
+}
+
 static inline size_t trace_buffer_desc_size(size_t buffer_size, unsigned int nr_cpus)
 {
-	unsigned int nr_pages = max(DIV_ROUND_UP(buffer_size, PAGE_SIZE), 2UL) + 1;
+	unsigned long nr_pages = __calc_nr_pages_ring_buffer_desc(buffer_size);
 	struct ring_buffer_desc *rbdesc;
 
 	return size_add(offsetof(struct trace_buffer_desc, __data),
diff --git a/kernel/trace/trace_remote.c b/kernel/trace/trace_remote.c
index e6724f947170d..0e8ca62301040 100644
--- a/kernel/trace/trace_remote.c
+++ b/kernel/trace/trace_remote.c
@@ -980,7 +980,7 @@ int trace_remote_alloc_buffer(struct trace_buffer_desc *desc, size_t desc_size,
 			      const struct cpumask *cpumask)
 {
 	size_t min_desc_size = trace_buffer_desc_size(buffer_size, cpumask_weight(cpumask));
-	unsigned int nr_pages = max(DIV_ROUND_UP(buffer_size, PAGE_SIZE), 2UL) + 1;
+	unsigned int nr_pages = __calc_nr_pages_ring_buffer_desc(buffer_size);
 	struct ring_buffer_desc *rb_desc;
 	int cpu, ret = -ENOMEM;
 
-- 
2.53.0



