Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ACB53FD948;
	Fri, 15 May 2026 16:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861921; cv=none; b=hKMIGqjPXX52nGLhrfWN5luu91PyrSLhLVgNzRStub/VI4UI8GAkYlX1PEZfLG8np5AMMNQttW7FhMhVJGXRNbMlVTQcpFE9Es08Lf+b5Ta+Sr2Oamz0PLkhAJiQyT2VR3iYgwe1rBC0NTLijo/vaVcLsW6x87fHUajolQ3fXkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861921; c=relaxed/simple;
	bh=KXIy79TMK14r5p8QZjxQcA74nfITP9aWuc6Xdrhtnqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NXTrYXcBLPqFOwoJzWtrLjNGQPaMIZktuI/CbCjLFKI1ur4YR/ZjCMNRsbsyTOXw/b357hUQbj+zX9bXODrv/NV3sD8ufy0r6qXeg4Mg0P49BdhXClauG3SPS4zOK+ER+Z1wZCALcF9J8hKpwalvTP/6Pqj3l6GD5nNAmPh+NNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1IK7xN29; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1IK7xN29"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2CD1C2BCB0;
	Fri, 15 May 2026 16:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861921;
	bh=KXIy79TMK14r5p8QZjxQcA74nfITP9aWuc6Xdrhtnqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1IK7xN299Fr8vd8LLF5IXW93UpnEDUBA5/iHj9odbVJBPZo4l2Qu/jihhh3PGwLRE
	 10lNmovSUyMb5f8ZEByTLLFEntZDvZfSnprkGDcwpn6cycGdFHZwlLv5wmm/Nk5ZzL
	 N0tQgArupqCwzn1h0w1RcN5OD0ysoM/V6NMx+NNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 039/188] spi: qup: fix controller deregistration
Date: Fri, 15 May 2026 17:47:36 +0200
Message-ID: <20260515154658.157990042@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

commit 443e3a0005a4342b218b6dbd4c6387d3c7fed85a upstream.

Make sure to deregister the controller before disabling underlying
resources like clocks during driver unbind.

Fixes: 64ff247a978f ("spi: Add Qualcomm QUP SPI controller support")
Cc: stable@vger.kernel.org	# 3.15
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260410081757.503099-10-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-qup.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-qup.c
+++ b/drivers/spi/spi-qup.c
@@ -1194,7 +1194,7 @@ static int spi_qup_probe(struct platform
 	pm_runtime_set_active(dev);
 	pm_runtime_enable(dev);
 
-	ret = devm_spi_register_controller(dev, host);
+	ret = spi_register_controller(host);
 	if (ret)
 		goto disable_pm;
 
@@ -1321,6 +1321,10 @@ static void spi_qup_remove(struct platfo
 	struct spi_qup *controller = spi_controller_get_devdata(host);
 	int ret;
 
+	spi_controller_get(host);
+
+	spi_unregister_controller(host);
+
 	ret = pm_runtime_get_sync(&pdev->dev);
 
 	if (ret >= 0) {
@@ -1340,6 +1344,8 @@ static void spi_qup_remove(struct platfo
 
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
+
+	spi_controller_put(host);
 }
 
 static const struct of_device_id spi_qup_dt_match[] = {


