Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 332D026B747;
	Tue, 26 Aug 2025 13:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215083; cv=none; b=oG0kceB3AFZ9FHvXUMpxcLwhq/mKd3A2t+PCnIaBFMb/d3gwWoWWFoxh8xkmSyFfzgJfUy8XzbmxxHH7EJsIryA5SCM+HMrDVq8ZwnreBYzlXpL2Iih4bPfMVBY7seAJlgJ7i6LERISO44JfYoPzBuPqTgn5qS/LOaTA+mfqjJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215083; c=relaxed/simple;
	bh=GsBtUDGesNT4otFRvxfnh8tcwQKVo4jLD68a6SRPQs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jNnDEb2zUR32Fa8Ug1jfgcVSUXmOZXVUO+3DfAA5xNH72rWXEpwWtJFxec5o03W2HQC82BZQL5NfEhziCA5ROVDfn2HaTUjp60Q3XZLY/i2iiDPwauM9EksmcaoNXl9Xrxd3DIihEdTwr8MtwrTz6R8zXueaF567yPPhOcmq1Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R1EO+bf1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R1EO+bf1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3BBDC4CEF1;
	Tue, 26 Aug 2025 13:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215083;
	bh=GsBtUDGesNT4otFRvxfnh8tcwQKVo4jLD68a6SRPQs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R1EO+bf129vhDoWf/j0s1HHCHqDP4UUgmTFQV2tgY34+vvvNAi5mBcV2nAGzS+3sE
	 OW8FjJQWVBIxf9CKJFy/xIt4xgVlAs+smiTo9p79cShSO2P9cZj5aMbrpCOMaKaZ3r
	 QlKSmaAzmo5FymNGkLchy3GWW+/OHvfW+LGmQKrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Johan Hovold <johan@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 353/482] net: enetc: fix device and OF node leak at probe
Date: Tue, 26 Aug 2025 13:10:06 +0200
Message-ID: <20250826110939.555795554@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 70458f8a6b44daf3ad39f0d9b6d1097c8a7780ed ]

Make sure to drop the references to the IERB OF node and platform device
taken by of_parse_phandle() and of_find_device_by_node() during probe.

Fixes: e7d48e5fbf30 ("net: enetc: add a mini driver for the Integrated Endpoint Register Block")
Cc: stable@vger.kernel.org	# 5.13
Cc: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250725171213.880-3-johan@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/enetc/enetc_pf.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -1207,6 +1207,7 @@ static int enetc_pf_register_with_ierb(s
 	struct device_node *node = pdev->dev.of_node;
 	struct platform_device *ierb_pdev;
 	struct device_node *ierb_node;
+	int ret;
 
 	/* Don't register with the IERB if the PF itself is disabled */
 	if (!node || !of_device_is_available(node))
@@ -1214,16 +1215,25 @@ static int enetc_pf_register_with_ierb(s
 
 	ierb_node = of_find_compatible_node(NULL, NULL,
 					    "fsl,ls1028a-enetc-ierb");
-	if (!ierb_node || !of_device_is_available(ierb_node))
+	if (!ierb_node)
 		return -ENODEV;
 
+	if (!of_device_is_available(ierb_node)) {
+		of_node_put(ierb_node);
+		return -ENODEV;
+	}
+
 	ierb_pdev = of_find_device_by_node(ierb_node);
 	of_node_put(ierb_node);
 
 	if (!ierb_pdev)
 		return -EPROBE_DEFER;
 
-	return enetc_ierb_register_pf(ierb_pdev, pdev);
+	ret = enetc_ierb_register_pf(ierb_pdev, pdev);
+
+	put_device(&ierb_pdev->dev);
+
+	return ret;
 }
 
 static int enetc_pf_probe(struct pci_dev *pdev,


