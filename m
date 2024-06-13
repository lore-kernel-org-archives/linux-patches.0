Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18532161;
	Thu, 13 Jun 2024 12:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282331; cv=none; b=SG0S/6mk5MpFRvgkmTxi96spRgrUDVJQyzaStHitan0K4Es3y4oN6OvNLE+fPq02Ba+f9v9hvxNa8kHuAb8czEyNImZl5lwgJQ0jl0sNvCtfn0cDaYl4hy/g/uLgjVV/pB2kv9dcRWSEaGNhvjpwnQK5TgC8WXe8R9C5VQWJdRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282331; c=relaxed/simple;
	bh=wT01WIPyJIwBsz4THtRKuk9NL4XnR6/RSb48D/sHQNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OY9t4HLymoikmKw/tgZf+iqk0gxdeCqnxIhnw2MJnQqFmMMPzsKYfEDKu+sAjCy3eAZCm2Z4AiZqzSzFikcOWyYFvlUbukd+pKrqqaEOTYI24yctV91syQOgJmoOD4Thhf9wZkHmL4Z+Ea5P6ddngh1lpsEL6AfGhAeSuIfaUps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=koyByUoU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="koyByUoU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36D53C2BBFC;
	Thu, 13 Jun 2024 12:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282330;
	bh=wT01WIPyJIwBsz4THtRKuk9NL4XnR6/RSb48D/sHQNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=koyByUoURfW0GlNp8CZvl5e1yM4J/d5Cxkw8maGILa8SG/4Bzyc9GTpuDnq/5Vjig
	 m06cgGU6x+cOb2rRGtpYWvnWbCTSu0rvfSkOg53U5Q8+WGVcoHQmJYZeBNGf1yhcoH
	 4lplLYPOsd9D43UCAtBfDTtrzSYbf2pRU/mEHf5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 240/402] s390/vdso64: filter out munaligned-symbols flag for vdso
Date: Thu, 13 Jun 2024 13:33:17 +0200
Message-ID: <20240613113311.508164231@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sumanth Korikkar <sumanthk@linux.ibm.com>

[ Upstream commit 8192a1b3807510d0ed5be1f8988c08f8d41cced9 ]

Gcc recently implemented an optimization [1] for loading symbols without
explicit alignment, aligning with the IBM Z ELF ABI. This ABI mandates
symbols to reside on a 2-byte boundary, enabling the use of the larl
instruction. However, kernel linker scripts may still generate unaligned
symbols. To address this, a new -munaligned-symbols option has been
introduced [2] in recent gcc versions.

[1] https://gcc.gnu.org/pipermail/gcc-patches/2023-June/622872.html
[2] https://gcc.gnu.org/pipermail/gcc-patches/2023-August/625986.html

However, when -munaligned-symbols  is used in vdso code, it leads to the
following compilation error:
`.data.rel.ro.local' referenced in section `.text' of
arch/s390/kernel/vdso64/vdso64_generic.o: defined in discarded section
`.data.rel.ro.local' of arch/s390/kernel/vdso64/vdso64_generic.o

vdso linker script discards .data section to make it lightweight.
However, -munaligned-symbols in vdso object files references literal
pool and accesses _vdso_data. Hence, compile vdso code without
-munaligned-symbols.  This means in the future, vdso code should deal
with alignment of newly introduced unaligned linker symbols.

Acked-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Link: https://lore.kernel.org/r/20240219132734.22881-2-sumanthk@linux.ibm.com
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Stable-dep-of: 10f705253651 ("s390/vdso: Generate unwind information for C modules")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/vdso64/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/s390/kernel/vdso64/Makefile b/arch/s390/kernel/vdso64/Makefile
index 08e87b083647c..e2e031e4d9243 100644
--- a/arch/s390/kernel/vdso64/Makefile
+++ b/arch/s390/kernel/vdso64/Makefile
@@ -26,6 +26,7 @@ KBUILD_AFLAGS_64 += -m64 -s
 
 KBUILD_CFLAGS_64 := $(filter-out -m64,$(KBUILD_CFLAGS))
 KBUILD_CFLAGS_64 := $(filter-out -mno-pic-data-is-text-relative,$(KBUILD_CFLAGS_64))
+KBUILD_CFLAGS_64 := $(filter-out -munaligned-symbols,$(KBUILD_CFLAGS_64))
 KBUILD_CFLAGS_64 += -m64 -fPIC -fno-common -fno-builtin
 ldflags-y := -shared -soname=linux-vdso64.so.1 \
 	     --hash-style=both --build-id=sha1 -T
-- 
2.43.0



