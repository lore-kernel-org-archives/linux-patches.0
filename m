Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354BD51FCA3;
	Wed, 30 Sep 2026 17:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789685; cv=none; b=eahV0pcRO8Oh3csKV7gSUTVJaV3i86QUU43hcPPJjh/ZaDqoGAOCXwqlTWxC1etrupr3EGpMhAziFVPE6nvw5tUGj0Pj2je+AzuouwCTvRru5LUz76O3lE1egAOBce5+ZRuRgIs54+eKQtwmFFQAmQpxvpD6fROuxEBcLp+qnFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789685; c=relaxed/simple;
	bh=2VBDBCB7Xvi9He+ER+1dBU085CzIlTwv47ef0QMqXKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bOqlcfhuhv99It8NZ6rVAL+yczPg3fMRC6eEJPmGbDnAz+XFZBnVio8aR0KE0n1H7bdTLUsmjtw9hrqsAk59dhAPuoRbJ2O11HxCEek/jD5vtnaVC7MVQdmtmH79xvFgRijMI8yA1ru4kqyI0oWG3Lap5eTGS9MrH3AnlZ+lF68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tZ/vvl1Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tZ/vvl1Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C4281F000FF;
	Wed, 30 Sep 2026 17:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789684;
	bh=/Radd82tW+JsfFDEbi+2+Be1NXh2TjW3z+AL2uDGIGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tZ/vvl1Y8a8QJRk7m8kpaPDDjJy32NyRILrj9pCtDlOQliBLJPjmOKW4xIFaAuCZz
	 HocUyUPlz3DyPnyt5wo7pX+F8cFUghPiBcodj2Qn3Ue3fB2aaySrXKzNCCRaI5Q0r3
	 sG3YLwFIXKhdlod/BigHZaTZMuxQ90lFn8HaFj4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Donnefort <vdonnefort@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 564/877] ring-buffer: Make cpu_buffer::free_page a buffer_data_read_page
Date: Wed, 30 Sep 2026 17:24:35 +0200
Message-ID: <20260930152426.813818140@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Donnefort <vdonnefort@google.com>

[ Upstream commit 7a1fb95de5404134f8758c1295ce88986bdf117c ]

Discarding a cached reader page after a concurrent ring buffer resize
uses the new global subbuf_order for the free_pages() call. This
mismatched order may crashes the kernel or leaks memory because the cached
page was allocated under the old size.

Save the actual free_page order alongside the page address to ensure we
always refer to the correct value and do not rely on the potentially
stalled cpu_buffer->subbuf_order value. The simplest is to make
free_page a buffer_data_read_page which already covers exactly what we
need: a page address and a page order.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260813131152.3589632-4-vdonnefort@google.com
Fixes: 8e7b58c27b3c ("ring-buffer: Just update the subbuffers when changing their allocation order")
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
[ Changed upstream’s dpage variable to bpage in ring_buffer_free_read_page(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -507,7 +507,7 @@ struct ring_buffer_per_cpu {
 	raw_spinlock_t			reader_lock;	/* serialize readers */
 	arch_spinlock_t			lock;
 	struct lock_class_key		lock_key;
-	struct buffer_data_page		*free_page;
+	struct buffer_data_read_page	free_page;
 	unsigned long			nr_pages;
 	unsigned int			current_context;
 	struct list_head		*pages;
@@ -2376,7 +2376,7 @@ static void rb_free_cpu_buffer(struct ri
 		free_buffer_page(bpage);
 	}
 
-	free_pages((unsigned long)cpu_buffer->free_page, cpu_buffer->buffer->subbuf_order);
+	free_pages((unsigned long)cpu_buffer->free_page.data, cpu_buffer->free_page.order);
 
 	kfree(cpu_buffer);
 }
@@ -6422,9 +6422,9 @@ ring_buffer_alloc_read_page(struct trace
 	local_irq_save(flags);
 	arch_spin_lock(&cpu_buffer->lock);
 
-	if (cpu_buffer->free_page) {
-		bpage->data = cpu_buffer->free_page;
-		cpu_buffer->free_page = NULL;
+	if (cpu_buffer->free_page.data) {
+		*bpage = cpu_buffer->free_page;
+		cpu_buffer->free_page.data = NULL;
 	}
 
 	arch_spin_unlock(&cpu_buffer->lock);
@@ -6476,8 +6476,8 @@ void ring_buffer_free_read_page(struct t
 	local_irq_save(flags);
 	arch_spin_lock(&cpu_buffer->lock);
 
-	if (!cpu_buffer->free_page) {
-		cpu_buffer->free_page = bpage;
+	if (!cpu_buffer->free_page.data) {
+		cpu_buffer->free_page = *data_page;
 		bpage = NULL;
 	}
 
@@ -6838,7 +6838,7 @@ int ring_buffer_subbuf_order_set(struct
 	}
 
 	for_each_buffer_cpu(buffer, cpu) {
-		struct buffer_data_page *old_free_data_page;
+		struct buffer_data_read_page old_free_data_page;
 		struct list_head old_pages;
 		unsigned long flags;
 
@@ -6881,7 +6881,7 @@ int ring_buffer_subbuf_order_set(struct
 
 		arch_spin_lock(&cpu_buffer->lock);
 		old_free_data_page = cpu_buffer->free_page;
-		cpu_buffer->free_page = NULL;
+		cpu_buffer->free_page.data = NULL;
 		arch_spin_unlock(&cpu_buffer->lock);
 
 		rb_head_page_activate(cpu_buffer);
@@ -6893,7 +6893,7 @@ int ring_buffer_subbuf_order_set(struct
 			list_del_init(&bpage->list);
 			free_buffer_page(bpage);
 		}
-		free_pages((unsigned long)old_free_data_page, old_order);
+		free_pages((unsigned long)old_free_data_page.data, old_free_data_page.order);
 
 		rb_check_pages(cpu_buffer);
 	}


