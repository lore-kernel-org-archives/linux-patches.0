Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D44353E3DB4;
	Tue, 21 Jul 2026 17:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653936; cv=none; b=lQrigCmNf9BQW3PK7DvHNo1bkIn3+DB2HcSA6/aVyoRWuz2TKD0gDK7X2x/mn4gCwCIsTcdAPuTODWdsD3SnB54W8N3l0taqpAJ4i6UKWUBYSzdUUn610KfiLlVwJ7BgRIL0jWr5ir+6xMMa88nfHiB4pqj7/abwXGhxYPczKCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653936; c=relaxed/simple;
	bh=ztATlJ3tw/HAnLGQovu4NJqhNL0H89YRvLNxyhSEinA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HfcRAffhOTOpzYekx+bc+RZT68Z3qiaGd2tUWVr0ymO1+H8nW5aH6GcFOy6F5kwrR+vTHg8W3rjrAQYnBXGbyZaZMB1dnK5mQ8Uqj4fUBXWO7A7R4vj83ZVjtNo41Pa+KkQQy8eLEJOFLZWuXTG1rnqfxub4PfPrkpE7dBDTfs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e0a8KXhe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e0a8KXhe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45F6A1F000E9;
	Tue, 21 Jul 2026 17:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653935;
	bh=OztLS0rAj7uG6zPgKO79TVf2qUM6PDYP4PIVzgvokY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e0a8KXhe6zQDNwO7M3l9Ao88T9yn+fhIU+UDmbTEkrBzjD04rZAuSmGfAZiV5Uma2
	 AqRW1gt5KuKB5Hc5ggjMbJGKn2YX+Ijj39NjUsQlY8juMyCanS45K2YpXQ1tqGfSS0
	 aTS37ABm/yTw8rntwrvi7r4c3gQIzWW61p9awi1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1513/2077] tracing/remotes: Fix struct_len in trace_remote_alloc_buffer()
Date: Tue, 21 Jul 2026 17:19:46 +0200
Message-ID: <20260721152628.468669105@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Vincent Donnefort <vdonnefort@google.com>

[ Upstream commit d471d4f86e8689ad15309e49da8e5e4e9bb9ce87 ]

Pre-calculate desc->struct_len up-front in trace_remote_alloc_buffer()
with trace_buffer_desc_size() to fix double-counting.

While at it, use the accessor __first_ring_buffer_desc().

Link: https://patch.msgid.link/20260709160017.1729517-3-vdonnefort@google.com
Fixes: 96e43537af54 ("tracing: Introduce trace remotes")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_remote.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/kernel/trace/trace_remote.c b/kernel/trace/trace_remote.c
index 4895241bf8ff0c..6dde6bdcbde702 100644
--- a/kernel/trace/trace_remote.c
+++ b/kernel/trace/trace_remote.c
@@ -979,27 +979,22 @@ EXPORT_SYMBOL_GPL(trace_remote_free_buffer);
 int trace_remote_alloc_buffer(struct trace_buffer_desc *desc, size_t desc_size, size_t buffer_size,
 			      const struct cpumask *cpumask)
 {
+	size_t min_desc_size = trace_buffer_desc_size(buffer_size, cpumask_weight(cpumask));
 	unsigned int nr_pages = max(DIV_ROUND_UP(buffer_size, PAGE_SIZE), 2UL) + 1;
-	void *desc_end = desc + desc_size;
 	struct ring_buffer_desc *rb_desc;
 	int cpu, ret = -ENOMEM;
 
-	if (desc_size < struct_size(desc, __data, 0))
+	if (desc_size < min_desc_size)
 		return -EINVAL;
 
 	desc->nr_cpus = 0;
-	desc->struct_len = struct_size(desc, __data, 0);
+	desc->struct_len = min_desc_size;
 
-	rb_desc = (struct ring_buffer_desc *)&desc->__data[0];
+	rb_desc = __first_ring_buffer_desc(desc);
 
 	for_each_cpu(cpu, cpumask) {
 		unsigned int id;
 
-		if ((void *)rb_desc + struct_size(rb_desc, page_va, nr_pages) > desc_end) {
-			ret = -EINVAL;
-			goto err;
-		}
-
 		rb_desc->cpu = cpu;
 		rb_desc->nr_page_va = 0;
 		rb_desc->meta_va = (unsigned long)__get_free_page(GFP_KERNEL);
@@ -1015,8 +1010,6 @@ int trace_remote_alloc_buffer(struct trace_buffer_desc *desc, size_t desc_size,
 
 			rb_desc->nr_page_va++;
 		}
-		desc->struct_len += offsetof(struct ring_buffer_desc, page_va);
-		desc->struct_len += struct_size(rb_desc, page_va, rb_desc->nr_page_va);
 		rb_desc = __next_ring_buffer_desc(rb_desc);
 	}
 
-- 
2.53.0



