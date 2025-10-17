Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB46A2F12DD;
	Fri, 17 Oct 2025 15:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713417; cv=none; b=To3QU/68DOnfgHyfEZIUs+YJ8g0xIUzKquM3QPZcjd6V6NityyT1l7leETily7R12zqUTRu6nDut9gCjbQDFLr98+Ui/oADK+Z4RZO/OQQ3HqSUIa0gDUi9Z670ptLOzp79/Nt6rqPLRUiAq20/jAPMDrwSjEpRIR1au0LW/VG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713417; c=relaxed/simple;
	bh=bCbuORchekpWTZxd9oSEow1gmh9/sUlEcD+OrFzeGYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J5oN0hT06yHiEj8/38yNOPtsep9qTU/ep7GNqA8JJ0y6Ol0uEgMKAcEvQafc+gw3YncHY/9F6VyRbZiNM5r7BrL+x5WotWwicp1lK+z+GBv4q/sbeNDRF0xDgBmamL7+1vRio/4a5UyL6lLawgI3ZR/9OmZyuwdbbSJqTE72wgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SHiPxSIm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SHiPxSIm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34C6FC4CEE7;
	Fri, 17 Oct 2025 15:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713417;
	bh=bCbuORchekpWTZxd9oSEow1gmh9/sUlEcD+OrFzeGYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SHiPxSImzHL40Kj3AR5UbsDl/cHHCcZtyW+SEhWRUX51Q5+HilbUHJhios1d328XM
	 UjAjkAFnEioy0AS2ueayiuMp2Y4aJ9ir1LLgsPcEfHl3FwthD8UTy0hOH+HM+TNLrg
	 1iO2Uhfq7Ir4njLavHrlahDkDezwDngQxugpa5sA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sai Prakash Ranjan <quic_saipraka@quicinc.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 157/168] asm-generic/io: Add _RET_IP_ to MMIO trace for more accurate debug info
Date: Fri, 17 Oct 2025 16:53:56 +0200
Message-ID: <20251017145134.830175354@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sai Prakash Ranjan <quic_saipraka@quicinc.com>

[ Upstream commit 5e5ff73c2e5863f93fc5fd78d178cd8f2af12464 ]

Due to compiler optimizations like inlining, there are cases where
MMIO traces using _THIS_IP_ for caller information might not be
sufficient to provide accurate debug traces.

1) With optimizations (Seen with GCC):

In this case, _THIS_IP_ works fine and prints the caller information
since it will be inlined into the caller and we get the debug traces
on who made the MMIO access, for ex:

rwmmio_read: qcom_smmu_tlb_sync+0xe0/0x1b0 width=32 addr=0xffff8000087447f4
rwmmio_post_read: qcom_smmu_tlb_sync+0xe0/0x1b0 width=32 val=0x0 addr=0xffff8000087447f4

2) Without optimizations (Seen with Clang):

_THIS_IP_ will not be sufficient in this case as it will print only
the MMIO accessors itself which is of not much use since it is not
inlined as below for example:

rwmmio_read: readl+0x4/0x80 width=32 addr=0xffff8000087447f4
rwmmio_post_read: readl+0x48/0x80 width=32 val=0x4 addr=0xffff8000087447f4

So in order to handle this second case as well irrespective of the compiler
optimizations, add _RET_IP_ to MMIO trace to make it provide more accurate
debug information in all these scenarios.

Before:

rwmmio_read: readl+0x4/0x80 width=32 addr=0xffff8000087447f4
rwmmio_post_read: readl+0x48/0x80 width=32 val=0x4 addr=0xffff8000087447f4

After:

rwmmio_read: qcom_smmu_tlb_sync+0xe0/0x1b0 -> readl+0x4/0x80 width=32 addr=0xffff8000087447f4
rwmmio_post_read: qcom_smmu_tlb_sync+0xe0/0x1b0 -> readl+0x4/0x80 width=32 val=0x0 addr=0xffff8000087447f4

Fixes: 210031971cdd ("asm-generic/io: Add logging support for MMIO accessors")
Signed-off-by: Sai Prakash Ranjan <quic_saipraka@quicinc.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Stable-dep-of: 8327bd4fcb6c ("asm-generic/io.h: Skip trace helpers if rwmmio events are disabled")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/asm-generic/io.h      |   80 +++++++++++++++++++++---------------------
 include/trace/events/rwmmio.h |   43 ++++++++++++++--------
 lib/trace_readwrite.c         |   16 ++++----
 3 files changed, 75 insertions(+), 64 deletions(-)

--- a/include/asm-generic/io.h
+++ b/include/asm-generic/io.h
@@ -80,24 +80,24 @@ DECLARE_TRACEPOINT(rwmmio_read);
 DECLARE_TRACEPOINT(rwmmio_post_read);
 
 void log_write_mmio(u64 val, u8 width, volatile void __iomem *addr,
-		    unsigned long caller_addr);
+		    unsigned long caller_addr, unsigned long caller_addr0);
 void log_post_write_mmio(u64 val, u8 width, volatile void __iomem *addr,
-			 unsigned long caller_addr);
+			 unsigned long caller_addr, unsigned long caller_addr0);
 void log_read_mmio(u8 width, const volatile void __iomem *addr,
-		   unsigned long caller_addr);
+		   unsigned long caller_addr, unsigned long caller_addr0);
 void log_post_read_mmio(u64 val, u8 width, const volatile void __iomem *addr,
-			unsigned long caller_addr);
+			unsigned long caller_addr, unsigned long caller_addr0);
 
 #else
 
 static inline void log_write_mmio(u64 val, u8 width, volatile void __iomem *addr,
-				  unsigned long caller_addr) {}
+				  unsigned long caller_addr, unsigned long caller_addr0) {}
 static inline void log_post_write_mmio(u64 val, u8 width, volatile void __iomem *addr,
-				       unsigned long caller_addr) {}
+				       unsigned long caller_addr, unsigned long caller_addr0) {}
 static inline void log_read_mmio(u8 width, const volatile void __iomem *addr,
-				 unsigned long caller_addr) {}
+				 unsigned long caller_addr, unsigned long caller_addr0) {}
 static inline void log_post_read_mmio(u64 val, u8 width, const volatile void __iomem *addr,
-				      unsigned long caller_addr) {}
+				      unsigned long caller_addr, unsigned long caller_addr0) {}
 
 #endif /* CONFIG_TRACE_MMIO_ACCESS */
 
@@ -188,11 +188,11 @@ static inline u8 readb(const volatile vo
 {
 	u8 val;
 
-	log_read_mmio(8, addr, _THIS_IP_);
+	log_read_mmio(8, addr, _THIS_IP_, _RET_IP_);
 	__io_br();
 	val = __raw_readb(addr);
 	__io_ar(val);
-	log_post_read_mmio(val, 8, addr, _THIS_IP_);
+	log_post_read_mmio(val, 8, addr, _THIS_IP_, _RET_IP_);
 	return val;
 }
 #endif
@@ -203,11 +203,11 @@ static inline u16 readw(const volatile v
 {
 	u16 val;
 
-	log_read_mmio(16, addr, _THIS_IP_);
+	log_read_mmio(16, addr, _THIS_IP_, _RET_IP_);
 	__io_br();
 	val = __le16_to_cpu((__le16 __force)__raw_readw(addr));
 	__io_ar(val);
-	log_post_read_mmio(val, 16, addr, _THIS_IP_);
+	log_post_read_mmio(val, 16, addr, _THIS_IP_, _RET_IP_);
 	return val;
 }
 #endif
@@ -218,11 +218,11 @@ static inline u32 readl(const volatile v
 {
 	u32 val;
 
-	log_read_mmio(32, addr, _THIS_IP_);
+	log_read_mmio(32, addr, _THIS_IP_, _RET_IP_);
 	__io_br();
 	val = __le32_to_cpu((__le32 __force)__raw_readl(addr));
 	__io_ar(val);
-	log_post_read_mmio(val, 32, addr, _THIS_IP_);
+	log_post_read_mmio(val, 32, addr, _THIS_IP_, _RET_IP_);
 	return val;
 }
 #endif
@@ -234,11 +234,11 @@ static inline u64 readq(const volatile v
 {
 	u64 val;
 
-	log_read_mmio(64, addr, _THIS_IP_);
+	log_read_mmio(64, addr, _THIS_IP_, _RET_IP_);
 	__io_br();
 	val = __le64_to_cpu((__le64 __force)__raw_readq(addr));
 	__io_ar(val);
-	log_post_read_mmio(val, 64, addr, _THIS_IP_);
+	log_post_read_mmio(val, 64, addr, _THIS_IP_, _RET_IP_);
 	return val;
 }
 #endif
@@ -248,11 +248,11 @@ static inline u64 readq(const volatile v
 #define writeb writeb
 static inline void writeb(u8 value, volatile void __iomem *addr)
 {
-	log_write_mmio(value, 8, addr, _THIS_IP_);
+	log_write_mmio(value, 8, addr, _THIS_IP_, _RET_IP_);
 	__io_bw();
 	__raw_writeb(value, addr);
 	__io_aw();
-	log_post_write_mmio(value, 8, addr, _THIS_IP_);
+	log_post_write_mmio(value, 8, addr, _THIS_IP_, _RET_IP_);
 }
 #endif
 
@@ -260,11 +260,11 @@ static inline void writeb(u8 value, vola
 #define writew writew
 static inline void writew(u16 value, volatile void __iomem *addr)
 {
-	log_write_mmio(value, 16, addr, _THIS_IP_);
+	log_write_mmio(value, 16, addr, _THIS_IP_, _RET_IP_);
 	__io_bw();
 	__raw_writew((u16 __force)cpu_to_le16(value), addr);
 	__io_aw();
-	log_post_write_mmio(value, 16, addr, _THIS_IP_);
+	log_post_write_mmio(value, 16, addr, _THIS_IP_, _RET_IP_);
 }
 #endif
 
@@ -272,11 +272,11 @@ static inline void writew(u16 value, vol
 #define writel writel
 static inline void writel(u32 value, volatile void __iomem *addr)
 {
-	log_write_mmio(value, 32, addr, _THIS_IP_);
+	log_write_mmio(value, 32, addr, _THIS_IP_, _RET_IP_);
 	__io_bw();
 	__raw_writel((u32 __force)__cpu_to_le32(value), addr);
 	__io_aw();
-	log_post_write_mmio(value, 32, addr, _THIS_IP_);
+	log_post_write_mmio(value, 32, addr, _THIS_IP_, _RET_IP_);
 }
 #endif
 
@@ -285,11 +285,11 @@ static inline void writel(u32 value, vol
 #define writeq writeq
 static inline void writeq(u64 value, volatile void __iomem *addr)
 {
-	log_write_mmio(value, 64, addr, _THIS_IP_);
+	log_write_mmio(value, 64, addr, _THIS_IP_, _RET_IP_);
 	__io_bw();
 	__raw_writeq((u64 __force)__cpu_to_le64(value), addr);
 	__io_aw();
-	log_post_write_mmio(value, 64, addr, _THIS_IP_);
+	log_post_write_mmio(value, 64, addr, _THIS_IP_, _RET_IP_);
 }
 #endif
 #endif /* CONFIG_64BIT */
@@ -305,9 +305,9 @@ static inline u8 readb_relaxed(const vol
 {
 	u8 val;
 
-	log_read_mmio(8, addr, _THIS_IP_);
+	log_read_mmio(8, addr, _THIS_IP_, _RET_IP_);
 	val = __raw_readb(addr);
-	log_post_read_mmio(val, 8, addr, _THIS_IP_);
+	log_post_read_mmio(val, 8, addr, _THIS_IP_, _RET_IP_);
 	return val;
 }
 #endif
@@ -318,9 +318,9 @@ static inline u16 readw_relaxed(const vo
 {
 	u16 val;
 
-	log_read_mmio(16, addr, _THIS_IP_);
+	log_read_mmio(16, addr, _THIS_IP_, _RET_IP_);
 	val = __le16_to_cpu(__raw_readw(addr));
-	log_post_read_mmio(val, 16, addr, _THIS_IP_);
+	log_post_read_mmio(val, 16, addr, _THIS_IP_, _RET_IP_);
 	return val;
 }
 #endif
@@ -331,9 +331,9 @@ static inline u32 readl_relaxed(const vo
 {
 	u32 val;
 
-	log_read_mmio(32, addr, _THIS_IP_);
+	log_read_mmio(32, addr, _THIS_IP_, _RET_IP_);
 	val = __le32_to_cpu(__raw_readl(addr));
-	log_post_read_mmio(val, 32, addr, _THIS_IP_);
+	log_post_read_mmio(val, 32, addr, _THIS_IP_, _RET_IP_);
 	return val;
 }
 #endif
@@ -344,9 +344,9 @@ static inline u64 readq_relaxed(const vo
 {
 	u64 val;
 
-	log_read_mmio(64, addr, _THIS_IP_);
+	log_read_mmio(64, addr, _THIS_IP_, _RET_IP_);
 	val = __le64_to_cpu(__raw_readq(addr));
-	log_post_read_mmio(val, 64, addr, _THIS_IP_);
+	log_post_read_mmio(val, 64, addr, _THIS_IP_, _RET_IP_);
 	return val;
 }
 #endif
@@ -355,9 +355,9 @@ static inline u64 readq_relaxed(const vo
 #define writeb_relaxed writeb_relaxed
 static inline void writeb_relaxed(u8 value, volatile void __iomem *addr)
 {
-	log_write_mmio(value, 8, addr, _THIS_IP_);
+	log_write_mmio(value, 8, addr, _THIS_IP_, _RET_IP_);
 	__raw_writeb(value, addr);
-	log_post_write_mmio(value, 8, addr, _THIS_IP_);
+	log_post_write_mmio(value, 8, addr, _THIS_IP_, _RET_IP_);
 }
 #endif
 
@@ -365,9 +365,9 @@ static inline void writeb_relaxed(u8 val
 #define writew_relaxed writew_relaxed
 static inline void writew_relaxed(u16 value, volatile void __iomem *addr)
 {
-	log_write_mmio(value, 16, addr, _THIS_IP_);
+	log_write_mmio(value, 16, addr, _THIS_IP_, _RET_IP_);
 	__raw_writew(cpu_to_le16(value), addr);
-	log_post_write_mmio(value, 16, addr, _THIS_IP_);
+	log_post_write_mmio(value, 16, addr, _THIS_IP_, _RET_IP_);
 }
 #endif
 
@@ -375,9 +375,9 @@ static inline void writew_relaxed(u16 va
 #define writel_relaxed writel_relaxed
 static inline void writel_relaxed(u32 value, volatile void __iomem *addr)
 {
-	log_write_mmio(value, 32, addr, _THIS_IP_);
+	log_write_mmio(value, 32, addr, _THIS_IP_, _RET_IP_);
 	__raw_writel(__cpu_to_le32(value), addr);
-	log_post_write_mmio(value, 32, addr, _THIS_IP_);
+	log_post_write_mmio(value, 32, addr, _THIS_IP_, _RET_IP_);
 }
 #endif
 
@@ -385,9 +385,9 @@ static inline void writel_relaxed(u32 va
 #define writeq_relaxed writeq_relaxed
 static inline void writeq_relaxed(u64 value, volatile void __iomem *addr)
 {
-	log_write_mmio(value, 64, addr, _THIS_IP_);
+	log_write_mmio(value, 64, addr, _THIS_IP_, _RET_IP_);
 	__raw_writeq(__cpu_to_le64(value), addr);
-	log_post_write_mmio(value, 64, addr, _THIS_IP_);
+	log_post_write_mmio(value, 64, addr, _THIS_IP_, _RET_IP_);
 }
 #endif
 
--- a/include/trace/events/rwmmio.h
+++ b/include/trace/events/rwmmio.h
@@ -12,12 +12,14 @@
 
 DECLARE_EVENT_CLASS(rwmmio_rw_template,
 
-	TP_PROTO(unsigned long caller, u64 val, u8 width, volatile void __iomem *addr),
+	TP_PROTO(unsigned long caller, unsigned long caller0, u64 val, u8 width,
+		 volatile void __iomem *addr),
 
-	TP_ARGS(caller, val, width, addr),
+	TP_ARGS(caller, caller0, val, width, addr),
 
 	TP_STRUCT__entry(
 		__field(unsigned long, caller)
+		__field(unsigned long, caller0)
 		__field(unsigned long, addr)
 		__field(u64, val)
 		__field(u8, width)
@@ -25,56 +27,64 @@ DECLARE_EVENT_CLASS(rwmmio_rw_template,
 
 	TP_fast_assign(
 		__entry->caller = caller;
+		__entry->caller0 = caller0;
 		__entry->val = val;
 		__entry->addr = (unsigned long)addr;
 		__entry->width = width;
 	),
 
-	TP_printk("%pS width=%d val=%#llx addr=%#lx",
-		(void *)__entry->caller, __entry->width,
+	TP_printk("%pS -> %pS width=%d val=%#llx addr=%#lx",
+		(void *)__entry->caller0, (void *)__entry->caller, __entry->width,
 		__entry->val, __entry->addr)
 );
 
 DEFINE_EVENT(rwmmio_rw_template, rwmmio_write,
-	TP_PROTO(unsigned long caller, u64 val, u8 width, volatile void __iomem *addr),
-	TP_ARGS(caller, val, width, addr)
+	TP_PROTO(unsigned long caller, unsigned long caller0, u64 val, u8 width,
+		 volatile void __iomem *addr),
+	TP_ARGS(caller, caller0, val, width, addr)
 );
 
 DEFINE_EVENT(rwmmio_rw_template, rwmmio_post_write,
-	TP_PROTO(unsigned long caller, u64 val, u8 width, volatile void __iomem *addr),
-	TP_ARGS(caller, val, width, addr)
+	TP_PROTO(unsigned long caller, unsigned long caller0, u64 val, u8 width,
+		 volatile void __iomem *addr),
+	TP_ARGS(caller, caller0, val, width, addr)
 );
 
 TRACE_EVENT(rwmmio_read,
 
-	TP_PROTO(unsigned long caller, u8 width, const volatile void __iomem *addr),
+	TP_PROTO(unsigned long caller, unsigned long caller0, u8 width,
+		 const volatile void __iomem *addr),
 
-	TP_ARGS(caller, width, addr),
+	TP_ARGS(caller, caller0, width, addr),
 
 	TP_STRUCT__entry(
 		__field(unsigned long, caller)
+		__field(unsigned long, caller0)
 		__field(unsigned long, addr)
 		__field(u8, width)
 	),
 
 	TP_fast_assign(
 		__entry->caller = caller;
+		__entry->caller0 = caller0;
 		__entry->addr = (unsigned long)addr;
 		__entry->width = width;
 	),
 
-	TP_printk("%pS width=%d addr=%#lx",
-		 (void *)__entry->caller, __entry->width, __entry->addr)
+	TP_printk("%pS -> %pS width=%d addr=%#lx",
+		 (void *)__entry->caller0, (void *)__entry->caller, __entry->width, __entry->addr)
 );
 
 TRACE_EVENT(rwmmio_post_read,
 
-	TP_PROTO(unsigned long caller, u64 val, u8 width, const volatile void __iomem *addr),
+	TP_PROTO(unsigned long caller, unsigned long caller0, u64 val, u8 width,
+		 const volatile void __iomem *addr),
 
-	TP_ARGS(caller, val, width, addr),
+	TP_ARGS(caller, caller0, val, width, addr),
 
 	TP_STRUCT__entry(
 		__field(unsigned long, caller)
+		__field(unsigned long, caller0)
 		__field(unsigned long, addr)
 		__field(u64, val)
 		__field(u8, width)
@@ -82,13 +92,14 @@ TRACE_EVENT(rwmmio_post_read,
 
 	TP_fast_assign(
 		__entry->caller = caller;
+		__entry->caller0 = caller0;
 		__entry->val = val;
 		__entry->addr = (unsigned long)addr;
 		__entry->width = width;
 	),
 
-	TP_printk("%pS width=%d val=%#llx addr=%#lx",
-		 (void *)__entry->caller, __entry->width,
+	TP_printk("%pS -> %pS width=%d val=%#llx addr=%#lx",
+		 (void *)__entry->caller0, (void *)__entry->caller, __entry->width,
 		 __entry->val, __entry->addr)
 );
 
--- a/lib/trace_readwrite.c
+++ b/lib/trace_readwrite.c
@@ -14,33 +14,33 @@
 
 #ifdef CONFIG_TRACE_MMIO_ACCESS
 void log_write_mmio(u64 val, u8 width, volatile void __iomem *addr,
-		    unsigned long caller_addr)
+		    unsigned long caller_addr, unsigned long caller_addr0)
 {
-	trace_rwmmio_write(caller_addr, val, width, addr);
+	trace_rwmmio_write(caller_addr, caller_addr0, val, width, addr);
 }
 EXPORT_SYMBOL_GPL(log_write_mmio);
 EXPORT_TRACEPOINT_SYMBOL_GPL(rwmmio_write);
 
 void log_post_write_mmio(u64 val, u8 width, volatile void __iomem *addr,
-			 unsigned long caller_addr)
+			 unsigned long caller_addr, unsigned long caller_addr0)
 {
-	trace_rwmmio_post_write(caller_addr, val, width, addr);
+	trace_rwmmio_post_write(caller_addr, caller_addr0, val, width, addr);
 }
 EXPORT_SYMBOL_GPL(log_post_write_mmio);
 EXPORT_TRACEPOINT_SYMBOL_GPL(rwmmio_post_write);
 
 void log_read_mmio(u8 width, const volatile void __iomem *addr,
-		   unsigned long caller_addr)
+		   unsigned long caller_addr, unsigned long caller_addr0)
 {
-	trace_rwmmio_read(caller_addr, width, addr);
+	trace_rwmmio_read(caller_addr, caller_addr0, width, addr);
 }
 EXPORT_SYMBOL_GPL(log_read_mmio);
 EXPORT_TRACEPOINT_SYMBOL_GPL(rwmmio_read);
 
 void log_post_read_mmio(u64 val, u8 width, const volatile void __iomem *addr,
-			unsigned long caller_addr)
+			unsigned long caller_addr, unsigned long caller_addr0)
 {
-	trace_rwmmio_post_read(caller_addr, val, width, addr);
+	trace_rwmmio_post_read(caller_addr, caller_addr0, val, width, addr);
 }
 EXPORT_SYMBOL_GPL(log_post_read_mmio);
 EXPORT_TRACEPOINT_SYMBOL_GPL(rwmmio_post_read);


