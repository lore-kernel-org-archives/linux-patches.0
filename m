Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D674A37E5E5;
	Thu, 20 Aug 2026 17:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247251; cv=none; b=b9F95iYLCgWq+HuvAOxCcI29RI6vqwKiVsBC/USexhmKYMbKvKJ0gTRHIKevJBJXihYS5h5E6QQo1aoXGB9X+S00VjERXba7aLRwni6Uoisbu2dpUG3gaX1tXCy7Wzr8Gd7SlbZCCwNtQso2R1SfXHEKiCu4ELcEb+qCUfdqOkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247251; c=relaxed/simple;
	bh=R6J44DWP4wv3kNsxxIeBVlXHWHkVwwNWxoDTi2PcwRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WUGWFqnrhMNWlLTV8yNSnY+jRuiy13l4596RNUs4x4mtuwuvne5nC5yO7cmDP6sF54MD91k0QtAFdFV5ygmOM5cLuk6tyrDgo4OzXYCHVZMqYbYFVWJsOzTsU82JgHa3/THF7Q6How4upSd7r/5Zbdv561mwkCPcA6dPjw1QkGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gcr4PszN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gcr4PszN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40F4D1F000E9;
	Thu, 20 Aug 2026 17:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247249;
	bh=8zxs0lA+IdtVzoZw97hy4Jl/+k2yY+YpKq94ZIg1tts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gcr4PszNkjGveVbU02WD5pgrSbE4lKxvQ80K2+NaFbiSIbjQNCJyYq1nWN31BZ6aN
	 QrOdG/Vi3zp/W2TGL0zCaK5Ix1f0WOjJtx0Sw3R0WUpwAfvazYOhA+BTLCVAd5cXJm
	 v68sQsrZ9gxiCLTBK73MkfzAj1Y0c+sWRVMrikOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 184/220] ring-buffer: Make ring_buffer_{un}map() simpler with guard(mutex)
Date: Thu, 20 Aug 2026 16:56:14 +0200
Message-ID: <20260820145229.026410329@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit 60bc720e10eac397b3adae975095df77bc368b88 ]

Convert the taking of the buffer->mutex and the cpu_buffer->mapping_lock
over to guard(mutex) and simplify the ring_buffer_map() and
ring_buffer_unmap() functions.

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Vincent Donnefort <vdonnefort@google.com>
Link: https://lore.kernel.org/20250527122009.267efb72@gandalf.local.home
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Stable-dep-of: 7c727dfce6be ("ring-buffer: Prevent resizing of persistent ring buffer")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |   35 +++++++++++------------------------
 1 file changed, 11 insertions(+), 24 deletions(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -7097,36 +7097,34 @@ int ring_buffer_map(struct trace_buffer
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 	unsigned long flags, *subbuf_ids;
-	int err = 0;
+	int err;
 
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		return -EINVAL;
 
 	cpu_buffer = buffer->buffers[cpu];
 
-	mutex_lock(&cpu_buffer->mapping_lock);
+	guard(mutex)(&cpu_buffer->mapping_lock);
 
 	if (cpu_buffer->user_mapped) {
 		err = __rb_map_vma(cpu_buffer, vma);
 		if (!err)
 			err = __rb_inc_dec_mapped(cpu_buffer, true);
-		mutex_unlock(&cpu_buffer->mapping_lock);
 		return err;
 	}
 
 	/* prevent another thread from changing buffer/sub-buffer sizes */
-	mutex_lock(&buffer->mutex);
+	guard(mutex)(&buffer->mutex);
 
 	err = rb_alloc_meta_page(cpu_buffer);
 	if (err)
-		goto unlock;
+		return err;
 
 	/* subbuf_ids include the reader while nr_pages does not */
 	subbuf_ids = kcalloc(cpu_buffer->nr_pages + 1, sizeof(*subbuf_ids), GFP_KERNEL);
 	if (!subbuf_ids) {
 		rb_free_meta_page(cpu_buffer);
-		err = -ENOMEM;
-		goto unlock;
+		return -ENOMEM;
 	}
 
 	atomic_inc(&cpu_buffer->resize_disabled);
@@ -7154,11 +7152,7 @@ int ring_buffer_map(struct trace_buffer
 		atomic_dec(&cpu_buffer->resize_disabled);
 	}
 
-unlock:
-	mutex_unlock(&buffer->mutex);
-	mutex_unlock(&cpu_buffer->mapping_lock);
-
-	return err;
+	return 0;
 }
 
 /*
@@ -7186,24 +7180,22 @@ int ring_buffer_unmap(struct trace_buffe
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 	unsigned long flags;
-	int err = 0;
 
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		return -EINVAL;
 
 	cpu_buffer = buffer->buffers[cpu];
 
-	mutex_lock(&cpu_buffer->mapping_lock);
+	guard(mutex)(&cpu_buffer->mapping_lock);
 
 	if (!cpu_buffer->user_mapped) {
-		err = -ENODEV;
-		goto out;
+		return -ENODEV;
 	} else if (cpu_buffer->user_mapped > 1) {
 		__rb_inc_dec_mapped(cpu_buffer, false);
-		goto out;
+		return 0;
 	}
 
-	mutex_lock(&buffer->mutex);
+	guard(mutex)(&buffer->mutex);
 	raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
 
 	/* This is the last user space mapping */
@@ -7218,12 +7210,7 @@ int ring_buffer_unmap(struct trace_buffe
 	rb_free_meta_page(cpu_buffer);
 	atomic_dec(&cpu_buffer->resize_disabled);
 
-	mutex_unlock(&buffer->mutex);
-
-out:
-	mutex_unlock(&cpu_buffer->mapping_lock);
-
-	return err;
+	return 0;
 }
 
 int ring_buffer_map_get_reader(struct trace_buffer *buffer, int cpu)


