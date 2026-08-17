Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55693EC82D;
	Mon, 17 Aug 2026 14:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975643; cv=none; b=QkaxLvmOknkZyySdvmu9dgxcO4oSLFgGF41+7MSP503ggMHUYzCsrdP/HlVt57fQtlnDPmW0rk+qJDyYZQLroO+7Dl391zxdGWgyGCeF+VC0HYaw9Le0sjvxVvEuPZSVIZH0vyHiCsinCnGUv9JqPQJbrgrPJOlSXdPwuZWox+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975643; c=relaxed/simple;
	bh=e/6ikijHebmU76rSbvuq13e+u5Fsqn+TQCnbyba/H7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bGwPILI0hniLXOdFdgLR0CFmc8oODSSW/WiiU2XU1slMQIEmFrP4GIRh7O0CctDWWKOTVrWild7JT7BQQMbdwi6zSrokYt3nh7MyfZtZjQdnj77I/QP8AmYo2DnQax7rJp8E4vALLa3Y1i44Qjzzc4dDM5RJJVXEa0AwvVlRkqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HWDkRDAA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HWDkRDAA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54B721F000E9;
	Mon, 17 Aug 2026 14:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975641;
	bh=wgFZogqOq3j2xdrbYegb8no1lYDP3F+vACVENqYOJGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HWDkRDAA1BkCyFRwXGyiRVd4oZnMEfKvIbtKvaq7mUNpkzYA6oe3KvGXZaC24yKEc
	 Ia1KnVimR4qSFuAACjAKNa8HopZlYWi8ZhVCcpLUop1Q8wb+9KNP7S8aJ3UHI6XVTW
	 vtelt676Fe9pv8e1d+Klmn9p0/ERfCxR2rcEIIG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Lazar <alazar@nvidia.com>,
	Carolina Jubran <cjubran@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 097/389] net/mlx5e: Report zero bandwidth for non-ETS traffic classes
Date: Mon, 17 Aug 2026 15:28:56 +0200
Message-ID: <20260817132542.904226063@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

From: Alexei Lazar <alazar@nvidia.com>

[ Upstream commit ffb1873b2df11945b8c395e859169248675c91c5 ]

The IEEE 802.1Qaz standard defines that bandwidth allocation percentages
only apply to Enhanced Transmission Selection (ETS) traffic classes.
For STRICT and VENDOR transmission selection algorithms, bandwidth
percentage values are not applicable.

Currently for non-ETS 100 bandwidth is being reported for all traffic
classes in the get operation due to hardware limitation, regardless of
their TSA type.

Fix this by reporting 0 for non-ETS traffic classes.

Fixes: 820c2c5e773d ("net/mlx5e: Read ETS settings directly from firmware")
Signed-off-by: Alexei Lazar <alazar@nvidia.com>
Reviewed-by: Carolina Jubran <cjubran@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Link: https://patch.msgid.link/20260717075125.1244877-2-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
index 5d0be9703a48e1..c1d1c21f41b4b1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
@@ -158,6 +158,13 @@ static int mlx5e_dcbnl_ieee_getets(struct net_device *netdev,
 	}
 	memcpy(ets->tc_tsa, priv->dcbx.tc_tsa, sizeof(ets->tc_tsa));
 
+	/* Report 0 for non ETS TSA */
+	for (i = 0; i < ets->ets_cap; i++) {
+		if (ets->tc_tx_bw[i] == MLX5E_MAX_BW_ALLOC &&
+		    priv->dcbx.tc_tsa[i] != IEEE_8021QAZ_TSA_ETS)
+			ets->tc_tx_bw[i] = 0;
+	}
+
 	return err;
 }
 
-- 
2.53.0



