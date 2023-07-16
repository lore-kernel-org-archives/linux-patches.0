Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27148F70
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 19:53:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08157C433C8;
	Sun, 16 Jul 2023 19:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537206;
	bh=BbcvVudddc8u9/yqBnr457mSYU+MbJhA6sCX10fcsWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IhJC2AqCUn6SVXpi5gjf4Wms/Frh/vS7Z5GS2Gky9DZU9+R2wMHvahXlE8su0IKVy
	 e/nixufOVUNRf3qN/ECtByMkxc8gX581kQfh0HxqDPdW1C17ULqDgAGzFOVEGxoFrw
	 11uejkKVlSH7BG6CCHxRK1IdEYfg+wWaYt5MUuuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 014/800] s390/kasan: fix insecure W+X mapping warning
Date: Sun, 16 Jul 2023 21:37:47 +0200
Message-ID: <20230716194949.436211575@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexander Gordeev <agordeev@linux.ibm.com>

[ Upstream commit 2ed8b509753a0454b52b2d72e982265472c8d861 ]

Since commit 3b5c3f000c2e ("s390/kasan: move shadow mapping
to decompressor") the decompressor establishes mappings for
the shadow memory and sets initial protection attributes to
RWX. The decompressed kernel resets protection to RW+NX
later on.

In case a shadow memory range is not aligned on page boundary
(e.g. as result of mem= kernel command line parameter use),
the "Checked W+X mappings: FAILED, 1 W+X pages found" warning
hits.

Reported-by: Vasily Gorbik <gor@linux.ibm.com>
Fixes: 557b19709da9 ("s390/kasan: move shadow mapping to decompressor")
Reviewed-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/mm/vmem.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/s390/mm/vmem.c b/arch/s390/mm/vmem.c
index 5b22c6e24528a..b9dcb4ae6c59a 100644
--- a/arch/s390/mm/vmem.c
+++ b/arch/s390/mm/vmem.c
@@ -667,7 +667,15 @@ static void __init memblock_region_swap(void *a, void *b, int size)
 
 #ifdef CONFIG_KASAN
 #define __sha(x)	((unsigned long)kasan_mem_to_shadow((void *)x))
+
+static inline int set_memory_kasan(unsigned long start, unsigned long end)
+{
+	start = PAGE_ALIGN_DOWN(__sha(start));
+	end = PAGE_ALIGN(__sha(end));
+	return set_memory_rwnx(start, (end - start) >> PAGE_SHIFT);
+}
 #endif
+
 /*
  * map whole physical memory to virtual memory (identity mapping)
  * we reserve enough space in the vmalloc area for vmemmap to hotplug
@@ -737,10 +745,8 @@ void __init vmem_map_init(void)
 	}
 
 #ifdef CONFIG_KASAN
-	for_each_mem_range(i, &base, &end) {
-		set_memory_rwnx(__sha(base),
-				(__sha(end) - __sha(base)) >> PAGE_SHIFT);
-	}
+	for_each_mem_range(i, &base, &end)
+		set_memory_kasan(base, end);
 #endif
 	set_memory_rox((unsigned long)_stext,
 		       (unsigned long)(_etext - _stext) >> PAGE_SHIFT);
-- 
2.39.2



