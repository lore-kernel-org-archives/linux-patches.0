Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B8CF1DEFF4;
	Wed,  6 Nov 2024 12:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730894903; cv=none; b=CxjvUuc1yjovch0U3KT/wv5JRUennADUdzZXghfrhfeyAtfSHyvuM58Lj5EwSozUadcCYT+t/kHGGweuhC/fksnjKsZbYFA2Ja8U010AHtIXUt5dOQNwkFlJx/s3VU9wkvJRexmhKsNLVken/0H/iT4EeB1ptoiQhQGozrfJf6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730894903; c=relaxed/simple;
	bh=TtYmwPGlOJBSBjzSkAOqOyjjrYsBETpHLm7ThcvPYZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KrHuEDbAzeIJxi3GML3y415YIVbmxxidGysKavqSisOaa2JzMC2bsfzJRZthb+VT9M1gEdZVku6dwcZ3cVFftFwbB9320HQ0QAtAbkHONbSHdhZ6UmwHvQBfQqZ6C4QIRdP3h7T78m5tEQX+fMHax3MbC1WZUkyBfDBHYdBRcWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JmvPv5Qs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JmvPv5Qs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 230A4C4CECD;
	Wed,  6 Nov 2024 12:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730894903;
	bh=TtYmwPGlOJBSBjzSkAOqOyjjrYsBETpHLm7ThcvPYZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JmvPv5QsgX0+7grj94dcH35FUWbrzha78cErdjYaBUWi0DXhMst/L3uhcWukKCcVd
	 oWNVEFaWnYyhaHl1ttOycp1/l8WK3JwLTeXgTHeKj6+8vEO1Bi5yAJ96UZTHNtI1n9
	 wjVCM5Uox+wFovAYeRbMURx6QCM05D9ktHTRCjNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 038/350] block, bfq: choose the last bfqq from merge chain in bfq_setup_cooperator()
Date: Wed,  6 Nov 2024 12:59:26 +0100
Message-ID: <20241106120321.826385595@linuxfoundation.org>
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
index 1479e8d6fede2..3ed6584496f34 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -2226,8 +2226,12 @@ bfq_setup_cooperator(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 	struct bfq_queue *in_service_bfqq, *new_bfqq;
 
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
 	 * Prevent bfqq from being merged if it has been created too
-- 
2.43.0



