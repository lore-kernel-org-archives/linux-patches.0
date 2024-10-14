Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D1E1ADFFB;
	Mon, 14 Oct 2024 15:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919499; cv=none; b=d7KOXnjHZG6OlDug1DLV+jOn9clpuKXFU8XvxhTQFwB+gLXae3W3+4767pkY78I5HzWs+m4dc74rYOsrMhfkII9WMkGRBARVReeK89jgF4DgfOC4W1aiyvvsIh+/xIKQM2hP+J7a3vxELFVjevYHeV4ke7DKiZXHkS2/wAQWzd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919499; c=relaxed/simple;
	bh=Y3ijdciqb8aetLxTYCUj1pdwsV8aPQr4iOAbQLTufwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Puo4ehWgCscCEFfEkmsQ+PJi2VuWTESQze/JbZzjbwGi+IH+WANj6Q+4HLLQggZRc/iVEPSl9KnQZGlnhKI5aoY8ao7+m6HRJTTY3dvWAIxooY5HH+VyF7JGH2RI13qw/MpwRMrn5E5vKOhEQilcXqCaFf5qSSui/r5k3fymmbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vysbm7jE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vysbm7jE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE7CAC4CEC3;
	Mon, 14 Oct 2024 15:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919499;
	bh=Y3ijdciqb8aetLxTYCUj1pdwsV8aPQr4iOAbQLTufwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vysbm7jEI8ICKpjQRQ0HFO69cYuMoS9Rij5IO5vrCVkbivNkajiwH8rBkz9KwBQ1K
	 hP3DSrB585TJgwEr7Jky5XFQ0AT+OsAappjsQdu84TGKWtDkZjOU+HKvC6g7KfjvNB
	 z2v+foejFl5WRXgl6e38vRM74mku8A4XqJB1YWGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 623/798] spi: bcm63xx: Fix missing pm_runtime_disable()
Date: Mon, 14 Oct 2024 16:19:37 +0200
Message-ID: <20241014141242.514019901@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit 265697288ec2160ca84707565d6641d46f69b0ff ]

The pm_runtime_disable() is missing in the remove function, fix it
by using devm_pm_runtime_enable(), so the pm_runtime_disable() in
the probe error path can also be removed.

Fixes: 2d13f2ff6073 ("spi: bcm63xx-spi: fix pm_runtime")
Cc: stable@vger.kernel.org # v5.13+
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Suggested-by: Jonas Gorski <jonas.gorski@gmail.com>
Link: https://patch.msgid.link/20240819123349.4020472-3-ruanjinjie@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bcm63xx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-bcm63xx.c b/drivers/spi/spi-bcm63xx.c
index 51296615536a9..695ac74571286 100644
--- a/drivers/spi/spi-bcm63xx.c
+++ b/drivers/spi/spi-bcm63xx.c
@@ -595,13 +595,15 @@ static int bcm63xx_spi_probe(struct platform_device *pdev)
 
 	bcm_spi_writeb(bs, SPI_INTR_CLEAR_ALL, SPI_INT_STATUS);
 
-	pm_runtime_enable(&pdev->dev);
+	ret = devm_pm_runtime_enable(&pdev->dev);
+	if (ret)
+		goto out_clk_disable;
 
 	/* register and we are done */
 	ret = devm_spi_register_master(dev, master);
 	if (ret) {
 		dev_err(dev, "spi register failed\n");
-		goto out_pm_disable;
+		goto out_clk_disable;
 	}
 
 	dev_info(dev, "at %pr (irq %d, FIFOs size %d)\n",
@@ -609,8 +611,6 @@ static int bcm63xx_spi_probe(struct platform_device *pdev)
 
 	return 0;
 
-out_pm_disable:
-	pm_runtime_disable(&pdev->dev);
 out_clk_disable:
 	clk_disable_unprepare(clk);
 out_err:
-- 
2.43.0



