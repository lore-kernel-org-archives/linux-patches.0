Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EECD52949E0;
	Fri, 15 May 2026 16:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862005; cv=none; b=I+9fkQhQzqD/Itv96UeUO8UqgY4FAOl9MMtvtWYbRxlJpYBnLDjvoyrJMHfHFe216PL7nMP2VtE1JkPU7U8r2Y7duUt3QdufYD/HJYS7X1is8lwkDfpwZLoWNOlQ7iQi8ZTcWh1C7CSsEg5wNYA0QAAR6G3plVBIO4RGzvaE7V0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862005; c=relaxed/simple;
	bh=Mht681929TBeqQO8WGNmGVlhD3HvRxzw+I4nNuSfxoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kiq1agKGTavIesTEqSdxntEHmNjnlBNLtkmWUT70Ynrga+EVNAXSi+LcfIIFBzZKsqXj6/pnqba0KAQefuLrwpPV731CNtltrrzt1FO8ld+FXzH5gNW+tq/VMY33zHTwOa03EsgoszltnIkfMR/In+R75vuXFixb8nya7BRyQC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tOAw9CGx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tOAw9CGx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85FAFC2BCB0;
	Fri, 15 May 2026 16:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862004;
	bh=Mht681929TBeqQO8WGNmGVlhD3HvRxzw+I4nNuSfxoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tOAw9CGxGSnoafgBeiuQ9R2KmZjS7D75dLT5xIugZWRd4oFdM/ad7ygQSfnntggww
	 r3gi/7+4u3WpG/wfeUr0qr5vNkewZcoOgmrED+rn3mq/5mFxLIkJZey8CJP6JdO7Mh
	 CjkD6ocFJ3aszIXTgho4CykMQUjSI9oPUyUpNwO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leilk Liu <leilk.liu@mediatek.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 064/188] spi: mt65xx: fix controller deregistration
Date: Fri, 15 May 2026 17:48:01 +0200
Message-ID: <20260515154658.704216228@linuxfoundation.org>
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
@@ -1326,7 +1326,7 @@ static int mtk_spi_probe(struct platform
 
 	pm_runtime_enable(dev);
 
-	ret = devm_spi_register_controller(dev, host);
+	ret = spi_register_controller(host);
 	if (ret) {
 		pm_runtime_disable(dev);
 		return dev_err_probe(dev, ret, "failed to register host\n");
@@ -1341,6 +1341,8 @@ static void mtk_spi_remove(struct platfo
 	struct mtk_spi *mdata = spi_controller_get_devdata(host);
 	int ret;
 
+	spi_unregister_controller(host);
+
 	cpu_latency_qos_remove_request(&mdata->qos_request);
 	if (mdata->use_spimem && !completion_done(&mdata->spimem_done))
 		complete(&mdata->spimem_done);


