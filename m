Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B5DB3955CE;
	Tue, 12 May 2026 17:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608554; cv=none; b=Fe8lq/JDyIVOF9hMAbdlnMf8eM9+FEsmbiUVVT3hfC5xqShB026iQqqYd6S2TSTi7gAROnJIuSD3q5wgnIVRpw0uCCXAw3dB4Px4+Qy3R7QZ6oYceo2l96hkm8p8uz552DLLuUNw9WlCsm4S1pNezPSLyrq9bT+lNAZRJ4uEr2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608554; c=relaxed/simple;
	bh=SpqhYc7Nrm+FqKXqijFK1tJrDlhgHdf6Xes+FM5qjlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EfPyXqxhFpS2NEIWbdqlY+O7ftEQ24VfEx8OcKnjlkKtLwybu0ANYrYPtZPFo4+NS+XaziFNgdExmFeLu/c9kv1qZy14RxlQ6yVOVOTA9UFXU7KoEUB3WoSLMSYKU6asF0nHa50xofVhfM5poMauXxmiGceCoZrLr0sKXTf+gbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cn+Nix6c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cn+Nix6c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CCEFC2BCB0;
	Tue, 12 May 2026 17:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608553;
	bh=SpqhYc7Nrm+FqKXqijFK1tJrDlhgHdf6Xes+FM5qjlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cn+Nix6cCE49HR6EAe8V4/yV3AfdTy+6sn4Ulax6ugBSV1+JXaVX/MyQG+C1/PDh0
	 39Pc90K29jnhjYdceFAbS9w8jXsdQPxdPjUqoSMxWQ4gbRLRfdQ7zlId6OgbyFnB3S
	 SJnEALfZGtiP0bjVcFp9yxE8/epzgxNaru1/645U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjit Waghmode <ranjit.waghmode@xilinx.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 082/270] spi: zynqmp-gqspi: fix controller deregistration
Date: Tue, 12 May 2026 19:38:03 +0200
Message-ID: <20260512173940.184353392@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 6895fc4faafc9082e15e4e624b23dd5f0c98feb5 upstream.

Make sure to deregister the controller before disabling underlying
resources like clocks during driver unbind.

Fixes: dfe11a11d523 ("spi: Add support for Zynq Ultrascale+ MPSoC GQSPI controller")
Cc: stable@vger.kernel.org	# 4.2: 64640f6c972e
Cc: stable@vger.kernel.org	# 4.2
Cc: Ranjit Waghmode <ranjit.waghmode@xilinx.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260410081757.503099-26-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-zynqmp-gqspi.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-zynqmp-gqspi.c
+++ b/drivers/spi/spi-zynqmp-gqspi.c
@@ -1324,7 +1324,7 @@ static int zynqmp_qspi_probe(struct plat
 	ctlr->dev.of_node = np;
 	ctlr->auto_runtime_pm = true;
 
-	ret = devm_spi_register_controller(&pdev->dev, ctlr);
+	ret = spi_register_controller(ctlr);
 	if (ret) {
 		dev_err(&pdev->dev, "spi_register_controller failed\n");
 		goto clk_dis_all;
@@ -1362,6 +1362,8 @@ static void zynqmp_qspi_remove(struct pl
 
 	pm_runtime_get_sync(&pdev->dev);
 
+	spi_unregister_controller(xqspi->ctlr);
+
 	zynqmp_gqspi_write(xqspi, GQSPI_EN_OFST, 0x0);
 
 	pm_runtime_disable(&pdev->dev);


