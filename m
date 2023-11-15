Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 752153C481
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UJVGL4Jv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C9F9C433C9;
	Wed, 15 Nov 2023 19:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077253;
	bh=pUz03s7MmfuRFkf/PonQVu8gTGmwQHok7C32vGfDe0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UJVGL4JvZ0YGDceYgaG4H0ZA1bG53xMN5MN4a26Ydytb8pvC+YKEKWUXN31dVzY8O
	 3POEDX6kkZrIF9wprM24wViGEieCuh6+uXlkw0xSES0yh3gkQ9uxSJmmwiEgSq40a5
	 mOPTFFsrvdpd7xUTMTiTnwJhLnDFYWtizsWqYeOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Shurong <zhang_shurong@foxmail.com>,
	Helen Koike <helen.koike@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 159/603] spi: tegra: Fix missing IRQ check in tegra_slink_probe()
Date: Wed, 15 Nov 2023 14:11:44 -0500
Message-ID: <20231115191624.196463004@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Zhang Shurong <zhang_shurong@foxmail.com>

[ Upstream commit eb9913b511f10968a02cfa5329a896855dd152a3 ]

This func misses checking for platform_get_irq()'s call and may passes the
negative error codes to request_irq(), which takes unsigned IRQ #,
causing it to fail with -EINVAL, overriding an original error code.

Fix this by stop calling request_irq() with invalid IRQ #s.

Fixes: dc4dc3605639 ("spi: tegra: add spi driver for SLINK controller")
Signed-off-by: Zhang Shurong <zhang_shurong@foxmail.com>
Reviewed-by: Helen Koike <helen.koike@collabora.com>
Link: https://lore.kernel.org/r/tencent_73FCC06A3D1C14EE5175253C6FB46A07B709@qq.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-tegra20-slink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/spi/spi-tegra20-slink.c b/drivers/spi/spi-tegra20-slink.c
index 4d6db6182c5ed..f5cd365c913a8 100644
--- a/drivers/spi/spi-tegra20-slink.c
+++ b/drivers/spi/spi-tegra20-slink.c
@@ -1086,6 +1086,8 @@ static int tegra_slink_probe(struct platform_device *pdev)
 	reset_control_deassert(tspi->rst);
 
 	spi_irq = platform_get_irq(pdev, 0);
+	if (spi_irq < 0)
+		return spi_irq;
 	tspi->irq = spi_irq;
 	ret = request_threaded_irq(tspi->irq, tegra_slink_isr,
 				   tegra_slink_isr_thread, IRQF_ONESHOT,
-- 
2.42.0



