Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C0E3149C69;
	Fri,  6 Dec 2024 14:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496607; cv=none; b=NSnuaSnLY66CSYAT2QN6xVR4yE/yujXL12eocvlAh2IIegOx2IN7mUPEDRgvLqEBPdzehXOliOySuXmoCbiMhgPB3UW/sQArolpkq1w8GZzjtk6Mp7BodFGRgWXeWPXObHgxa8Y9xBIC0cPjDSklGT02xUMM1EVNFc9D/s19Dkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496607; c=relaxed/simple;
	bh=gxMUlUBI/pRZoIPbNRU74VCeciBfFZWCN+cvfJ4CUb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UCCL+Z2S8RpvhgBuPLFa3USyCFhzUh2aX9WOYh7IYDyAoW6+dEt7PcJKvn7Q0BEd4qwCg0JE0muC5bw4Tx9bSd23qX4VWzzuVJbmfdqXY+CJAoCJyPX71ZRLjtZZ4TRovrHyFjQlq11qxUopohvCQH6virAdD9YHp3r2KndwKE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uDPCpxMY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uDPCpxMY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2969DC4CED1;
	Fri,  6 Dec 2024 14:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496606;
	bh=gxMUlUBI/pRZoIPbNRU74VCeciBfFZWCN+cvfJ4CUb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uDPCpxMYdZVPFpqxw4kwwmqG+ihs8Ovasux5lcWN7Jx7LfbvD37LVGFldu1XqtfPQ
	 hSuKn65M2RclIrhINFnBtvkclDrSEBWmDEidyhO48fGL2kH2J1AIBqxD6xwBcmpk4m
	 FQEJa5lNJB30Vt14+vFqAE3XUwuwAGKwWQ8drEVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 053/676] s390/pageattr: Implement missing kernel_page_present()
Date: Fri,  6 Dec 2024 15:27:52 +0100
Message-ID: <20241206143655.423171355@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 2835f8bf5530750c3381166005934f996a83ad05 ]

kernel_page_present() was intentionally not implemented when adding
ARCH_HAS_SET_DIRECT_MAP support, since it was only used for suspend/resume
which is not supported anymore on s390.

A new bpf use case led to a compile error specific to s390. Even though
this specific use case went away implement kernel_page_present(), so that
the API is complete and potential future users won't run into this problem.

Reported-by: Daniel Borkmann <daniel@iogearbox.net>
Closes: https://lore.kernel.org/all/045de961-ac69-40cc-b141-ab70ec9377ec@iogearbox.net
Fixes: 0490d6d7ba0a ("s390/mm: enable ARCH_HAS_SET_DIRECT_MAP")
Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/set_memory.h |  1 +
 arch/s390/mm/pageattr.c            | 15 +++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/arch/s390/include/asm/set_memory.h b/arch/s390/include/asm/set_memory.h
index 06fbabe2f66c9..cb4cc0f59012f 100644
--- a/arch/s390/include/asm/set_memory.h
+++ b/arch/s390/include/asm/set_memory.h
@@ -62,5 +62,6 @@ __SET_MEMORY_FUNC(set_memory_4k, SET_MEMORY_4K)
 
 int set_direct_map_invalid_noflush(struct page *page);
 int set_direct_map_default_noflush(struct page *page);
+bool kernel_page_present(struct page *page);
 
 #endif
diff --git a/arch/s390/mm/pageattr.c b/arch/s390/mm/pageattr.c
index 441f654d048d2..44271835c97e7 100644
--- a/arch/s390/mm/pageattr.c
+++ b/arch/s390/mm/pageattr.c
@@ -406,6 +406,21 @@ int set_direct_map_default_noflush(struct page *page)
 	return __set_memory((unsigned long)page_to_virt(page), 1, SET_MEMORY_DEF);
 }
 
+bool kernel_page_present(struct page *page)
+{
+	unsigned long addr;
+	unsigned int cc;
+
+	addr = (unsigned long)page_address(page);
+	asm volatile(
+		"	lra	%[addr],0(%[addr])\n"
+		"	ipm	%[cc]\n"
+		: [cc] "=d" (cc), [addr] "+a" (addr)
+		:
+		: "cc");
+	return (cc >> 28) == 0;
+}
+
 #if defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_KFENCE)
 
 static void ipte_range(pte_t *pte, unsigned long address, int nr)
-- 
2.43.0



