Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6EA7385D85;
	Tue, 12 May 2026 17:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778607869; cv=none; b=VpMWYze0RsToXi7dmj3XVJVFKLOF/8raTfFfq26IIxLqV4409TpksWzmxo5FmA8Bi+V+HhMPyxf7/DFYqymcjMEeXcJu+IgAyyjtfmE8U5oOYZ8y4YsyjXtR0vKDY6MZ0VAcGzxu6J9exqoFunPxqHQCzngAKsTpXTYrH+WjSlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778607869; c=relaxed/simple;
	bh=WMdSfKJN9fX/XKUFTwg5cl6uDYrxgjV+/9w0sxcFCmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n98wYGysEFygeIa8xiWewnFwU6xDHCKExvzZ24nI7VmrGMvzYGcLPYXU0aqW0mcU2eZ8ue0Lep/ycoiIoOaCnNIO1JkiNuI/ORnWboEQ3f5se1N/QlfLJUP9IdDn5QihOz2kudrH7kpkpe/bFxdyKvxx63l6dq+j5TgfBUzeTzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g8oKzr21; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g8oKzr21"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D61CC2BCC7;
	Tue, 12 May 2026 17:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778607869;
	bh=WMdSfKJN9fX/XKUFTwg5cl6uDYrxgjV+/9w0sxcFCmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g8oKzr219pB7+bc0pOm8V01oeB507lUiY0n2gb+EbkS2SzQx3Cq1CAzX7i1fwh4yw
	 4CTdQvN5QNRN7t4YbTxJjzz6e1KhUn+s65RXIX/RsprfhAShJ26ZliQ9oci6PVCVA+
	 U3JdVyU6CBDUoVlq6i67FK0tDaK9WXi5VWcvnCpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 068/206] spi: sun4i: fix controller deregistration
Date: Tue, 12 May 2026 19:38:40 +0200
Message-ID: <20260512173934.285893042@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 42108a2f03e0fdeabe9d02d085bdb058baa1189f upstream.

Make sure to deregister the controller before disabling underlying
resources like clocks during driver unbind.

Fixes: b5f6517948cc ("spi: sunxi: Add Allwinner A10 SPI controller driver")
Cc: stable@vger.kernel.org	# 3.15
Cc: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260410081757.503099-19-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-sun4i.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-sun4i.c
+++ b/drivers/spi/spi-sun4i.c
@@ -504,7 +504,7 @@ static int sun4i_spi_probe(struct platfo
 	pm_runtime_enable(&pdev->dev);
 	pm_runtime_idle(&pdev->dev);
 
-	ret = devm_spi_register_controller(&pdev->dev, host);
+	ret = spi_register_controller(host);
 	if (ret) {
 		dev_err(&pdev->dev, "cannot register SPI host\n");
 		goto err_pm_disable;
@@ -522,7 +522,15 @@ err_free_host:
 
 static void sun4i_spi_remove(struct platform_device *pdev)
 {
+	struct spi_controller *host = platform_get_drvdata(pdev);
+
+	spi_controller_get(host);
+
+	spi_unregister_controller(host);
+
 	pm_runtime_force_suspend(&pdev->dev);
+
+	spi_controller_put(host);
 }
 
 static const struct of_device_id sun4i_spi_match[] = {


