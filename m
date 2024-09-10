Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60194EEC9;
	Tue, 10 Sep 2024 09:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962316; cv=none; b=IY4gtxdmkz/zdVrhcDzUlwqC3sAjr1HhWc8WYvQDIbLtjgwDGb5ADGuWX0wqFzchRyOF4L1CYd0oenDcHfD/0EZCNgCVPBVnMfRIU0f/DD1Y5euokK2XQYYDRaLwjnu2PIBkrvAKnmc9LrZvfgvyNa6y+3fiAqCu/LW9M/Ob3jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962316; c=relaxed/simple;
	bh=8Qx4KELvOHqJfo0+jEWtbqtTq90RVHigONir3S2uw/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ELyDbVVEDeAKTZ60Fvx2EDbV1SwAa4CNfrZepFxcbdZHL5qrhK/RmZ9oO7VB30WH7roWp297hi4bKUQGP5gJ+QahAP22ps0r2mGCboAE9m82rD1R0ZwBCIx4vUB4+G7/PubnwGhqx4RikYnE6VmECDlBlzwhe3HfoyMJcVjPF9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XBUkI2vm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XBUkI2vm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1C08C4CEC3;
	Tue, 10 Sep 2024 09:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962316;
	bh=8Qx4KELvOHqJfo0+jEWtbqtTq90RVHigONir3S2uw/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XBUkI2vmu2c7vQBbxxyBVMSK4r+qGTuQ/el2mXMtATy2j1vBf2Qs6do53J7p7XTe4
	 p73iULWLkpPEHOh1V08d6Tg4MemG4Q0x6ugJJ4a9MqWfYbysJgpooP2D5nBLLm9rUk
	 1yAAIIPmm+xeJe5oL01SaM6aRrWViFZ2R5HnDOYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohan Kumar <mkumard@nvidia.com>,
	Ritu Chaudhary <rituc@nvidia.com>,
	Sameer Pujar <spujar@nvidia.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 342/375] ASoC: tegra: Fix CBB error during probe()
Date: Tue, 10 Sep 2024 11:32:19 +0200
Message-ID: <20240910092634.076927109@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mohan Kumar <mkumard@nvidia.com>

[ Upstream commit 6781b962d97bc52715a8db8cc17278cc3c23ebe8 ]

When Tegra audio drivers are built as part of the kernel image,
TIMEOUT_ERR is observed from cbb-fabric. Following is seen on
Jetson AGX Orin during boot:

[    8.012482] **************************************
[    8.017423] CPU:0, Error:cbb-fabric, Errmon:2
[    8.021922]    Error Code            : TIMEOUT_ERR
[    8.025966]    Overflow              : Multiple TIMEOUT_ERR
[    8.030644]
[    8.032175]    Error Code            : TIMEOUT_ERR
[    8.036217]    MASTER_ID             : CCPLEX
[    8.039722]    Address               : 0x290a0a8
[    8.043318]    Cache                 : 0x1 -- Bufferable
[    8.047630]    Protection            : 0x2 -- Unprivileged, Non-Secure, Data Access
[    8.054628]    Access_Type           : Write

[    8.106130] WARNING: CPU: 0 PID: 124 at drivers/soc/tegra/cbb/tegra234-cbb.c:604 tegra234_cbb_isr+0x134/0x178

[    8.240602] Call trace:
[    8.243126]  tegra234_cbb_isr+0x134/0x178
[    8.247261]  __handle_irq_event_percpu+0x60/0x238
[    8.252132]  handle_irq_event+0x54/0xb8

These errors happen when MVC device, which is a child of AHUB
device, tries to access its device registers. This happens as
part of call tegra210_mvc_reset_vol_settings() in MVC device
probe().

The root cause of this problem is, the child MVC device gets
probed before the AHUB clock gets enabled. The AHUB clock is
enabled in runtime PM resume of parent AHUB device and due to
the wrong sequence of pm_runtime_enable() in AHUB driver,
runtime PM resume doesn't happen for AHUB device when MVC makes
register access.

Fix this by calling pm_runtime_enable() for parent AHUB device
before of_platform_populate() in AHUB driver. This ensures that
clock becomes available when MVC makes register access.

Fixes: 16e1bcc2caf4 ("ASoC: tegra: Add Tegra210 based AHUB driver")
Signed-off-by: Mohan Kumar <mkumard@nvidia.com>
Signed-off-by: Ritu Chaudhary <rituc@nvidia.com>
Signed-off-by: Sameer Pujar <spujar@nvidia.com>
Link: https://patch.msgid.link/20240823144342.4123814-3-spujar@nvidia.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/tegra/tegra210_ahub.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/sound/soc/tegra/tegra210_ahub.c b/sound/soc/tegra/tegra210_ahub.c
index 3f114a2adfce..ab3c6b2544d2 100644
--- a/sound/soc/tegra/tegra210_ahub.c
+++ b/sound/soc/tegra/tegra210_ahub.c
@@ -2,7 +2,7 @@
 //
 // tegra210_ahub.c - Tegra210 AHUB driver
 //
-// Copyright (c) 2020-2022, NVIDIA CORPORATION.  All rights reserved.
+// Copyright (c) 2020-2024, NVIDIA CORPORATION.  All rights reserved.
 
 #include <linux/clk.h>
 #include <linux/device.h>
@@ -1391,11 +1391,13 @@ static int tegra_ahub_probe(struct platform_device *pdev)
 		return err;
 	}
 
+	pm_runtime_enable(&pdev->dev);
+
 	err = of_platform_populate(pdev->dev.of_node, NULL, NULL, &pdev->dev);
-	if (err)
+	if (err) {
+		pm_runtime_disable(&pdev->dev);
 		return err;
-
-	pm_runtime_enable(&pdev->dev);
+	}
 
 	return 0;
 }
-- 
2.43.0



