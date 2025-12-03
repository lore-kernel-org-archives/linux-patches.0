Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DAAB3168E8;
	Wed,  3 Dec 2025 15:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776583; cv=none; b=DPU8eBjtnb+DohC7emXzwWl6e3TZPTppIST6xhnl9dDz+AChwHhk2/LEcnfKdEyTqqTKEg9TuyxoxrUNsvOvg43t9KCAZlMkppDUTO30J9Df+p7WFxgNyw8ysyGD9ae7okRUfBwqd6z3tc52r+apxV2DV3mYlDwk+UelCgCtZxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776583; c=relaxed/simple;
	bh=ohY71j4HHKxEg5tdBOYH35Fed/Wkchxui/wwbZUdoOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oju5jDsz8JPwQnC7l9OnK1zlxArgjMZW22HdIiIP5/ZGrz7C+n1hrLQx9ua/MJmKLzpTk+tPmSsNQ7el7K6eVZPq9vzgaI18ZFtt5gFqtYoB2VAS2gK55zSqJtLiFxSL4j6rfyyMgtHHxHMmQh/f15kb6pYUMj6kNLCn1gyKgms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lp7h53TB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lp7h53TB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE824C4CEF5;
	Wed,  3 Dec 2025 15:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776583;
	bh=ohY71j4HHKxEg5tdBOYH35Fed/Wkchxui/wwbZUdoOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lp7h53TBR/T/puUnrUzghWALCd3xNoaPFHQAvihV2ClrEhNlhkXlF/XbyDjxfYBsT
	 LaJ6H1Kj2OhzrmGT7r2BgEczZ37dPYOCxGXQF8P8hamSM0YqTEUNGrRCdda6YgAfBV
	 OZyT68s06eQcHReV2xCQp/Zvbz5rHOMEVnzhcNiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 226/300] mlxsw: spectrum: Fix memory leak in mlxsw_sp_flower_stats()
Date: Wed,  3 Dec 2025 16:27:10 +0100
Message-ID: <20251203152408.998120975@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit 407a06507c2358554958e8164dc97176feddcafc ]

The function mlxsw_sp_flower_stats() calls mlxsw_sp_acl_ruleset_get() to
obtain a ruleset reference. If the subsequent call to
mlxsw_sp_acl_rule_lookup() fails to find a rule, the function returns
an error without releasing the ruleset reference, causing a memory leak.

Fix this by using a goto to the existing error handling label, which
calls mlxsw_sp_acl_ruleset_put() to properly release the reference.

Fixes: 7c1b8eb175b69 ("mlxsw: spectrum: Add support for TC flower offload statistics")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20251112052114.1591695-1-zilin@seu.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index 41855e58564b1..3d99b16ebd553 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -650,8 +650,10 @@ int mlxsw_sp_flower_stats(struct mlxsw_sp *mlxsw_sp,
 		return -EINVAL;
 
 	rule = mlxsw_sp_acl_rule_lookup(mlxsw_sp, ruleset, f->cookie);
-	if (!rule)
-		return -EINVAL;
+	if (!rule) {
+		err = -EINVAL;
+		goto err_rule_get_stats;
+	}
 
 	err = mlxsw_sp_acl_rule_get_stats(mlxsw_sp, rule, &packets, &bytes,
 					  &drops, &lastuse, &used_hw_stats);
-- 
2.51.0



