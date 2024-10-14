Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B9C156256;
	Mon, 14 Oct 2024 15:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919899; cv=none; b=iswTh6DC0gkraKygABgZ2j4UhgiSknVz3CJCYbMdcOAs1+ptLTt4NHjcBsGOOGA3kqEAX+Nl41QWAH3sqp3zqbXmkrSUIXP89SgFHfCJsI26bdhHfS1TasAZz1fPGyGBJxtk033GhG5Jrcw0aza4FrHTrB4uUP55e6WYBknPwH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919899; c=relaxed/simple;
	bh=IYK8JriQIz9AHY0TL3woCeC961ZLos8eJ6JMTGyVIT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cFbQq3YRYwyohLsEh/3OJeRNq4xpqRwVoFkQX4T/ipyYaorrxCvnGZ1bm75HSCGqREbKNXwU57I060AwjGT/rzi9L4PPkB7nCPOP+/2Wph2BSDa78gndVeagv9lxUUykwmQORcSg8SSUMtBgcLSrE6UkC1D/4Zv7u+KL16rUuHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lNYQSPc1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lNYQSPc1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 550D9C4CEC3;
	Mon, 14 Oct 2024 15:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919898;
	bh=IYK8JriQIz9AHY0TL3woCeC961ZLos8eJ6JMTGyVIT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lNYQSPc19CRjpO38fVeZ3borY5d/s7Qg2S9GQNxvZVWRNwGIQWzJ3PWkWb6jbxmpl
	 c4RnaAh5+Ec9LiCFf1UzqDgA/HMRlUEhhHVzgmIfitIY0xZjafWD6jzhJK6QMcSRhQ
	 GzNNlSJ11BWqcOVpDSSOjcZzbfxSWNUrS1I9T7hs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Hunter <jonathanh@nvidia.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Furong Xu <0x1207@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 740/798] Revert "net: stmmac: set PP_FLAG_DMA_SYNC_DEV only if XDP is enabled"
Date: Mon, 14 Oct 2024 16:21:34 +0200
Message-ID: <20241014141247.142046215@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 5546da79e6cc5bb3324bf25688ed05498fd3f86d ]

This reverts commit b514c47ebf41a6536551ed28a05758036e6eca7c.

The commit describes that we don't have to sync the page when
recycling, and it tries to optimize that case. But we do need
to sync after allocation. Recycling side should be changed to
pass the right sync size instead.

Fixes: b514c47ebf41 ("net: stmmac: set PP_FLAG_DMA_SYNC_DEV only if XDP is enabled")
Reported-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://lore.kernel.org/20241004070846.2502e9ea@kernel.org
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Furong Xu <0x1207@gmail.com>
Link: https://patch.msgid.link/20241004142115.910876-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index b5b7ff5b32616..93630840309e7 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2015,7 +2015,7 @@ static int __alloc_dma_rx_desc_resources(struct stmmac_priv *priv,
 	rx_q->queue_index = queue;
 	rx_q->priv_data = priv;
 
-	pp_params.flags = PP_FLAG_DMA_MAP | (xdp_prog ? PP_FLAG_DMA_SYNC_DEV : 0);
+	pp_params.flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV;
 	pp_params.pool_size = dma_conf->dma_rx_size;
 	num_pages = DIV_ROUND_UP(dma_conf->dma_buf_sz, PAGE_SIZE);
 	pp_params.order = ilog2(num_pages);
-- 
2.43.0



