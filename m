Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C56A742D758;
	Fri,  7 Aug 2026 15:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117092; cv=none; b=nSywmvIwvGut93BY4K3ORf3vF4LiWF3/7lJOdC+Gm5ltchkiyprEHpUaz/lWCmjV/zc5cO08qpbCkbeBDA9wKHMe4sKJpmMA/Krdtvcw6gysZK8zz8MM1CWO4oPl/DorpGR7ZJv8v5OeNMeWuUcAW0rVJ6aLfWgYkkSdDiKC+As=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117092; c=relaxed/simple;
	bh=puHc30Jcx8j/lM1exE8jT+w+nt5jDuTV9ERbdCQNYp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YOrX1hqksD7Ufqd8hNyK5OOughcmP1kLxyRzTWPIbNETmfd4MaZfMSndEi8Icd7j7zr+DVC8QGRuOoJVvLFWvylx02K0ldSB3na9nQAEOXGDser78AA7cquhKcgJm8884EyAFBU4nXwJ8ylesiAXpZmxiK5W6qdV4fMrYdUWrlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bs+hKTbe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bs+hKTbe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1692F1F000E9;
	Fri,  7 Aug 2026 15:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117091;
	bh=GtAwcA6F5gFYkZpbUK5nIsr94sH4aOzD5SqOqpk67GU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bs+hKTbeKpOaoVzN6nNQwrPPhxBXJruRbu6xCbeI2E7ldGDGa01qJfzjh4p8tg3uk
	 IClLFS9enLyptH6MyftSg+dBnmZZsfWDR9BJXjkqMov21AnH2QMPOljy0KL/4Hhjys
	 AFaRuwE4aO+LzdETVD4fe5QBDz1NmhEPNiPG9eLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 196/438] ring-buffer: Fix subbuf_ids memory leak in rb_allocate_cpu_buffer() error path
Date: Fri,  7 Aug 2026 16:36:32 +0200
Message-ID: <20260807143432.204402149@linuxfoundation.org>
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

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

[ Upstream commit 260b20d9b78bf002f89088fb62d60e8dee98f6f8 ]

In rb_allocate_cpu_buffer(), cpu_buffer->subbuf_ids is allocated using
kcalloc() when buffer->remote is non-NULL. If a subsequent page allocation
fails (e.g., ring_buffer_desc_page() returns NULL or rb_allocate_pages()
fails), execution jumps to fail_free_reader.

While __free(kfree) automatically frees the outer cpu_buffer structure
at scope exit, kfree(cpu_buffer) does not recursively free nested heap
pointers such as cpu_buffer->subbuf_ids, resulting in a memory leak.

Fix this by explicitly freeing cpu_buffer->subbuf_ids in the
fail_free_reader error unwinding path when cpu_buffer->remote is set.

Link: https://patch.msgid.link/178550740672.380917.6067449683620196150.stgit@devnote2
Fixes: 2e67fabd8b77 ("ring-buffer: Introduce ring-buffer remotes")
Assisted-by: Antigravity:gemini-3.6-flash
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ring_buffer.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index d896fb25de702..d2e2cf18bfdbe 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2489,6 +2489,7 @@ rb_allocate_cpu_buffer(struct trace_buffer *buffer, long nr_pages, int cpu)
 	return_ptr(cpu_buffer);
 
  fail_free_reader:
+	kfree(cpu_buffer->subbuf_ids);
 	free_buffer_page(cpu_buffer->reader_page);
 
 	return NULL;
-- 
2.53.0



