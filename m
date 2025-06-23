Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44DE0B676;
	Mon, 23 Jun 2025 22:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716955; cv=none; b=gaPiNGhmmZQWwP98uFd92BzQqm2qO/cOWU3uZ6fCyf/YCNswCVuK/QUWRUSPgMHduWau+IPlvf6gPtM8yToi1R+BteDhjgs0xSoeUxsr+M1rHr+s2Wz6YLs3lJ8z6+4ou5NgNl2efHWH7DOcr85ot3rPdrCfqbgim9XrQmq4Jq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716955; c=relaxed/simple;
	bh=hvQg4twDke/j6LUIhTLuCJedRXm0QImf1r5RlOmPaiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fCJrQFNfjDbE5gB0FdrXbK5r40ZuIRGMe489ErCqANeJXKgx8y2F6bFi+6piPvlOCp6cPNfy0UW1GElkfhKHXlZYCuTpsHbEChWfO4q9k8/Dwcu9/ZUO8t6CI1u3T4w56Ur2xDWN+eBduduB/A0vH/4KlCo9+rTdm/r4cAj+rdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vln0t13k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vln0t13k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C63FAC4CEEA;
	Mon, 23 Jun 2025 22:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716955;
	bh=hvQg4twDke/j6LUIhTLuCJedRXm0QImf1r5RlOmPaiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vln0t13kMCxbH107XOKIUupcPQaDRtVvBErSL+9QQ2yr6OMZJ0emdBFrM2xmG+OHz
	 79lwKCVdVyIl3XFPUp4pUHwf8qgK9Vpy6xKjxq1FRTISTjOsBveetWxBdKML2LMdCk
	 NjljSLezinLIRmdXV1tlRi3D85yt+ccu5WiEmiIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Yanteng Si <si.yanteng@linux.dev>,
	WANG Xuerui <git@xen0n.name>,
	Xi Ruoyao <xry111@xry111.site>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 301/414] LoongArch: vDSO: Correctly use asm parameters in syscall wrappers
Date: Mon, 23 Jun 2025 15:07:18 +0200
Message-ID: <20250623130649.531693293@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

commit e242bbbb6d7ac7556aa1e358294dc7e3c82cc902 upstream.

The syscall wrappers use the "a0" register for two different register
variables, both the first argument and the return value. Here the "ret"
variable is used as both input and output while the argument register is
only used as input. Clang treats the conflicting input parameters as an
undefined behaviour and optimizes away the argument assignment.

The code seems to work by chance for the most part today but that may
change in the future. Specifically clock_gettime_fallback() fails with
clockids from 16 to 23, as implemented by the upcoming auxiliary clocks.

Switch the "ret" register variable to a pure output, similar to the
other architectures' vDSO code. This works in both clang and GCC.

Link: https://lore.kernel.org/lkml/20250602102825-42aa84f0-23f1-4d10-89fc-e8bbaffd291a@linutronix.de/
Link: https://lore.kernel.org/lkml/20250519082042.742926976@linutronix.de/
Fixes: c6b99bed6b8f ("LoongArch: Add VDSO and VSYSCALL support")
Fixes: 18efd0b10e0f ("LoongArch: vDSO: Wire up getrandom() vDSO implementation")
Cc: stable@vger.kernel.org
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Yanteng Si <si.yanteng@linux.dev>
Reviewed-by: WANG Xuerui <git@xen0n.name>
Reviewed-by: Xi Ruoyao <xry111@xry111.site>
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/include/asm/vdso/getrandom.h    |    2 +-
 arch/loongarch/include/asm/vdso/gettimeofday.h |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/arch/loongarch/include/asm/vdso/getrandom.h
+++ b/arch/loongarch/include/asm/vdso/getrandom.h
@@ -20,7 +20,7 @@ static __always_inline ssize_t getrandom
 
 	asm volatile(
 	"      syscall 0\n"
-	: "+r" (ret)
+	: "=r" (ret)
 	: "r" (nr), "r" (buffer), "r" (len), "r" (flags)
 	: "$t0", "$t1", "$t2", "$t3", "$t4", "$t5", "$t6", "$t7", "$t8",
 	  "memory");
--- a/arch/loongarch/include/asm/vdso/gettimeofday.h
+++ b/arch/loongarch/include/asm/vdso/gettimeofday.h
@@ -25,7 +25,7 @@ static __always_inline long gettimeofday
 
 	asm volatile(
 	"       syscall 0\n"
-	: "+r" (ret)
+	: "=r" (ret)
 	: "r" (nr), "r" (tv), "r" (tz)
 	: "$t0", "$t1", "$t2", "$t3", "$t4", "$t5", "$t6", "$t7",
 	  "$t8", "memory");
@@ -44,7 +44,7 @@ static __always_inline long clock_gettim
 
 	asm volatile(
 	"       syscall 0\n"
-	: "+r" (ret)
+	: "=r" (ret)
 	: "r" (nr), "r" (clkid), "r" (ts)
 	: "$t0", "$t1", "$t2", "$t3", "$t4", "$t5", "$t6", "$t7",
 	  "$t8", "memory");
@@ -63,7 +63,7 @@ static __always_inline int clock_getres_
 
 	asm volatile(
 	"       syscall 0\n"
-	: "+r" (ret)
+	: "=r" (ret)
 	: "r" (nr), "r" (clkid), "r" (ts)
 	: "$t0", "$t1", "$t2", "$t3", "$t4", "$t5", "$t6", "$t7",
 	  "$t8", "memory");


