Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7521F7094;
	Tue,  3 Dec 2024 14:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237746; cv=none; b=jhw4o5Y/ICnbajhMQztoprd3hfmiMy+X14moyE7xVCRQ/3tZVF10S20YoGIlD+9u1mKwC4S7iVrdafUi9wHmPa6yS70JGJOJDQLXPz2f3augPHgIgaWUD5MgYagIYuVvEzD61uKzOb8i14hkKV4q5+/hzr/Dk+YONscb8MMtSy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237746; c=relaxed/simple;
	bh=R5fhaiT8gjXudYxmXrb06btVTd+LPkuaEPJE23svYbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H63kXzyNC31CNw6B6vSoKU4qe6HM3OSKD4WOfZjZjCRHKl/96r025AQ4fv1u2kav23YhTGq67MB/Q/JRfPszJoe3/V9lpLsrl11zkm4zUk5Eu12bXhmlH3SiBaHMIyN4HykPBzIAoFlPnYjXz+Rhne5MIVNT0MhxYevieYbIe9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fa6kseVW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fa6kseVW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6D75C4CECF;
	Tue,  3 Dec 2024 14:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237746;
	bh=R5fhaiT8gjXudYxmXrb06btVTd+LPkuaEPJE23svYbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fa6kseVWOJLVSztOk84cduN497XrUc5cut8K7JHkqqwiF4dKchIZIoJrVmOAsGP0g
	 6bzI6adc4pb2aphAHOxJ+e+btRwWq4BNgfjugH/hDiuTANfwJn/tqppb6SW37uUzOY
	 taCwtDKs39bM9p5bWYEJBBSLtuie+tb60eE9B4rQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 058/817] s390/pageattr: Implement missing kernel_page_present()
Date: Tue,  3 Dec 2024 15:33:50 +0100
Message-ID: <20241203143957.948781459@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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
index 5f805ad42d4c3..aec9eb16b6f7b 100644
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



