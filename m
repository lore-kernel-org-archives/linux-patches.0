Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05D82F260C;
	Wed, 17 Sep 2025 12:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113189; cv=none; b=i4oVufS49oCPjv5zNzHhIYsrdn66uhU2jYys1fviH4I30ex6vDYfqGmntt15DLaoz8pmsgACrCyE94YLNOhljAZZck93ArHggN2M4VFLoIf2ec3PmW156cpkuLnxqob2/U4TlpaltJ1BWu9IDouo6kdz8AFjxU6nHyqv1PEzU4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113189; c=relaxed/simple;
	bh=RpqOWrPvv3tFu1Rk2JCVGKoRcB+8L6JGUUIwglfb4fk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VEo2rjg9ucN1deu97zziGuzK/V/GIKFIRpKWffQq938uH1XD/fmZ5I/nVt3qwe661j9KXB8y8LJiwVe8ErvJGNTArZk4SlzoG5Zm2O0n42Kugcv0pgYuWL5oQWZfFNrrfThp4/mO1ki2Cf0ZyZDh2HLL2nJHQu4MjBP3qq+tPm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NiGOgzkY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NiGOgzkY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6888BC4CEF0;
	Wed, 17 Sep 2025 12:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113188;
	bh=RpqOWrPvv3tFu1Rk2JCVGKoRcB+8L6JGUUIwglfb4fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NiGOgzkYlmZeN6EYLLe2p9g+a62RIuI6pcJ5jvrsDsvT7CibCjy9tAT9gKex9oLKG
	 BvQMC+nOASMMwtgouoKvfGQbkKhhASKJzvS/Y97O5F02aTCpEzSyHsfJUngXNPtFh3
	 22JzEEmvy3EBcVYK/98A5ciauMXt4mpUaZ6I3BH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	kernel test robot <lkp@intel.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 010/140] dma-mapping: fix swapped dir/flags arguments to trace_dma_alloc_sgt_err
Date: Wed, 17 Sep 2025 14:33:02 +0200
Message-ID: <20250917123344.570775046@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
References: <20250917123344.315037637@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Sean Anderson <sean.anderson@linux.dev>

[ Upstream commit d5bbfbad58ec0ccd187282f0e171bc763efa6828 ]

trace_dma_alloc_sgt_err was called with the dir and flags arguments
swapped. Fix this.

Fixes: 68b6dbf1f441 ("dma-mapping: trace more error paths")
Signed-off-by: Sean Anderson <sean.anderson@linux.dev>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202410302243.1wnTlPk3-lkp@intel.com/
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/mapping.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index c12c62ad8a6bf..c7cc4e33ec6e0 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -782,7 +782,7 @@ struct sg_table *dma_alloc_noncontiguous(struct device *dev, size_t size,
 		trace_dma_alloc_sgt(dev, sgt, size, dir, gfp, attrs);
 		debug_dma_map_sg(dev, sgt->sgl, sgt->orig_nents, 1, dir, attrs);
 	} else {
-		trace_dma_alloc_sgt_err(dev, NULL, 0, size, gfp, dir, attrs);
+		trace_dma_alloc_sgt_err(dev, NULL, 0, size, dir, gfp, attrs);
 	}
 	return sgt;
 }
-- 
2.51.0



