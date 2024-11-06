Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8722C1D2784;
	Wed,  6 Nov 2024 12:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730894909; cv=none; b=DSuvp+Abj79KDc0MX1a2do3JccjmDgYAY/KRwUbKxFxL6rjjXrxKPGSx+bLrYza+kJH7ySRcstjXNUQrBymN395Rto2fXw8uXTThZi6geI57plmsJDbwasC3X+zmWsqqFZpu3NpG+brYdphtNCxLbtPff81ZxDi0Yg9kxYWjR28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730894909; c=relaxed/simple;
	bh=a4Mfbxao/COgXvJTw0bPjbv0Bb2qbtObqXhMT9af/T8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GaR748u8ywvCVVbXHtD5rYq3Ar8CRzTnvbNXlVq2+mqySc9FMpaxiD0Pn9Xd1dyHX0OHznw60X243Oc6dsJlmQ+o0lnJQ/FGLh7zk7VTG++R++b6sk0Nvkhgl9jYfngw4kTiiSxlvV3tUeKoT6ivpO4SmZBVQIiuIAycAcKKEas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hB0i5hVb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hB0i5hVb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AF6FC4CECD;
	Wed,  6 Nov 2024 12:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730894909;
	bh=a4Mfbxao/COgXvJTw0bPjbv0Bb2qbtObqXhMT9af/T8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hB0i5hVbPjyuzoYx9NdU/FU3ewG/d0rs1bNhXzmrW2hGdl6W/h3uda1zkqFUudNQw
	 nm9osY276EblWxgDnJbJwK0tlwkvLHFgm3pao4l14FhgD3BWAYkZuN9g52jJMiBU1W
	 yERnFHVnhSd+Rx1KaNVlom4a/0hck7u6JIAPkcpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 039/350] block, bfq: dont break merge chain in bfq_split_bfqq()
Date: Wed,  6 Nov 2024 12:59:27 +0100
Message-ID: <20241106120321.850367905@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 3ed6584496f34..afc30a200fe82 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -5037,7 +5037,7 @@ bfq_split_bfqq(struct bfq_io_cq *bic, struct bfq_queue *bfqq)
 {
 	bfq_log_bfqq(bfqq->bfqd, bfqq, "splitting queue");
 
-	if (bfqq_process_refs(bfqq) == 1) {
+	if (bfqq_process_refs(bfqq) == 1 && !bfqq->new_bfqq) {
 		bfqq->pid = current->pid;
 		bfq_clear_bfqq_coop(bfqq);
 		bfq_clear_bfqq_split_coop(bfqq);
-- 
2.43.0



