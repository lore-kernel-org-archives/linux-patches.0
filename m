Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7E7231830;
	Mon, 17 Aug 2026 14:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976863; cv=none; b=kZMlh+0dfNt8/YTcfIOKH4KBQ2S85in1CzSZYUoD8MjvlBiaCNloYX3w+7igAO0DIcF/llJqCc34E/NZZj9GjkAcGZrxV8t8Lc99gne9gJrPI3HQf1MW+vXNE6pjrI5q3Klh4z85SN6vUff/jgLSIqmvEdAY9F60YA0dUsPf69M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976863; c=relaxed/simple;
	bh=7Sg8BdYC04TrodgbkW094aIo5zOykeK8TSn0e3w08TU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yd8PVEPdww70sq59Bq7W+RmMYFT2bSQFVX0A5QptSDNzSSoFZcDgfbrKi8ThLzhZAnStbhtf2X5xMleDUb06deEtzAxhdKxjFq7+KJz9f1NhvcJSU5GqGG7KUB1L4l7BZcWy+b8n+jwl/DCHAuo0bjZEEBN4+4YRDABpXxQzkM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YAzzOxI7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YAzzOxI7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB0221F000E9;
	Mon, 17 Aug 2026 14:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976862;
	bh=eKnPUcTWQXiBD46fMRDyVawoE8LqM/pQNxlC8frw970=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YAzzOxI7IAoupno3ATMfWk264SDnHjdQlCJyPJRCfbZonAPeLQgnb0sBKv79B1Lu9
	 pEDKiqScNj6sFquATrJ54JXZr77C4DmB2hvU7CIvTQs5keqPNa08lxpyTWMiL6bu8p
	 nX4xTEHhT23k1414OH3F5vvcvthBPfzXfVSyJDOI=
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
Subject: [PATCH 5.15 129/456] net/mlx5e: Report zero bandwidth for non-ETS traffic classes
Date: Mon, 17 Aug 2026 15:28:39 +0200
Message-ID: <20260817132545.155982659@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index dae944d28ee26d..bb1dd223ecf5ed 100644
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



