Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B85350843;
	Tue, 26 Aug 2025 14:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218315; cv=none; b=SImKOOfjZ0uETEkI8OusD52sqFOw1KyREMX2mZNU8I8CJG/MeCQNT9IvZ4YDw292zkKGS/PIjsSDmkr15BFD5A35EU9qyHx1QfiRz9DJZ1EGaMCpTXkxIT5AIBOWFpSHIbUQ596vdLw3hdUHqoMqzNdgIurQK/8QT6O9b67ugiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218315; c=relaxed/simple;
	bh=SP2c2O8wL4zJ7Vjb2OvRXhybbi4mNA1YLaLSrgoULPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZoqIv+/aW8JfVaxkffZjZ1haX8rhr0ugzOV2DvYBNa91kX9KiDYB0Wt0z9me+/cKy9hdjeP2JshKgcWzAe8Q6zQSWwJih8j6aS5o1FZ378w0NYo30D5soFxKltCPh3WeikW8DvDae7QE5W6DkSN0ycgNw/X2zuJmT3VKOhjn43w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CFK4eZZi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CFK4eZZi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 871AAC4CEF1;
	Tue, 26 Aug 2025 14:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218314;
	bh=SP2c2O8wL4zJ7Vjb2OvRXhybbi4mNA1YLaLSrgoULPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CFK4eZZi6KSFUThdCrsl9FtM3IseML/oAxvRJkJvbwGcfFoVg2TaYU7dQi4KP2ufJ
	 BVMiPVBgveG3mD9L5pKe3Se84o4QeZ9IdMFpj1VkaCs/i5rpPCrTXipl7Xl79HALuu
	 pw7RobrcQcVlDkZNK8MnJ1oih6sNkfDoCR9aUyvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 444/523] dpaa2-eth: retry the probe when the MAC is not yet discovered on the bus
Date: Tue, 26 Aug 2025 13:10:54 +0200
Message-ID: <20250826110935.403310113@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ioana Ciornei <ioana.ciornei@nxp.com>

[ Upstream commit 47325da28ef137fa04a0e5d6d244e9635184bf5e ]

The fsl_mc_get_endpoint() function now returns -EPROBE_DEFER when the
dpmac device was not yet discovered by the fsl-mc bus. When this
happens, pass the error code up so that we can retry the probe at a
later time.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: ee9f3a81ab08 ("dpaa2-eth: Fix device reference count leak in MAC endpoint handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -4134,7 +4134,11 @@ static int dpaa2_eth_connect_mac(struct
 
 	dpni_dev = to_fsl_mc_device(priv->net_dev->dev.parent);
 	dpmac_dev = fsl_mc_get_endpoint(dpni_dev);
-	if (IS_ERR_OR_NULL(dpmac_dev) || dpmac_dev->dev.type != &fsl_mc_bus_dpmac_type)
+
+	if (PTR_ERR(dpmac_dev) == -EPROBE_DEFER)
+		return PTR_ERR(dpmac_dev);
+
+	if (IS_ERR(dpmac_dev) || dpmac_dev->dev.type != &fsl_mc_bus_dpmac_type)
 		return 0;
 
 	mac = kzalloc(sizeof(struct dpaa2_mac), GFP_KERNEL);


