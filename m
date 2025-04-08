Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24C71FBCB2;
	Tue,  8 Apr 2025 11:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110302; cv=none; b=mlVCRqRyUmgmsQpo8J7b4axDfmemjB0I4/nZGH3blyyircIHT3W+z+aLbAIOppoYx7ovzy5yWEA8fzNyzi8+qGwJ0rcbjnQR/tMVJRLA5HSxgbabFQX9NaUfHdNb057dLaW6mKCON6zp487dgbTHBKYYRh7LoQU+/Qs9tGnlKJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110302; c=relaxed/simple;
	bh=twDh1bBcRgM61ay+PkY6+0yAjEbnTMYOd9M+PhZ9uZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EtIie0nwABa0zCl10nHdAMMXdX7gve20EgaBBH2j5mVHU1Jptj9cT4BjlvOgE2kL+9zuA9kfWbs6rlw4Zip0RCTiKqv2TM4CGO3acqjkT4I0godAzrU4HptzyECr2BQqmt/jYGbGompul1q80CLtyIEhdQCRb3ifvsNWxqzL+ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UWygUd27; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UWygUd27"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6469CC4CEE5;
	Tue,  8 Apr 2025 11:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110302;
	bh=twDh1bBcRgM61ay+PkY6+0yAjEbnTMYOd9M+PhZ9uZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UWygUd2778n1gAQXPC9g8KYGFmSS6blr1nS4oCHUYmwPz2u+LLPpr1JQUHrPilMNZ
	 VXA4p2YBfI4gcmi2kRnr9eqmZanT4ZHEXXsXLped7uHE0qZUB3H5mUzdoD+N/rrF2+
	 XI1oF0Za/g93Or2MxFW+D3woW/5rQ2Q8Wcyioows=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 015/731] x86/vdso: Fix latent bug in vclock_pages calculation
Date: Tue,  8 Apr 2025 12:38:32 +0200
Message-ID: <20250408104914.615856773@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit 3ef32d90cdaa0cfa6c4ffd18f8d646a658163e3d ]

The vclock pages are *after* the non-vclock pages. Currently there are both
two vclock and two non-vclock pages so the existing logic works by
accident.  As soon as the number of pages changes it will break however.
This will be the case with the introduction of the generic vDSO data
storage.

Use a macro to keep the calculation understandable and in sync between
the linker script and mapping code.

Fixes: e93d2521b27f ("x86/vdso: Split virtual clock pages into dedicated mapping")
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/all/20250204-vdso-store-rng-v3-1-13a4669dfc8c@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/entry/vdso/vdso-layout.lds.S | 2 +-
 arch/x86/entry/vdso/vma.c             | 2 +-
 arch/x86/include/asm/vdso/vsyscall.h  | 1 +
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/entry/vdso/vdso-layout.lds.S b/arch/x86/entry/vdso/vdso-layout.lds.S
index 872947c1004c3..918606ff92a98 100644
--- a/arch/x86/entry/vdso/vdso-layout.lds.S
+++ b/arch/x86/entry/vdso/vdso-layout.lds.S
@@ -24,7 +24,7 @@ SECTIONS
 
 	timens_page  = vvar_start + PAGE_SIZE;
 
-	vclock_pages = vvar_start + VDSO_NR_VCLOCK_PAGES * PAGE_SIZE;
+	vclock_pages = VDSO_VCLOCK_PAGES_START(vvar_start);
 	pvclock_page = vclock_pages + VDSO_PAGE_PVCLOCK_OFFSET * PAGE_SIZE;
 	hvclock_page = vclock_pages + VDSO_PAGE_HVCLOCK_OFFSET * PAGE_SIZE;
 
diff --git a/arch/x86/entry/vdso/vma.c b/arch/x86/entry/vdso/vma.c
index 39e6efc1a9cab..aa62949335ece 100644
--- a/arch/x86/entry/vdso/vma.c
+++ b/arch/x86/entry/vdso/vma.c
@@ -290,7 +290,7 @@ static int map_vdso(const struct vdso_image *image, unsigned long addr)
 	}
 
 	vma = _install_special_mapping(mm,
-				       addr + (__VVAR_PAGES - VDSO_NR_VCLOCK_PAGES) * PAGE_SIZE,
+				       VDSO_VCLOCK_PAGES_START(addr),
 				       VDSO_NR_VCLOCK_PAGES * PAGE_SIZE,
 				       VM_READ|VM_MAYREAD|VM_IO|VM_DONTDUMP|
 				       VM_PFNMAP,
diff --git a/arch/x86/include/asm/vdso/vsyscall.h b/arch/x86/include/asm/vdso/vsyscall.h
index 37b4a70559a82..88b31d4cdfaf3 100644
--- a/arch/x86/include/asm/vdso/vsyscall.h
+++ b/arch/x86/include/asm/vdso/vsyscall.h
@@ -6,6 +6,7 @@
 #define __VVAR_PAGES	4
 
 #define VDSO_NR_VCLOCK_PAGES	2
+#define VDSO_VCLOCK_PAGES_START(_b)	((_b) + (__VVAR_PAGES - VDSO_NR_VCLOCK_PAGES) * PAGE_SIZE)
 #define VDSO_PAGE_PVCLOCK_OFFSET	0
 #define VDSO_PAGE_HVCLOCK_OFFSET	1
 
-- 
2.39.5



