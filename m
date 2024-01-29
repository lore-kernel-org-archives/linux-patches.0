Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA52E76C74;
	Mon, 29 Jan 2024 17:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548651; cv=none; b=CRJc9ZklYPOFJ1OeAA6R8jDYmSEU8H791UGXN26DjPhSOCngO2QPHSAKQF3Dl/RM5ONjtptfk2W1G858naBX045QH2QeVxGZlZuHTqz6JY9rHjJM2sBOigbvG81v/sK0tri7rzdE6VrxPLmBPYPLUIRFeqfFtqJHlp/vTQD8azw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548651; c=relaxed/simple;
	bh=ydoCGOxFdPWf6peYEuI+pRRoMHUmqSOw8yGNWcLwQ6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l/OtESu5UaVsK6UBVpVmWvfKTH7qYDQuy8/Q3yRKubjaNCMmfU203WLYUhodjYesMJyrqh0dvb7AWz9AbQUNKeVVzZ6jeNB7K40lQ5yxJSVhJOKskIarxqFYL00g7CdaMtqXwZ6xNgSkn5eaUGsIewk9UOLd4P1Yz6SC+ZmQt+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zy8lIyYM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zy8lIyYM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FB08C43399;
	Mon, 29 Jan 2024 17:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548651;
	bh=ydoCGOxFdPWf6peYEuI+pRRoMHUmqSOw8yGNWcLwQ6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zy8lIyYMhQ/BVgVh0IZPHDggwVVpFIijb0BNGgVgDXtYjd2s56t0Xo7iK9Bu00obc
	 xq++YicuDzQ6eD1XPjMHDhXuo6+QWPLoLFYbHv1upDn0xIPmVTarn00vGqfRjnUKDC
	 yLxLWLhS0JX966gwmmrnAhVM5ppfuuVqKKRpcvT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yajun Deng <yajun.deng@linux.dev>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 307/331] memblock: fix crash when reserved memory is not added to memory
Date: Mon, 29 Jan 2024 09:06:11 -0800
Message-ID: <20240129170023.866484375@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

From: Yajun Deng <yajun.deng@linux.dev>

[ Upstream commit 6a9531c3a88096a26cf3ac582f7ec44f94a7dcb2 ]

After commit 61167ad5fecd ("mm: pass nid to reserve_bootmem_region()")
nid of a reserved region is used by init_reserved_page() (with
CONFIG_DEFERRED_STRUCT_PAGE_INIT=y) to access node strucure.
In many cases the nid of the reserved memory is not set and this causes
a crash.

When the nid of a reserved region is not set, fall back to
early_pfn_to_nid(), so that nid of the first_online_node will be passed
to init_reserved_page().

Fixes: 61167ad5fecd ("mm: pass nid to reserve_bootmem_region()")
Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
Link: https://lore.kernel.org/r/20240118061853.2652295-1-yajun.deng@linux.dev
[rppt: massaged the commit message]
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memblock.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/memblock.c b/mm/memblock.c
index 913b2520a9a0..6d18485571b4 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2119,6 +2119,9 @@ static void __init memmap_init_reserved_pages(void)
 		start = region->base;
 		end = start + region->size;
 
+		if (nid == NUMA_NO_NODE || nid >= MAX_NUMNODES)
+			nid = early_pfn_to_nid(PFN_DOWN(start));
+
 		reserve_bootmem_region(start, end, nid);
 	}
 }
-- 
2.43.0



