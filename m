Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE193F86E1;
	Fri, 15 May 2026 16:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861395; cv=none; b=b+cqOs4lHyGTdxu84AAv462Uwr/ZCySGpOcGnc7HHM0Xi3NBiBMeG0Jr6VWJbANDtxbOCTXj6YTqinha641lCONqcuQgCgqyFDR++cnarCCGp+xZ5HLviNzCEUtSKwtUw7Jcu8inZcFWR2nfWKl9Q573GUr38yyPyIdtPlJrmnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861395; c=relaxed/simple;
	bh=+P2x8BUDOtes6AZaYkH9R7qCAjO0Ed+t5Kzjg+76Od8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QLCRXfkO16tSQMOUKlAjSi5mbYxL8Bq8asVHe7oDxGUZFkYId6roc/c+ezRfZ9Q+90O47jL4Qyygh+lEq4aD+qOLhTkPugSgVrv7b239mhlsBYtgCzilqOSCDiOwMIBBJ3jKcnkfnm96bFdRn3Yg9ofNgLH0yNTdJbpi973expQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YomkVmAx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YomkVmAx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 405C2C2BCB3;
	Fri, 15 May 2026 16:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861394;
	bh=+P2x8BUDOtes6AZaYkH9R7qCAjO0Ed+t5Kzjg+76Od8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YomkVmAxiI/VEY/jcqMNdsDvqyFRg0vEQZY/G2uyCvTmzEo3r+32cKQcwbWFmYqiT
	 b7rMa0p34tQ0dMxcp21w5S9gx+pGoEdDIw9BjtCUeLNMWxkOZWFpQxH05PlyeoNFmz
	 9to8dPI8Tsb9Gd/njq7EQkf+kNFd/OokxEDWmwOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 312/474] spi: qup: fix controller deregistration
Date: Fri, 15 May 2026 17:47:01 +0200
Message-ID: <20260515154721.761376565@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1149,7 +1149,7 @@ static int spi_qup_probe(struct platform
 	pm_runtime_set_active(dev);
 	pm_runtime_enable(dev);
 
-	ret = devm_spi_register_controller(dev, host);
+	ret = spi_register_controller(host);
 	if (ret)
 		goto disable_pm;
 
@@ -1274,6 +1274,10 @@ static void spi_qup_remove(struct platfo
 	struct spi_qup *controller = spi_controller_get_devdata(host);
 	int ret;
 
+	spi_controller_get(host);
+
+	spi_unregister_controller(host);
+
 	ret = pm_runtime_get_sync(&pdev->dev);
 
 	if (ret >= 0) {
@@ -1293,6 +1297,8 @@ static void spi_qup_remove(struct platfo
 
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
+
+	spi_controller_put(host);
 }
 
 static const struct of_device_id spi_qup_dt_match[] = {


