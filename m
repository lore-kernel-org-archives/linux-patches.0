Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D507B3AC3B;
	Tue, 11 Nov 2025 01:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822889; cv=none; b=W11n0p4LhUoJCoN8maBvUjzn+cHxHGEUB2RaYFEOARsEsndw8CmUqjpL5DYOrHRav33WppIXXTIfPSVzoO4kEHv/FxCfOv6RFVSmxnf4n/Ua7kX5NUiP4UTgnjfw6WlL8Z8Faw3mGlqsVmZI/8s6FYUHxnnDOps+piYAKMZnd5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822889; c=relaxed/simple;
	bh=967soiR7boCgfbNupzIGR/qS1eX9pcr6TNDdsD+sVHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bXOrTiC03b22ELJcjYCwSKjaPL6h8josq2FXJGer3RuxEHQmb48bkd0WK1hjIyExdfFz4TRty9d4ZGk4FkNWEcJV+00xWi+WCxyC5wcL6MvezVM3+BnkkWHn5ezQKyv7f/TGe1CtPpchBZaU1UWm8kwagqq0AaoKsXDcr2SzOJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ehm5kqhR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ehm5kqhR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 717A7C19421;
	Tue, 11 Nov 2025 01:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822889;
	bh=967soiR7boCgfbNupzIGR/qS1eX9pcr6TNDdsD+sVHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ehm5kqhRzbTT5vTSLJOBZVBZloDIbTvo2aDV/DPZWmFkLeAKdM3APD/8+FNjX7IRZ
	 d/tL+wX6jWvQBOnUZ76hU3vZc2Pxe9jKKQgPzpqjGEtsyc7Aykzn2fGIgd9d/jOYkG
	 1Ig5qHVTviLX9RSFVcoZ4O24t1rJHJy19joAuRpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 190/849] io_uring/zcrx: account niov arrays to cgroup
Date: Tue, 11 Nov 2025 09:36:00 +0900
Message-ID: <20251111004541.019878819@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 31bf77dcc3810e08bcc7d15470e92cdfffb7f7f1 ]

net_iov / freelist / etc. arrays can be quite long, make sure they're
accounted.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/zcrx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 23ffc95caa427..e3953ea740c03 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -426,17 +426,17 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
 
 	ret = -ENOMEM;
 	area->nia.niovs = kvmalloc_array(nr_iovs, sizeof(area->nia.niovs[0]),
-					 GFP_KERNEL | __GFP_ZERO);
+					 GFP_KERNEL_ACCOUNT | __GFP_ZERO);
 	if (!area->nia.niovs)
 		goto err;
 
 	area->freelist = kvmalloc_array(nr_iovs, sizeof(area->freelist[0]),
-					GFP_KERNEL | __GFP_ZERO);
+					GFP_KERNEL_ACCOUNT | __GFP_ZERO);
 	if (!area->freelist)
 		goto err;
 
 	area->user_refs = kvmalloc_array(nr_iovs, sizeof(area->user_refs[0]),
-					GFP_KERNEL | __GFP_ZERO);
+					GFP_KERNEL_ACCOUNT | __GFP_ZERO);
 	if (!area->user_refs)
 		goto err;
 
-- 
2.51.0



