Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354221779B1;
	Tue,  8 Oct 2024 12:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391164; cv=none; b=FxCvGzRIyQQlx2mMXWoi8BYRgGZfjCdyLwUz4FPACtnk6bUCSbTzZS8VEGtiaxqSmx6Sp2/gqpbJms6sbq+gLrN6tc0d5KmZEewIKkTzGbYGIbg6mjSMQQEgoI1QDYhaTW7bISWHTxta67NbTqp7186yuXphsT/P2HnAjuf171w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391164; c=relaxed/simple;
	bh=o3u1MYOZ3bfJLcO9qQGFucaGmL/a98i5hqauGBCEDAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ABdB4gQBmyPSIg7GPwTZ3gOwXv1mg9A5IQBa2TIhA2hEb0aNy86FR8vXfH6SvNE4zZF4/QRJrx12cimbQ29/diTw4c4P0XfaDOJiIu4FTF2ljRVKlPzBSHyAs553SpQmUafO+cNRV8HK3NZQPjCiRmGVD1IoXhZDLwZFtGWaWxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kJgLv/Xo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kJgLv/Xo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8FB2C4CEC7;
	Tue,  8 Oct 2024 12:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391164;
	bh=o3u1MYOZ3bfJLcO9qQGFucaGmL/a98i5hqauGBCEDAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kJgLv/XoVOfLz2Q/41nvX61lYTFimeZi2Zayg7prE3gomy/OEQhKn2c+ZoKPNoXsk
	 fU226n+o7uj1M5FWVbtJP7tl30sXJpFoDgs8SXFujdqO7CD5DogRqjtEjdMPOGKTcI
	 NRmxi5oludQypFnNCawNjiKwnUGUJxAMXynmocJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Sergey Ryazanov <ryazanov.s.a@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 027/558] net: wwan: qcom_bam_dmux: Fix missing pm_runtime_disable()
Date: Tue,  8 Oct 2024 14:00:57 +0200
Message-ID: <20241008115703.291800442@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

[ Upstream commit d505d3593b52b6c43507f119572409087416ba28 ]

It's important to undo pm_runtime_use_autosuspend() with
pm_runtime_dont_use_autosuspend() at driver exit time.

But the pm_runtime_disable() and pm_runtime_dont_use_autosuspend()
is missing in the error path for bam_dmux_probe(). So add it.

Found by code review. Compile-tested only.

Fixes: 21a0ffd9b38c ("net: wwan: Add Qualcomm BAM-DMUX WWAN network driver")
Suggested-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Reviewed-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Reviewed-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wwan/qcom_bam_dmux.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wwan/qcom_bam_dmux.c b/drivers/net/wwan/qcom_bam_dmux.c
index 26ca719fa0de4..5dcb9a84a12e3 100644
--- a/drivers/net/wwan/qcom_bam_dmux.c
+++ b/drivers/net/wwan/qcom_bam_dmux.c
@@ -823,17 +823,17 @@ static int bam_dmux_probe(struct platform_device *pdev)
 	ret = devm_request_threaded_irq(dev, pc_ack_irq, NULL, bam_dmux_pc_ack_irq,
 					IRQF_ONESHOT, NULL, dmux);
 	if (ret)
-		return ret;
+		goto err_disable_pm;
 
 	ret = devm_request_threaded_irq(dev, dmux->pc_irq, NULL, bam_dmux_pc_irq,
 					IRQF_ONESHOT, NULL, dmux);
 	if (ret)
-		return ret;
+		goto err_disable_pm;
 
 	ret = irq_get_irqchip_state(dmux->pc_irq, IRQCHIP_STATE_LINE_LEVEL,
 				    &dmux->pc_state);
 	if (ret)
-		return ret;
+		goto err_disable_pm;
 
 	/* Check if remote finished initialization before us */
 	if (dmux->pc_state) {
@@ -844,6 +844,11 @@ static int bam_dmux_probe(struct platform_device *pdev)
 	}
 
 	return 0;
+
+err_disable_pm:
+	pm_runtime_disable(dev);
+	pm_runtime_dont_use_autosuspend(dev);
+	return ret;
 }
 
 static void bam_dmux_remove(struct platform_device *pdev)
-- 
2.43.0



