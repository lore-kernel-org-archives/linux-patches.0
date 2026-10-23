Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774529;
	b=Wpni2OE2BZkKeowmjvobHqjAPyQ6AgDL65EYF6b2AJUEkTq/FA0/Nhx7mtml3M0XznhS
	 N8ytw8n2alt/cZAf5g/+SRhzyYEdh9BRmXMTxUKjKE9se1eWK9r1ka+v+ggpS11UnLV4g
	 JIqYCwFgvhkHSD/R4uq1mvDhBcV/4xKyQKUZtta9MkZLk3/dmq/KvEp/QdeVCeWNsy8ju
	 o17pFXzD9lrQsZLEwKM7NbnT2ZJ3I5WGDOG7i66750HJBBtzCtRNgncGc+2XqjrNrJhdL
	 BdjA2NsDT1r2pBuXfWieys8lYKYsSIYF35eXhBaf1pUz5Psh0ho2YwJi9KKlvmysCLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774529;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gVAHWS8CCah+D4qkEBqMKoF3PpVcnEVcKS21DsetOt4=;
	b=QVgUSCVO6byOeq3KIvAwkBZjlCr59zYrgUSCHVAneLCEPaR2sF7i2OV0YbvU+YWGjfpq
	 EokkTfIoV2XjYKwX+BYTkgxmevMchIdLTtr4OmhcfARwwa8pgODlDJ2/NvuKqjuyuT6XA
	 DTprsfcHBT45HTiiYTITRc6OnsoLNHMrXzfwJho8/fVV5YcYxPrpKtsYlpXO8bgKwwcMW
	 x3AgquDokQ+TnT2z55sHwR9LJwNibYrJPF68VLd7fk46LFt5QZHjhIYlakQRqVGGf/kJK
	 zUOTOg8BZhJ8M1+QEgM7fx01QNmJ0qw1eqS2l9aELRRL+XJlKYfkC1k/nm1GqnXeJYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="gktVV/r8";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82069606A31A;
	Fri, 23 Oct 2026 16:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gktVV/r8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D11D31F01825;
	Fri, 23 Oct 2026 16:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774529;
	bh=gVAHWS8CCah+D4qkEBqMKoF3PpVcnEVcKS21DsetOt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gktVV/r8jKF0l7i06ZODx81hZwfH4TP894mF6jfhYVy1Du8o+3yyoU0sRM4+CYcWo
	 W79yYH6t09T79/pWc1u/F+eoMR6g2o2yp8DQP4YSDyUKk+bbh3J+wuIuSprOfKMlUW
	 FK8U/BolwSx46b0QlVARtvk7Zsr1cNCLylUst0Kw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Donnefort <vdonnefort@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 071/242] ring-buffer: Skip si_mem_available() for persistent and remote buffers
Date: Fri, 23 Oct 2026 18:38:33 +0200
Message-ID: <20261023163715.460592293@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Donnefort <vdonnefort@google.com>

[ Upstream commit c9fc60c18b6d42efdea0cd88ca132b2f452157c3 ]

Persistent and remote buffer memory is pre-allocated by the time
__rb_allocate_pages() is called. Skip si_mem_available() to avoid
wrongly failing the allocation under memory pressure.

For the same reason, unset user_thread.

Link: https://patch.msgid.link/20261013102047.1488347-2-vdonnefort@google.com
Fixes: be68d63a139b ("ring-buffer: Add ring_buffer_alloc_range()")
Fixes: 2e67fabd8b77 ("ring-buffer: Introduce ring-buffer remotes")
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ring_buffer.c | 41 +++++++++++++++++++-------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 7c59e8e586196..4c0141d8e0622 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2424,20 +2424,30 @@ static int __rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
 	struct trace_buffer *buffer = cpu_buffer->buffer;
 	struct ring_buffer_cpu_meta *meta = NULL;
 	struct buffer_page *bpage, *tmp;
-	bool user_thread = current->mm != NULL;
 	struct ring_buffer_desc *desc = NULL;
+	bool user_thread = false;
 	long i;
 
-	/*
-	 * Check if the available memory is there first.
-	 * Note, si_mem_available() only gives us a rough estimate of available
-	 * memory. It may not be accurate. But we don't care, we just want
-	 * to prevent doing any allocation when it is obvious that it is
-	 * not going to succeed.
-	 */
-	i = si_mem_available();
-	if (i < nr_pages)
-		return -ENOMEM;
+	if (buffer->range_addr_start) {
+		meta = rb_range_meta(buffer, nr_pages, cpu_buffer->cpu);
+	} else if (buffer->remote) {
+		desc = ring_buffer_desc(buffer->remote->desc, cpu_buffer->cpu);
+		if (!desc || WARN_ON(desc->nr_page_va != (nr_pages + 1)))
+			return -EINVAL;
+	} else {
+		/*
+		 * Check if the available memory is there first.
+		 * Note, si_mem_available() only gives us a rough estimate of available
+		 * memory. It may not be accurate. But we don't care, we just want
+		 * to prevent doing any allocation when it is obvious that it is
+		 * not going to succeed.
+		 */
+		i = si_mem_available();
+		if (i < nr_pages)
+			return -ENOMEM;
+
+		user_thread = current->mm != NULL;
+	}
 
 	/*
 	 * If a user thread allocates too much, and si_mem_available()
@@ -2451,15 +2461,6 @@ static int __rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
 	if (user_thread)
 		set_current_oom_origin();
 
-	if (buffer->range_addr_start)
-		meta = rb_range_meta(buffer, nr_pages, cpu_buffer->cpu);
-
-	if (buffer->remote) {
-		desc = ring_buffer_desc(buffer->remote->desc, cpu_buffer->cpu);
-		if (!desc || WARN_ON(desc->nr_page_va != (nr_pages + 1)))
-			return -EINVAL;
-	}
-
 	for (i = 0; i < nr_pages; i++) {
 
 		bpage = alloc_cpu_page(cpu_buffer->cpu);
-- 
2.53.0



