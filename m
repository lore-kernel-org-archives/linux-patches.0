Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5FAC30569D;
	Fri, 15 May 2026 15:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860761; cv=none; b=uWv4QErZ0zlKmStV1FJyaNevhwHwFdE6GkeKJi2hW6rddCQw807CafAbhr5qHy6lhMMtnbI39lIpxypvTRmyiP4O1g7+I6EyZBoQK+qr89Tn7l+/t4Znk6wrhJgmEgH+iVgP+GtOfhVLmVxDQJClTgzXiTLmTqEp6QmNJqXf6O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860761; c=relaxed/simple;
	bh=yaFXRRs0znVxy0s/xlKNYpfhmzF5s/qC1ljWLjOyyXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qbrs9fG6AwpvvdTZqk8SOn5qIpVD+BklDHpSGoGrW+O4SYG0Iz8MthpLr4ZXdlcdFTeLKR74xjpp86hOmSbGlM6UmLSu1WrA2ZoxBjb6wZ5uWsVU7rW6xRpH0oDJRdqp95j92LwP/XY3RZWapquZmJgGtuJM1+3ib+dJylOv9JA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zRbWyb0U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zRbWyb0U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23433C2BCB3;
	Fri, 15 May 2026 15:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860761;
	bh=yaFXRRs0znVxy0s/xlKNYpfhmzF5s/qC1ljWLjOyyXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zRbWyb0UFELkXONelGkDnD9/+aUO/OgVjAdiLTCTu+oWYG1Zeu+o+w0x0x7+P796I
	 qmQ/RwjmUxoknCV70kCmpStbgDQtZlQUjpBBx1bPT3H9+mJviYmqVEBaCNm3tzwJEM
	 7rUrhSI++MATUu8OyyF29DgHsouj7RpWGJon5Kf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 027/474] spi: imx: fix use-after-free on unbind
Date: Fri, 15 May 2026 17:42:16 +0200
Message-ID: <20260515154715.637404049@linuxfoundation.org>
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

commit 1c78c2002380a1fe31bfb01a3d5f29809e55a096 upstream.

The SPI subsystem frees the controller and any subsystem allocated
driver data as part of deregistration (unless the allocation is device
managed).

Take another reference before deregistering the controller so that the
driver data is not freed until the driver is done with it.

Fixes: 307c897db762 ("spi: spi-imx: replace struct spi_imx_data::bitbang by pointer to struct spi_controller")
Cc: stable@vger.kernel.org	# 5.19
Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260324082326.901043-2-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-imx.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -1898,6 +1898,8 @@ static void spi_imx_remove(struct platfo
 	struct spi_imx_data *spi_imx = spi_controller_get_devdata(controller);
 	int ret;
 
+	spi_controller_get(controller);
+
 	spi_unregister_controller(controller);
 
 	ret = pm_runtime_get_sync(spi_imx->dev);
@@ -1911,6 +1913,8 @@ static void spi_imx_remove(struct platfo
 	pm_runtime_disable(spi_imx->dev);
 
 	spi_imx_sdma_exit(spi_imx);
+
+	spi_controller_put(controller);
 }
 
 static int __maybe_unused spi_imx_runtime_resume(struct device *dev)


