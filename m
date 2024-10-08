Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A431DED74;
	Tue,  8 Oct 2024 12:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392177; cv=none; b=eoqq3psHeM4UO0pUhhH1xYJlLs6lmtv6CHm3BRwB2Hy3BIwnDd6BoqVBNW5UbdGnUXhnp1PFD2kxiWaTpws4Dh4A39WrLw78kfNv3KuWDT0dwo6+/qMh8wow+cM2pWI+6QI6M52wkBRybaYjZW6MKaXDJIJ8uARK/JvzTSchBsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392177; c=relaxed/simple;
	bh=EIaPrjSyYZlTc5pJ/QuEGSWkKOj1hxki3qFvkrx5e4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=acHTr9COGDMKn6DLKbnC2/ZZYBTQjko/U28v5pz+V79u/b84jTN8z2YfOMHUh+ASVEdTNdhCrNExtzw1NutUttg+rs/EMIldnRbjBYBKS6QknqWIzdJL2KFO4/cI+4P1pNbCAkynceNXAMgsxtq4MjVWFqj5eUmTTDxZFd7IgYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RxxvnUOC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RxxvnUOC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B3E2C4CEC7;
	Tue,  8 Oct 2024 12:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392176;
	bh=EIaPrjSyYZlTc5pJ/QuEGSWkKOj1hxki3qFvkrx5e4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RxxvnUOCavwBH2eu9Kqi+181Nt8wFqCC26xo3y4Cb4kRuJKrUcwHeiS/pkFm+qtmc
	 K6FyXowtW8LO4LJOT93raxzMW/Sdzv5zWkvesKMOi4XMK0JWOzlVXcp9MH3zN3TfSB
	 y75AM5Xl+S1jhIna74dQTg8f1nMhvTWRXozzxt3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 337/558] powerpc/vdso: Fix VDSO data access when running in a non-root time namespace
Date: Tue,  8 Oct 2024 14:06:07 +0200
Message-ID: <20241008115715.564771091@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit c73049389e58c01e2e3bbfae900c8daeee177191 ]

When running in a non-root time namespace, the global VDSO data page
is replaced by a dedicated namespace data page and the global data
page is mapped next to it. Detailed explanations can be found at
commit 660fd04f9317 ("lib/vdso: Prepare for time namespace support").

When it happens, __kernel_get_syscall_map and __kernel_get_tbfreq
and __kernel_sync_dicache don't work anymore because they read 0
instead of the data they need.

To address that, clock_mode has to be read. When it is set to
VDSO_CLOCKMODE_TIMENS, it means it is a dedicated namespace data page
and the global data is located on the following page.

Add a macro called get_realdatapage which reads clock_mode and add
PAGE_SIZE to the pointer provided by get_datapage macro when
clock_mode is equal to VDSO_CLOCKMODE_TIMENS. Use this new macro
instead of get_datapage macro except for time functions as they handle
it internally.

Fixes: 74205b3fc2ef ("powerpc/vdso: Add support for time namespaces")
Reported-by: Jason A. Donenfeld <Jason@zx2c4.com>
Closes: https://lore.kernel.org/all/ZtnYqZI-nrsNslwy@zx2c4.com/
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/vdso_datapage.h | 15 +++++++++++++++
 arch/powerpc/kernel/asm-offsets.c        |  2 ++
 arch/powerpc/kernel/vdso/cacheflush.S    |  2 +-
 arch/powerpc/kernel/vdso/datapage.S      |  4 ++--
 4 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/include/asm/vdso_datapage.h b/arch/powerpc/include/asm/vdso_datapage.h
index a585c8e538ff0..939daf6b695ef 100644
--- a/arch/powerpc/include/asm/vdso_datapage.h
+++ b/arch/powerpc/include/asm/vdso_datapage.h
@@ -111,6 +111,21 @@ extern struct vdso_arch_data *vdso_data;
 	addi	\ptr, \ptr, (_vdso_datapage - 999b)@l
 .endm
 
+#include <asm/asm-offsets.h>
+#include <asm/page.h>
+
+.macro get_realdatapage ptr scratch
+	get_datapage \ptr
+#ifdef CONFIG_TIME_NS
+	lwz	\scratch, VDSO_CLOCKMODE_OFFSET(\ptr)
+	xoris	\scratch, \scratch, VDSO_CLOCKMODE_TIMENS@h
+	xori	\scratch, \scratch, VDSO_CLOCKMODE_TIMENS@l
+	cntlzw	\scratch, \scratch
+	rlwinm	\scratch, \scratch, PAGE_SHIFT - 5, 1 << PAGE_SHIFT
+	add	\ptr, \ptr, \scratch
+#endif
+.endm
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* __KERNEL__ */
diff --git a/arch/powerpc/kernel/asm-offsets.c b/arch/powerpc/kernel/asm-offsets.c
index 23733282de4d9..7b3feb6bc2103 100644
--- a/arch/powerpc/kernel/asm-offsets.c
+++ b/arch/powerpc/kernel/asm-offsets.c
@@ -346,6 +346,8 @@ int main(void)
 #else
 	OFFSET(CFG_SYSCALL_MAP32, vdso_arch_data, syscall_map);
 #endif
+	OFFSET(VDSO_CLOCKMODE_OFFSET, vdso_arch_data, data[0].clock_mode);
+	DEFINE(VDSO_CLOCKMODE_TIMENS, VDSO_CLOCKMODE_TIMENS);
 
 #ifdef CONFIG_BUG
 	DEFINE(BUG_ENTRY_SIZE, sizeof(struct bug_entry));
diff --git a/arch/powerpc/kernel/vdso/cacheflush.S b/arch/powerpc/kernel/vdso/cacheflush.S
index 0085ae464dac9..3b2479bd2f9a1 100644
--- a/arch/powerpc/kernel/vdso/cacheflush.S
+++ b/arch/powerpc/kernel/vdso/cacheflush.S
@@ -30,7 +30,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_COHERENT_ICACHE)
 #ifdef CONFIG_PPC64
 	mflr	r12
   .cfi_register lr,r12
-	get_datapage	r10
+	get_realdatapage	r10, r11
 	mtlr	r12
   .cfi_restore	lr
 #endif
diff --git a/arch/powerpc/kernel/vdso/datapage.S b/arch/powerpc/kernel/vdso/datapage.S
index db8e167f01667..2b19b6201a33a 100644
--- a/arch/powerpc/kernel/vdso/datapage.S
+++ b/arch/powerpc/kernel/vdso/datapage.S
@@ -28,7 +28,7 @@ V_FUNCTION_BEGIN(__kernel_get_syscall_map)
 	mflr	r12
   .cfi_register lr,r12
 	mr.	r4,r3
-	get_datapage	r3
+	get_realdatapage	r3, r11
 	mtlr	r12
 #ifdef __powerpc64__
 	addi	r3,r3,CFG_SYSCALL_MAP64
@@ -52,7 +52,7 @@ V_FUNCTION_BEGIN(__kernel_get_tbfreq)
   .cfi_startproc
 	mflr	r12
   .cfi_register lr,r12
-	get_datapage	r3
+	get_realdatapage	r3, r11
 #ifndef __powerpc64__
 	lwz	r4,(CFG_TB_TICKS_PER_SEC + 4)(r3)
 #endif
-- 
2.43.0



