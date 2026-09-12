Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15C5CA6F;
	Sat, 12 Sep 2026 11:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211450; cv=none; b=OIx92op6aEXr9u/22DNpRYYwMUfCCssIxl9F9U1BEiTN90Q5U7ZXMve0QE/7VuU+VJmfzxUHPKQ1eT9vsA2HHByIRPnqmWmzbomNxAEfnBODgtclXn2rnhL9PMJBCTNka8gmjFJU1ptZ2NJzEYSDrTpA1jizev9jgGrK2rXEdR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211450; c=relaxed/simple;
	bh=9iCD2WO8SXMozL9fMt3J2RQZ7Nnit+uaaDs8sFg+Cyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DoO2C1iOVDDUU0z3GeqhcBIzVJjn9u4tL/Wn6llvR1lSX8J+oK+qIehPpYN+wf8ze4iWt2Y3oDTqruZG0z7AKhSWvwaKagbQAMTs2VPmj7AhIGD499TTCktEfpMDXCVlxHfhGHMVVf9l79zl9zU18cagDfWUpvPyAjUov+Ttvuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GsHOkL7O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GsHOkL7O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8CC31F000FF;
	Sat, 12 Sep 2026 11:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211448;
	bh=c7QdywQSKONHFwXY2eQZ0PCx+XcaW8I+1OhxYka2sLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GsHOkL7OWXlE0/e/AJGMwLSDVjNFeUX+Et0pXZdJR79WbI58DKT8nssfA5Xk41w6q
	 gCAlU63Nh+V5fixSk0vnaaaxeD3ub8n5ttV8E8mFJUwi1ypzdSG/pCSak6U6FGuwhQ
	 ELl+pLpHkhT76gMQp3h3ceFoYXePic11roZE42yM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Donnefort <vdonnefort@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1196/1518] ring-buffer: Remove trace_buffer::cpus
Date: Sat, 12 Sep 2026 08:56:05 +0200
Message-ID: <20260912065650.536536643@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Vincent Donnefort <vdonnefort@google.com>

[ Upstream commit d9b5e22bf24d5c82522475306cd332b287ac43bc ]

The 'cpus' field in struct trace_buffer became useless in commit
8e7b58c27b3c ("ring-buffer: Just update the subbuffers when changing their
allocation order"). Remove it

Link: https://patch.msgid.link/20260813131152.3589632-9-vdonnefort@google.com
Fixes: 8e7b58c27b3c ("ring-buffer: Just update the subbuffers when changing their allocation order")
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ring_buffer.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 15d1bc4fad71a..73018638934a1 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -583,7 +583,6 @@ struct ring_buffer_per_cpu {
 
 struct trace_buffer {
 	unsigned			flags;
-	int				cpus;
 	atomic_t			record_disabled;
 	atomic_t			resizing;
 	cpumask_var_t			cpumask;
@@ -2564,7 +2563,6 @@ static struct trace_buffer *alloc_buffer(unsigned long size, unsigned flags,
 	init_irq_work(&buffer->irq_work.work, rb_wake_up_waiters);
 	init_waitqueue_head(&buffer->irq_work.waiters);
 
-	buffer->cpus = nr_cpu_ids;
 
 	bsize = sizeof(void *) * nr_cpu_ids;
 	buffer->buffers = kzalloc(ALIGN(bsize, cache_line_size()),
-- 
2.53.0



