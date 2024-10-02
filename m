Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D8E61D0787;
	Wed,  2 Oct 2024 14:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879323; cv=none; b=ckByC8oNrbz6QiUgp/cM5MM0FBVK1DgI6fNu+u7yL3mp1puhukdNOsCBXUFH+3M9DxE/oy3e15Nv2VnGJOsSuTSLyP0/Bf3Qanp5o0amlVd482bhQe9Iin8ShIgOO2FD/3ftuE6iFGs6oGzGLLQtSLUD489k3oTFoJKa2JyxFUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879323; c=relaxed/simple;
	bh=WAKIvE4pBnNt8B9WoxEO4cgHA4ugLJCmiTvbHwEbKxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rjLM1jjT14YuprvksuLC7ce6IESpRnyHS6pp9KRWdKmRE5do/MBJffGYuO4l2+IDfkffzLNFOXJ1pb2+RkzkkN72jbvRh+tfE5+x0lOWpFOBJSALJ0w4OekAXed2pJsiujuPzj9kgLm+MGyoDxEaKa0wyQ8d60MNr4/uLvdrynM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UD2CXGah; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UD2CXGah"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECA7DC4CEC2;
	Wed,  2 Oct 2024 14:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879323;
	bh=WAKIvE4pBnNt8B9WoxEO4cgHA4ugLJCmiTvbHwEbKxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UD2CXGah0NdXqa3xm76A1ndew037FknqdFWi4XQIFitN3yI+1FHcFeRgBO2LLb1sx
	 9dIDjxOmVdxP+Tb6dh3bBqbNoLElhOBlALh5yKsaXGO8BPHbFBaFlD4vseIODmfwfX
	 FzAA12I0muqqs/BDri0gGJyuFWjBhP6doTPUeW2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 079/538] block, bfq: choose the last bfqq from merge chain in bfq_setup_cooperator()
Date: Wed,  2 Oct 2024 14:55:18 +0200
Message-ID: <20241002125755.336790232@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 0e456dba86c7f9a19792204a044835f1ca2c8dbb ]

Consider the following merge chain:

Process 1       Process 2       Process 3	Process 4
 (BIC1)          (BIC2)          (BIC3)		 (BIC4)
  Λ                |               |               |
   \--------------\ \-------------\ \-------------\|
                   V               V		   V
  bfqq1--------->bfqq2---------->bfqq3----------->bfqq4

IO from Process 1 will get bfqf2 from BIC1 first, then
bfq_setup_cooperator() will found bfqq2 already merged to bfqq3 and then
handle this IO from bfqq3. However, the merge chain can be much deeper
and bfqq3 can be merged to other bfqq as well.

Fix this problem by iterating to the last bfqq in
bfq_setup_cooperator().

Fixes: 36eca8948323 ("block, bfq: add Early Queue Merge (EQM)")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20240902130329.3787024-3-yukuai1@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bfq-iosched.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 7d13420a16d6a..bdb7ceb680890 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -2911,8 +2911,12 @@ bfq_setup_cooperator(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 	struct bfq_iocq_bfqq_data *bfqq_data = &bic->bfqq_data[a_idx];
 
 	/* if a merge has already been setup, then proceed with that first */
-	if (bfqq->new_bfqq)
-		return bfqq->new_bfqq;
+	new_bfqq = bfqq->new_bfqq;
+	if (new_bfqq) {
+		while (new_bfqq->new_bfqq)
+			new_bfqq = new_bfqq->new_bfqq;
+		return new_bfqq;
+	}
 
 	/*
 	 * Check delayed stable merge for rotational or non-queueing
-- 
2.43.0



