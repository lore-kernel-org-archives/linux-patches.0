Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED6497D414;
	Wed, 21 Feb 2024 13:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522309; cv=none; b=LxhFiO5/iJxVnXAj3wXPjbhRY95WXc6HWfW9xav3lbFoVwgBfW/B9DbPA6kZVuQ/A+jE61GiiG4olRuDG24R2NHNur6B7w9edsTs8TEjGagVcp1cY5qa0cMn2tuWGfKhgiMHRKenq8oMYGdKZf5ibNP+cmmS/6OI54AzWLaZhbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522309; c=relaxed/simple;
	bh=eJA08cV1KZTMOiGxLlfKoSNiLeunpXUfZE5PWwGifzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gJuOOn7ESNkqcOSH6xGz093RxfGDQ9VmKSx3a3iqPcVtvj+D5hlQZ8G/UoMzZzCvwqhwDvwcLLYTeBAfYbz9jnQgic+xiegxajW9vQ+rnSpXJvqGMGikIWe2DcIgY2Ord5TM0VJ+WHdZIWfkUIHZD1e1XHtyWJLGtugnaEm3NE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YVqy1SEj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YVqy1SEj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B30FC433C7;
	Wed, 21 Feb 2024 13:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522307;
	bh=eJA08cV1KZTMOiGxLlfKoSNiLeunpXUfZE5PWwGifzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YVqy1SEjk7DDe6hGQFhvHIqbo9+sRvuzISWkNx6Mky5I3QiSOys3KhQPEPABrYow1
	 kCuiUgha8ISOMl29VRgxBaEmXdZzWFeQc3lPRXJAEs7pBLxxVII3knYJUXxcBNPnA4
	 n/ryP9HkTC+dwPdFjJGtINAFTPZV5gkMovs4Srjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 129/476] powerpc/mm: Fix build failures due to arch_reserved_kernel_pages()
Date: Wed, 21 Feb 2024 14:03:00 +0100
Message-ID: <20240221130012.726436059@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
User-Agent: quilt/0.67
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit d8c3f243d4db24675b653f0568bb65dae34e6455 ]

With NUMA=n and FA_DUMP=y or PRESERVE_FA_DUMP=y the build fails with:

  arch/powerpc/kernel/fadump.c:1739:22: error: no previous prototype for ‘arch_reserved_kernel_pages’ [-Werror=missing-prototypes]
  1739 | unsigned long __init arch_reserved_kernel_pages(void)
       |                      ^~~~~~~~~~~~~~~~~~~~~~~~~~

The prototype for arch_reserved_kernel_pages() is in include/linux/mm.h,
but it's guarded by __HAVE_ARCH_RESERVED_KERNEL_PAGES. The powerpc
headers define __HAVE_ARCH_RESERVED_KERNEL_PAGES in asm/mmzone.h, which
is not included into the generic headers when NUMA=n.

Move the definition of __HAVE_ARCH_RESERVED_KERNEL_PAGES into asm/mmu.h
which is included regardless of NUMA=n.

Additionally the ifdef around __HAVE_ARCH_RESERVED_KERNEL_PAGES needs to
also check for CONFIG_PRESERVE_FA_DUMP.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20231130114433.3053544-1-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/mmu.h    | 4 ++++
 arch/powerpc/include/asm/mmzone.h | 3 ---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/include/asm/mmu.h b/arch/powerpc/include/asm/mmu.h
index 8abe8e42e045..de0bb77f54e0 100644
--- a/arch/powerpc/include/asm/mmu.h
+++ b/arch/powerpc/include/asm/mmu.h
@@ -416,5 +416,9 @@ extern void *abatron_pteptrs[2];
 #include <asm/nohash/mmu.h>
 #endif
 
+#if defined(CONFIG_FA_DUMP) || defined(CONFIG_PRESERVE_FA_DUMP)
+#define __HAVE_ARCH_RESERVED_KERNEL_PAGES
+#endif
+
 #endif /* __KERNEL__ */
 #endif /* _ASM_POWERPC_MMU_H_ */
diff --git a/arch/powerpc/include/asm/mmzone.h b/arch/powerpc/include/asm/mmzone.h
index 4c6c6dbd182f..3764d3585d30 100644
--- a/arch/powerpc/include/asm/mmzone.h
+++ b/arch/powerpc/include/asm/mmzone.h
@@ -42,9 +42,6 @@ u64 memory_hotplug_max(void);
 #else
 #define memory_hotplug_max() memblock_end_of_DRAM()
 #endif /* CONFIG_NUMA */
-#ifdef CONFIG_FA_DUMP
-#define __HAVE_ARCH_RESERVED_KERNEL_PAGES
-#endif
 
 #ifdef CONFIG_MEMORY_HOTPLUG
 extern int create_section_mapping(unsigned long start, unsigned long end,
-- 
2.43.0



