Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A74350D7C;
	Tue, 26 Aug 2025 13:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216090; cv=none; b=C8ZDKH2O6WCNSPgTKT8kq31fmQmsEepSpoY54BHighquJvT5La/CbHP1CHXGYltJwndGulEz+kgSD0wA9Dv8geztMHYcxJo1yy9XjDgYGCjvbyaSnNx/EwUoy1+98lVZZerWozdK4xlbFrsNsE0DZFz/15m4wqUcNZ4FaoqhjeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216090; c=relaxed/simple;
	bh=1Eeicl2ftS3CSaSECQwomQP4Z8VRpl9r2AA15m/Wwco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cNM3L5O3S/Jbqk9AbNx4JhiyzqFjtqlawaG9MmEk7AXo5ijVtZZCINzYHRft5svhAW5qJHHHvE+XlbUB+31Biiof5NCuY76m2IIJtOGB7S5Pr8Nq07rYCwYJYpbrF2ZkpURd7oyCALTTEal0OPcUE8WDvACt07ot74RM9eTxH2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gfhvE13Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gfhvE13Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D034EC4CEF1;
	Tue, 26 Aug 2025 13:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216090;
	bh=1Eeicl2ftS3CSaSECQwomQP4Z8VRpl9r2AA15m/Wwco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gfhvE13ZJs5atoZG2wVQ5TCUdmno12Dl4vR2gBnwgPQlLergTDS1H/voB+IxVdaaz
	 sW0hytzfosdft44hkeetaMkGgxBHYpdJc5VLF4URtikUryfEowBN7zZcCABC7R0zNY
	 sI2P1MnXBpNG1O7jJP6HOd13Rk98P2xSHjroRvjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yangbo Lu <yangbo.lu@nxp.com>,
	Johan Hovold <johan@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 263/644] net: gianfar: fix device leak when querying time stamp info
Date: Tue, 26 Aug 2025 13:05:54 +0200
Message-ID: <20250826110952.892771606@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Johan Hovold <johan@kernel.org>

commit da717540acd34e5056e3fa35791d50f6b3303f55 upstream.

Make sure to drop the reference to the ptp device taken by
of_find_device_by_node() when querying the time stamping capabilities.

Note that holding a reference to the ptp device does not prevent its
driver data from going away.

Fixes: 7349a74ea75c ("net: ethernet: gianfar_ethtool: get phc index through drvdata")
Cc: stable@vger.kernel.org	# 4.18
Cc: Yangbo Lu <yangbo.lu@nxp.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250725171213.880-4-johan@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/gianfar_ethtool.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/freescale/gianfar_ethtool.c
+++ b/drivers/net/ethernet/freescale/gianfar_ethtool.c
@@ -1461,8 +1461,10 @@ static int gfar_get_ts_info(struct net_d
 	if (ptp_node) {
 		ptp_dev = of_find_device_by_node(ptp_node);
 		of_node_put(ptp_node);
-		if (ptp_dev)
+		if (ptp_dev) {
 			ptp = platform_get_drvdata(ptp_dev);
+			put_device(&ptp_dev->dev);
+		}
 	}
 
 	if (ptp)


