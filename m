Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0424F1D07AD;
	Wed,  2 Oct 2024 14:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877620; cv=none; b=fs0ijwT3GZriEBOP3Ykffbu3cdc0PYTDSU6fDB4s1zQhKxGqWwGKgs8uHCli8jyUYOW75RPAcI3oUXEUs5Wx1cqVHBC7pxw+/M96eemyUqPq1bFLWnqex+LEr53ylhd1FiwYnDMhHsOuDhKdwTGu36P4RO7s55s/+ZnqhxmrfIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877620; c=relaxed/simple;
	bh=Io3NTshlG1Jngd7JlAmmqG9gX+zENyHkUH/UTj0ez9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ScKZkiJnCdfVoRlzaoibqlc57t5Q4uLFIvqGm7UB0apV9vQbYQkZTxG4X5e6oQ6YIB0eSVKy7wCsf3RuRFc0QfYGvgNdCAKDyrV7+ydteQzQAWxUabZasT1rr+qbQTvkhqMeZRdRnpYtW93IFU1iBCWSX6gB44eUUnTqjyC/jLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pC7005vj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pC7005vj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D431C4CEC2;
	Wed,  2 Oct 2024 14:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877619;
	bh=Io3NTshlG1Jngd7JlAmmqG9gX+zENyHkUH/UTj0ez9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pC7005vjATkl5WP9mgzNeruMlV7SR4QnJZ+P4af/o2Zf/HlJanmb2ByC4UZw9zWLT
	 0oaCHYI6175Oq4mhl4mt5smREHpbmz2IbYhTY+kmh+9NALpQTiJVG11k37bbr5kjO0
	 RnvFaGHultVgnztDqZFKMCKy33Db4j6404m5YNLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 105/634] block, bfq: choose the last bfqq from merge chain in bfq_setup_cooperator()
Date: Wed,  2 Oct 2024 14:53:25 +0200
Message-ID: <20241002125815.259408819@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 4f02056f1d413..279ea5bed78d8 100644
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



