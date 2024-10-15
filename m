Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F2B11C07C2;
	Tue, 15 Oct 2024 12:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997120; cv=none; b=Y371CvL9z5q0nCKompMb+ec4+vrHBV0ox6wcrEy+fDTR7lr3GudBhuMEbLzc6Tt4WkpTtUze1MOwQDudgL+GS2FUd8qhkpjjuqpHuhi4Pph3oy1KaaFs04KiFzh4MXCVuGHugShHaARRin+o7uStqpeQ7YVS9Mue7+CUELhnpfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997120; c=relaxed/simple;
	bh=ZJeHW1joxavyHutAQeHP9pxB0w2KPC/cfG8PFgkHozg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uR0pp9FDIbMDwoTEYjpU+xe3E2ArsgSu1kH6ZGqLVFuLBF3IjJarlfOsQ8dbofDtrAqU6SVoQhXiVvIj44azTyDwahiS0NrHAt2EfbvZ+u7Av3fsPgQjzPasFFuUrFf3v6SiMf6ZQpOHQ+T+w3b0cxfJ+Iao2LE1Sy7Rltfh2VQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cTPUGjrj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cTPUGjrj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93A91C4CEC6;
	Tue, 15 Oct 2024 12:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997120;
	bh=ZJeHW1joxavyHutAQeHP9pxB0w2KPC/cfG8PFgkHozg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cTPUGjrjAQaXVvRpz2ztKqWLkQVXa4dzgGAIXF3j6mPIJZNVUr7XmOXu4CAb5Tqut
	 m9ABhZjM4znAUn3xiuQvz3ss18BLyT3LIW4CDHKcEpB1+MYbWkEzUu8I0259XXyXZ1
	 /lVewOjEnW70WVQDkSaIUjqnBysPo/iJoRU77v0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 092/518] block, bfq: dont break merge chain in bfq_split_bfqq()
Date: Tue, 15 Oct 2024 14:39:56 +0200
Message-ID: <20241015123920.554658399@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e68881f71ff13..515e3c1a54759 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -6013,7 +6013,7 @@ bfq_split_bfqq(struct bfq_io_cq *bic, struct bfq_queue *bfqq)
 {
 	bfq_log_bfqq(bfqq->bfqd, bfqq, "splitting queue");
 
-	if (bfqq_process_refs(bfqq) == 1) {
+	if (bfqq_process_refs(bfqq) == 1 && !bfqq->new_bfqq) {
 		bfqq->pid = current->pid;
 		bfq_clear_bfqq_coop(bfqq);
 		bfq_clear_bfqq_split_coop(bfqq);
-- 
2.43.0



