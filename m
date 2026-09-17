Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E11584D489B;
	Thu, 17 Sep 2026 15:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659486; cv=none; b=HObWGWjQ6lIkos3raNFXYyjFbX6LA8+DqoTZNzd+IFcO7ahey8YvCbqI15SVD2Zyz2OKR0DOSCXCYuICNmzWJfTn3SGoSjFtvKff3XGYHZMtfCpIXhlau16k/1LvvSxfwLHbgjGwAwX1PXtBGTDICcrc4Jk6/tUX2BJ0sSJv4wE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659486; c=relaxed/simple;
	bh=h0Q9d9ZzdxjPHpaPcsjz7yAA0iv09OMcM/zC3WOkyXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RD2s1SNSZdDkz90QLHKeJpyFqRWXn1yCI5IudiMJs2+0SasbQMszc0fO6Wb53rZ2yFj62GI/lsnU7YMtNe3VuXANyKstm4xhod/68dLkgFDuVzg56AQogOo6NPn8jsboMG8H0bzSq4L8u5O0DFtCL2bx1ucCpxBldrq1vaME4Mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hX5T+cSN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hX5T+cSN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD2981F0089A;
	Thu, 17 Sep 2026 15:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659478;
	bh=xPXB2W4/2/+0xT8hyXOjoboynBSB8xZnwgF+eXptiYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hX5T+cSNnJiAHMLVO3qVobX22/PN8EgpVUfeQo5tFkpvYZgmRz0JpcYB8Oeg4/Nfu
	 H1p/jDZcuJAKX1qRfo0JUpZJrUT8akKUrnauk/gwNXhQWj77jDZNfnL1eQYg+GaOj5
	 Z5bsUEqpkA3FNdheuHyBFqnqnDl4E5+5jcQ4zQ7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Donnefort <vdonnefort@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 270/733] ring-buffer: Cap static ring buffer nr_pages
Date: Thu, 17 Sep 2026 16:09:38 +0100
Message-ID: <20260917151358.072561630@linuxfoundation.org>
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

[ Upstream commit f2b2b645595c82b4e824880f6cb987e077a8da19 ]

Static ring buffers (i.e. persistent, user-mapped and remote) rely on
the bpage::id field. The number of pages for those ring buffers must fit
into that variable. Enforce this limit on ring buffer creation or
user-mapping.

While at it, prevent nr_pages underflow when allocating a persistent
buffer.

Link: https://patch.msgid.link/20260904164450.1345852-4-vdonnefort@google.com
Fixes: be68d63a139b ("ring-buffer: Add ring_buffer_alloc_range()")
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ring_buffer.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 8e4fb3bf309c6..66760542fce10 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -641,6 +641,15 @@ static bool rb_is_static(struct ring_buffer_per_cpu *cpu_buffer)
 	return cpu_buffer->user_mapped || cpu_buffer->remote || cpu_buffer->ring_meta;
 }
 
+static unsigned long rb_static_max_pages(void)
+{
+	/*
+	 * Static ring buffers are using bpage::id and must account for the
+	 * reader page.
+	 */
+	return (1UL << 30) - 1;
+}
+
 struct ring_buffer_iter {
 	struct ring_buffer_per_cpu	*cpu_buffer;
 	unsigned long			head;
@@ -2825,6 +2834,8 @@ static struct trace_buffer *alloc_buffer(unsigned long size, unsigned flags,
 		size = end - buffers_start;
 		size = size / nr_cpu_ids;
 
+		if (size < sizeof(struct ring_buffer_cpu_meta))
+			goto fail_free_buffers;
 		/*
 		 * The number of sub-buffers (nr_pages) is determined by the
 		 * total size allocated minus the meta data size.
@@ -2834,6 +2845,10 @@ static struct trace_buffer *alloc_buffer(unsigned long size, unsigned flags,
 		 */
 		nr_pages = (size - sizeof(struct ring_buffer_cpu_meta)) /
 			(subbuf_size + sizeof(int));
+
+		if (nr_pages > rb_static_max_pages())
+			goto fail_free_buffers;
+
 		/* Need at least two pages plus the reader page */
 		if (nr_pages < 3)
 			goto fail_free_buffers;
@@ -2866,6 +2881,10 @@ static struct trace_buffer *alloc_buffer(unsigned long size, unsigned flags,
 		/* The writer is remote. This ring-buffer is read-only */
 		atomic_inc(&buffer->record_disabled);
 		nr_pages = desc->nr_page_va - 1;
+
+		if (nr_pages > rb_static_max_pages())
+			goto fail_free_buffers;
+
 		if (nr_pages < 2)
 			goto fail_free_buffers;
 	} else {
@@ -7826,6 +7845,9 @@ int ring_buffer_map(struct trace_buffer *buffer, int cpu,
 	/* prevent another thread from changing buffer/sub-buffer sizes */
 	guard(mutex)(&buffer->mutex);
 
+	if (cpu_buffer->nr_pages > rb_static_max_pages())
+		return -E2BIG;
+
 	err = rb_alloc_meta_page(cpu_buffer);
 	if (err)
 		return err;
-- 
2.53.0



