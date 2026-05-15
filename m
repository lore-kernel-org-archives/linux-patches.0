Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1355D3FBB74;
	Fri, 15 May 2026 16:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862401; cv=none; b=hWWe8utTB/HDb83qMa67Z6f/bg+JHeYxy0quW5KlJUuNC+59DPC1BhO8qjePUDv4Z1P9WEWjmA7ubZACLZs73gqOPILUg3I/DEn9wzm+tCiB24KTW74Yqy4LtbyWNFuLo8+oaBqdKw34IQN3uP+oHoRHK+yBqwee9nOV/g0h2O0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862401; c=relaxed/simple;
	bh=ZID1Xc+MdiKwfXZ2L7pXEVQ3Wx0sFpseb74wis9Qco4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GClPY2ZiWk0IbWehRezZZ5Ym5tZYk7aK3cFAvo5JyGhbma85la77Z6a8XFG49hDqh7fq6+3PkxbWXV33qN8susy/g3byeclEhRahqMXJ6QtywlkvADFc0T6qM0+5xw97xAWE/lS73B9xM63DoO47j9jkROXlJOrIwkBAJvV8A4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2I+DxXbR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2I+DxXbR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72027C2BCB3;
	Fri, 15 May 2026 16:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862400;
	bh=ZID1Xc+MdiKwfXZ2L7pXEVQ3Wx0sFpseb74wis9Qco4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2I+DxXbRKSvweYjtkrD4JCoD1FRHzIgn4I+UZEmGQrsQRxONkfWqnp+GT8tra7LMc
	 vKjLVcAC65qjUq9mkiYvjYHCzFOWtb3FzmXtFM8DcWquv+SjSw08x47VtgzZ+B4Ifg
	 FQkw1mFiAPtnYTZa3ZKUqORLxCpoyCIbhW3LSTa8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 033/201] spi: st-ssc4: fix controller deregistration
Date: Fri, 15 May 2026 17:47:31 +0200
Message-ID: <20260515154659.251205762@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 19857374010d06ca6a2f7c2c53464122eb804df0 upstream.

Make sure to deregister the controller before disabling underlying
resources like clocks during driver unbind.

Fixes: 9e862375c542 ("spi: Add new driver for STMicroelectronics' SPI Controller")
Cc: stable@vger.kernel.org	# 4.0
Cc: Lee Jones <lee@kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260410081757.503099-18-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-st-ssc4.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-st-ssc4.c
+++ b/drivers/spi/spi-st-ssc4.c
@@ -349,7 +349,7 @@ static int spi_st_probe(struct platform_
 
 	platform_set_drvdata(pdev, host);
 
-	ret = devm_spi_register_controller(&pdev->dev, host);
+	ret = spi_register_controller(host);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to register host\n");
 		goto rpm_disable;
@@ -371,10 +371,16 @@ static void spi_st_remove(struct platfor
 	struct spi_controller *host = platform_get_drvdata(pdev);
 	struct spi_st *spi_st = spi_controller_get_devdata(host);
 
+	spi_controller_get(host);
+
+	spi_unregister_controller(host);
+
 	pm_runtime_disable(&pdev->dev);
 
 	clk_disable_unprepare(spi_st->clk);
 
+	spi_controller_put(host);
+
 	pinctrl_pm_select_sleep_state(&pdev->dev);
 }
 


