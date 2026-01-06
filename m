Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B2D836402C;
	Tue,  6 Jan 2026 17:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721851; cv=none; b=s6wAXn4nqevPteRXBs7REc+mXT0yhLKBUkhNx/NWXYmJHoGyA2oPD1++2Ngf1piyCxZRbWMGoOCkVQ64qD4qQXa674pwckIugS/1MNIEAqNsR2jjjfActoFdMf+hiX1Xt0YNjeieWFDLFif8tfo+VCV1Smu9tsM6t4bbxQT4+bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721851; c=relaxed/simple;
	bh=vjYYqYIrgWDoub5Xa/gjxihIlrLYt4Jvl8HKcWHc3Dg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CQAPQxLZsw64cGkrOHxaSkPwlPKnWa39utwwOlPdiTYgm1/k84bFstBatZjS4edzvTpS7iNDABJI6o6fuozyK6Ssd2hdCOht26ZAwij+kC3X9bjs8cVzaTdGPHhATNsLfkyWFcFxVZBN2TmV08AkNYQDZPfzRCLK5kTu8A3ltoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S9M9+4jN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S9M9+4jN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A30D7C116C6;
	Tue,  6 Jan 2026 17:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721851;
	bh=vjYYqYIrgWDoub5Xa/gjxihIlrLYt4Jvl8HKcWHc3Dg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S9M9+4jNWzsyk1Jc23RuF9KA3AhhSU9U1UCdLPmwhAHRASN1JpcIqybdM5p9cHTDt
	 finWrI+Uxuva8chbR8iNK9eyYJ/+ccfnZOPK1YatP/vB1EUHkl6GkLqB0HGt5UyniD
	 nxp8Tx3QuY+5AGTTaAh9KYJzoyuLbNMw5aqqnA3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 057/312] platform/x86/intel/pmt/discovery: use valid device pointer in dev_err_probe
Date: Tue,  6 Jan 2026 18:02:11 +0100
Message-ID: <20260106170549.913852023@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit 66e245db16f0175af656cd812b6dc1a5e1f7b80a ]

The PMT feature probe creates a child device with device_create().
If device creation fail, the code pass priv->dev (which is an ERR_PTR)
to dev_err_probe(), which is not a valid device pointer.

This patch change the dev_err_probe() call to use the parent auxiliary
device (&auxdev->dev) and update the error message to reference the
parent device name. It ensure correct error reporting and avoid
passing an invalid device pointer.

Fixes: d9a078809356 ("platform/x86/intel/pmt: Add PMT Discovery driver")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Link: https://patch.msgid.link/20251224095133.115678-1-alok.a.tiwari@oracle.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/pmt/discovery.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/intel/pmt/discovery.c b/drivers/platform/x86/intel/pmt/discovery.c
index 9c5b4d0e1fae..e500aa327d23 100644
--- a/drivers/platform/x86/intel/pmt/discovery.c
+++ b/drivers/platform/x86/intel/pmt/discovery.c
@@ -548,9 +548,9 @@ static int pmt_features_probe(struct auxiliary_device *auxdev, const struct auxi
 	priv->dev = device_create(&intel_pmt_class, &auxdev->dev, MKDEV(0, 0), priv,
 				  "%s-%s", "features", dev_name(priv->parent));
 	if (IS_ERR(priv->dev))
-		return dev_err_probe(priv->dev, PTR_ERR(priv->dev),
+		return dev_err_probe(&auxdev->dev, PTR_ERR(priv->dev),
 				     "Could not create %s-%s device node\n",
-				     "features", dev_name(priv->dev));
+				     "features", dev_name(priv->parent));
 
 	/* Initialize each feature */
 	for (i = 0; i < ivdev->num_resources; i++) {
-- 
2.51.0



