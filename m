Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A92829D26A;
	Tue, 26 Aug 2025 11:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208121; cv=none; b=QqOZoAWHRYCkfCixdvtZng6gycNBQ4FtnN+ro1PfMGDH9J0T7vbxDl15KZpwsg8U+5MLopLPBOYtCQbrMto51ZrgG8efAr1aJmcylCczgYM3LsH4bEfJaskoB5fy6odw2AIcXqdfbnrs/qe+xv6mCvlfiDsW8OFzObQX0fsoOnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208121; c=relaxed/simple;
	bh=C80zVHdPSwj3L8an73pDRP3D6Xcw4HDyecVnBs8suWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rRf28jSdxJpXMUdsOvVJMLsIO52H3XhpwkKQRhEgOT+Ctp4NX4pA2IJi/sQcgRstmfX3ayGHGSAE5SqsI5DRvDOSHi64675xyJrSNh6O4exWKCLVnUQ8KvM8A26Rak1m0KDZEfpm9FQ5HefQbZFX71vZbKrCpHI8BnMax/j9XiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S8sQo+gx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S8sQo+gx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D6E3C4CEF1;
	Tue, 26 Aug 2025 11:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208120;
	bh=C80zVHdPSwj3L8an73pDRP3D6Xcw4HDyecVnBs8suWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S8sQo+gx4yCKK+45FMC6LSR627x9Pq54gT4R3Z9K+8N6oO6ahgCWISnEmlyX+6NW0
	 pn69uSwSWLe8be3cXawuozup3rkuagnKDz3N8oNoxZZvHEMEj7n3SE5lIYdTK4pOO9
	 35xrmGeryjLrOwFMmH7Or2Mz1EqXSVkfgRSYCQGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilay Shroff <nilay@linux.ibm.com>,
	Ming Lei <ming.lei@redhat.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 444/457] block: decrement block_rq_qos static key in rq_qos_del()
Date: Tue, 26 Aug 2025 13:12:08 +0200
Message-ID: <20250826110948.257479778@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nilay Shroff <nilay@linux.ibm.com>

[ Upstream commit ade1beea1c27657712aa8f594226d461639382ff ]

rq_qos_add() increments the block_rq_qos static key when a QoS
policy is attached. When a QoS policy is removed via rq_qos_del(),
we must symmetrically decrement the static key. If this removal drops
the last QoS policy from the queue (q->rq_qos becomes NULL), the
static branch can be disabled and the jump label patched to a NOP,
avoiding overhead on the hot path.

This change ensures rq_qos_add()/rq_qos_del() keep the
block_rq_qos static key balanced and prevents leaving the branch
permanently enabled after the last policy is removed.

Fixes: 033b667a823e ("block: blk-rq-qos: guard rq-qos helpers by static key")
Signed-off-by: Nilay Shroff <nilay@linux.ibm.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20250814082612.500845-3-nilay@linux.ibm.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-rq-qos.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/blk-rq-qos.c b/block/blk-rq-qos.c
index 848591fb3c57..b1e24bb85ad2 100644
--- a/block/blk-rq-qos.c
+++ b/block/blk-rq-qos.c
@@ -374,6 +374,7 @@ void rq_qos_del(struct rq_qos *rqos)
 	for (cur = &q->rq_qos; *cur; cur = &(*cur)->next) {
 		if (*cur == rqos) {
 			*cur = rqos->next;
+			static_branch_dec(&block_rq_qos);
 			break;
 		}
 	}
-- 
2.50.1



