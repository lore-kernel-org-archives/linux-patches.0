Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74DC63385A7;
	Wed,  3 Dec 2025 15:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777339; cv=none; b=mZcxZcPgs+sdsVmcRAGKe2XJyKDDbgmszbtIy9Y0sPiIEWp3gJF5vaByo/0iO0pPa3bdeDRbFSFcmhMMMOXs9u7r5QDZW/WkJWy1btMdTZCwkr6ZueuliWiEyuDI1QqlrQogZTfY7+x2pGgHRc5k02RCKr14Bj6PIutEgfTEXZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777339; c=relaxed/simple;
	bh=Q1YsiGOpztF3PcmmTChpmADjp+QfgT4E7PnY3ZWtBeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d+Dpo/TuV/57mB7iCfy2DPwto0O0o/C5uANNV4+WlkEfg8MgtbIYuTMvrfqHWND5h7DZKRtE5FMhPT416jB/YRBU3xXt2jJy0ph2ogba0jcvCxrnsMLJZ+Ac09DkcF2GcD5ucmWnePfC/cmCplo852Irgy3e+wWzHOUenTx/+nA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rU7g4jQj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rU7g4jQj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E61AAC4CEF5;
	Wed,  3 Dec 2025 15:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777339;
	bh=Q1YsiGOpztF3PcmmTChpmADjp+QfgT4E7PnY3ZWtBeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rU7g4jQjUpjz/PHivuQpdeOMVUL6EeBUEWBCUbBva9PqlwayAaSwtnRjegTjcgKCs
	 cHxXW2LWQ11d0IHNnJH7FvJvJk/SGuRDsMlfFOF4B+Aizb01mLR2Vqe+CgAiSvNH5o
	 uTy39BexEcrjZzKNnkyQIMT7lPbsm9t3ZYUn4pLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youngjun Park <youngjun.park@lge.com>,
	Chris Li <chrisl@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 142/146] mm: swap: remove duplicate nr_swap_pages decrement in get_swap_page_of_type()
Date: Wed,  3 Dec 2025 16:28:40 +0100
Message-ID: <20251203152351.670553767@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Youngjun Park <youngjun.park@lge.com>

[ Upstream commit f5e31a196edcd1f1bb44f26b6f9299b9a5b9b3c4 ]

After commit 4f78252da887, nr_swap_pages is decremented in
swap_range_alloc(). Since cluster_alloc_swap_entry() calls
swap_range_alloc() internally, the decrement in get_swap_page_of_type()
causes double-decrementing.

As a representative userspace-visible runtime example of the impact,
/proc/meminfo reports increasingly inaccurate SwapFree values.  The
discrepancy grows with each swap allocation, and during hibernation
when large amounts of memory are written to swap, the reported value
can deviate significantly from actual available swap space, misleading
users and monitoring tools.

Remove the duplicate decrement.

Link: https://lkml.kernel.org/r/20251102082456.79807-1-youngjun.park@lge.com
Fixes: 4f78252da887 ("mm: swap: move nr_swap_pages counter decrement from folio_alloc_swap() to swap_range_alloc()")
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
Acked-by: Chris Li <chrisl@kernel.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Kairui Song <kasong@tencent.com>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: <stable@vger.kernel.org> [6.17+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ adjusted context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/swapfile.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1866,10 +1866,8 @@ swp_entry_t get_swap_page_of_type(int ty
 	if (get_swap_device_info(si)) {
 		if (si->flags & SWP_WRITEOK) {
 			offset = cluster_alloc_swap_entry(si, 0, 1);
-			if (offset) {
+			if (offset)
 				entry = swp_entry(si->type, offset);
-				atomic_long_dec(&nr_swap_pages);
-			}
 		}
 		put_swap_device(si);
 	}


