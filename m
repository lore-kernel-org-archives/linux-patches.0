Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96DC019E992;
	Tue, 12 Nov 2024 10:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408503; cv=none; b=cYdMn+rbqlH3D7Or5JNeb5R+XebPhDYz9CoX3+Pw1ib0IV8b7KbTk2vlNbpTe9O+W56cKPPVXhh/YAJ3GSi4ESVABmX/p1cMsFtWSQqNx85UMahRyWEmTtaKPZE+713ctljVRRijgVS49haGp78eLamMQnBLvQtK1iICCeC/6rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408503; c=relaxed/simple;
	bh=pYopgXeO0ClSpTkuGlZ36/bQyvw28h6eKVqvH2L4Rto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sY7TaYEBhsg91/K46hXAFjEK8CoLR729GmsxGDnZ4RV8QeRH9s4IJWh8wPM66+Wef9Z/hF7N5wNfIt1lb+F3ZQUQ266BXYKWi3pPwQcEZPDQQ4kTzc/EXeVqB4GRPBwjpfZl+0gj4+XM9eeeZqGhOnPn1qWG8pFB/FYlq4MijIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ofk5AY3q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ofk5AY3q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19DD9C4CED6;
	Tue, 12 Nov 2024 10:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408503;
	bh=pYopgXeO0ClSpTkuGlZ36/bQyvw28h6eKVqvH2L4Rto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ofk5AY3qDYTHEszjuXatNhpj1qo7RR9cMN66UFeWL0s9JDGqGwcgSwJrTiriVF8OA
	 ZemT7WDipINjoHgz6MlcNI+YEix3pgGz3Q7pOGgq8wci0X2shwBlsFLAXkS8BwunUV
	 ZnEnpEsIkoR2rSffmmExBiPrqr0MZjUzS1hnn7CE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Yujie Liu <yujie.liu@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Arnd Bergmann <arnd@arndb.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.11 182/184] xtensa: Emulate one-byte cmpxchg
Date: Tue, 12 Nov 2024 11:22:20 +0100
Message-ID: <20241112101907.849500966@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

From: Paul E. McKenney <paulmck@kernel.org>

commit e799bef0d9c85b963938d8f31806a898385a5b09 upstream.

Use the new cmpxchg_emu_u8() to emulate one-byte cmpxchg() on xtensa.

[ paulmck: Apply kernel test robot feedback. ]
[ paulmck: Drop two-byte support per Arnd Bergmann feedback. ]
[ Apply Geert Uytterhoeven feedback. ]

Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Tested-by: Yujie Liu <yujie.liu@intel.com>
Cc: Andi Shyti <andi.shyti@linux.intel.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/xtensa/Kconfig               |    1 +
 arch/xtensa/include/asm/cmpxchg.h |    2 ++
 2 files changed, 3 insertions(+)

--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -14,6 +14,7 @@ config XTENSA
 	select ARCH_HAS_DMA_SET_UNCACHED if MMU
 	select ARCH_HAS_STRNCPY_FROM_USER if !KASAN
 	select ARCH_HAS_STRNLEN_USER
+	select ARCH_NEED_CMPXCHG_1_EMU
 	select ARCH_USE_MEMTEST
 	select ARCH_USE_QUEUED_RWLOCKS
 	select ARCH_USE_QUEUED_SPINLOCKS
--- a/arch/xtensa/include/asm/cmpxchg.h
+++ b/arch/xtensa/include/asm/cmpxchg.h
@@ -15,6 +15,7 @@
 
 #include <linux/bits.h>
 #include <linux/stringify.h>
+#include <linux/cmpxchg-emu.h>
 
 /*
  * cmpxchg
@@ -74,6 +75,7 @@ static __inline__ unsigned long
 __cmpxchg(volatile void *ptr, unsigned long old, unsigned long new, int size)
 {
 	switch (size) {
+	case 1:  return cmpxchg_emu_u8(ptr, old, new);
 	case 4:  return __cmpxchg_u32(ptr, old, new);
 	default: __cmpxchg_called_with_bad_pointer();
 		 return old;


