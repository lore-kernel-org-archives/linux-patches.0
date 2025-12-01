Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC67225A640;
	Mon,  1 Dec 2025 11:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588707; cv=none; b=hSYSQ64Sgns9iCa22wmzL3w2amnl/CoQgC8037oYrcD3VCiHwlIr7uK1RQVELp+caM/qXRFNnjbnsEG/V172lMZUwlx8LNHl8PGTrSKsPvtgaNHBhGaGa8V6HAmdNeyRAJEBeA9Ort/41qBf3JIfWO8LLNyD4Yn01vdWDswlYGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588707; c=relaxed/simple;
	bh=Ck+/bcfmpuVU7rfNYHiiPrtpFVTkFHhsRtijTNa3+no=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FwKILRT9jakndjCeNVoyl1sFzinKvVqvdQbfsyOb7Xi64nAqz0zsFe9NdyKt/SbPv81zscaCr+BVFHQg9kwGjYpojuwUjNr7x/j73iS0RDai4xrxpFSME3A6NeC/JlNfuQ1XUy51CrZzAcAuCBWJTnLWyO2o1O1s9lFkrnt60sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gYoGZhYF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gYoGZhYF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71036C113D0;
	Mon,  1 Dec 2025 11:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588706;
	bh=Ck+/bcfmpuVU7rfNYHiiPrtpFVTkFHhsRtijTNa3+no=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gYoGZhYFYQFY1rEjnzL2Rni6e1G+bUy6z4QJ+vPGmW7/6inMhiNuySjf/ZvRkyXYV
	 lUBrqLgwRkzlqDcq7AYqEpUZzJm7lemqT7RPiHFo+DvRBjeBXmq4prwhP8919I0X69
	 RNTJWkjMjxA8HwN+MEIhrwvLGD+JSiObogx+40fc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gal Pressman <gal@nvidia.com>,
	Nimrod Oren <noren@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 142/187] net/mlx5e: Fix wraparound in rate limiting for values above 255 Gbps
Date: Mon,  1 Dec 2025 12:24:10 +0100
Message-ID: <20251201112246.351585103@linuxfoundation.org>
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

[ Upstream commit 43b27d1bd88a4bce34ec2437d103acfae9655f9e ]

Add validation to reject rates exceeding 255 Gbps that would overflow
the 8 bits max bandwidth field.

Fixes: d8880795dabf ("net/mlx5e: Implement DCBNL IEEE max rate")
Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Nimrod Oren <noren@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/1762681073-1084058-5-git-send-email-tariqt@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
index 3379f99a44dd6..4acab31f53ac0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
@@ -580,11 +580,13 @@ static int mlx5e_dcbnl_ieee_setmaxrate(struct net_device *netdev,
 	u8 max_bw_value[IEEE_8021QAZ_MAX_TCS];
 	u8 max_bw_unit[IEEE_8021QAZ_MAX_TCS];
 	__u64 upper_limit_mbps;
+	__u64 upper_limit_gbps;
 	int i;
 
 	memset(max_bw_value, 0, sizeof(max_bw_value));
 	memset(max_bw_unit, 0, sizeof(max_bw_unit));
 	upper_limit_mbps = 255 * MLX5E_100MB;
+	upper_limit_gbps = 255 * MLX5E_1GB;
 
 	for (i = 0; i <= mlx5_max_tc(mdev); i++) {
 		if (!maxrate->tc_maxrate[i]) {
@@ -596,10 +598,16 @@ static int mlx5e_dcbnl_ieee_setmaxrate(struct net_device *netdev,
 						  MLX5E_100MB);
 			max_bw_value[i] = max_bw_value[i] ? max_bw_value[i] : 1;
 			max_bw_unit[i]  = MLX5_100_MBPS_UNIT;
-		} else {
+		} else if (max_bw_value[i] <= upper_limit_gbps) {
 			max_bw_value[i] = div_u64(maxrate->tc_maxrate[i],
 						  MLX5E_1GB);
 			max_bw_unit[i]  = MLX5_GBPS_UNIT;
+		} else {
+			netdev_err(netdev,
+				   "tc_%d maxrate %llu Kbps exceeds limit %llu\n",
+				   i, maxrate->tc_maxrate[i],
+				   upper_limit_gbps);
+			return -EINVAL;
 		}
 	}
 
-- 
2.51.0



