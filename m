Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46CD12C697;
	Mon, 28 Oct 2024 06:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097564; cv=none; b=g0ldV5QNA2ULN5nEzR/IxmymDtmfedfeUIGtr1JpBhVcuONjDJclOlbav7LmhBcjYfkCwVqCDaor04iZ+JpJh8wvJNYpOQ5/bB2mWDpU0cto08BJBsPtrcKGM1xK1iWPVP9VSM3Qs8a7XhkmqDND60mOYZzncPUshcKpkgd01Ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097564; c=relaxed/simple;
	bh=c4pXM+k2ef6QmbLOBGZ7r9e4AuLwhOX3jaGsNxTvck4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fckXOX4hk/srXjhvr9U/jncLb9srUpepP5mjZZRkBUowdZXiZOGvvv3ARwD6R/+1tIHXPBHwIYA4xlJUfR82KGcYko64T87yvvSaavV3I6c3awPBM2iApVAg9g2NOwieoFcNdx9oTqtQrvCu7WciRcYma7zKl6jN+mw8Hr8o4Bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lWy+zABH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lWy+zABH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DED25C4CEC3;
	Mon, 28 Oct 2024 06:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097564;
	bh=c4pXM+k2ef6QmbLOBGZ7r9e4AuLwhOX3jaGsNxTvck4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lWy+zABH3mFDU7RnhBoDApC3vkr/qBZZRH3Mqdx4cbHCOf55enHPexMLqXW39JbzL
	 DS3BikXujcG10HJYiw67zQQ5rEKGfOU6BKU3z4B0tMk+NkF7IMkG1V3qm6kGeWt4vY
	 o96FIwHHGYNEYRVoV58ixeJagr1hQUUmmFbIMBS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai Shen <KaiShen@linux.alibaba.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 048/208] net/smc: Fix memory leak when using percpu refs
Date: Mon, 28 Oct 2024 07:23:48 +0100
Message-ID: <20241028062307.840142580@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kai Shen <KaiShen@linux.alibaba.com>

[ Upstream commit 25c12b459db8365fee84b63f3dd7910f70627f29 ]

This patch adds missing percpu_ref_exit when releasing percpu refs.
When releasing percpu refs, percpu_ref_exit should be called.
Otherwise, memory leak happens.

Fixes: 79a22238b4f2 ("net/smc: Use percpu ref for wr tx reference")
Signed-off-by: Kai Shen <KaiShen@linux.alibaba.com>
Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>
Link: https://patch.msgid.link/20241010115624.7769-1-KaiShen@linux.alibaba.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_wr.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/smc/smc_wr.c b/net/smc/smc_wr.c
index 0021065a600a0..994c0cd4fddbf 100644
--- a/net/smc/smc_wr.c
+++ b/net/smc/smc_wr.c
@@ -648,8 +648,10 @@ void smc_wr_free_link(struct smc_link *lnk)
 	smc_wr_tx_wait_no_pending_sends(lnk);
 	percpu_ref_kill(&lnk->wr_reg_refs);
 	wait_for_completion(&lnk->reg_ref_comp);
+	percpu_ref_exit(&lnk->wr_reg_refs);
 	percpu_ref_kill(&lnk->wr_tx_refs);
 	wait_for_completion(&lnk->tx_ref_comp);
+	percpu_ref_exit(&lnk->wr_tx_refs);
 
 	if (lnk->wr_rx_dma_addr) {
 		ib_dma_unmap_single(ibdev, lnk->wr_rx_dma_addr,
@@ -912,11 +914,13 @@ int smc_wr_create_link(struct smc_link *lnk)
 	init_waitqueue_head(&lnk->wr_reg_wait);
 	rc = percpu_ref_init(&lnk->wr_reg_refs, smcr_wr_reg_refs_free, 0, GFP_KERNEL);
 	if (rc)
-		goto dma_unmap;
+		goto cancel_ref;
 	init_completion(&lnk->reg_ref_comp);
 	init_waitqueue_head(&lnk->wr_rx_empty_wait);
 	return rc;
 
+cancel_ref:
+	percpu_ref_exit(&lnk->wr_tx_refs);
 dma_unmap:
 	if (lnk->wr_rx_v2_dma_addr) {
 		ib_dma_unmap_single(ibdev, lnk->wr_rx_v2_dma_addr,
-- 
2.43.0



