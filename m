Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9BCC23E356;
	Tue, 12 May 2026 18:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609279; cv=none; b=T4t/OhNeP+czpOp7rMnzSLA/XdR8HNTccfFY0pINreahRaN5j3eO+CbL3i9QbfGvuhnSqIQ7jUY2oK0JaPVAUE4qB9uVxC0TEa7CGW0AtUANkDmGtuGwlbXsfvHiQQrQJiqXvfeYDKpzKmNP25aLymuoEihXyGwfOk9KCWzq5dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609279; c=relaxed/simple;
	bh=R1++CtntCiXSS6aLA1ZgqWX0YouQhUqyd4ChWm/psos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I6YFrvB6gWBpv+1V/hLhx1Xcuk67ypLocfCkix6kVpLI7WSbrbAGbhdjyEksj5P5RlXtPk+NCo4yZbWOzmipYvCBye43MEua4vIHpELROfTMnkFMaP9NLwUVsDjWhm8Zsl7E2TlQbriwGx6W1wuy+ooyQVkR5VWpkfV2ytXyaDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x+Z8N5n9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x+Z8N5n9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56D65C2BCB0;
	Tue, 12 May 2026 18:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609279;
	bh=R1++CtntCiXSS6aLA1ZgqWX0YouQhUqyd4ChWm/psos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x+Z8N5n9HR6dwhAwJFbeoJb1zODQd8KxlOBGQ+AoG2/jm3ZGTAvMOBv5ak3sj1Llr
	 GdMaXR/4etneXidBABKpVWV8Syt9OehXaJU98wjIXpnyZuACvBA22HWY+Jr8oPXsYF
	 z0cZTHJapWo29JqL+IeU78CVfIGSh/b2SPybJXHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Naman Jain <namjain@linux.microsoft.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.0 134/307] block: add pgmap check to biovec_phys_mergeable
Date: Tue, 12 May 2026 19:38:49 +0200
Message-ID: <20260512173942.957061031@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


