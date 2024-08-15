Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A46F01A2C0F;
	Thu, 15 Aug 2024 13:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728910; cv=none; b=b1I0b8wSmeE3aU6QE4pS1nKICjEIA9g4tOdhIuchADEQ25JOz2O2kNMafIeeVkCL9nZE5QqOSJ/AFzSHCorCpOJyC+hmqFlW+hSnWR5evJtSQa8uPSbiXXLXmDJbOdCf3+KIdEsHXymSI0Yl/ruLTif6ZKiSyH96j80e1hNJH+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728910; c=relaxed/simple;
	bh=sEEaGKCmtcPGPT56LVbWeQmkFnGdgcvgmznqwTV6dpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YUfNrYxRhiOeBKs0b5TLiyckfqicwGdiTOWqc4L3hVZJlA1gBhpzLWlVNPB//x9sqGieAPFyHVPBDXjmHIgfmZ+aGlKXeFTRtrGhMHOVOhUxWWdCnIRNI+PFcweA1TrIrXH6pesxI8vTaY/Eol9nTrke3s4IOkhNrEJ5vIio9/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cl97ZEW5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cl97ZEW5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB6F6C4AF0A;
	Thu, 15 Aug 2024 13:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728910;
	bh=sEEaGKCmtcPGPT56LVbWeQmkFnGdgcvgmznqwTV6dpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cl97ZEW5i3CgCpB+BikEL6cUNXiKuUy1S4851yGBZbjJmlM7wtwr2bnAocaRfgaBd
	 MjPGqhohrcRQFAIhAo94s1J4p8mRmVCcPI6PVV3ppX/luOEHT5BSV3FEo9Wg5HcLpo
	 kg/P/Zg5jkVHIx1oYpkeXPXB5PuK1vj2L5e8lcw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Jiri Olsa <jolsa@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Peter Zijlstra <peterz@infradead.org>,
	Stephane Eranian <eranian@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vince Weaver <vincent.weaver@maine.edu>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 118/196] perf/x86/intel/pt: Split ToPA metadata and page layout
Date: Thu, 15 Aug 2024 15:23:55 +0200
Message-ID: <20240815131856.591391933@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Shishkin <alexander.shishkin@linux.intel.com>

[ Upstream commit 38bb8d77d0b932a0773b5de2ef42479409314f96 ]

PT uses page sized ToPA tables, where the ToPA table resides at the bottom
and its driver-specific metadata taking up a few words at the top of the
page. The split is currently calculated manually and needs to be redone
every time a field is added to or removed from the metadata structure.
Also, the 32-bit version can be made smaller.

By splitting the table and metadata into separate structures, we are making
the compiler figure out the division of the page.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Link: http://lkml.kernel.org/r/20190821124727.73310-5-alexander.shishkin@linux.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Stable-dep-of: ad97196379d0 ("perf/x86/intel/pt: Fix a topa_entry base address calculation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/pt.c | 93 ++++++++++++++++++++++++--------------
 1 file changed, 60 insertions(+), 33 deletions(-)

diff --git a/arch/x86/events/intel/pt.c b/arch/x86/events/intel/pt.c
index 5dff4548b0875..1fe74019ee3c8 100644
--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -546,16 +546,8 @@ static void pt_config_buffer(void *buf, unsigned int topa_idx,
 	wrmsrl(MSR_IA32_RTIT_OUTPUT_MASK, reg);
 }
 
-/*
- * Keep ToPA table-related metadata on the same page as the actual table,
- * taking up a few words from the top
- */
-
-#define TENTS_PER_PAGE (((PAGE_SIZE - 40) / sizeof(struct topa_entry)) - 1)
-
 /**
- * struct topa - page-sized ToPA table with metadata at the top
- * @table:	actual ToPA table entries, as understood by PT hardware
+ * struct topa - ToPA metadata
  * @list:	linkage to struct pt_buffer's list of tables
  * @phys:	physical address of this page
  * @offset:	offset of the first entry in this table in the buffer
@@ -563,7 +555,6 @@ static void pt_config_buffer(void *buf, unsigned int topa_idx,
  * @last:	index of the last initialized entry in this table
  */
 struct topa {
-	struct topa_entry	table[TENTS_PER_PAGE];
 	struct list_head	list;
 	u64			phys;
 	u64			offset;
@@ -571,8 +562,39 @@ struct topa {
 	int			last;
 };
 
+/*
+ * Keep ToPA table-related metadata on the same page as the actual table,
+ * taking up a few words from the top
+ */
+
+#define TENTS_PER_PAGE	\
+	((PAGE_SIZE - sizeof(struct topa)) / sizeof(struct topa_entry))
+
+/**
+ * struct topa_page - page-sized ToPA table with metadata at the top
+ * @table:	actual ToPA table entries, as understood by PT hardware
+ * @topa:	metadata
+ */
+struct topa_page {
+	struct topa_entry	table[TENTS_PER_PAGE];
+	struct topa		topa;
+};
+
+static inline struct topa_page *topa_to_page(struct topa *topa)
+{
+	return container_of(topa, struct topa_page, topa);
+}
+
+static inline struct topa_page *topa_entry_to_page(struct topa_entry *te)
+{
+	return (struct topa_page *)((unsigned long)te & PAGE_MASK);
+}
+
 /* make -1 stand for the last table entry */
-#define TOPA_ENTRY(t, i) ((i) == -1 ? &(t)->table[(t)->last] : &(t)->table[(i)])
+#define TOPA_ENTRY(t, i)				\
+	((i) == -1					\
+		? &topa_to_page(t)->table[(t)->last]	\
+		: &topa_to_page(t)->table[(i)])
 #define TOPA_ENTRY_SIZE(t, i) (sizes(TOPA_ENTRY((t), (i))->size))
 
 /**
@@ -585,27 +607,27 @@ struct topa {
 static struct topa *topa_alloc(int cpu, gfp_t gfp)
 {
 	int node = cpu_to_node(cpu);
-	struct topa *topa;
+	struct topa_page *tp;
 	struct page *p;
 
 	p = alloc_pages_node(node, gfp | __GFP_ZERO, 0);
 	if (!p)
 		return NULL;
 
-	topa = page_address(p);
-	topa->last = 0;
-	topa->phys = page_to_phys(p);
+	tp = page_address(p);
+	tp->topa.last = 0;
+	tp->topa.phys = page_to_phys(p);
 
 	/*
 	 * In case of singe-entry ToPA, always put the self-referencing END
 	 * link as the 2nd entry in the table
 	 */
 	if (!intel_pt_validate_hw_cap(PT_CAP_topa_multiple_entries)) {
-		TOPA_ENTRY(topa, 1)->base = topa->phys >> TOPA_SHIFT;
-		TOPA_ENTRY(topa, 1)->end = 1;
+		TOPA_ENTRY(&tp->topa, 1)->base = tp->topa.phys;
+		TOPA_ENTRY(&tp->topa, 1)->end = 1;
 	}
 
-	return topa;
+	return &tp->topa;
 }
 
 /**
@@ -715,22 +737,23 @@ static void pt_topa_dump(struct pt_buffer *buf)
 	struct topa *topa;
 
 	list_for_each_entry(topa, &buf->tables, list) {
+		struct topa_page *tp = topa_to_page(topa);
 		int i;
 
-		pr_debug("# table @%p (%016Lx), off %llx size %zx\n", topa->table,
+		pr_debug("# table @%p (%016Lx), off %llx size %zx\n", tp->table,
 			 topa->phys, topa->offset, topa->size);
 		for (i = 0; i < TENTS_PER_PAGE; i++) {
 			pr_debug("# entry @%p (%lx sz %u %c%c%c) raw=%16llx\n",
-				 &topa->table[i],
-				 (unsigned long)topa->table[i].base << TOPA_SHIFT,
-				 sizes(topa->table[i].size),
-				 topa->table[i].end ?  'E' : ' ',
-				 topa->table[i].intr ? 'I' : ' ',
-				 topa->table[i].stop ? 'S' : ' ',
-				 *(u64 *)&topa->table[i]);
+				 &tp->table[i],
+				 (unsigned long)tp->table[i].base << TOPA_SHIFT,
+				 sizes(tp->table[i].size),
+				 tp->table[i].end ?  'E' : ' ',
+				 tp->table[i].intr ? 'I' : ' ',
+				 tp->table[i].stop ? 'S' : ' ',
+				 *(u64 *)&tp->table[i]);
 			if ((intel_pt_validate_hw_cap(PT_CAP_topa_multiple_entries) &&
-			     topa->table[i].stop) ||
-			    topa->table[i].end)
+			     tp->table[i].stop) ||
+			    tp->table[i].end)
 				break;
 		}
 	}
@@ -793,7 +816,7 @@ static void pt_update_head(struct pt *pt)
  */
 static void *pt_buffer_region(struct pt_buffer *buf)
 {
-	return phys_to_virt(buf->cur->table[buf->cur_idx].base << TOPA_SHIFT);
+	return phys_to_virt(TOPA_ENTRY(buf->cur, buf->cur_idx)->base << TOPA_SHIFT);
 }
 
 /**
@@ -870,9 +893,11 @@ static void pt_handle_status(struct pt *pt)
 static void pt_read_offset(struct pt_buffer *buf)
 {
 	u64 offset, base_topa;
+	struct topa_page *tp;
 
 	rdmsrl(MSR_IA32_RTIT_OUTPUT_BASE, base_topa);
-	buf->cur = phys_to_virt(base_topa);
+	tp = phys_to_virt(base_topa);
+	buf->cur = &tp->topa;
 
 	rdmsrl(MSR_IA32_RTIT_OUTPUT_MASK, offset);
 	/* offset within current output region */
@@ -1022,6 +1047,7 @@ static void pt_buffer_setup_topa_index(struct pt_buffer *buf)
  */
 static void pt_buffer_reset_offsets(struct pt_buffer *buf, unsigned long head)
 {
+	struct topa_page *cur_tp;
 	int pg;
 
 	if (buf->snapshot)
@@ -1030,7 +1056,8 @@ static void pt_buffer_reset_offsets(struct pt_buffer *buf, unsigned long head)
 	pg = (head >> PAGE_SHIFT) & (buf->nr_pages - 1);
 	pg = pt_topa_next_entry(buf, pg);
 
-	buf->cur = (struct topa *)((unsigned long)buf->topa_index[pg] & PAGE_MASK);
+	cur_tp = topa_entry_to_page(buf->topa_index[pg]);
+	buf->cur = &cur_tp->topa;
 	buf->cur_idx = buf->topa_index[pg] - TOPA_ENTRY(buf->cur, 0);
 	buf->output_off = head & (pt_buffer_region_size(buf) - 1);
 
@@ -1296,7 +1323,7 @@ void intel_pt_interrupt(void)
 			return;
 		}
 
-		pt_config_buffer(buf->cur->table, buf->cur_idx,
+		pt_config_buffer(topa_to_page(buf->cur)->table, buf->cur_idx,
 				 buf->output_off);
 		pt_config(event);
 	}
@@ -1361,7 +1388,7 @@ static void pt_event_start(struct perf_event *event, int mode)
 	WRITE_ONCE(pt->handle_nmi, 1);
 	hwc->state = 0;
 
-	pt_config_buffer(buf->cur->table, buf->cur_idx,
+	pt_config_buffer(topa_to_page(buf->cur)->table, buf->cur_idx,
 			 buf->output_off);
 	pt_config(event);
 
-- 
2.43.0



