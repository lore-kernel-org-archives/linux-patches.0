Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0E74ABBD7;
	Thu, 17 Sep 2026 15:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660014; cv=none; b=DNrYGrUInM8mWmdiEJhbbi4qwvcapycG0dE+gShrJhChIzBaIbkzR4a05hE41aN1+wFzpdjH0gY7EhoJdDicR781fbv8pwMr2RYj/h9yNYXyuN32YQGJqUkcxl/hZvEucQCmecbFlj5QupNisbYQrBgwLnEFmnbWTCP/PvVG3bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660014; c=relaxed/simple;
	bh=UqmAr7XzwtM9nyPohbwmEsENGuedlLqRW9vzCoKUMQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eLqqQoYrrxslrM8u7aRC0N/XY9cRTkbHXPf99SqDrX4wghKwK8oZ4L9k4v/b6eRlo81JUm1azuATqFSBpiXeAXDMijMlTCNpj8avaG1uJofMBzfxo/JKM5GtzYj8R+4I0MDE4Zl3vTZLms/az/fKrHdjgSriko3Cv9wO71Fe9Ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gGUznN32; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gGUznN32"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74C771F00898;
	Thu, 17 Sep 2026 15:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660006;
	bh=OJxw/FlDFvD4XjVCOTLcLtGIOxRhPCgX0eAwqg5BU/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gGUznN32X6Cp9JO3/CVBDzw31tShuYNbyoXhM7nTQQ9y62DpRtdXmidoD+QJYyAT6
	 l2RqCjdBh+inK7JmGLGAAF3THwNJgKypZvCjN/NU/dN5kG2GKAf4IrU2QKRI4sjfDc
	 2bCzTMAQDB+nxFLqnrC+i1K2jpnnUe7tJON83dM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Donnefort <vdonnefort@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 446/733] tracing/remotes: Catch nr_page_va overflow in ring_buffer_desc sizing
Date: Thu, 17 Sep 2026 16:12:34 +0100
Message-ID: <20260917151403.002249625@linuxfoundation.org>
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

[ Upstream commit d059d8bf2c9b5d563d15e7552d73e17d7535013a ]

The number of pages per remote ring buffer is capped by
ring_buffer_desc::nr_page_va (32 bits). A buffer_size large enough to
overflow that field would silently allocate a descriptor smaller than
what was asked for.

Return SIZE_MAX from trace_buffer_desc_size() on nr_page_va overflow.

Link: https://patch.msgid.link/20260911193937.602202-3-vdonnefort@google.com
Fixes: 2e67fabd8b77 ("ring-buffer: Introduce ring-buffer remotes")
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ring_buffer.h | 4 ++++
 kernel/trace/trace_remote.c | 6 +++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index 11bffb6a142d1..eac3e9080c3c0 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -295,6 +295,10 @@ static inline size_t trace_buffer_desc_size(size_t buffer_size, unsigned int nr_
 	unsigned long nr_pages = __calc_nr_pages_ring_buffer_desc(buffer_size);
 	struct ring_buffer_desc *rbdesc;
 
+	/* Capped by ring_buffer_desc::nr_page_va */
+	if (nr_pages > UINT_MAX)
+		return SIZE_MAX;
+
 	return size_add(offsetof(struct trace_buffer_desc, __data),
 			size_mul(nr_cpus, struct_size(rbdesc, page_va, nr_pages)));
 }
diff --git a/kernel/trace/trace_remote.c b/kernel/trace/trace_remote.c
index 0e8ca62301040..c79cd21347a03 100644
--- a/kernel/trace/trace_remote.c
+++ b/kernel/trace/trace_remote.c
@@ -980,9 +980,12 @@ int trace_remote_alloc_buffer(struct trace_buffer_desc *desc, size_t desc_size,
 			      const struct cpumask *cpumask)
 {
 	size_t min_desc_size = trace_buffer_desc_size(buffer_size, cpumask_weight(cpumask));
-	unsigned int nr_pages = __calc_nr_pages_ring_buffer_desc(buffer_size);
 	struct ring_buffer_desc *rb_desc;
 	int cpu, ret = -ENOMEM;
+	unsigned int nr_pages;
+
+	if (min_desc_size == SIZE_MAX)
+		return -E2BIG;
 
 	if (desc_size < min_desc_size)
 		return -EINVAL;
@@ -991,6 +994,7 @@ int trace_remote_alloc_buffer(struct trace_buffer_desc *desc, size_t desc_size,
 	desc->struct_len = min_desc_size;
 
 	rb_desc = __first_ring_buffer_desc(desc);
+	nr_pages = __calc_nr_pages_ring_buffer_desc(buffer_size);
 
 	for_each_cpu(cpu, cpumask) {
 		unsigned int id;
-- 
2.53.0



