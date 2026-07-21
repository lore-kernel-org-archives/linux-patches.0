Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6305C3859EE;
	Tue, 21 Jul 2026 17:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656554; cv=none; b=czHjE8gadfecT+vAkB0wAilnL1FKIH/Wxrx8igZXdY6zYO0bSku5OK00PQ87n2eTmR8wPl1TOUvQJp4iIl/Moit6Pv4U7KO/BhHSQXk7+b28SHnAPQKwl2pPODMf/MeFTBE+Ej6iQwlZ+rbE0QhXf+AvHYiajMejgROKMdhDogg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656554; c=relaxed/simple;
	bh=qI1T3ZtAcsva3Quh48C98Hud9eev8vjergyB+7Z9kHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UDvmkbiGRbQHwWhAMo/r3hYWjQbPtGTjA3K0HNB2D9IG0DkYG64XjhIgrIt2I2+A/i+k9fOk9Z8N0WDN7dw1bQWnAk5ZSQ13ukFZO7mwglA073K+8+zk6MAZr57Z5mQTyhjJYWeTGIFCNJSgvWf9IXTr9MZvZ8aSFTJIdr6lKiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dd2RgDBe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dd2RgDBe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C707C1F000E9;
	Tue, 21 Jul 2026 17:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656553;
	bh=ySS7YsndHjzOhtGyE55FCCpHlPgVClzE/WvZmzWIr4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dd2RgDBerJ1L7ZmSHJV/d4dsfrK2SMjTz+MCuJKSVdYmZohsIT4wGOIsoQ8TV1Zjp
	 KWQlvTe03X2z6D86DTkueFuswpTD3qt2LdHvJCTkJFop8mchu5T0Hx3e57jAT8VhNK
	 6ZyOikUcJQpkOCGPdstC56+x+5yc1fbVUhgPVFFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0432/1611] spi: meson-spifc: fix runtime PM leak on remove
Date: Tue, 21 Jul 2026 17:09:08 +0200
Message-ID: <20260721152524.995504068@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 606c0826bd90384a54571c0c5475ca41f50164ea ]

pm_runtime_get_sync() increments the runtime PM usage counter even when it
returns an error. meson_spifc_remove() uses it to resume the controller
before disabling runtime PM, but never drops the usage counter again.

Balance the get with pm_runtime_put_noidle() after disabling runtime PM,
matching the teardown pattern used by other SPI controller drivers.

Found by static analysis. I do not have hardware to test this.

Fixes: c3e4bc5434d2 ("spi: meson: Add support for Amlogic Meson SPIFC")
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Link: https://patch.msgid.link/20260609052647.5-1-ruoyuw560@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-meson-spifc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-meson-spifc.c b/drivers/spi/spi-meson-spifc.c
index ef7efeaeee97ee..e19ca48a2b6531 100644
--- a/drivers/spi/spi-meson-spifc.c
+++ b/drivers/spi/spi-meson-spifc.c
@@ -352,6 +352,7 @@ static void meson_spifc_remove(struct platform_device *pdev)
 {
 	pm_runtime_get_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
+	pm_runtime_put_noidle(&pdev->dev);
 }
 
 #ifdef CONFIG_PM_SLEEP
-- 
2.53.0



