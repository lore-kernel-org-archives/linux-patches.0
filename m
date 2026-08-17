Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 380B943A7F2;
	Mon, 17 Aug 2026 13:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974831; cv=none; b=ApB87kZUnpYS/eP2lQuMP4W3Ob1LH0qP73jnnvV6ipwMNBSrn7cP+ZSIoxbnz9jqMO3PBtGsk84XcsHEpst2DCE2OuZCuF0ICrbSgq7MEg/HAbbEGIYJxkNv6QY75o3bYYPnTkfIEY5MtfTOz8Ppw2baZjYwvHZTq2UkGLRh89o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974831; c=relaxed/simple;
	bh=DKcG4Dfjf3+OKi2OR6b5KVl+UQ8fUPpBvLXLuaKUx2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jlitwQD6qT0yLfoSx3NikdJrTR9TGOm7kULQinjKNum2R02l9nYOwPlHcY66CCvq+dEzDfcQV0uTRhSw7aq0MxiC/u/wt6LgPtmrW9L1N9ricj/g18T2ScacfI5Em2lPDqOZf1+DSu8WDw4uNn8587vaUD2EeVD+cQiLi2hFj+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=utZg0b9q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="utZg0b9q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 576B41F00A3A;
	Mon, 17 Aug 2026 13:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974818;
	bh=u6n9kbEuk/uS3FDa0PwMX+d009gIFq2X0Mzw9yWLsh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=utZg0b9qxN9zQJsxh8Wf4+gKMVDbOrYKv/2ePJ7n20V3oP6qINcb2wR+FRuQmIG7m
	 WsIcNhBiSAIJ9tlMXVjpXkeR7B37IdVkkxB60xsj365677ucTL+sc4ZyNbCpH+VADa
	 k0WtUqiWs9xcR9kOkIXTqWEmzU8OdFQmnVel4kYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Chen <will.chen.tty@gmail.com>,
	Joe Damato <joe@dama.to>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 064/250] bnxt: fix memory leak in bnxt_queue_mem_alloc error cases
Date: Mon, 17 Aug 2026 15:30:25 +0200
Message-ID: <20260817132539.073391662@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Chen <will.chen.tty@gmail.com>

[ Upstream commit d1000fd7995e51deec872d154e0a40d82f7a539f ]

There is a small memory leak in bnxt_queue_mem_alloc:
when bnxt_alloc_rx_agg_bmap() succeeds
but bnxt_alloc_one_tpa_info() later fails,
the rx_agg_bmap allocated by bnxt_alloc_rx_agg_bmap()
is not freed in the fallthrough cleanup cases.

Free the rx_agg_bmap in the err_free_rx_agg_ring case
and initialize clone->rx_agg_bmap = NULL earlier in the function
to allow for safe fallthrough.

Fixes: bd649c5cc958 ("bnxt_en: handle tpa_info in queue API implementation")
Signed-off-by: Will Chen <will.chen.tty@gmail.com>
Reviewed-by: Joe Damato <joe@dama.to>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20260729220132.1256924-1-will.chen.tty@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 52b356f4966ab..d90775c0ce0b5 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -16017,6 +16017,7 @@ static int bnxt_queue_mem_alloc(struct net_device *dev,
 	clone->rx_next_cons = 0;
 	clone->need_head_pool = false;
 	clone->rx_page_size = qcfg->rx_page_size;
+	clone->rx_agg_bmap = NULL;
 
 	rc = bnxt_alloc_rx_page_pool(bp, clone, rxr->page_pool->p.nid);
 	if (rc)
@@ -16069,6 +16070,8 @@ static int bnxt_queue_mem_alloc(struct net_device *dev,
 	bnxt_free_one_tpa_info(bp, clone);
 err_free_rx_agg_ring:
 	bnxt_free_ring(bp, &clone->rx_agg_ring_struct.ring_mem);
+	kfree(clone->rx_agg_bmap);
+	clone->rx_agg_bmap = NULL;
 err_free_rx_ring:
 	bnxt_free_ring(bp, &clone->rx_ring_struct.ring_mem);
 err_rxq_info_unreg:
-- 
2.53.0



