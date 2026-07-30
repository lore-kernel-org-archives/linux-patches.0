Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27AC9441638;
	Thu, 30 Jul 2026 14:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422139; cv=none; b=tOFXPSpCR68v+vruPQM46dewG4ZT8m4vOXVzQlshg52dzWz4r+bpg178FIBmnErYJtwNNYYTclBt38owTs7hsXHA6RrCe5rwfA9jdD7XW94zLkJju+bMkjz/6NUL8ydBE4oS+6yHo4w6bidU0i94QyI+UzoiGGs2LqfDVqU3Cac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422139; c=relaxed/simple;
	bh=ULV14bvaBgIxumbSv6BYmWWDrJjf9UAxQ16MbOjZghs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hJR6msMWVp+8kNZZeOYz3tTWXBbdA7zi+eYfpjY/qcnGvGOsJh2BEFzWY2I2+deYWp/baOvH4WbxGRa24QGav/GQsN0TG4gBvtXeV87JB6+p9Zvew+32aqdX+y6tLorac3GBTVwhj1QHdo6BRY6khMgosJBqJwIDRytxARPXTcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wzgl47yD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wzgl47yD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 138A01F000E9;
	Thu, 30 Jul 2026 14:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422136;
	bh=/02CW7G4Pqd9+ms0y6/M+2Sfg5NUDHFf1OpQGoaRhnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wzgl47yDD1xweO+Jecf2KqmlB+1hOZaDYXwcPgyXyq8mmVf3vapgW2AbSN16S8u7a
	 vOV8Yq/D0TcaEbZVcNYWAPlA1tznw/hNHQCUMRs0U80n93tG3odAdt4jDYMvanfu+U
	 zBRm30dcH3paBhoCXj7ejK/835hvum6MrYRZ0fUI=
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
Subject: [PATCH 7.1 337/744] net/mlx5e: Report zero bandwidth for non-ETS traffic classes
Date: Thu, 30 Jul 2026 16:10:10 +0200
Message-ID: <20260730141451.446223170@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4b86df6d5b9eaa..762f0a46c12097 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
@@ -173,6 +173,13 @@ static int mlx5e_dcbnl_ieee_getets(struct net_device *netdev,
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



