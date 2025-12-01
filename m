Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0358825A640;
	Mon,  1 Dec 2025 11:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588704; cv=none; b=YIULdwbzfg2xr66OvYv8NpfvWBUzwrh3tqLbIZozEfzTS7TSBH2ZiwczFwMIe93KK/IQq5Gj5iZjkZQNMW/71r8r9I/eKOFZYPsCSSsv0JI3y4/z4NCttn78Ll/igtduN64faoAwh6LvNTdaPG728ss11P/+qGhYxnRzP671p7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588704; c=relaxed/simple;
	bh=uHL8+0NsG8QnjTI7kdUddH/naFik1cj+CBL1NtBD7C0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gjGMxAItR4cvt+rFGVP0cW+9BzPql4fcCAmwA+nQarelhoDEcGp7T5nNR5Su/Af7uzVfcgnCR0cQ5pt2uL/sxRdRMEl7LtlFjUoTGqIQpIgsTj6+d5TlSp4m31ppFXSUZHlXvqFpBd3XT52nZfNRVprt2BSNshsTXtfNVoh2VkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aU0KgThw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aU0KgThw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83D40C113D0;
	Mon,  1 Dec 2025 11:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588703;
	bh=uHL8+0NsG8QnjTI7kdUddH/naFik1cj+CBL1NtBD7C0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aU0KgThwgjVp/Ry1xdpkbuQ3Wd8TefRvxln2k8fiFMmi/9gxOxgwlBjIj+r03dRMy
	 XTwFYhoChyxpctFlAy9vsC6DN4egElvIlpieiAVM3yJn/mJWQA465WtFxIeq0YG7lm
	 uL/frXCycp2WsYNWtqoy7XRhL3S5AuhvaSLGuadg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gal Pressman <gal@nvidia.com>,
	Nimrod Oren <noren@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 141/187] net/mlx5e: Fix maxrate wraparound in threshold between units
Date: Mon,  1 Dec 2025 12:24:09 +0100
Message-ID: <20251201112246.316326405@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gal Pressman <gal@nvidia.com>

[ Upstream commit a7bf4d5063c7837096aab2853224eb23628514d9 ]

The previous calculation used roundup() which caused an overflow for
rates between 25.5Gbps and 26Gbps.
For example, a rate of 25.6Gbps would result in using 100Mbps units with
value of 256, which would overflow the 8 bits field.

Simplify the upper_limit_mbps calculation by removing the
unnecessary roundup, and adjust the comparison to use <= to correctly
handle the boundary condition.

Fixes: d8880795dabf ("net/mlx5e: Implement DCBNL IEEE max rate")
Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Nimrod Oren <noren@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/1762681073-1084058-4-git-send-email-tariqt@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
index f1952e14c8042..3379f99a44dd6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
@@ -579,18 +579,19 @@ static int mlx5e_dcbnl_ieee_setmaxrate(struct net_device *netdev,
 	struct mlx5_core_dev *mdev = priv->mdev;
 	u8 max_bw_value[IEEE_8021QAZ_MAX_TCS];
 	u8 max_bw_unit[IEEE_8021QAZ_MAX_TCS];
-	__u64 upper_limit_mbps = roundup(255 * MLX5E_100MB, MLX5E_1GB);
+	__u64 upper_limit_mbps;
 	int i;
 
 	memset(max_bw_value, 0, sizeof(max_bw_value));
 	memset(max_bw_unit, 0, sizeof(max_bw_unit));
+	upper_limit_mbps = 255 * MLX5E_100MB;
 
 	for (i = 0; i <= mlx5_max_tc(mdev); i++) {
 		if (!maxrate->tc_maxrate[i]) {
 			max_bw_unit[i]  = MLX5_BW_NO_LIMIT;
 			continue;
 		}
-		if (maxrate->tc_maxrate[i] < upper_limit_mbps) {
+		if (maxrate->tc_maxrate[i] <= upper_limit_mbps) {
 			max_bw_value[i] = div_u64(maxrate->tc_maxrate[i],
 						  MLX5E_100MB);
 			max_bw_value[i] = max_bw_value[i] ? max_bw_value[i] : 1;
-- 
2.51.0



