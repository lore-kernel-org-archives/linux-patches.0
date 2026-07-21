Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D548046D2A4;
	Tue, 21 Jul 2026 17:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653931; cv=none; b=QNaogytxZSWuCvtxBc4yy0b0rGFdgo2CJWLxlYMf6q0iSFGhutNYDhYm48kmKvKg1+kl5YWjZRktlJ1oqfoohS1f/LyjooLISkWpC8j5sZTC7ib9Q0A75pfqnWXQLgs/IDWaeKt6vnmegU6jL+q1937GHuWBgoqHjpBbMHr0wts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653931; c=relaxed/simple;
	bh=iAAvcrGNlLvkFQar4JI0+bIqTG0tOaN10WYODhlG9lk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UehPe2fiiXbyzlw5ZfiESdgm6GMYBp3zhvSuRCTDBKck7W3N++w91Zu94UDk7VWZ0wF3dDVR3bIH46rjliLw1xueSKSbZVJOaOW1K/Vb/yvZZQ/xYXYAvOSW83NOb1/BlIO/PJDvt9EalOAKZIoXonKbdkArsLQjgpPeSz1YFIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rsDEebnL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rsDEebnL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0334F1F000E9;
	Tue, 21 Jul 2026 17:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653930;
	bh=4zip0FylRlhDZ7UUuAem7tJxD/WbOHaVWWv6/VP3xiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rsDEebnL3/0RTuFwAO5Ry+U25swkIQ2s/MtGciN3MVhpaZBNYGzWVjXEum4MKcJV8
	 IRFjkoVRqlDw73LKf5GeAZD49zEq0t7+8DGHExyGZYJEjBTEXEuqzy9mjcdXkXIxpe
	 bxD3YNZ8S2hzR7Yqn5rC9yoAQ0cY1yKgepYT2U14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1512/2077] tracing/remotes: Fix leak in trace_remote_alloc_buffer() error path
Date: Tue, 21 Jul 2026 17:19:45 +0200
Message-ID: <20260721152628.445247994@linuxfoundation.org>
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

[ Upstream commit ec082d0b978b5fb4c11205ccce63587ac94c74e1 ]

If page allocation fails in trace_remote_alloc_buffer(), desc->nr_cpus
is not yet incremented for the current CPU. As a consequence, on error,
half-allocated rb_desc will not be freed in trace_remote_free_buffer().

Increment desc->nr_cpus as soon as the first allocation for the current
CPU has succeeded.

Link: https://patch.msgid.link/20260709160017.1729517-2-vdonnefort@google.com
Fixes: 96e43537af54 ("tracing: Introduce trace remotes")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_remote.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace_remote.c b/kernel/trace/trace_remote.c
index d6c3f94d67cd9f..4895241bf8ff0c 100644
--- a/kernel/trace/trace_remote.c
+++ b/kernel/trace/trace_remote.c
@@ -1006,6 +1006,8 @@ int trace_remote_alloc_buffer(struct trace_buffer_desc *desc, size_t desc_size,
 		if (!rb_desc->meta_va)
 			goto err;
 
+		desc->nr_cpus++;
+
 		for (id = 0; id < nr_pages; id++) {
 			rb_desc->page_va[id] = (unsigned long)__get_free_page(GFP_KERNEL);
 			if (!rb_desc->page_va[id])
@@ -1013,7 +1015,6 @@ int trace_remote_alloc_buffer(struct trace_buffer_desc *desc, size_t desc_size,
 
 			rb_desc->nr_page_va++;
 		}
-		desc->nr_cpus++;
 		desc->struct_len += offsetof(struct ring_buffer_desc, page_va);
 		desc->struct_len += struct_size(rb_desc, page_va, rb_desc->nr_page_va);
 		rb_desc = __next_ring_buffer_desc(rb_desc);
-- 
2.53.0



