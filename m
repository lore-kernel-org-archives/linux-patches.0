Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACEBE47CC89;
	Thu, 20 Aug 2026 16:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243740; cv=none; b=HpPBH0Auw7YM0LXlLAPvBSTUIZJ1Q7/wZ5l4LII5RsBDGpoUYVw3xOhXeKRgMcQWzV2EziubA6WhhxJYTdINZ7oUrc/rqHpTlv468+rb/Z0ZXP+D/Rvd0kb7OPKJMZmvIlJyVXhmQrGlWS5jFu0V+9u1idi2azbsrLKM0DR2Fdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243740; c=relaxed/simple;
	bh=qdC8w9TRnU2r+TtDI5ce+KpuhQCKhNB49YOnmzW71YM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NeTvetWvn3LV5wrvg2r5lwykt89+8YFJ6FFyeTAbTMzc2k5qsdd5RM82aizNsCSdpNupLef1JUzYiEbjULfZfmhtDCJyGSFbZkXUJy1keupfnvYHJqdyEhRrcA/bI1ysBkwerIaOi4/NQksJcNftEIXpuAm+CAsY9DWMSdiVv3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TC/xeQmW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TC/xeQmW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 121C51F000E9;
	Thu, 20 Aug 2026 16:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243738;
	bh=ggNb3G0661o08a1J5Pg/rGc0ebWDrKdyIP5y/mGIzYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TC/xeQmW/fH8syhxp13y2QpqbcwDUgiZM97+qJmqZ/exgVNI1pNO8t4bLHpuXwO3+
	 AFlYSD4BMDyMb8K+a/ws2Uzi++XuUecUoTd38+Hqcrp/Jph1FFdlDv/RPwB1dU333P
	 20B83ZT/xJ8/e6BJd8nUxgOlx7ugbdPrNCVTRRuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Dawei Feng <dawei.feng@seu.edu.cn>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 160/272] octeontx2-pf: fix SQB pointer leak on init failure
Date: Thu, 20 Aug 2026 16:55:44 +0200
Message-ID: <20260820145236.120798518@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dawei Feng <dawei.feng@seu.edu.cn>

[ Upstream commit 62e7df6d042aeebd5efb581074e28865c04477be ]

otx2_init_hw_resources() initializes SQ aura and pool resources before
several later setup steps. On failure, err_free_sq_ptrs only frees SQB
pages, leaving the per-SQ sqb_ptrs arrays behind.

Use otx2_free_sq_res() for the SQ unwind path and let it free sqb_ptrs
even when sq->sqe has not been allocated yet.

The bug was first flagged by an experimental analysis tool we are
developing for kernel memory-management bugs while analyzing
v6.13-rc1. The tool is still under development and is not yet publicly
available. Manual inspection confirms that the bug is still
present in v7.1.1.

An x86_64 allyesconfig build showed no new warnings. As we do not have an
OcteonTX2 PF device and the corresponding AF mailbox setup to test with,
no runtime testing was able to be performed.

Fixes: caa2da34fd25 ("octeontx2-pf: Initialize and config queues")
Cc: stable@vger.kernel.org
Reviewed-by: Ratheesh Kannoth <rkannoth@marvell.com>
Signed-off-by: Dawei Feng <dawei.feng@seu.edu.cn>
Link: https://patch.msgid.link/20260630071625.349996-1-dawei.feng@seu.edu.cn
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1484,14 +1484,13 @@ static int otx2_init_hw_resources(struct
 	return err;
 
 err_free_nix_queues:
-	otx2_free_sq_res(pf);
 	otx2_free_cq_res(pf);
 	otx2_ctx_disable(mbox, NIX_AQ_CTYPE_RQ, false);
 err_free_txsch:
 	if (otx2_txschq_stop(pf))
 		dev_err(pf->dev, "%s failed to stop TX schedulers\n", __func__);
 err_free_sq_ptrs:
-	otx2_sq_free_sqbs(pf);
+	otx2_free_sq_res(pf);
 err_free_rq_ptrs:
 	otx2_free_aura_ptr(pf, AURA_NIX_RQ);
 	otx2_ctx_disable(mbox, NPA_AQ_CTYPE_POOL, true);


