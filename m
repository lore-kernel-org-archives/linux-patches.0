Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DFCD30E825;
	Mon, 27 Oct 2025 19:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592374; cv=none; b=r+00NIk3+SP84akMXBx9et/X9tT8sKKnEIXBjeoJGTggmAbgpNiMmDJvzcyDmpR8AoilRfSWTAupiKuONCXaRNoMRpQRUCh6j8Pj80Su4WgoI420IH8r/ECcAZFPx3oze9DqGLt4d6jzJ0ApC6n6AjlDZnnrrWG1SgClg01Hm9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592374; c=relaxed/simple;
	bh=pNrlniriYBYt+ylJQjItnXspf5JzsZb5Mx0X/zrU3IE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=liiH4atTziwFt9DdJE5o39jgS1x2KQBud7BspuYuKP2JrMRcPwGi6nOMh/R1PzFdKOyDZeXiwtgge7xqw24/pUib2lafYE2byR43trMit8MCeK5dsxUPfUTVoTv0cWTpe9WO4Z8yhmNLrscIAKTOiFPl2j0hB0dZeVAy3FnlC/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=APL6eO48; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="APL6eO48"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B76B0C4CEF1;
	Mon, 27 Oct 2025 19:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592374;
	bh=pNrlniriYBYt+ylJQjItnXspf5JzsZb5Mx0X/zrU3IE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=APL6eO48Hote8sch93WGvFUJXdjAwXDBD/RhPBgGlGwK6qajDSj4cByPw1MfCAvgl
	 m7fk8iOhJ8LEVKciWJDu41vHsXKdjfux90t+7f6foNBnpohDjeQw+6b8V+FdO6ZSrW
	 60B4sjcLRQPuVP0arMseEAdoXUQzItQlkfIvKDJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erhard Furtner <erhard_f@mailbox.org>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Andrew Donnellan <ajd@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 079/157] powerpc/32: Remove PAGE_KERNEL_TEXT to fix startup failure
Date: Mon, 27 Oct 2025 19:35:40 +0100
Message-ID: <20251027183503.395411999@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
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

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 9316512b717f6f25c4649b3fdb0a905b6a318e9f ]

PAGE_KERNEL_TEXT is an old macro that is used to tell kernel whether
kernel text has to be mapped read-only or read-write based on build
time options.

But nowadays, with functionnalities like jump_labels, static links,
etc ... more only less all kernels need to be read-write at some
point, and some combinations of configs failed to work due to
innacurate setting of PAGE_KERNEL_TEXT. On the other hand, today
we have CONFIG_STRICT_KERNEL_RWX which implements a more controlled
access to kernel modifications.

Instead of trying to keep PAGE_KERNEL_TEXT accurate with all
possible options that may imply kernel text modification, always
set kernel text read-write at startup and rely on
CONFIG_STRICT_KERNEL_RWX to provide accurate protection.

Do this by passing PAGE_KERNEL_X to map_kernel_page() in
__maping_ram_chunk() instead of passing PAGE_KERNEL_TEXT. Once
this is done, the only remaining user of PAGE_KERNEL_TEXT is
mmu_mark_initmem_nx() which uses it in a call to setibat().
As setibat() ignores the RW/RO, we can seamlessly replace
PAGE_KERNEL_TEXT by PAGE_KERNEL_X here as well and get rid of
PAGE_KERNEL_TEXT completely.

Reported-by: Erhard Furtner <erhard_f@mailbox.org>
Closes: https://lore.kernel.org/all/342b4120-911c-4723-82ec-d8c9b03a8aef@mailbox.org/
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Tested-by: Andrew Donnellan <ajd@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/8e2d793abf87ae3efb8f6dce10f974ac0eda61b8.1757412205.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/pgtable.h | 12 ------------
 arch/powerpc/mm/book3s32/mmu.c     |  4 ++--
 arch/powerpc/mm/pgtable_32.c       |  2 +-
 3 files changed, 3 insertions(+), 15 deletions(-)

diff --git a/arch/powerpc/include/asm/pgtable.h b/arch/powerpc/include/asm/pgtable.h
index 9972626ddaf68..eda12ceacb55a 100644
--- a/arch/powerpc/include/asm/pgtable.h
+++ b/arch/powerpc/include/asm/pgtable.h
@@ -20,18 +20,6 @@ struct mm_struct;
 #include <asm/nohash/pgtable.h>
 #endif /* !CONFIG_PPC_BOOK3S */
 
-/*
- * Protection used for kernel text. We want the debuggers to be able to
- * set breakpoints anywhere, so don't write protect the kernel text
- * on platforms where such control is possible.
- */
-#if defined(CONFIG_KGDB) || defined(CONFIG_XMON) || defined(CONFIG_BDI_SWITCH) || \
-	defined(CONFIG_KPROBES) || defined(CONFIG_DYNAMIC_FTRACE)
-#define PAGE_KERNEL_TEXT	PAGE_KERNEL_X
-#else
-#define PAGE_KERNEL_TEXT	PAGE_KERNEL_ROX
-#endif
-
 /* Make modules code happy. We don't set RO yet */
 #define PAGE_KERNEL_EXEC	PAGE_KERNEL_X
 
diff --git a/arch/powerpc/mm/book3s32/mmu.c b/arch/powerpc/mm/book3s32/mmu.c
index 850783cfa9c73..1b1848761a000 100644
--- a/arch/powerpc/mm/book3s32/mmu.c
+++ b/arch/powerpc/mm/book3s32/mmu.c
@@ -204,7 +204,7 @@ void mmu_mark_initmem_nx(void)
 
 	for (i = 0; i < nb - 1 && base < top;) {
 		size = bat_block_size(base, top);
-		setibat(i++, PAGE_OFFSET + base, base, size, PAGE_KERNEL_TEXT);
+		setibat(i++, PAGE_OFFSET + base, base, size, PAGE_KERNEL_X);
 		base += size;
 	}
 	if (base < top) {
@@ -215,7 +215,7 @@ void mmu_mark_initmem_nx(void)
 				pr_warn("Some RW data is getting mapped X. "
 					"Adjust CONFIG_DATA_SHIFT to avoid that.\n");
 		}
-		setibat(i++, PAGE_OFFSET + base, base, size, PAGE_KERNEL_TEXT);
+		setibat(i++, PAGE_OFFSET + base, base, size, PAGE_KERNEL_X);
 		base += size;
 	}
 	for (; i < nb; i++)
diff --git a/arch/powerpc/mm/pgtable_32.c b/arch/powerpc/mm/pgtable_32.c
index 5c02fd08d61ef..69fac96c2dcd1 100644
--- a/arch/powerpc/mm/pgtable_32.c
+++ b/arch/powerpc/mm/pgtable_32.c
@@ -109,7 +109,7 @@ static void __init __mapin_ram_chunk(unsigned long offset, unsigned long top)
 	p = memstart_addr + s;
 	for (; s < top; s += PAGE_SIZE) {
 		ktext = core_kernel_text(v);
-		map_kernel_page(v, p, ktext ? PAGE_KERNEL_TEXT : PAGE_KERNEL);
+		map_kernel_page(v, p, ktext ? PAGE_KERNEL_X : PAGE_KERNEL);
 		v += PAGE_SIZE;
 		p += PAGE_SIZE;
 	}
-- 
2.51.0



