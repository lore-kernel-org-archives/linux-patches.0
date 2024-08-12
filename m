Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC16186E38;
	Mon, 12 Aug 2024 16:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479127; cv=none; b=fvYXr7D2JShn+5WVCQ/HWUlPqm5sWNYzldfNtHCBmssN+fBlzavzSnphGQ/rBS5HwpMyM7M7bMXbVwBRf/dpv/A9JnqBzH48JUEnn3C5jirHUdNMo6T/c6zaewdayU7Qv4CVXdNABuMWTOFilDt7iitvNgA4OEMv4mWqCKBy/yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479127; c=relaxed/simple;
	bh=xGtzHABa9vOwzf49QiTLNwYC7/+uXTyC6JbhXSsOHJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NPEcRbhtdBUFSk1kVGeLTdW6s1MEQj7I/WBUdGDaQGfFnDzkkz3msx8F4iKwxSGkyKog47uv556BdTRXd7VeBrcowAsLFzz3oUE5r2b2MqRN5Os6VgQkQn1pwz6hNez7ffWbuy/Rg4vFA2a2EDdEXfviD5txQP7vUjkTXIGKe2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pwmPCRVH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pwmPCRVH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6B97C32782;
	Mon, 12 Aug 2024 16:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479127;
	bh=xGtzHABa9vOwzf49QiTLNwYC7/+uXTyC6JbhXSsOHJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pwmPCRVHRLdfIk5YeOO6UC9c8EImIAoSoq03Ga4euG/2MhO3Eliv6PbpNFLGhYJi1
	 03UnXaU/FCmAP0ZBpqPYmuEDkzQjcsMUNKHmX/R8H2HqW4klamWaw673KOsWtPB3XJ
	 O04tp7MpmjeZrWh5kmzvXDSqKiojCdWZ5YEQSrVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 142/150] block: Call .limit_depth() after .hctx has been set
Date: Mon, 12 Aug 2024 18:03:43 +0200
Message-ID: <20240812160130.651988558@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Bart Van Assche <bvanassche@acm.org>

commit 6259151c04d4e0085e00d2dcb471ebdd1778e72e upstream.

Call .limit_depth() after data->hctx has been set such that data->hctx can
be used in .limit_depth() implementations.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Zhiguo Niu <zhiguo.niu@unisoc.com>
Fixes: 07757588e507 ("block/mq-deadline: Reserve 25% of scheduler tags for synchronous requests")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Tested-by: Zhiguo Niu <zhiguo.niu@unisoc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20240509170149.7639-2-bvanassche@acm.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-mq.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -439,6 +439,7 @@ __blk_mq_alloc_requests_batch(struct blk
 
 static struct request *__blk_mq_alloc_requests(struct blk_mq_alloc_data *data)
 {
+	void (*limit_depth)(blk_opf_t, struct blk_mq_alloc_data *) = NULL;
 	struct request_queue *q = data->q;
 	u64 alloc_time_ns = 0;
 	struct request *rq;
@@ -465,7 +466,7 @@ static struct request *__blk_mq_alloc_re
 		    !blk_op_is_passthrough(data->cmd_flags) &&
 		    e->type->ops.limit_depth &&
 		    !(data->flags & BLK_MQ_REQ_RESERVED))
-			e->type->ops.limit_depth(data->cmd_flags, data);
+			limit_depth = e->type->ops.limit_depth;
 	}
 
 retry:
@@ -477,6 +478,9 @@ retry:
 	if (data->flags & BLK_MQ_REQ_RESERVED)
 		data->rq_flags |= RQF_RESV;
 
+	if (limit_depth)
+		limit_depth(data->cmd_flags, data);
+
 	/*
 	 * Try batched alloc if we want more than 1 tag.
 	 */


