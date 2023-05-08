Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322F4168C5
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:49:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A34D3C433D2;
	Mon,  8 May 2023 10:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542942;
	bh=m6hWB4ZdwqCUjX/JEb+H73QfA1xko8i3kGsZiDlrHak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kDmFrJHc4FIin1rhS0h42Rbh5i7f8UgH4BQ8cfmmiwpfQf2XMNLUjDFqCjDnR8qWh
	 KkBjqWaEdgZqhjj/7GvZ5qndc+Fv06DdMDu6zHgF+igrpCfZEqcS9dDAYp977QJJA5
	 ClD4ossH45muanoMdsoXRtKzCpwyGsquIYTb0iTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mikelley@microsoft.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 563/663] swiotlb: fix debugfs reporting of reserved memory pools
Date: Mon,  8 May 2023 11:46:29 +0200
Message-Id: <20230508094447.442237720@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michael Kelley <mikelley@microsoft.com>

[ Upstream commit 5499d01c029069044a3b3e50501c77b474c96178 ]

For io_tlb_nslabs, the debugfs code reports the correct value for a
specific reserved memory pool.  But for io_tlb_used, the value reported
is always for the default pool, not the specific reserved pool. Fix this.

Fixes: 5c850d31880e ("swiotlb: fix passing local variable to debugfs_create_ulong()")
Signed-off-by: Michael Kelley <mikelley@microsoft.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/swiotlb.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 465cd2b5481f1..81f40821084ec 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -935,7 +935,9 @@ EXPORT_SYMBOL_GPL(is_swiotlb_active);
 
 static int io_tlb_used_get(void *data, u64 *val)
 {
-	*val = mem_used(&io_tlb_default_mem);
+	struct io_tlb_mem *mem = data;
+
+	*val = mem_used(mem);
 	return 0;
 }
 DEFINE_DEBUGFS_ATTRIBUTE(fops_io_tlb_used, io_tlb_used_get, NULL, "%llu\n");
@@ -948,7 +950,7 @@ static void swiotlb_create_debugfs_files(struct io_tlb_mem *mem,
 		return;
 
 	debugfs_create_ulong("io_tlb_nslabs", 0400, mem->debugfs, &mem->nslabs);
-	debugfs_create_file("io_tlb_used", 0400, mem->debugfs, NULL,
+	debugfs_create_file("io_tlb_used", 0400, mem->debugfs, mem,
 			&fops_io_tlb_used);
 }
 
-- 
2.39.2



