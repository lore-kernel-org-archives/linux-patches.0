Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063415;
	b=1cOrLdIJyGUWwnSChjhADujlDFYTuycyiK0zlaPMHu2PgAILJaJhzuwi05wqJu7k6c4V
	 xKYQdOpJfd+4pMAIfi1arqqDy5rmPuwq34Zgvfj380FgcZYMDJmfyvGi4braTE9AuWPyB
	 CSzhNbJnQUUM6FX7j0otySdsXVpG8AKxbV58PdImWjeH7PiM7AiqpoPCgYywgJ6Hgb4q/
	 ho68JOLSDfl7iQrc/d72kZ0zwOa+gJcCJtVhIEqZtWERNx+AaCgKy7IdtkIiB3rPsmxhC
	 RcgIKwPVw6kbYhnQtRETNZ5HP9y4CmgyxLHhaUrmdlywbtjYJNiGFwYmj7RoLA4Bitg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063415;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U5G3wNM0xceQ3VuuaXR/n71QjuaecDz2ArBVBm54CyQ=;
	b=dOUSKEZe2ABVxbJm90M5x3JOljAMIax80sUCWv+9h/2gTbZ8l3a3SuSV+oHbnSJKB9nY
	 Jg3X26tRklL2mhHOptGjBhwQG6tOPFYrutRKEY7FpR8c1yQyneX0hiFx/Ug28MLmPaUGq
	 hTFYxdyp3T+Saxufm5n/Gtj1NASZmdX54tWcTNeAIKSzLMdbRMxnR07wL+uUHsDMOlY99
	 UywND4LhvdCzKWeCZdG8wm6jJw00ZJgfUbO/ShFTtPAMyaxcSCZIqUmsiglSZjVAHrSJB
	 //LUrBZYmsq3ynJOFNy8phb3fgaLyBX5zo+VG43wJoW/k2xARud9yhG3n4F2YpuNRew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=heXsuE2a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558FB606A336;
	Sat,  7 Nov 2026 14:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=heXsuE2a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0450B1F008A1;
	Sat,  7 Nov 2026 14:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063415;
	bh=U5G3wNM0xceQ3VuuaXR/n71QjuaecDz2ArBVBm54CyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=heXsuE2aRagPUNHuUR3eU1RMMuD8meEz601ar/6zp6PsFZv9CoYqmctzZeBUx3gXk
	 7/GDxpvDWOc2LA1OIq+/JyTswUv5dXMPW/2PC4GNY4ECs7JivI7j2+GwJKXqX35VGU
	 AFfb4WmyYKY0Pb0D1JYWTckDntiXQNVCLf1FtOQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 583/869] efi/libstub: arm64: Dont use the platform register x18
Date: Sat,  7 Nov 2026 08:54:25 -0500
Message-ID: <20261107134912.932606527@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit 4c86b5f3fa78347fa9cbc9e8ec06615b2f80e397 ]

The UEFI specification designates x18, the platform register, as "do not
use" on AArch64, so that UEFI code is compatible both with an OS that
assigns a fixed role to x18, and with one that uses it as a temporary
register.

The arm64 EFI stub and the EFI zboot decompressor only avoid x18 if the
kernel is built with shadow call stacks, as that is the only case where
-ffixed-x18 is added to KBUILD_CFLAGS, which the stub inherits.
Otherwise, the compiler is free to use x18 as a temporary register, and
it does so.

So pass -ffixed-x18 unconditionally when building the stub for arm64,
so that the image can be run by loaders that rely on x18 being left
alone, such as a kernel that uses it for its shadow call stack.

Cc: <stable@vger.kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/libstub/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index 94b05e4451dd3..c532ba5503522 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -22,7 +22,7 @@ cflags-$(CONFIG_X86)		+= -m$(BITS) -D__KERNEL__ -std=gnu11 \
 
 # arm64 uses the full KBUILD_CFLAGS so it's necessary to explicitly
 # disable the stackleak plugin
-cflags-$(CONFIG_ARM64)		+= -fpie $(DISABLE_KSTACK_ERASE) \
+cflags-$(CONFIG_ARM64)		+= -fpie $(DISABLE_KSTACK_ERASE) -ffixed-x18 \
 				   -fno-unwind-tables -fno-asynchronous-unwind-tables
 cflags-$(CONFIG_ARM)		+= -DEFI_HAVE_STRLEN -DEFI_HAVE_STRNLEN \
 				   -DEFI_HAVE_MEMCHR -DEFI_HAVE_STRRCHR \
-- 
2.53.0



