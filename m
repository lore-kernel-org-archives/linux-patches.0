Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAFF51F8907;
	Tue,  3 Dec 2024 15:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240073; cv=none; b=ZYW7FH4s/8zQ3hos1AWa/Rb4ZGY02yPA9FVIs38QZqnMLKyHGs/nlS4M0jUGKyxTsBhUUV/wv5eS0QRX7RbxaTgj5NwXnuK1fInErr+hzbT4A6Vuu7ZmJwTtYjaswXlfkYIdOKRDPc7AvPl0eXsP+ZSOF2qO74scmbbguxaJ88Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240073; c=relaxed/simple;
	bh=zhoKENNa80HehLkrK7GzHotJAW6fpZlWGL1DpoMFcVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iQdFmUv/X92zNQ4T1M31/KN6JHKZzgmQQWmaCEnfT3AxKUKeG0Uq5fmRF8BZbfv+LL1mY28MClTukk4++hCwsoHWXfdYrKv7t1ilvA0GFm+huygtUKTBayfCFZTnAsj6xFpWdmom0PHQ72hAzKTo1fUwsBnpU9Un99Ip0B7Qr84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YdfRE8aO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YdfRE8aO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 314DCC4CECF;
	Tue,  3 Dec 2024 15:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240073;
	bh=zhoKENNa80HehLkrK7GzHotJAW6fpZlWGL1DpoMFcVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YdfRE8aOjlsJGN4Zj78W+dgP/kSl+ClC7to15dCcHHW7EMS7aHt3dFB00B5B1YDzn
	 Jz4OB9t2yjQKOUO5Woqv5teIYIKsPgZbc8vbv2iGdi+IMw6IKdy6Dw6NqUEFufA/Qg
	 a0KveJnFB/6Z3OSj3vsfIAbXdFNHJb7V+1PRvm7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 014/826] s390/pageattr: Implement missing kernel_page_present()
Date: Tue,  3 Dec 2024 15:35:41 +0100
Message-ID: <20241203144744.011534438@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



