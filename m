Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83AC8357D11;
	Wed, 30 Sep 2026 16:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786266; cv=none; b=Y3ZJYo7StVvVzL1edwWxUSJoa6o81NWOVphtXngeq07m92U5In+SJdc+lq+IN/FUcLEQxKIFfhLfmBDrP1klzxawQ86aYeAH0TpSbbesnT2Jjs7blGzkCDI19bThckti18FZ3XNgqMWhulPOl7RuWspWYBlhXZiI5taxy0MVg/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786266; c=relaxed/simple;
	bh=PUWT4RCHVdDbfKzB/8b3STzlZSrY3H5FL4dvbEq0u74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uPFoZIxIqnf1Ayaiix9hSQh2owAfr8nJrbtj8Dor2FN3d4O7EljfIdGYCX9bKhME4HC0RS5M1E4i5+c3qvbkptGcA+9NEA458XoZlhsAjJlLmhnqwJj8/wS4aQRQv2hwSWtdxZ32BbKBONWRSZmKyHCcKclCPCNpQQ/La8WDs0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V4Ov/7E+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V4Ov/7E+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFA501F000FF;
	Wed, 30 Sep 2026 16:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786265;
	bh=RSR17rlKER8h6nTfbaP4iPn8Hz3dpCmNLjCNIEN5ZYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V4Ov/7E+OQhpXYe//g+k0CvfoDNWXXi78Y79V3MoA0CgNUuRp5J8871uLSpN0Pqon
	 tDw2gNoJgLLYXn3EXDP5xRRt0j/nZqsAOXvzoI5jlpEb9e6EohIUtmLMiqI9Cy8s6H
	 V2OojQz+UeURgTY7gFOWp28aYlCFfCHOqR2HT59Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengming Zhou <zhouchengming@bytedance.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 784/982] blk-mq: fix tags leak when shrink nr_hw_queues
Date: Wed, 30 Sep 2026 17:25:20 +0200
Message-ID: <20260930152433.595107770@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengming Zhou <zhouchengming@bytedance.com>

[ Upstream commit e1dd7bc93029024af5688253b0c05181d6e01f8e ]

Although we don't need to realloc set->tags[] when shrink nr_hw_queues,
we need to free them. Or these tags will be leaked.

How to reproduce:
1. mount -t configfs configfs /mnt
2. modprobe null_blk nr_devices=0 submit_queues=8
3. mkdir /mnt/nullb/nullb0
4. echo 1 > /mnt/nullb/nullb0/power
5. echo 4 > /mnt/nullb/nullb0/submit_queues
6. rmdir /mnt/nullb/nullb0

In step 4, will alloc 9 tags (8 submit queues and 1 poll queue), then
in step 5, new_nr_hw_queues = 5 (4 submit queues and 1 poll queue).
At last in step 6, only these 5 tags are freed, the other 4 tags leaked.

Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20230821095602.70742-1-chengming.zhou@linux.dev
Signed-off-by: Jens Axboe <axboe@kernel.dk>

[ Backport to 6.1.y: use this tree's cur_nr_hw_queues snapshot when
  freeing excess tag sets. ]
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 8a9d9e3db1668..b6215bee3d3c4 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -4509,9 +4509,13 @@ static int blk_mq_realloc_tag_set_tags(struct blk_mq_tag_set *set,
 				  int cur_nr_hw_queues, int new_nr_hw_queues)
 {
 	struct blk_mq_tags **new_tags;
+	int i;
 
-	if (cur_nr_hw_queues >= new_nr_hw_queues)
+	if (cur_nr_hw_queues >= new_nr_hw_queues) {
+		for (i = new_nr_hw_queues; i < cur_nr_hw_queues; i++)
+			__blk_mq_free_map_and_rqs(set, i);
 		return 0;
+	}
 
 	new_tags = kcalloc_node(new_nr_hw_queues, sizeof(struct blk_mq_tags *),
 				GFP_KERNEL, set->numa_node);
-- 
2.53.0



