Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9784011188;
	Sat,  3 Feb 2024 04:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933489; cv=none; b=AFajmR4ijNR4OPyTOrIvMXhJwbqnvMQP8LaDFi08TR1SXNhSg1ksxxyS234ejY54k//sK5pv+HQ4bPJUHE+7RSZCRXkDFOd/Xl5a38oP7a1uBUPG9kgD1LrDmBfCnWwDwVlnc9W3O3UINwMjI7kBW6o6ZVInLcUqnHuPkyonRDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933489; c=relaxed/simple;
	bh=blwHsdYyEvbRpH5qK+4dkmmGF9JPQslvf/u8mRBcX84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tTbZ/8komrXgVP+j5pjWLJu6hviF2N3xOJK6Xpd88Jogk58qQywVlkKQJnEq29NkbwQpwfBNJdY3eVo8IlQ6yc8+TI5XAhmPXz/aR4wlXetorDUWOzaSFH2KXNTyVQ7JNXSNEGiP9SvKfHEf9et3BZiYjhvjsDR3flyD926+EDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HI0AqwTM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HI0AqwTM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62E2AC433F1;
	Sat,  3 Feb 2024 04:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933489;
	bh=blwHsdYyEvbRpH5qK+4dkmmGF9JPQslvf/u8mRBcX84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HI0AqwTMKPBWVtKccTZm/WmzOBJb8CyFv6Qe7+UW38UswABTJuarnoetBrw1fhpEg
	 WPiy/gtCM3AasVBxYrKcl4dkcpj3PDWXBa02gc9iAalgNJjd5SW6HZwNejXumVvpDY
	 XfEYSGOwuWo3pWcMqWpyuneUJXZT3LlO5UfmFdoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 007/322] powerpc/mm: Fix build failures due to arch_reserved_kernel_pages()
Date: Fri,  2 Feb 2024 20:01:44 -0800
Message-ID: <20240203035359.290036237@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 52cc25864a1b..d8b7e246a32f 100644
--- a/arch/powerpc/include/asm/mmu.h
+++ b/arch/powerpc/include/asm/mmu.h
@@ -412,5 +412,9 @@ extern void *abatron_pteptrs[2];
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



