Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365A01F667F;
	Wed,  6 Nov 2024 12:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897892; cv=none; b=Roiaz5GBeU8PQ485w9w9ZcwNPFHKVdveEiu50cKRoSLlJE2wBd02s54UOLLqsDWZGmKCtszIWjE09elocVJABuuzkqoiZRgjPRS/8Sc30lhUY1OEL3kuLEoamc6cQpCj9uoEofbogOEJf7XgcpzqTH5y6leHN5CbRdmql0Q6yaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897892; c=relaxed/simple;
	bh=YSG5PpJlHRschbLZFyUjuz31ETKrbwq6nHlNKedMW0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FgsIJJTlBOzvB5Gf02ZMmp//gDJ1RpFtdPjTM9Ze8DCSiCiw5ReYmYnS5ODOnhg/FQ7iNPw3+lvZzLYz2JumeT+gbrIFGflly+IBoA8coEr9REIFtFcdKa3zMtgz6XGON2vAzt+oIzuHbTWS1wnSrkhz2/6IsDR1uY6WRGWuFAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=huRSLn2u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="huRSLn2u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74F92C4CECD;
	Wed,  6 Nov 2024 12:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897892;
	bh=YSG5PpJlHRschbLZFyUjuz31ETKrbwq6nHlNKedMW0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=huRSLn2u/KITTf3pF+jbvw6MZ3QbIaRwosLiYXrdV2jfEm+60PX1Usv7rxE6jBiuM
	 WPLYvhzLyuzhr2S0r88DY7+nVJyjaj13PqHtkmKuz8k2IdREoGj2EjZE16qJADibw8
	 zrJdOID7pOwz1lyHppDq8ro/HVavSVaVsNFR+8uY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 054/462] block, bfq: dont break merge chain in bfq_split_bfqq()
Date: Wed,  6 Nov 2024 12:59:07 +0100
Message-ID: <20241106120332.851826172@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 42c306ed723321af4003b2a41bb73728cab54f85 ]

Consider the following scenario:

    Process 1       Process 2       Process 3       Process 4
     (BIC1)          (BIC2)          (BIC3)          (BIC4)
      Λ               |               |                |
       \-------------\ \-------------\ \--------------\|
                      V               V                V
      bfqq1--------->bfqq2---------->bfqq3----------->bfqq4
ref    0              1               2                4

If Process 1 issue a new IO and bfqq2 is found, and then bfq_init_rq()
decide to spilt bfqq2 by bfq_split_bfqq(). Howerver, procress reference
of bfqq2 is 1 and bfq_split_bfqq() just clear the coop flag, which will
break the merge chain.

Expected result: caller will allocate a new bfqq for BIC1

    Process 1       Process 2       Process 3       Process 4
     (BIC1)          (BIC2)          (BIC3)          (BIC4)
                      |               |                |
                       \-------------\ \--------------\|
                                      V                V
      bfqq1--------->bfqq2---------->bfqq3----------->bfqq4
ref    0              0               1                3

Since the condition is only used for the last bfqq4 when the previous
bfqq2 and bfqq3 are already splited. Fix the problem by checking if
bfqq is the last one in the merge chain as well.

Fixes: 36eca8948323 ("block, bfq: add Early Queue Merge (EQM)")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20240902130329.3787024-4-yukuai1@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bfq-iosched.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 015c1879edd2a..897a3aae12b80 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -5994,7 +5994,7 @@ bfq_split_bfqq(struct bfq_io_cq *bic, struct bfq_queue *bfqq)
 {
 	bfq_log_bfqq(bfqq->bfqd, bfqq, "splitting queue");
 
-	if (bfqq_process_refs(bfqq) == 1) {
+	if (bfqq_process_refs(bfqq) == 1 && !bfqq->new_bfqq) {
 		bfqq->pid = current->pid;
 		bfq_clear_bfqq_coop(bfqq);
 		bfq_clear_bfqq_split_coop(bfqq);
-- 
2.43.0



