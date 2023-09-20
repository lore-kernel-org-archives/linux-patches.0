Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A44992AB5E
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:10:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A555C433C7;
	Wed, 20 Sep 2023 12:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211836;
	bh=Y68bkvIauV5/1kK1s/P54iO5h52mhyeRxV/V9UFabE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dhgq+ZCM4Rrt3Ad7jBOn+buI9Uyd2hTGkqMwUF02j3bdpJpZu+VZ1SbCeumHjIPiE
	 UpOSZs1JpvCFWhO16hRFsHF4LBO1ETwE0GNyesOy7afDB2oVy8nBr3nih6aDABpOv5
	 C1lyIPj4bJzeDNC+Q8JAhAORR7rbeV9NxwgduROU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Shurong <zhang_shurong@foxmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 053/273] spi: tegra20-sflash: fix to check return value of platform_get_irq() in tegra_sflash_probe()
Date: Wed, 20 Sep 2023 13:28:13 +0200
Message-ID: <20230920112848.067928070@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112846.440597133@linuxfoundation.org>
References: <20230920112846.440597133@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Shurong <zhang_shurong@foxmail.com>

[ Upstream commit 29a449e765ff70a5bd533be94babb6d36985d096 ]

The platform_get_irq might be failed and return a negative result. So
there should have an error handling code.

Fixed this by adding an error handling code.

Fixes: 8528547bcc33 ("spi: tegra: add spi driver for sflash controller")
Signed-off-by: Zhang Shurong <zhang_shurong@foxmail.com>
Link: https://lore.kernel.org/r/tencent_71FC162D589E4788C2152AAC84CD8D5C6D06@qq.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-tegra20-sflash.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-tegra20-sflash.c b/drivers/spi/spi-tegra20-sflash.c
index 749288310c36c..2989795272a16 100644
--- a/drivers/spi/spi-tegra20-sflash.c
+++ b/drivers/spi/spi-tegra20-sflash.c
@@ -469,7 +469,11 @@ static int tegra_sflash_probe(struct platform_device *pdev)
 		goto exit_free_master;
 	}
 
-	tsd->irq = platform_get_irq(pdev, 0);
+	ret = platform_get_irq(pdev, 0);
+	if (ret < 0)
+		goto exit_free_master;
+	tsd->irq = ret;
+
 	ret = request_irq(tsd->irq, tegra_sflash_isr, 0,
 			dev_name(&pdev->dev), tsd);
 	if (ret < 0) {
-- 
2.40.1



