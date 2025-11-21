Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ACBC2749C5;
	Fri, 21 Nov 2025 13:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731912; cv=none; b=ZHoOzsW8sorZhhsUPT/4YUE5UNv0nCIpw2tTac5jlPUvSKCyyhvocLytIbQLCX2IctEU0wSyFPHgzecTtEfgaKsdlzipX43dMUfRx8tJhnMptWDDcWrYNf4rZPr9WT2G7DM/YuO7RqpyaZ/IQJgyur5eWcVQtFFt9tHMjuwn6Mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731912; c=relaxed/simple;
	bh=fApCtWAHpwousLSOn00exviB02BpAwm2aCALXOe2af8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QogEowR4w8exV9/7dt0Lx9FdyQWqlpzSBNa9aoJduBNNVO6ktRGpzkzgewdzDp3rdfuhK30YQb9gFEJFil20Jnh1SvkAVBCDhZd3fBrPjSqgruoqbgpvDu53EIDAnWI0WKMAdveyaaapZgaZN8cGudiOkC0gbeQkdgUx5b7HNyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AKz63Hmx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AKz63Hmx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F26FFC4CEF1;
	Fri, 21 Nov 2025 13:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731912;
	bh=fApCtWAHpwousLSOn00exviB02BpAwm2aCALXOe2af8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AKz63Hmxc9hi9GfftCsW5My9Nw2D3j8efmgmDYjnxnoOWpWqjL9x7LVq/s/JRQPJF
	 23OKZdE3q1Pd4MO7MFAI/5+wSOJbrS7sfEf2WgjchCEEabEt+W6GnVwQL8CDOCNVLv
	 wFenf2PLTNAWkb/ul5k6W5UpfNlOdOOn/alwPsE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Rajani Kantha <681739313@139.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 091/185] f2fs: fix to avoid overflow while left shift operation
Date: Fri, 21 Nov 2025 14:11:58 +0100
Message-ID: <20251121130147.152214791@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Chao Yu <chao@kernel.org>

[ Upstream commit 0fe1c6bec54ea68ed8c987b3890f2296364e77bb ]

Should cast type of folio->index from pgoff_t to loff_t to avoid overflow
while left shift operation.

Fixes: 3265d3db1f16 ("f2fs: support partial truncation on compressed inode")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
[ Modification: Using rpages[i]->index instead of folio->index due to
it was changed since commit:1cda5bc0b2fe ("f2fs: Use a folio in
f2fs_truncate_partial_cluster()") on 6.14 ]
Signed-off-by: Rajani Kantha <681739313@139.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/compress.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/compress.c b/fs/f2fs/compress.c
index b05bb7bfa14c5..fcd21bb060cd4 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -1236,7 +1236,7 @@ int f2fs_truncate_partial_cluster(struct inode *inode, u64 from, bool lock)
 		int i;
 
 		for (i = cluster_size - 1; i >= 0; i--) {
-			loff_t start = rpages[i]->index << PAGE_SHIFT;
+			loff_t start = (loff_t)rpages[i]->index << PAGE_SHIFT;
 
 			if (from <= start) {
 				zero_user_segment(rpages[i], 0, PAGE_SIZE);
-- 
2.51.0



