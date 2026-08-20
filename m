Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D28380FE3;
	Thu, 20 Aug 2026 15:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239154; cv=none; b=BfjdNoPXF9ZJkE+t+OA7RlIF/4f/VX5XdiAi0Xjhb13q7SukpIGih1BLfJc6ctgR8Dn4Ozc1ecvkcDDfM103vm2Rv7XHAwz5Y5/3PI4TKE8Py3Wqq/7Q0qWSTRVKUorVuDffETm3Q8MFQiPws/gE5jElm/4fFsjkFOl7Lncuffg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239154; c=relaxed/simple;
	bh=KBa3qy9ma7meQD1I5Y/UJQfkEI3isc9832yJqosZOlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ISPR6HGbaJJX3Ho7A9wHqNV8XelVga9/gbI6KLzsc9ltnBnURiVajyIwlwpXbofT3z62HdPucfvuW9rod3CmFz/eW3LQJh9xMsFWudSrcTN2kmcZy7fzVVdhrjrE5E53YLRW3yFpjYsG/CpH8+i1aZldHsHOs7G5ed52oVLo5Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LryujYME; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LryujYME"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D01B1F000E9;
	Thu, 20 Aug 2026 15:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239152;
	bh=nFnm9U7Y5blz9BitjgFRNXyALvdARzdAQG0nGwjBAIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LryujYMEaLC1QTOETm7vHIL1Oe9u9l+hHVxN/gVWjg226JFJhWDoI5R+cekocEiXl
	 HnEPZkZcyV0H0+1RFtz9Cg3Rseq30cnOrj3idISaeu9CMjdu7mynxQkNXSXO4MIGBo
	 1iPtzy8QIbdpZ3g2sXs8PYujX6m2navBR+R5r0UQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 161/217] ring-buffer: Store bpage pointers into subbuf_ids
Date: Thu, 20 Aug 2026 16:55:29 +0200
Message-ID: <20260820145242.597876326@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

[ Upstream commit e682207bf7ae3f81885f612ada1ac44d027158d4 ]

The subbuf_ids field allows to point to a specific page from the
ring-buffer based on its ID. As a preparation or the upcoming
ring-buffer remote support, point this array to the buffer_page instead
of the buffer_data_page.

Link: https://patch.msgid.link/20260309162516.2623589-3-vdonnefort@google.com
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Stable-dep-of: 7c727dfce6be ("ring-buffer: Prevent resizing of persistent ring buffer")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -557,7 +557,7 @@ struct ring_buffer_per_cpu {
 	unsigned int			mapped;
 	unsigned int			user_mapped;	/* user space mapping */
 	struct mutex			mapping_lock;
-	unsigned long			*subbuf_ids;	/* ID to subbuf VA */
+	struct buffer_page		**subbuf_ids;	/* ID to subbuf VA */
 	struct trace_buffer_meta	*meta_page;
 	struct ring_buffer_cpu_meta	*ring_meta;
 
@@ -7039,7 +7039,7 @@ static void rb_free_meta_page(struct rin
 }
 
 static void rb_setup_ids_meta_page(struct ring_buffer_per_cpu *cpu_buffer,
-				   unsigned long *subbuf_ids)
+				   struct buffer_page **subbuf_ids)
 {
 	struct trace_buffer_meta *meta = cpu_buffer->meta_page;
 	unsigned int nr_subbufs = cpu_buffer->nr_pages + 1;
@@ -7048,7 +7048,7 @@ static void rb_setup_ids_meta_page(struc
 	int id = 0;
 
 	id = rb_page_id(cpu_buffer, cpu_buffer->reader_page, id);
-	subbuf_ids[id++] = (unsigned long)cpu_buffer->reader_page->page;
+	subbuf_ids[id++] = cpu_buffer->reader_page;
 	cnt++;
 
 	first_subbuf = subbuf = rb_set_head_page(cpu_buffer);
@@ -7058,7 +7058,7 @@ static void rb_setup_ids_meta_page(struc
 		if (WARN_ON(id >= nr_subbufs))
 			break;
 
-		subbuf_ids[id] = (unsigned long)subbuf->page;
+		subbuf_ids[id] = subbuf;
 
 		rb_inc_page(&subbuf);
 		id++;
@@ -7067,7 +7067,7 @@ static void rb_setup_ids_meta_page(struc
 
 	WARN_ON(cnt != nr_subbufs);
 
-	/* install subbuf ID to kern VA translation */
+	/* install subbuf ID to bpage translation */
 	cpu_buffer->subbuf_ids = subbuf_ids;
 
 	meta->meta_struct_len = sizeof(*meta);
@@ -7223,13 +7223,15 @@ static int __rb_map_vma(struct ring_buff
 	}
 
 	while (p < nr_pages) {
+		struct buffer_page *subbuf;
 		struct page *page;
 		int off = 0;
 
 		if (WARN_ON_ONCE(s >= nr_subbufs))
 			return -EINVAL;
 
-		page = virt_to_page((void *)cpu_buffer->subbuf_ids[s]);
+		subbuf = cpu_buffer->subbuf_ids[s];
+		page = virt_to_page((void *)subbuf->page);
 
 		for (; off < (1 << (subbuf_order)); off++, page++) {
 			if (p >= nr_pages)
@@ -7256,7 +7258,8 @@ int ring_buffer_map(struct trace_buffer
 		    struct vm_area_struct *vma)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
-	unsigned long flags, *subbuf_ids;
+	struct buffer_page **subbuf_ids;
+	unsigned long flags;
 	int err;
 
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
@@ -7280,7 +7283,7 @@ int ring_buffer_map(struct trace_buffer
 	if (err)
 		return err;
 
-	/* subbuf_ids include the reader while nr_pages does not */
+	/* subbuf_ids includes the reader while nr_pages does not */
 	subbuf_ids = kcalloc(cpu_buffer->nr_pages + 1, sizeof(*subbuf_ids), GFP_KERNEL);
 	if (!subbuf_ids) {
 		rb_free_meta_page(cpu_buffer);


