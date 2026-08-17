Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E761F3F928B;
	Mon, 17 Aug 2026 13:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974059; cv=none; b=JDoxd7zoILircDkP8mRnkPejRqYhFOoh2B/QD6xyLOO07ah1k93z7o6vf2FXFOR8tEoVWRsJIMgXS8Vut0NeqpNzZrmL48DV1MPXFGP4uzmgEBtmtTVZ7P8GuKLj0DCV/rTPXO2BzkKmJAJqXdGwV9OBJvCaJnLj8d+90d+ntw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974059; c=relaxed/simple;
	bh=N20U7q538zl7MOxLXtroQ2XtlKlAXlu5apdbEBp+9rc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eiYvq6tQGJFHpkkUQRuuMxPb9B2Sh8lffOU5hirXiBOELh3uvqLcacoYoo2LO2vRCJ9FozWUJh/evVEDWmsu+WuWlveO1xF7q4oKmP7pmnpWgfMsdXuC0cIaiG1MQBWFF9+KA7CIO5h5dcVPJ7PFCu+TsfhysdaLIz1ZFn2yh28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oi1up6YW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oi1up6YW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 445871F00A3E;
	Mon, 17 Aug 2026 13:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974051;
	bh=Yu3QQjhvrsCOvsETf+btK5e3+07AA/JpRC38NCSL5B8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oi1up6YWTCv9zPwqL+U0QCT3FyaZNt9lJYP6gCiCi6Fwe/1wm9gB4zaXXifAu/C6T
	 Q5xuMKO6ViyPD7bzb/T1T3Ht2CONrafPp8VP8o7J82HzhOjURSGRwucxIKz8agBwDU
	 8PksVDcdzicNO1sof2xviSyiZ3Qm5WR/yLuIKnlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Chen <will.chen.tty@gmail.com>,
	Joe Damato <joe@dama.to>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 071/271] bnxt: fix memory leak in bnxt_queue_mem_alloc error cases
Date: Mon, 17 Aug 2026 15:29:56 +0200
Message-ID: <20260817132539.664701360@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index d44d3ac255aa4..cb6e45fc9cd98 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -16225,6 +16225,7 @@ static int bnxt_queue_mem_alloc(struct net_device *dev,
 	clone->rx_next_cons = 0;
 	clone->need_head_pool = false;
 	clone->rx_page_size = qcfg->rx_page_size;
+	clone->rx_agg_bmap = NULL;
 
 	rc = bnxt_alloc_rx_page_pool(bp, clone, rxr->page_pool->p.nid);
 	if (rc)
@@ -16277,6 +16278,8 @@ static int bnxt_queue_mem_alloc(struct net_device *dev,
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



