Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D4C830AADC;
	Fri, 21 Nov 2025 13:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731718; cv=none; b=epfJQzhjtdCcXmhSP6ptzbjQR5g6Vz5rc1+LazfryFRltxh5uSEx5ExFNXaNM6tKpnoNO+dEFzwiB/G5TIRL99bhAXKi43XkA6mP+d6QCClDh52hOfpv7IT2ulUjUR7OXCArMlx1tcUsCxbKiNhTd/1XnpCXFUwmnbfFRhOAO2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731718; c=relaxed/simple;
	bh=1FXBdTE3d1yBYDNr7w5NS3SC+roI2vy5aezhcMQpW0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oBUCRMYmMn9uYwbZhFe5zyWmIUiijRoz4oNlrSp79wfnHEYZHdNVckzj7w+MgMQPKytmfGUMTFhn/1Dqche5yP/UTgDuPjpiZd6Vzbyo7aO3DX7E7GEr3brJ3KjPRxF9IMpLWwYcUI4IhbA69pvFCx9ofDAILWleGBq1qEPquu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QcZzIXj9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QcZzIXj9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BA45C4CEF1;
	Fri, 21 Nov 2025 13:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731717;
	bh=1FXBdTE3d1yBYDNr7w5NS3SC+roI2vy5aezhcMQpW0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QcZzIXj9uskWeDHYCx1E6vK6XmNZsvjWiXDlpRF5DluB0rpWjNE8Y86HApYqYDUcT
	 gyUBUj/xPCeKXPHf9eSmMPsBQA+ffdyZfExlLtrmdHrhueo6yhtmPACAq/6XeePTff
	 DOxpukX/iNHa/k3OrcmqSuA50TNt0Rk8RZjHNIWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gal Pressman <gal@nvidia.com>,
	Nimrod Oren <noren@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 057/185] net/mlx5e: Fix wraparound in rate limiting for values above 255 Gbps
Date: Fri, 21 Nov 2025 14:11:24 +0100
Message-ID: <20251121130145.935217902@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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
index 99ee288ed43a4..154f8d9eec02a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
@@ -596,11 +596,13 @@ static int mlx5e_dcbnl_ieee_setmaxrate(struct net_device *netdev,
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
@@ -612,10 +614,16 @@ static int mlx5e_dcbnl_ieee_setmaxrate(struct net_device *netdev,
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



