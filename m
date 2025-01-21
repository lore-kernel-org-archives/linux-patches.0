Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D1C1F5419;
	Tue, 21 Jan 2025 18:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482586; cv=none; b=sWty6LdagLyj3j2d7p5obc09BCLGDwO7vyf0u8QTc68JnGhvx0PsMVuxjJiWyYqlr9xrrPWfnKA9X18PB73lA/nKDklWiyo0mkUfXy0Y8TNqQHxUNGXIt15xzPSwQZ+s6/IBUc41o7cZ2i6QaDasx+p7WukWH8Sghu6IyJOBArs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482586; c=relaxed/simple;
	bh=kjbnfexezi43pgUg3LqjBhXkw/WWsGTax+1QnD/2bvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aHJlOuAyz72T/vM0se7ohtJ9K8txkK2/MHzKhaXIJ6siP2FHsSpNUgXEnQpKLd5mD6USU6azi2zh+KxD5nwJL+php8H1epb9OAGIgf1utWt+RzyqaR9PYj++L+qGF5ub6sHKz01vjuwM5GzfI+Ffp5bXHLmz2vIREeuOfbe4rck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pkqy86ax; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pkqy86ax"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92614C4CEDF;
	Tue, 21 Jan 2025 18:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482586;
	bh=kjbnfexezi43pgUg3LqjBhXkw/WWsGTax+1QnD/2bvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pkqy86axW2Yy2IEWhozSSljeFLEXD3nzdjU0BUKLpQj6gzDE5v2hcddGdOx7SPc6s
	 12GMy3nNUBySsdUPJkFIqJtlj1I4lhf1lQ9IOMB48kyITj3gL1LLWMH/WMErPleBvq
	 G4Bma9bFfCGWycOaMRW82G1y2vXTOrRcSprnWaAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Veronika Molnarova <vmolnaro@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Michael Petlan <mpetlan@redhat.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.12 102/122] tracing: gfp: Fix the GFP enum values shown for user space tracing tools
Date: Tue, 21 Jan 2025 18:52:30 +0100
Message-ID: <20250121174536.969456933@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
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

commit 60295b944ff6805e677c48ae4178532b207d43be upstream.

Tracing tools like perf and trace-cmd read the /sys/kernel/tracing/events/*/*/format
files to know how to parse the data and also how to print it. For the
"print fmt" portion of that file, if anything uses an enum that is not
exported to the tracing system, user space will not be able to parse it.

The GFP flags use to be defines, and defines get translated in the print
fmt sections. But now they are converted to use enums, which is not.

The mm_page_alloc trace event format use to have:

  print fmt: "page=%p pfn=0x%lx order=%d migratetype=%d gfp_flags=%s",
    REC->pfn != -1UL ? (((struct page *)vmemmap_base) + (REC->pfn)) : ((void
    *)0), REC->pfn != -1UL ? REC->pfn : 0, REC->order, REC->migratetype,
    (REC->gfp_flags) ? __print_flags(REC->gfp_flags, "|", {( unsigned
    long)(((((((( gfp_t)(0x400u|0x800u)) | (( gfp_t)0x40u) | (( gfp_t)0x80u) |
    (( gfp_t)0x100000u)) | (( gfp_t)0x02u)) | (( gfp_t)0x08u) | (( gfp_t)0)) |
    (( gfp_t)0x40000u) | (( gfp_t)0x80000u) | (( gfp_t)0x2000u)) & ~((
    gfp_t)(0x400u|0x800u))) | (( gfp_t)0x400u)), "GFP_TRANSHUGE"}, {( unsigned
    long)((((((( gfp_t)(0x400u|0x800u)) | (( gfp_t)0x40u) | (( gfp_t)0x80u) |
    (( gfp_t)0x100000u)) | (( gfp_t)0x02u)) | (( gfp_t)0x08u) | (( gfp_t)0)) ...

Where the GFP values are shown and not their names. But after the GFP
flags were converted to use enums, it has:

  print fmt: "page=%p pfn=0x%lx order=%d migratetype=%d gfp_flags=%s",
    REC->pfn != -1UL ? (vmemmap + (REC->pfn)) : ((void *)0), REC->pfn != -1UL
    ? REC->pfn : 0, REC->order, REC->migratetype, (REC->gfp_flags) ?
    __print_flags(REC->gfp_flags, "|", {( unsigned long)((((((((
    gfp_t)(((((1UL))) << (___GFP_DIRECT_RECLAIM_BIT))|((((1UL))) <<
    (___GFP_KSWAPD_RECLAIM_BIT)))) | (( gfp_t)((((1UL))) << (___GFP_IO_BIT)))
    | (( gfp_t)((((1UL))) << (___GFP_FS_BIT))) | (( gfp_t)((((1UL))) <<
    (___GFP_HARDWALL_BIT)))) | (( gfp_t)((((1UL))) << (___GFP_HIGHMEM_BIT))))
    | (( gfp_t)((((1UL))) << (___GFP_MOVABLE_BIT))) | (( gfp_t)0)) | ((
    gfp_t)((((1UL))) << (___GFP_COMP_BIT))) ...

Where the enums names like ___GFP_KSWAPD_RECLAIM_BIT are shown and not their
values. User space has no way to convert these names to their values and
the output will fail to parse. What is shown is now:

  mm_page_alloc:  page=0xffffffff981685f3 pfn=0x1d1ac1 order=0 migratetype=1 gfp_flags=0x140cca

The TRACE_DEFINE_ENUM() macro was created to handle enums in the print fmt
files. This causes them to be replaced at boot up with the numbers, so
that user space tooling can parse it. By using this macro, the output is
back to the human readable:

  mm_page_alloc: page=0xffffffff981685f3 pfn=0x122233 order=0 migratetype=1 gfp_flags=GFP_HIGHUSER_MOVABLE|__GFP_COMP

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Veronika  Molnarova <vmolnaro@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/20250116214438.749504792@goodmis.org
Reported-by: Michael Petlan <mpetlan@redhat.com>
Closes: https://lore.kernel.org/all/87be5f7c-1a0-dad-daa0-54e342efaea7@redhat.com/
Fixes: 772dd0342727c ("mm: enumerate all gfp flags")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/trace/events/mmflags.h | 63 ++++++++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmflags.h
index bb8a59c6caa2..d36c857dd249 100644
--- a/include/trace/events/mmflags.h
+++ b/include/trace/events/mmflags.h
@@ -13,6 +13,69 @@
  * Thus most bits set go first.
  */
 
+/* These define the values that are enums (the bits) */
+#define TRACE_GFP_FLAGS_GENERAL			\
+	TRACE_GFP_EM(DMA)			\
+	TRACE_GFP_EM(HIGHMEM)			\
+	TRACE_GFP_EM(DMA32)			\
+	TRACE_GFP_EM(MOVABLE)			\
+	TRACE_GFP_EM(RECLAIMABLE)		\
+	TRACE_GFP_EM(HIGH)			\
+	TRACE_GFP_EM(IO)			\
+	TRACE_GFP_EM(FS)			\
+	TRACE_GFP_EM(ZERO)			\
+	TRACE_GFP_EM(DIRECT_RECLAIM)		\
+	TRACE_GFP_EM(KSWAPD_RECLAIM)		\
+	TRACE_GFP_EM(WRITE)			\
+	TRACE_GFP_EM(NOWARN)			\
+	TRACE_GFP_EM(RETRY_MAYFAIL)		\
+	TRACE_GFP_EM(NOFAIL)			\
+	TRACE_GFP_EM(NORETRY)			\
+	TRACE_GFP_EM(MEMALLOC)			\
+	TRACE_GFP_EM(COMP)			\
+	TRACE_GFP_EM(NOMEMALLOC)		\
+	TRACE_GFP_EM(HARDWALL)			\
+	TRACE_GFP_EM(THISNODE)			\
+	TRACE_GFP_EM(ACCOUNT)			\
+	TRACE_GFP_EM(ZEROTAGS)
+
+#ifdef CONFIG_KASAN_HW_TAGS
+# define TRACE_GFP_FLAGS_KASAN			\
+	TRACE_GFP_EM(SKIP_ZERO)			\
+	TRACE_GFP_EM(SKIP_KASAN)
+#else
+# define TRACE_GFP_FLAGS_KASAN
+#endif
+
+#ifdef CONFIG_LOCKDEP
+# define TRACE_GFP_FLAGS_LOCKDEP		\
+	TRACE_GFP_EM(NOLOCKDEP)
+#else
+# define TRACE_GFP_FLAGS_LOCKDEP
+#endif
+
+#ifdef CONFIG_SLAB_OBJ_EXT
+# define TRACE_GFP_FLAGS_SLAB			\
+	TRACE_GFP_EM(NO_OBJ_EXT)
+#else
+# define TRACE_GFP_FLAGS_SLAB
+#endif
+
+#define TRACE_GFP_FLAGS				\
+	TRACE_GFP_FLAGS_GENERAL			\
+	TRACE_GFP_FLAGS_KASAN			\
+	TRACE_GFP_FLAGS_LOCKDEP			\
+	TRACE_GFP_FLAGS_SLAB
+
+#undef TRACE_GFP_EM
+#define TRACE_GFP_EM(a) TRACE_DEFINE_ENUM(___GFP_##a##_BIT);
+
+TRACE_GFP_FLAGS
+
+/* Just in case these are ever used */
+TRACE_DEFINE_ENUM(___GFP_UNUSED_BIT);
+TRACE_DEFINE_ENUM(___GFP_LAST_BIT);
+
 #define gfpflag_string(flag) {(__force unsigned long)flag, #flag}
 
 #define __def_gfpflag_names			\
-- 
2.48.1



