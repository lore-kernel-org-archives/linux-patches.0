Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075DA1DED4C;
	Wed, 19 Feb 2025 08:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955017; cv=none; b=iA6cd2nGameR0SZBdTU+zWOtzIV9FuBa3s/SUfhb68BljvsQb+76c5yskBO1i8BEnyD4AZhLLxaoIcgt6xMUjwURmCvx0sz5KE47kswBgsuivUFwCSwUE3xIOv1rPtJm3fsdRfvFcqpUDIVh4OH7TyqjPlxF/nk9viksKnPvJPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955017; c=relaxed/simple;
	bh=Z60vFgMH7zc9yqCkQ/0CAKPnoMu0AphOa+ZQvVRMn5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J3wMAl15gs/ywEKtfeMJJdpTNt74GNS3YE7IcM0WzGTImRqIW3C/RAu0iBlbrJwEnOKHOvb0n+ubaKEtECk4SFCJehRzsxlLbA37UFcYPdHVnZgSm3ec2b1FpDmP216V8Bzt4SNNZBnXuIZ5wCT0UYcGc0eladIEFSNNXQhE33g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UwBCzwTs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UwBCzwTs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C0FFC4CED1;
	Wed, 19 Feb 2025 08:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955016;
	bh=Z60vFgMH7zc9yqCkQ/0CAKPnoMu0AphOa+ZQvVRMn5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UwBCzwTssQRreKbyhYj6gJzF6mHDSMm/mfZ/hDEmQ0ORD0zsKmHfn+NSuOCzyyG9l
	 8gl89y8gOxB+nqyxThjAHRJylt6Jw64UUKUTcpfOvT2nrLLvjx3iFGw+9VPkuevJaX
	 SIe9W21o7IXE5dM2jh6OLkc+thY+W5bP8tW4L77g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.12 107/230] ring-buffer: Validate the persistent meta data subbuf array
Date: Wed, 19 Feb 2025 09:27:04 +0100
Message-ID: <20250219082605.878104148@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
User-Agent: quilt/0.68
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

commit f5b95f1fa2ef3a03f49eeec658ba97e721412b32 upstream.

The meta data for a mapped ring buffer contains an array of indexes of all
the subbuffers. The first entry is the reader page, and the rest of the
entries lay out the order of the subbuffers in how the ring buffer link
list is to be created.

The validator currently makes sure that all the entries are within the
range of 0 and nr_subbufs. But it does not check if there are any
duplicates.

While working on the ring buffer, I corrupted this array, where I added
duplicates. The validator did not catch it and created the ring buffer
link list on top of it. Luckily, the corruption was only that the reader
page was also in the writer path and only presented corrupted data but did
not crash the kernel. But if there were duplicates in the writer side,
then it could corrupt the ring buffer link list and cause a crash.

Create a bitmask array with the size of the number of subbuffers. Then
clear it. When walking through the subbuf array checking to see if the
entries are within the range, test if its bit is already set in the
subbuf_mask. If it is, then there is duplicates and fail the validation.
If not, set the corresponding bit and continue.

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Vincent Donnefort <vdonnefort@google.com>
Link: https://lore.kernel.org/20250214102820.7509ddea@gandalf.local.home
Fixes: c76883f18e59b ("ring-buffer: Add test if range of boot buffer is valid")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 07b421115692..0419d41a2060 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1672,7 +1672,8 @@ static void *rb_range_buffer(struct ring_buffer_per_cpu *cpu_buffer, int idx)
  * must be the same.
  */
 static bool rb_meta_valid(struct ring_buffer_meta *meta, int cpu,
-			  struct trace_buffer *buffer, int nr_pages)
+			  struct trace_buffer *buffer, int nr_pages,
+			  unsigned long *subbuf_mask)
 {
 	int subbuf_size = PAGE_SIZE;
 	struct buffer_data_page *subbuf;
@@ -1680,6 +1681,9 @@ static bool rb_meta_valid(struct ring_buffer_meta *meta, int cpu,
 	unsigned long buffers_end;
 	int i;
 
+	if (!subbuf_mask)
+		return false;
+
 	/* Check the meta magic and meta struct size */
 	if (meta->magic != RING_BUFFER_META_MAGIC ||
 	    meta->struct_size != sizeof(*meta)) {
@@ -1712,6 +1716,8 @@ static bool rb_meta_valid(struct ring_buffer_meta *meta, int cpu,
 
 	subbuf = rb_subbufs_from_meta(meta);
 
+	bitmap_clear(subbuf_mask, 0, meta->nr_subbufs);
+
 	/* Is the meta buffers and the subbufs themselves have correct data? */
 	for (i = 0; i < meta->nr_subbufs; i++) {
 		if (meta->buffers[i] < 0 ||
@@ -1725,6 +1731,12 @@ static bool rb_meta_valid(struct ring_buffer_meta *meta, int cpu,
 			return false;
 		}
 
+		if (test_bit(meta->buffers[i], subbuf_mask)) {
+			pr_info("Ring buffer boot meta [%d] array has duplicates\n", cpu);
+			return false;
+		}
+
+		set_bit(meta->buffers[i], subbuf_mask);
 		subbuf = (void *)subbuf + subbuf_size;
 	}
 
@@ -1889,17 +1901,22 @@ static void rb_meta_init_text_addr(struct ring_buffer_meta *meta)
 static void rb_range_meta_init(struct trace_buffer *buffer, int nr_pages)
 {
 	struct ring_buffer_meta *meta;
+	unsigned long *subbuf_mask;
 	unsigned long delta;
 	void *subbuf;
 	int cpu;
 	int i;
 
+	/* Create a mask to test the subbuf array */
+	subbuf_mask = bitmap_alloc(nr_pages + 1, GFP_KERNEL);
+	/* If subbuf_mask fails to allocate, then rb_meta_valid() will return false */
+
 	for (cpu = 0; cpu < nr_cpu_ids; cpu++) {
 		void *next_meta;
 
 		meta = rb_range_meta(buffer, nr_pages, cpu);
 
-		if (rb_meta_valid(meta, cpu, buffer, nr_pages)) {
+		if (rb_meta_valid(meta, cpu, buffer, nr_pages, subbuf_mask)) {
 			/* Make the mappings match the current address */
 			subbuf = rb_subbufs_from_meta(meta);
 			delta = (unsigned long)subbuf - meta->first_buffer;
@@ -1943,6 +1960,7 @@ static void rb_range_meta_init(struct trace_buffer *buffer, int nr_pages)
 			subbuf += meta->subbuf_size;
 		}
 	}
+	bitmap_free(subbuf_mask);
 }
 
 static void *rbm_start(struct seq_file *m, loff_t *pos)
-- 
2.48.1



