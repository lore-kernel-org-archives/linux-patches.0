Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082D31E00B6;
	Wed, 19 Feb 2025 08:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954195; cv=none; b=Br8Z1/i0Jgsh2x58PybvfF1/Y96vnA3tGp9dJShqh6JFyQ5mi0iD5MbWfR5pGwlJvOOS2Fp2o3W8d7fRjjwphI8r+jodaVVIi5iBxfdZ35rFyTEpQ2wIxuilIFjQJp9fqB7UUZDcpKRyUC+gEwW5bEReiigy+eNIDoMTQkaxCl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954195; c=relaxed/simple;
	bh=QLqcfsWe2N91sscldA9HYXdX82Ry6ZAAcC+1Po2Pcvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ns3oaMngceZIBATjpNR8NJpoci+K+EceyP9hWwO+6ySxc6WVWL4mjOjNLLnS4tfJdSSZWCumR8qI7dTcwUIxswIxz2LFXKnbLZ78i6vqzmyBP7q8XqX4sBWIzjFT4h1swdTJzxTDzCZGHvLXM7f1R3LjKOIGW5919RNeP+F7k9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bsIxlSYT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bsIxlSYT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45C31C4CED1;
	Wed, 19 Feb 2025 08:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954194;
	bh=QLqcfsWe2N91sscldA9HYXdX82Ry6ZAAcC+1Po2Pcvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bsIxlSYTos3Orwx7GSEPJsLglcLbCE+sjfek4vQVuPhef2vsGOkeUYIHtRrh3gcVa
	 w1jFyDEX+/mnUKCLZw/tIFG0LSLFXN/xM8q4c3MI/6uf8ao06+2s+5xTQEzttJvadh
	 veq+SkBMpWw+3wxIf/vLiq6OjYisAqlpOtMiN2nw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.13 126/274] ring-buffer: Validate the persistent meta data subbuf array
Date: Wed, 19 Feb 2025 09:26:20 +0100
Message-ID: <20250219082614.544668477@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
 kernel/trace/ring_buffer.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1672,7 +1672,8 @@ static void *rb_range_buffer(struct ring
  * must be the same.
  */
 static bool rb_meta_valid(struct ring_buffer_meta *meta, int cpu,
-			  struct trace_buffer *buffer, int nr_pages)
+			  struct trace_buffer *buffer, int nr_pages,
+			  unsigned long *subbuf_mask)
 {
 	int subbuf_size = PAGE_SIZE;
 	struct buffer_data_page *subbuf;
@@ -1680,6 +1681,9 @@ static bool rb_meta_valid(struct ring_bu
 	unsigned long buffers_end;
 	int i;
 
+	if (!subbuf_mask)
+		return false;
+
 	/* Check the meta magic and meta struct size */
 	if (meta->magic != RING_BUFFER_META_MAGIC ||
 	    meta->struct_size != sizeof(*meta)) {
@@ -1712,6 +1716,8 @@ static bool rb_meta_valid(struct ring_bu
 
 	subbuf = rb_subbufs_from_meta(meta);
 
+	bitmap_clear(subbuf_mask, 0, meta->nr_subbufs);
+
 	/* Is the meta buffers and the subbufs themselves have correct data? */
 	for (i = 0; i < meta->nr_subbufs; i++) {
 		if (meta->buffers[i] < 0 ||
@@ -1725,6 +1731,12 @@ static bool rb_meta_valid(struct ring_bu
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
 
@@ -1889,17 +1901,22 @@ static void rb_meta_init_text_addr(struc
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
@@ -1943,6 +1960,7 @@ static void rb_range_meta_init(struct tr
 			subbuf += meta->subbuf_size;
 		}
 	}
+	bitmap_free(subbuf_mask);
 }
 
 static void *rbm_start(struct seq_file *m, loff_t *pos)


