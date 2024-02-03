Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96FFE1C698;
	Sat,  3 Feb 2024 04:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933816; cv=none; b=NB01vVKIh+ahsDBKcoMKfKzUNAfxdE5JNxzKW8Hp0RZl/AXIL8QttczV9z7ycdPWMzgYxJxMjU5ClYpDmptTKBnqUU1fCd3Ym98BXlPzAV1aLFly8Q4egbIi4TkuGiJ0YQ70Ee3nKsj8cCzY8KQzAroTNwpIpEYr2WK00bICUxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933816; c=relaxed/simple;
	bh=lUoK02M4pR0qiRYI/A8vglesfV5YaBnPx2Tn3RHNIDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jK5T3ViV45eo9+3wwxzPRV9Xw5U+UXAAUSFiAWdCyiqL/oDLPlvNfZtYUxc/ObeVDlLj6cyWpd+FPpTM26PRrNDtohca1Sa4SJAyYRWslI5Yg/iPQdUYJMPfPWdfkguxeWEsrrWqWJERYpnndTjChFr9DagLGQFkTyYBJD3XG2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LrOvqQ4L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LrOvqQ4L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60592C433C7;
	Sat,  3 Feb 2024 04:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933816;
	bh=lUoK02M4pR0qiRYI/A8vglesfV5YaBnPx2Tn3RHNIDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LrOvqQ4Li4UWJXTsgGUBel8qMi2B0gl+g+EgyRYL/UQUAGlqnSKv1EZ+SCRx8ai/0
	 o+BRkGIZWxsaybP3EDmeGii3AO5K+4kTcgOQRhJ8HKQkHBhITNUkz8rrWdp5W/AoI1
	 cpVnAVr6DZyG1QAz8sg/bR/QVqGg2Ae2OQmbLxcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 134/353] block: prevent an integer overflow in bvec_try_merge_hw_page
Date: Fri,  2 Feb 2024 20:04:12 -0800
Message-ID: <20240203035407.956228517@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 3f034c374ad55773c12dd8f3c1607328e17c0072 ]

Reordered a check to avoid a possible overflow when adding len to bv_len.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Link: https://lore.kernel.org/r/20231204173419.782378-2-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/bio.c b/block/bio.c
index 5eba53ca953b..270f6b99926e 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -944,7 +944,7 @@ bool bvec_try_merge_hw_page(struct request_queue *q, struct bio_vec *bv,
 
 	if ((addr1 | mask) != (addr2 | mask))
 		return false;
-	if (bv->bv_len + len > queue_max_segment_size(q))
+	if (len > queue_max_segment_size(q) - bv->bv_len)
 		return false;
 	return bvec_try_merge_page(bv, page, len, offset, same_page);
 }
-- 
2.43.0



