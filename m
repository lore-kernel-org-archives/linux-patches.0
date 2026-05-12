Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D5BE3EDE72;
	Tue, 12 May 2026 17:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608533; cv=none; b=lEobpWEzX6Hix320QzWjq7MQVqytuKtgqTI94ZvhU9fYg8AnYlgLFQ2EoZiWX99y7kKRbhrzNKENAz/vrHegj91uqMZVTPTSCe/gsdUkMtvKa8Dlqe9GPUM0jdHRPriJ+MoktJfN0mHtnHeXI4PMHpsKfMaDPIAG2+wwfeUhHgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608533; c=relaxed/simple;
	bh=5kXNYNUiEltnZ436MJVLqC4l4vwdkKyg4RMjmLlz3Q8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F1yjEab94SxBWZKobAt4bdWJfZznwG0c+4Jf3C8Ti4g0z51Ubarh+n8Gg3cKU/x/RRAmkO+CDkZU2PqDRXl5zGD6LbGmHgcow3sWgzMFpeOFrUOh0a35i+RgYifI2tkHc4qLqjOMqPbs0h5DeqsdLB3GBXA8FImwLNYAKXNUDY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1lFJU6sj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1lFJU6sj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF8F4C2BCB0;
	Tue, 12 May 2026 17:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608533;
	bh=5kXNYNUiEltnZ436MJVLqC4l4vwdkKyg4RMjmLlz3Q8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1lFJU6sjQ/QHK0OExvnkZRtfD4ct7lzPvD71LXdlkLG1knSYdoGA4i6E+Uv6QQSYL
	 s7iBsrw00KXUsIYSCC1aqRdxvVciceYVW1UnYMVT1X+etn//RQfnFizA/TJFOoO1fG
	 qeGvNVsKmILkkkawSadEJXfZgp7+wYFEWDGi71ns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Naman Jain <namjain@linux.microsoft.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 115/270] block: add pgmap check to biovec_phys_mergeable
Date: Tue, 12 May 2026 19:38:36 +0200
Message-ID: <20260512173940.879292117@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naman Jain <namjain@linux.microsoft.com>

commit 13920e4b7b784b40cf4519ff1f0f3e513476a499 upstream.

biovec_phys_mergeable() is used by the request merge, DMA mapping,
and integrity merge paths to decide if two physically contiguous
bvec segments can be coalesced into one. It currently has no check
for whether the segments belong to different dev_pagemaps.

When zone device memory is registered in multiple chunks, each chunk
gets its own dev_pagemap. A single bio can legitimately contain
bvecs from different pgmaps -- iov_iter_extract_bvecs() breaks at
pgmap boundaries but the outer loop in bio_iov_iter_get_pages()
continues filling the same bio. If such bvecs are physically
contiguous, biovec_phys_mergeable() will coalesce them, making it
impossible to recover the correct pgmap for the merged segment
via page_pgmap().

Add a zone_device_pages_have_same_pgmap() check to prevent merging
bvec segments that span different pgmaps.

Fixes: 49580e690755 ("block: add check when merging zone device pages")
Cc: stable@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Naman Jain <namjain@linux.microsoft.com>
Link: https://patch.msgid.link/20260410153414.4159050-2-namjain@linux.microsoft.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/block/blk.h
+++ b/block/blk.h
@@ -132,6 +132,8 @@ static inline bool biovec_phys_mergeable
 
 	if (addr1 + vec1->bv_len != addr2)
 		return false;
+	if (!zone_device_pages_have_same_pgmap(vec1->bv_page, vec2->bv_page))
+		return false;
 	if (xen_domain() && !xen_biovec_phys_mergeable(vec1, vec2->bv_page))
 		return false;
 	if ((addr1 | mask) != ((addr2 + vec2->bv_len - 1) | mask))


