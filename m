Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B5EC16F84F;
	Wed,  2 Oct 2024 13:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875582; cv=none; b=QIpamRQuCemHv3+ViZ+AgrJGD4myPcVcWTHpZ6BdMOHp8AE5cMe6kyoyZEr9xvKQTF2/Y3KwOhOfH1CLaHy3ETaCLh5eS6p/54LxyFiRpzyOXdA0HgEu0TJiQhsirxFP3R/6cFzX0LvnTIp8d7kgTAddtBEb1ejFr1A/ejJBN6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875582; c=relaxed/simple;
	bh=KLqKHH+RVr3YvvBw1GHowUuKrjn4kMUZgQyZROTXkBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ws/Ld8b/8re1j32Uo0IxfCjRnD+PyS25SrycE4H9q+aeR1dD0LbF5N5mKOgvad2RGDb0nWKdE/RcJVf2ndWl2KJfKg1FV0I7GyFYUlf2lmN9gkr5OYmf2czodbMomjvKFJbFCQJY9hd4GMiO7ntVwKHfyPZKSOb5QQle/GiNF9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1jUyZrwW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1jUyZrwW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3511C4CEC5;
	Wed,  2 Oct 2024 13:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875582;
	bh=KLqKHH+RVr3YvvBw1GHowUuKrjn4kMUZgQyZROTXkBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1jUyZrwWlBBxd5RX5FuXh9NEWtUwHL04dfQqcH+gHAls7K8Su+SShuRWTa2dCI6UB
	 GrzbGohauOZFZcwU0gi410GVJNNFInAS81tAPy2iAsTsV7H+QOhFbShnTHslwes/Xz
	 UoWanUcY9c4wvapmjlGIFY8mRoHcia3fj7gRPrEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	William Zhang <william.zhang@broadcom.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 149/695] spi: bcmbca-hsspi: Fix missing pm_runtime_disable()
Date: Wed,  2 Oct 2024 14:52:27 +0200
Message-ID: <20241002125828.429542672@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit 4439a2e92cb89028b22c5d7ba1b99e75d7d889f6 ]

The pm_runtime_disable() is missing in remove function, use
devm_pm_runtime_enable() to fix it. So the pm_runtime_disable() in
the probe error path can also be removed.

Fixes: a38a2233f23b ("spi: bcmbca-hsspi: Add driver for newer HSSPI controller")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Reviewed-by: William Zhang <william.zhang@broadcom.com>
Link: https://patch.msgid.link/20240826124903.3429235-2-ruanjinjie@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bcmbca-hsspi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-bcmbca-hsspi.c b/drivers/spi/spi-bcmbca-hsspi.c
index 9f64afd8164ea..4965bc86d7f52 100644
--- a/drivers/spi/spi-bcmbca-hsspi.c
+++ b/drivers/spi/spi-bcmbca-hsspi.c
@@ -546,12 +546,14 @@ static int bcmbca_hsspi_probe(struct platform_device *pdev)
 			goto out_put_host;
 	}
 
-	pm_runtime_enable(&pdev->dev);
+	ret = devm_pm_runtime_enable(&pdev->dev);
+	if (ret)
+		goto out_put_host;
 
 	ret = sysfs_create_group(&pdev->dev.kobj, &bcmbca_hsspi_group);
 	if (ret) {
 		dev_err(&pdev->dev, "couldn't register sysfs group\n");
-		goto out_pm_disable;
+		goto out_put_host;
 	}
 
 	/* register and we are done */
@@ -565,8 +567,6 @@ static int bcmbca_hsspi_probe(struct platform_device *pdev)
 
 out_sysgroup_disable:
 	sysfs_remove_group(&pdev->dev.kobj, &bcmbca_hsspi_group);
-out_pm_disable:
-	pm_runtime_disable(&pdev->dev);
 out_put_host:
 	spi_controller_put(host);
 out_disable_pll_clk:
-- 
2.43.0



