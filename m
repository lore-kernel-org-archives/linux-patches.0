Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14ECF1F6680;
	Wed,  6 Nov 2024 12:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897889; cv=none; b=doa2Y3qNYw7EmBz0OxyhdMaymAT5D9FozRMkKYMd+Kfvjhd4KeVtxCrWStZwuxwo4ViGP+N8zBOOTqIq2qiMUyZ4YxLxYXDoxD8W365YEiS3ozwqdcY2Ez1nbNXwZmRjUui6gUwwGa5/vzgqBLf4eukbVzx0aL9LUL8kRI1zJJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897889; c=relaxed/simple;
	bh=YfWz/vCQdpmRl8BEA2Esj2SzqPoqbWJfaQa/XYD+4wc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jqc9S4A/KpOG56g4ifvgEkUE4J1OLqdQiUZXNsOuahCfWEIVOCAVNNpJsf7CnhsrDZBXWm+tSGFVuUq2wncZyrJ4GTmeLcqcf0ZeXO9sm/eau7RiS9i+IQz2+yLVnD5ckP+v7R5O6cbnT5Z+sstQMd+4hll9fTDDW9JHICKgXu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B+1Sl6Gv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B+1Sl6Gv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8988AC4CECD;
	Wed,  6 Nov 2024 12:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897888;
	bh=YfWz/vCQdpmRl8BEA2Esj2SzqPoqbWJfaQa/XYD+4wc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B+1Sl6GvNOAkCFZ6lc1wdraNKjMq+1+rf7a93HdbOeHxCndnpYRKRa2uUpIEThHAF
	 jiUpFAVKwAeGpJIhcwenNM/+dxLx376vjQcFBVmd4m+oJEFLNqldZ5aDPTnabHLtBW
	 WUgKvuTF1WL2Fd2y7m6tAeWJ4vnDeqiKpC+j2JNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 053/462] block, bfq: choose the last bfqq from merge chain in bfq_setup_cooperator()
Date: Wed,  6 Nov 2024 12:59:06 +0100
Message-ID: <20241106120332.826616192@linuxfoundation.org>
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
index 6ed6ff0864fd2..015c1879edd2a 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -2610,8 +2610,12 @@ bfq_setup_cooperator(struct bfq_data *bfqd, struct bfq_queue *bfqq,
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
 	 * Do not perform queue merging if the device is non
-- 
2.43.0



