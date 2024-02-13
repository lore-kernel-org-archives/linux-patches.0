Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773895FDD6;
	Tue, 13 Feb 2024 17:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845737; cv=none; b=jmIL2chdMTOpf+WQy9Y0JG9pkkzG5IUTqxmvyE4eifFK66ay59gCVWggZfLE3JmJOxbnOOhixbhEk1IkBllYBKPjFNPF1R7LU3eAIBythMCQnUF0k/3Tc86IJm48JZLia/TL4GPoARggRRzp/9KucNFfALaixkGIO8lEZFZsVqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845737; c=relaxed/simple;
	bh=n5+VFOli/xyFCyD/lVQW4wyA93fPx0EbNEtR9McT7OU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mkn5NjNh8ZCicROqgU+Avk1vgCqf7YjHFPUPo8NjQCTEPvOwXU3MVhv31EmxVDhRAtyxNR70I5cA9gdkXKOZUuK1FMyBjREdD3J73BPNNUWxG381J8ntp0dEHjL89oPAt6qZ4aS6OK6OCkmikJktcDsT2PnCb2aStpOcd8g0uEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=17gEjnb9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="17gEjnb9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 755F2C433C7;
	Tue, 13 Feb 2024 17:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845736;
	bh=n5+VFOli/xyFCyD/lVQW4wyA93fPx0EbNEtR9McT7OU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=17gEjnb9NO3vjdF83J/bAdgWH7ApNy1n7uHV84pKJG3NIHjukC2PJ1rYC7S0u8kHE
	 WS++5cyYRWgJlzVEL+2B+BKX5G1Fv2fssh/MZv1zIb+tpnRDlfYUIoMWpTxxLs7NBG
	 QhDooGNHaZ23kUSt+6abqvzTv9a1Y0OzkMb5m7U8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Jiri Pirko <jiri@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 042/124] octeontx2-pf: Fix a memleak otx2_sq_init
Date: Tue, 13 Feb 2024 18:21:04 +0100
Message-ID: <20240213171854.966132031@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhipeng Lu <alexious@zju.edu.cn>

[ Upstream commit b09b58e31b0f43d76f79b9943da3fb7c2843dcbb ]

When qmem_alloc and pfvf->hw_ops->sq_aq_init fails, sq->sg should be
freed to prevent memleak.

Fixes: c9c12d339d93 ("octeontx2-pf: Add support for PTP clock")
Signed-off-by: Zhipeng Lu <alexious@zju.edu.cn>
Acked-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 7ca6941ea0b9..02d0b707aea5 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -951,8 +951,11 @@ int otx2_sq_init(struct otx2_nic *pfvf, u16 qidx, u16 sqb_aura)
 	if (pfvf->ptp && qidx < pfvf->hw.tx_queues) {
 		err = qmem_alloc(pfvf->dev, &sq->timestamps, qset->sqe_cnt,
 				 sizeof(*sq->timestamps));
-		if (err)
+		if (err) {
+			kfree(sq->sg);
+			sq->sg = NULL;
 			return err;
+		}
 	}
 
 	sq->head = 0;
@@ -968,7 +971,14 @@ int otx2_sq_init(struct otx2_nic *pfvf, u16 qidx, u16 sqb_aura)
 	sq->stats.bytes = 0;
 	sq->stats.pkts = 0;
 
-	return pfvf->hw_ops->sq_aq_init(pfvf, qidx, sqb_aura);
+	err = pfvf->hw_ops->sq_aq_init(pfvf, qidx, sqb_aura);
+	if (err) {
+		kfree(sq->sg);
+		sq->sg = NULL;
+		return err;
+	}
+
+	return 0;
 
 }
 
-- 
2.43.0



