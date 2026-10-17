Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F63217BED0;
	Sat, 17 Oct 2026 16:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253442; cv=none; b=DZGs2BgqwMmjCTk0qOpEp6cC58G6IXdV15adYqbUUXWUW42szLp7pDAutGNizsKw+cKsmoT4PumzkQZsGgN/IPhkyKLDSHLsPA6RnLkzY1+pll1BtNLOuvYqS+X+phR4uZrNNat2Y/sRWjRKCLElGNE2AAYD7L5u6+PkR9YeleA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253442; c=relaxed/simple;
	bh=QunwK59tYblnK/VK7/bpF0/+sf2DfcKpNdatdN1k9gs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a+IBJ7SGUGwTCpZ87CUt/wdMFMl8dv8sVzLkBPsar0AVDLqz82I+X0efv+CkY+y53V0oC2eMzWk1nHI89Q43LvVAUFel6RWJpU8ToypliaogwZm2+rAIzlEMxtLmEv5o21JNQzF4kW0X2Xy8HxPapdD6VytsyPfMC/fHeixrDz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K28+937J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K28+937J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 771F61F000C5;
	Sat, 17 Oct 2026 16:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253441;
	bh=W2ighKaTygObXBWdlEzr+KIHeRmFrs5N9tOvAtn83dQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K28+937Jy1wTelBrpNUQYf0IA+r3pCt8sYeYYrRS+AJkqzmtbm7anGdCBU1Ae5PPH
	 rXghBIN0x84zvxmj+tn4W+r9oPfvHlh6K39nsv+gs9EPCJoz09R1yrdwoMQUdtGoga
	 jOQv3ryi+ngRRgrdSE9vV6pjVZGNWuYW7FwG15kc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lama Kayal <lkayal@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 120/869] net/mlx5: HWS, Fix memory leak in hws_action_get_shared_stc_nic error flow
Date: Sat, 17 Oct 2026 17:49:21 +0200
Message-ID: <20261017160040.119485265@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Lama Kayal <lkayal@nvidia.com>

[ Upstream commit a630f83592cdad1253523a1b760cfe78fef6cd9c ]

When an invalid stc_type is provided, the function allocates memory for
shared_stc but jumps to unlock_and_out without freeing it, causing a
memory leak.

Fix by jumping to free_shared_stc label instead to ensure proper cleanup.

Fixes: 504e536d9010 ("net/mlx5: HWS, added actions handling")
Signed-off-by: Lama Kayal <lkayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Link: https://patch.msgid.link/20250825143435.598584-3-mbloch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_action.c   | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_action.c
index 667fa29830b6f..4fbe0d9d594db 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_action.c
@@ -112,7 +112,7 @@ static int hws_action_get_shared_stc_nic(struct mlx5hws_context *ctx,
 		mlx5hws_err(ctx, "No such stc_type: %d\n", stc_type);
 		pr_warn("HWS: Invalid stc_type: %d\n", stc_type);
 		ret = -EINVAL;
-		goto unlock_and_out;
+		goto free_shared_stc;
 	}
 
 	ret = mlx5hws_action_alloc_single_stc(ctx, &stc_attr, tbl_type,
-- 
2.53.0



