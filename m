Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC96FC00
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:33:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A29BBC433D2;
	Mon, 15 May 2023 17:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684172018;
	bh=qtwkD26VeVQY/ry07ujbaLlqs2Jxqddl2erI/AeLXuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mP86dV2dfxQpv4C3qmN6cgRwSwrboP+N+miPKxdvgDv9wScD8S0RH8r7nNnhmzJYi
	 pM5cCAvFa7ifDeeTN8v6klTf8zKU2O3XFC2ZjSXnn7exISR0s587RltYeUn4GZ9xn5
	 Z/DUelHxoHh6KEuoBmmvezmwHrYuIzkbZc0XUvmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roger Quadros <rogerq@ti.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Johan Hovold <johan+linaro@kernel.org>
Subject: [PATCH 5.10 018/381] USB: dwc3: fix runtime pm imbalance on probe errors
Date: Mon, 15 May 2023 18:24:29 +0200
Message-Id: <20230515161737.586991260@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161736.775969473@linuxfoundation.org>
References: <20230515161736.775969473@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johan Hovold <johan+linaro@kernel.org>

commit 9a8ad10c9f2e0925ff26308ec6756b93fc2f4977 upstream.

Make sure not to suspend the device when probe fails to avoid disabling
clocks and phys multiple times.

Fixes: 328082376aea ("usb: dwc3: fix runtime PM in error path")
Cc: stable@vger.kernel.org      # 4.8
Cc: Roger Quadros <rogerq@ti.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20230404072524.19014-2-johan+linaro@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/core.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -1567,13 +1567,11 @@ static int dwc3_probe(struct platform_de
 	spin_lock_init(&dwc->lock);
 	mutex_init(&dwc->mutex);
 
+	pm_runtime_get_noresume(dev);
 	pm_runtime_set_active(dev);
 	pm_runtime_use_autosuspend(dev);
 	pm_runtime_set_autosuspend_delay(dev, DWC3_DEFAULT_AUTOSUSPEND_DELAY);
 	pm_runtime_enable(dev);
-	ret = pm_runtime_get_sync(dev);
-	if (ret < 0)
-		goto err1;
 
 	pm_runtime_forbid(dev);
 
@@ -1633,12 +1631,10 @@ err3:
 	dwc3_free_event_buffers(dwc);
 
 err2:
-	pm_runtime_allow(&pdev->dev);
-
-err1:
-	pm_runtime_put_sync(&pdev->dev);
-	pm_runtime_disable(&pdev->dev);
-
+	pm_runtime_allow(dev);
+	pm_runtime_disable(dev);
+	pm_runtime_set_suspended(dev);
+	pm_runtime_put_noidle(dev);
 disable_clks:
 	clk_bulk_disable_unprepare(dwc->num_clks, dwc->clks);
 assert_reset:


