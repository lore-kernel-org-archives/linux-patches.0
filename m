Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71AD716F84F;
	Wed,  2 Oct 2024 13:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875588; cv=none; b=BNR+MjVjWNEXcSgHREinn0fOMVPGAsa+K/ojauL9nVkehY4eyHGtUCA8UYmwD89hDt6pl8EtOCjUU9sj0pGz1NRe95ZRtmn8sR2jQPCCIjgHEQ8f/qC+VoJK6FIYuObEJvew5UHKH6mk0oyr31t7W2/uFng7OmwIqNPNhtPfaXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875588; c=relaxed/simple;
	bh=JaEl2tKyD34MXqZJk9GnIysFc/mm4YhN7hhc5qaNpPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ptJ8SECAvxx7dHUWde7P7s1a3XQwhWcWa0GJ4bKJ3SOXZy0jwUhbhG/UXtnFpMy35vEYKtcMDv6MivjEfehlSJdQSQz2/qghqpqz6hQexCU+OEH1SgAgOm24UYdnAqqCOY5vNDfmYWMMHTdjbyDg8YknZLBxvShdqTxMXuJzrAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MSkm8438; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MSkm8438"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9687CC4CEC5;
	Wed,  2 Oct 2024 13:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875588;
	bh=JaEl2tKyD34MXqZJk9GnIysFc/mm4YhN7hhc5qaNpPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MSkm8438gKwbbhWyYItWJKjj3C/G4QWCgHtNlu4Lzn9BIvwpOicbcO1HioT/e2yDN
	 98bwRRK9DWwsXOKuc9VSXzS/5G9dq/pQzoWew0aggIXGqGWRWFBYXzJJsW/znZtMaE
	 UeqAiGn7ZPonJZgtVLA9TkT1rqN6NQmU33p/3f4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 121/695] block, bfq: choose the last bfqq from merge chain in bfq_setup_cooperator()
Date: Wed,  2 Oct 2024 14:51:59 +0200
Message-ID: <20241002125827.303235518@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 83adac3e71dbe..ffaa0d56328a5 100644
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



