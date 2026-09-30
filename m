Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC90951CF6E;
	Wed, 30 Sep 2026 17:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790259; cv=none; b=ALSLv9GBIM6U55X0Qi4U2xFApt6A+qYF1xFGAyKkwKbgwbhEOWBY7MmzrM1kOOpNkS/qkDDOgVkfVGp2kPvELv+S2OgFZwBLchaYLyCtKqOUmDsF53nZl291voQit/PGsGkF2Xv0bpCJBrbcIuNpPncjbTsqWxdMLw37kj7y6ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790259; c=relaxed/simple;
	bh=FHD1gTcmI4zHyhulc2MB9z/CGaqmcRhgZ6a7qDul8/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mx4JyqcC9bCdtdqOCwV49h5b3/A6r/AE7qLWp4Ae/+qokcdrVCyyF/GVZexU498dpfNO29GKpzI3zvYuXueT/KCZ+gWkQlPU06kOZl8v4GraCzFd3b109Cv3XxLbkMzV9zbYutUxuAoIcNLL3UkX7JmB6JHD+ej/I0PmCh5lPgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n4JxWUnY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n4JxWUnY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 103DC1F000FF;
	Wed, 30 Sep 2026 17:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790258;
	bh=izU5sDHJcumXd/VhT2FDBicbrXczd2bKNDQ2oiPkS/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n4JxWUnYTEKGuoITNgkF8TuUUvpTb0FlS8btHKk2WSuSsW6xcGr3DPp0KgJvWWjv7
	 tVTTh7ols2NS7TLXcMJkpgz01YjRrnfi9udGgwvOPgg5ksLfRaj1KSf/8izUkvdl8s
	 tmGuWChjFMTRrgwLIUPtxcnVw+xbHkW2XWf1FKbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Chen <will.chen.tty@gmail.com>,
	Joe Damato <joe@dama.to>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 765/877] bnxt: fix memory leak in bnxt_queue_mem_alloc error cases
Date: Wed, 30 Sep 2026 17:27:56 +0200
Message-ID: <20260930152431.213833110@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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

Stable adaptation for 6.12:

The preceding per-queue buffer-size backport already initializes the
clone's rx_agg_bmap to NULL. Retain that initialization and apply the
missing bitmap cleanup to err_free_rx_agg_ring. This frees the clone's
bitmap when TPA allocation fails, while earlier allocation failures
can safely fall through with a NULL bitmap.

Keep the existing queue allocation interface and inherited RX page
size: this tree has neither qcfg nor need_head_pool. Leave the TPA
pointer resets to target commit 5ce7f36c334d. No functions are added.

Stable-dep-of: 5ce7f36c334d ("bnxt_en: Don't free the live ring's TPA state on queue restart failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -15459,6 +15459,8 @@ err_free_tpa_info:
 	bnxt_free_one_tpa_info(bp, clone);
 err_free_rx_agg_ring:
 	bnxt_free_ring(bp, &clone->rx_agg_ring_struct.ring_mem);
+	kfree(clone->rx_agg_bmap);
+	clone->rx_agg_bmap = NULL;
 err_free_rx_ring:
 	bnxt_free_ring(bp, &clone->rx_ring_struct.ring_mem);
 err_rxq_info_unreg:


