Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0032B1DF252;
	Wed,  6 Nov 2024 12:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895951; cv=none; b=mhPdmRdTs3dFMfpRQdy+x70zUc6Cn5H9l+8HD7+0l4rK/T3UTZtieNpGsPtn+UMvzPZmhgHJq565Mt2t+r6qLxqENcb64+q1sQypCQSJGH+PCqTAtEfLaArwcQHEka3hLXOE6bP+FApbA8Lt3Nk7MuJWuOG/giJqWvXWYlyfBUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895951; c=relaxed/simple;
	bh=eR+R1e0kwLrWpPnOkUC+7b13PpmDdEXPm5qUTZVx0/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ptUO/fz+N9BK3dKjvPdSYuebfFK0GixsjMW/QXKFk7KJWXFrYy6MlAgwphQggFzFR35jjuCeIlio8Onhueiw4eOZv04pwvov+Ip1LP3xw2P2jzw1vWY+EvbGqQ8peZJUNcJftr3WEfsjoMqdFbIp8wwZXY5G1TrPXU8JnNR7uz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j91JaHqV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j91JaHqV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B04BC4CECD;
	Wed,  6 Nov 2024 12:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895950;
	bh=eR+R1e0kwLrWpPnOkUC+7b13PpmDdEXPm5qUTZVx0/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j91JaHqVkxPSjic8pYgNWth71n12PxZ9G7n7ZvjWrMAIjvVfVTcV9mfROaRa+KB08
	 Iib5EjMNZ/goGbmkkc6hvuEv4Y4KpGh1tzipjSTM2bC58phnHvaNGVMf6puiaAcLUf
	 AULc9Z4uQwVR/cRfnKmnivUAVig9Ugw9zNA+nyfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naresh Kamboju <naresh.kamboju@linaro.org>,
	Linux Kernel Functional Testing <lkft@linaro.org>,
	Georgi Djakov <djakov@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 004/245] spi: geni-qcom: Fix boot warning related to pm_runtime and devres
Date: Wed,  6 Nov 2024 13:00:57 +0100
Message-ID: <20241106120319.351159236@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

From: Georgi Djakov <djakov@kernel.org>

[ Upstream commit d0ccf760a405d243a49485be0a43bd5b66ed17e2 ]

During boot, users sometimes observe the following warning:

[7.841431] WARNING: CPU: 4 PID: 492 at
drivers/interconnect/core.c:685 __icc_enable
(drivers/interconnect/core.c:685 (discriminator 7))
[..]
[7.841541] Call trace:
[7.841542] __icc_enable (drivers/interconnect/core.c:685 (discriminator 7))
[7.841545] icc_disable (drivers/interconnect/core.c:708)
[7.841547] geni_icc_disable (drivers/soc/qcom/qcom-geni-se.c:862)
[7.841553] spi_geni_runtime_suspend+0x3c/0x4c spi_geni_qcom

This occurs when the spi-geni driver receives an -EPROBE_DEFER error
from spi_geni_grab_gpi_chan(), causing devres to start releasing all
resources as shown below:

[7.138679] geni_spi 880000.spi: DEVRES REL ffff800081443800 devm_icc_release (8 bytes)
[7.138751] geni_spi 880000.spi: DEVRES REL ffff800081443800 devm_icc_release (8 bytes)
[7.138827] geni_spi 880000.spi: DEVRES REL ffff800081443800 pm_runtime_disable_action (16 bytes)
[7.139494] geni_spi 880000.spi: DEVRES REL ffff800081443800 devm_pm_opp_config_release (16 bytes)
[7.139512] geni_spi 880000.spi: DEVRES REL ffff800081443800 devm_spi_release_controller (8 bytes)
[7.139516] geni_spi 880000.spi: DEVRES REL ffff800081443800 devm_clk_release (16 bytes)
[7.139519] geni_spi 880000.spi: DEVRES REL ffff800081443800 devm_ioremap_release (8 bytes)
[7.139524] geni_spi 880000.spi: DEVRES REL ffff800081443800 devm_region_release (24 bytes)
[7.139527] geni_spi 880000.spi: DEVRES REL ffff800081443800 devm_kzalloc_release (22 bytes)
[7.139530] geni_spi 880000.spi: DEVRES REL ffff800081443800 devm_pinctrl_release (8 bytes)
[7.139539] geni_spi 880000.spi: DEVRES REL ffff800081443800 devm_kzalloc_release (40 bytes)

The issue here is that pm_runtime_disable_action() results in a call to
spi_geni_runtime_suspend(), which attempts to suspend the device and
disable an interconnect path that devm_icc_release() has just released.

Resolve this by calling geni_icc_get() before enabling runtime PM. This
approach ensures that when devres releases resources in reverse order,
it will start with pm_runtime_disable_action(), suspending the device,
and then proceed to free the remaining resources.

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
Closes: https://lore.kernel.org/r/CA+G9fYtsjFtddG8i+k-SpV8U6okL0p4zpsTiwGfNH5GUA8dWAA@mail.gmail.com
Fixes: 89e362c883c6 ("spi: geni-qcom: Undo runtime PM changes at driver exit time")
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Link: https://patch.msgid.link/20241008231615.430073-1-djakov@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-geni-qcom.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-geni-qcom.c b/drivers/spi/spi-geni-qcom.c
index 6f4057330444d..fa967be4f9a17 100644
--- a/drivers/spi/spi-geni-qcom.c
+++ b/drivers/spi/spi-geni-qcom.c
@@ -1108,6 +1108,11 @@ static int spi_geni_probe(struct platform_device *pdev)
 	init_completion(&mas->tx_reset_done);
 	init_completion(&mas->rx_reset_done);
 	spin_lock_init(&mas->lock);
+
+	ret = geni_icc_get(&mas->se, NULL);
+	if (ret)
+		return ret;
+
 	pm_runtime_use_autosuspend(&pdev->dev);
 	pm_runtime_set_autosuspend_delay(&pdev->dev, 250);
 	ret = devm_pm_runtime_enable(dev);
@@ -1117,9 +1122,6 @@ static int spi_geni_probe(struct platform_device *pdev)
 	if (device_property_read_bool(&pdev->dev, "spi-slave"))
 		spi->target = true;
 
-	ret = geni_icc_get(&mas->se, NULL);
-	if (ret)
-		return ret;
 	/* Set the bus quota to a reasonable value for register access */
 	mas->se.icc_paths[GENI_TO_CORE].avg_bw = Bps_to_icc(CORE_2X_50_MHZ);
 	mas->se.icc_paths[CPU_TO_GENI].avg_bw = GENI_DEFAULT_BW;
-- 
2.43.0



