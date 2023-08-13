Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D3309443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:26:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02E69C433C7;
	Sun, 13 Aug 2023 21:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691961961;
	bh=8SOFQyrS2XcR+/jgWBQbvc5B3VtrT921Tk6XIbDWWY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SIKo9HnZPQ3hSj6x4fspWSejEwkDbeVJVsqPh199x4HT8W9QRFDVMFrFRUuBwq9ZV
	 jSJCJv/RymZsF72bNZjxql/hSG2Yc/FabBc9Cpo344RQjGt7JPiuYfgtuZLYc49DTj
	 97P8S84SDIJpegGWOmoVsDL4/JTRY3g9KoHjVWXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Parri <parri.andrea@gmail.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.4 032/206] riscv,mmio: Fix readX()-to-delay() ordering
Date: Sun, 13 Aug 2023 23:16:42 +0200
Message-ID: <20230813211725.923092483@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>
References: <20230813211724.969019629@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andrea Parri <parri.andrea@gmail.com>

commit 4eb2eb1b4c0eb07793c240744843498564a67b83 upstream.

Section 2.1 of the Platform Specification [1] states:

  Unless otherwise specified by a given I/O device, I/O devices are on
  ordering channel 0 (i.e., they are point-to-point strongly ordered).

which is not sufficient to guarantee that a readX() by a hart completes
before a subsequent delay() on the same hart (cf. memory-barriers.txt,
"Kernel I/O barrier effects").

Set the I(nput) bit in __io_ar() to restore the ordering, align inline
comments.

[1] https://github.com/riscv/riscv-platform-specs

Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
Link: https://lore.kernel.org/r/20230803042738.5937-1-parri.andrea@gmail.com
Fixes: fab957c11efe ("RISC-V: Atomic and Locking Code")
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/mmio.h |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/arch/riscv/include/asm/mmio.h
+++ b/arch/riscv/include/asm/mmio.h
@@ -101,9 +101,9 @@ static inline u64 __raw_readq(const vola
  * Relaxed I/O memory access primitives. These follow the Device memory
  * ordering rules but do not guarantee any ordering relative to Normal memory
  * accesses.  These are defined to order the indicated access (either a read or
- * write) with all other I/O memory accesses. Since the platform specification
- * defines that all I/O regions are strongly ordered on channel 2, no explicit
- * fences are required to enforce this ordering.
+ * write) with all other I/O memory accesses to the same peripheral. Since the
+ * platform specification defines that all I/O regions are strongly ordered on
+ * channel 0, no explicit fences are required to enforce this ordering.
  */
 /* FIXME: These are now the same as asm-generic */
 #define __io_rbr()		do {} while (0)
@@ -125,14 +125,14 @@ static inline u64 __raw_readq(const vola
 #endif
 
 /*
- * I/O memory access primitives. Reads are ordered relative to any
- * following Normal memory access. Writes are ordered relative to any prior
- * Normal memory access.  The memory barriers here are necessary as RISC-V
+ * I/O memory access primitives.  Reads are ordered relative to any following
+ * Normal memory read and delay() loop.  Writes are ordered relative to any
+ * prior Normal memory write.  The memory barriers here are necessary as RISC-V
  * doesn't define any ordering between the memory space and the I/O space.
  */
 #define __io_br()	do {} while (0)
-#define __io_ar(v)	__asm__ __volatile__ ("fence i,r" : : : "memory")
-#define __io_bw()	__asm__ __volatile__ ("fence w,o" : : : "memory")
+#define __io_ar(v)	({ __asm__ __volatile__ ("fence i,ir" : : : "memory"); })
+#define __io_bw()	({ __asm__ __volatile__ ("fence w,o" : : : "memory"); })
 #define __io_aw()	mmiowb_set_pending()
 
 #define readb(c)	({ u8  __v; __io_br(); __v = readb_cpu(c); __io_ar(__v); __v; })


