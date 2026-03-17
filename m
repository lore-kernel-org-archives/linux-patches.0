Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D443ECBE3;
	Tue, 17 Mar 2026 16:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765641; cv=none; b=eyRTYEvkzJukx69xcqX7V1L6aZBlVjvXOzULp6nkNdnHHZk9J7A3Om0wDaYxbNl8vnqR6v40ZSNpDIYNBK8ta4bP9RZV2DkVDMKaa5iWFTSBDpT1Dnut2YbANybSbj6LuuOmBbBziJqDr5W8mXpxCIy3/UVUhfiLVx0c64gqinc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765641; c=relaxed/simple;
	bh=xsLuYpLj50Ufn2Kin/D84i2djCbA/G5xCzUIrHF83FU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bgBmBQam/Cm+F0es7wkpTCwnAy1euMTmS7GqkB4zeoKRXdZTrlRVXnbyVWgpqriKyHszjlPMC1wLK6g1/FRGySILTvUIHziptsP0bhHw1KSQLMSV4ABzpIJeX5Qq5kC7ffbhCJ7dHtCkcr65bqpyUNSVSTa9/9XST6C7WHzs8oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T8FIPZWb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T8FIPZWb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 856FCC2BCB1;
	Tue, 17 Mar 2026 16:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765641;
	bh=xsLuYpLj50Ufn2Kin/D84i2djCbA/G5xCzUIrHF83FU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T8FIPZWb9WDzQS+C/+zq3x/2fkOiRoE14lqsTGqgBp+p3j8Of8nQ1G/tJg7m9wOZM
	 7E07MOPbl/6fQ1FPdpa7HnAxf5UpqtrarLPAMjl1HRi2Zo/XH6Q5/9WAZhGvW2qzPs
	 jm1EYtGt4gbgXI/NQ9RJ2U5oyR6oO0FXdZweHtHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 056/378] spi: rockchip-sfc: Fix double-free in remove() callback
Date: Tue, 17 Mar 2026 17:30:13 +0100
Message-ID: <20260317163009.052338269@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 111e2863372c322e836e0c896f6dd9cf4ee08c71 ]

The driver uses devm_spi_register_controller() for registration, which
automatically unregisters the controller via devm cleanup when the
device is removed. The manual call to spi_unregister_controller() in
the remove() callback can lead to a double-free.

And to make sure controller is unregistered before DMA buffer is
unmapped, switch to use spi_register_controller() in probe().

Fixes: 8011709906d0 ("spi: rockchip-sfc: Support pm ops")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Link: https://patch.msgid.link/20260310-sfc-v2-1-67fab04b097f@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-rockchip-sfc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-rockchip-sfc.c b/drivers/spi/spi-rockchip-sfc.c
index b3c2b03b11535..8acf955636977 100644
--- a/drivers/spi/spi-rockchip-sfc.c
+++ b/drivers/spi/spi-rockchip-sfc.c
@@ -712,7 +712,7 @@ static int rockchip_sfc_probe(struct platform_device *pdev)
 		}
 	}
 
-	ret = devm_spi_register_controller(dev, host);
+	ret = spi_register_controller(host);
 	if (ret)
 		goto err_register;
 
-- 
2.51.0



