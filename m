Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D9E315D53;
	Tue, 21 Jul 2026 18:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659148; cv=none; b=IU2GOkysbdnSbWSglPDdFfMr79ac326T0BzDrvDlucCMsHtkjOdgM2cg5zpcKEaVCbqcX115vPZX8eQC/Axhdx4ZeE5ZcqrjaNoYz4t7QZLo/r3qRnN6fslxdiVpVdBQiyHaTVO2YS09uVmeBFiSGtpaxclftMhanjBEul6quf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659148; c=relaxed/simple;
	bh=HF9n6IG08J/BTtqn9lbuw7BFTBkEQnOswYtzft1BQtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a/uVAi9AL8Oih7ERWZpyV+nCfp9rewNcyep2E3GJ28VJQqw28LeNokSd9yu9lAg6D039Zk2ZFfU1btZ4G1SO2T4QnqepoJLsZ7TnZsi1jrnFRZQ24P22d8U5cKXYInPWNcEFV8LnZqf8PR6Z/nZ/pbAUvZcnwyhKJgISuSMa/8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZlMGobu8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZlMGobu8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53B591F000E9;
	Tue, 21 Jul 2026 18:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659146;
	bh=M9caWIMpdV4KGdYG/2bZFZ1Fm0FPW3JkMAt58Yjg9nM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZlMGobu82TSU487/QFcDoaqTxCJLNIfiK+gLGXIZFKapgl53H8gXCYJ9khoX1LjBJ
	 oWcBEEFBeU9THEvmiLmJb0gun+ZZqk7cO6fxgzLd03V72d96St+DYF/Nbd6sntJTHu
	 TEbXxFJOAjxjMWxg1nsJLaeR97O5+Taeu0B9bc3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 1411/1611] octeontx2-af: Free BPID bitmap on setup failure
Date: Tue, 21 Jul 2026 17:25:27 +0200
Message-ID: <20260721152547.178842930@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Haoxiang Li <haoxiang_li2024@163.com>

commit 36323f54cd323122a1be89ab2c316a6e55a94e30 upstream.

nix_setup_bpids() allocates bp->bpids with rvu_alloc_bitmap(), which uses
a plain kcalloc(). If any of the following devm_kcalloc() allocations for
the BPID mapping arrays fails, the function returns without freeing the
bitmap. Free the BPID bitmap before returning from those error paths.

Fixes: d6212d2e41a0 ("octeontx2-af: Create BPIDs free pool")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260623114316.2182271-1-haoxiang_li2024@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -527,19 +527,24 @@ static int nix_setup_bpids(struct rvu *r
 	bp->fn_map = devm_kcalloc(rvu->dev, bp->bpids.max,
 				  sizeof(u16), GFP_KERNEL);
 	if (!bp->fn_map)
-		return -ENOMEM;
+		goto free_bpids;
 
 	bp->intf_map = devm_kcalloc(rvu->dev, bp->bpids.max,
 				    sizeof(u8), GFP_KERNEL);
 	if (!bp->intf_map)
-		return -ENOMEM;
+		goto free_bpids;
 
 	bp->ref_cnt = devm_kcalloc(rvu->dev, bp->bpids.max,
 				   sizeof(u8), GFP_KERNEL);
 	if (!bp->ref_cnt)
-		return -ENOMEM;
+		goto free_bpids;
 
 	return 0;
+
+free_bpids:
+	rvu_free_bitmap(&bp->bpids);
+	bp->bpids.bmap = NULL;
+	return -ENOMEM;
 }
 
 void rvu_nix_flr_free_bpids(struct rvu *rvu, u16 pcifunc)


