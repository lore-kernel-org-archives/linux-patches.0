Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4664D1D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BKkcs2h+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8AACC433C9;
	Wed,  4 Oct 2023 18:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443707;
	bh=Rccw9v0lL2ypQ4aQIjXfLmmDOjAYtbUdgXaaXI7tJU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BKkcs2h+RvkJS43UE2p/VgSAMK7/xv3depi11AwWG1jMu5EMjsH4zHwZ7f39yoeYc
	 ENmMGJmuD1ph3pvWLlMNDZEneuchIJF4+jFU2HR+w5Vj3bz+KBAeuaAwXjVAvOvHHS
	 vgG+gZkdpx6bnn3ZHo7YdIy/5obz8GmJjWkMtC68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chong Qiao <qiaochong@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.1 223/259] LoongArch: numa: Fix high_memory calculation
Date: Wed,  4 Oct 2023 19:56:36 +0200
Message-ID: <20231004175227.566545277@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
References: <20231004175217.404851126@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

commit 1943feecf80e73ecc03ce40271f29c6cea142bac upstream.

For 64bit kernel without HIGHMEM, high_memory is the virtual address of
the highest physical address in the system. But __va(get_num_physpages()
<< PAGE_SHIFT) is not what we want for high_memory because there may be
holes in the physical address space. On the other hand, max_low_pfn is
calculated from memblock_end_of_DRAM(), which is exactly corresponding
to the highest physical address, so use it for high_memory calculation.

Cc: <stable@vger.kernel.org>
Fixes: d4b6f1562a3c3284adce ("LoongArch: Add Non-Uniform Memory Access (NUMA) support")
Signed-off-by: Chong Qiao <qiaochong@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/numa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/loongarch/kernel/numa.c
+++ b/arch/loongarch/kernel/numa.c
@@ -453,7 +453,7 @@ void __init paging_init(void)
 
 void __init mem_init(void)
 {
-	high_memory = (void *) __va(get_num_physpages() << PAGE_SHIFT);
+	high_memory = (void *) __va(max_low_pfn << PAGE_SHIFT);
 	memblock_free_all();
 	setup_zero_pages();	/* This comes from node 0 */
 }


