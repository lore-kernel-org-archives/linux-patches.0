Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAC112C11DF;
	Fri, 15 May 2026 16:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862663; cv=none; b=LudnW2zrqCymLrYTf9egI5bpuMpfdswrZNRmSt6GoRy8OEnpbz8ZzWjXANbzBzDgTmXpMWlk/8MiqgiEvlZymlNxmxwHUoA9L21LwYCETRs8ab1BgjHJfeW765Ukz0/K62Nce9FGH5tvmS9BBe0P1NeQ0Wg7WvSY2M668pvQuic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862663; c=relaxed/simple;
	bh=e5IVDCBiXNewWxeFVJKVkn9rDrZ/jWWdSZ7MB92+Qm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PAnuhRCp8OGbGbasLP8jEAzb0dGTgAmmcOi+lr9etqF6L5Rx0dV3UVEYJuwa47a9SwR4huWvGNe0+QakMEikpQ8UbIP9kfx1vr7ynePc225GSYSMxm+XFpQyHRqQgY0VX/16yt2x5DmaGdpjgZ0PkCc5RynjeFuAePVSBPKIgPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rZc1wU3y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rZc1wU3y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EFA2C2BCB0;
	Fri, 15 May 2026 16:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862663;
	bh=e5IVDCBiXNewWxeFVJKVkn9rDrZ/jWWdSZ7MB92+Qm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rZc1wU3yN8Zc2YPD32BecHI1cPI5anuRuhGvnKufx4o1FxEB39OO0PO2E4/PqrzWH
	 X/mFftcOh9jSK3WNljA7ZmG5qYglbBbRuGcXGuLmHPeCwc4bZHSV8OzK9ZX6uSmr97
	 sgNFPZaRWrkor9wWkXzMh4BMzmRlqNrpI0WosVXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leilk Liu <leilk.liu@mediatek.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 084/201] spi: mt65xx: fix controller deregistration
Date: Fri, 15 May 2026 17:48:22 +0200
Message-ID: <20260515154700.350465306@linuxfoundation.org>
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

commit 2ad30599cccc572ba2fc11010670eb6e01ea6bfc upstream.

Make sure to deregister the controller before disabling underlying
resources like clocks during driver unbind.

Fixes: a568231f4632 ("spi: mediatek: Add spi bus for Mediatek MT8173")
Cc: stable@vger.kernel.org	# 4.3: ace145802350
Cc: stable@vger.kernel.org	# 4.3
Cc: Leilk Liu <leilk.liu@mediatek.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260410081757.503099-2-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-mt65xx.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-mt65xx.c
+++ b/drivers/spi/spi-mt65xx.c
@@ -1325,7 +1325,7 @@ static int mtk_spi_probe(struct platform
 
 	pm_runtime_enable(dev);
 
-	ret = devm_spi_register_controller(dev, host);
+	ret = spi_register_controller(host);
 	if (ret) {
 		pm_runtime_disable(dev);
 		return dev_err_probe(dev, ret, "failed to register host\n");
@@ -1340,6 +1340,8 @@ static void mtk_spi_remove(struct platfo
 	struct mtk_spi *mdata = spi_controller_get_devdata(host);
 	int ret;
 
+	spi_unregister_controller(host);
+
 	cpu_latency_qos_remove_request(&mdata->qos_request);
 	if (mdata->use_spimem && !completion_done(&mdata->spimem_done))
 		complete(&mdata->spimem_done);


