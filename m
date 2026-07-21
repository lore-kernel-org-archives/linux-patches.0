Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F1A47043C;
	Tue, 21 Jul 2026 17:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656067; cv=none; b=OWF6ZajemrExUC5wYJp23ADJrtmtkKZhdbw0AG0u1jmHXwKGtrXHpMk0p4gQnAwivibYmSOBtw0FftiLQ3LVHq2+DB5b4r7eNWUQI0IOdunKANb2+MnnBuhqRb0KiTswZeNuq3VNLGIehpBxFt0JCmUC8dCHWZ0J7G4ypu2aBLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656067; c=relaxed/simple;
	bh=8Uv8pvco70gOM30ik86HNfmm6J4WeRpnL5u5lRWh9lY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=swSDiCtolPc6D0WEH/01AzWqblNhrAB4+Kv/2Z4yxPFjLLXJqlpMOp2C4ljJZtx5vjd1Q9nx8dpP83Y+GjqI0gkn7STrCZzlNlCAnNEqPZph6R7ox+/N2XZ6fgGAkh+ccE6Vs5f1d4IHXl8sVBkIZNc9J3VEH2ZO7zLzwSvAp44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=po8n7Cbd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="po8n7Cbd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92B1A1F00A3A;
	Tue, 21 Jul 2026 17:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656065;
	bh=YnUczWB7BGv4zt9Xkfp8SkdXzrPlZQPzuDv7WzAArb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=po8n7Cbd4nZgbtapOz21rFcOouwHA74Rbq4l+2VjLmBJyFQjntwdsGKuDbJD+0Pe7
	 2Qk5ox3eZBbX93Sf2lpedty773AfTwxmFCRwfcMNKTqoYkTBHx4vhGFOc+r7Q/eACM
	 gB/fRWCucY1yXPLDP3y0H1QwmtWDP58LT2xysGB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Ion Agorria <ion@agorria.com>,
	Svyatoslav Ryhel <clamor95@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0247/1611] drm/tegra: gr2d/gr3d: Contain PM in the gr*d_probe/gr*d_remove
Date: Tue, 21 Jul 2026 17:06:03 +0200
Message-ID: <20260721152520.581235668@linuxfoundation.org>
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

From: Ion Agorria <ion@agorria.com>

[ Upstream commit ace01e2af3871343d700fb60c6f64d8f8e3180e1 ]

The current power management configuration causes GR2G/GR3D to malfunction
after resume. Reconfigure all PM actions to be handled within the GR*D
probe and remove operations to address this.

Fixes: 62fa0a985e2c ("drm/tegra: Enable runtime PM during probe")
Acked-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Ion Agorria <ion@agorria.com>
Signed-off-by: Svyatoslav Ryhel <clamor95@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://patch.msgid.link/20260517091450.46728-3-clamor95@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tegra/gr2d.c | 13 ++++++-------
 drivers/gpu/drm/tegra/gr3d.c | 13 ++++++-------
 2 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/tegra/gr2d.c b/drivers/gpu/drm/tegra/gr2d.c
index e4148b034af745..892e3450b281e4 100644
--- a/drivers/gpu/drm/tegra/gr2d.c
+++ b/drivers/gpu/drm/tegra/gr2d.c
@@ -100,9 +100,6 @@ static int gr2d_exit(struct host1x_client *client)
 	if (err < 0)
 		return err;
 
-	pm_runtime_dont_use_autosuspend(client->dev);
-	pm_runtime_force_suspend(client->dev);
-
 	host1x_client_iommu_detach(client);
 	host1x_syncpt_put(client->syncpts[0]);
 	host1x_channel_put(gr2d->channel);
@@ -280,12 +277,18 @@ static int gr2d_probe(struct platform_device *pdev)
 	for (i = 0; i < ARRAY_SIZE(gr2d_addr_regs); i++)
 		set_bit(gr2d_addr_regs[i], gr2d->addr_regs);
 
+	pm_runtime_enable(dev);
+
 	err = host1x_client_register(&gr2d->client.base);
 	if (err < 0) {
+		pm_runtime_disable(dev);
 		dev_err(dev, "failed to register host1x client: %d\n", err);
 		return err;
 	}
 
+	pm_runtime_use_autosuspend(dev);
+	pm_runtime_set_autosuspend_delay(dev, 500);
+
 	return 0;
 }
 
@@ -367,10 +370,6 @@ static int __maybe_unused gr2d_runtime_resume(struct device *dev)
 		goto disable_clk;
 	}
 
-	pm_runtime_enable(dev);
-	pm_runtime_use_autosuspend(dev);
-	pm_runtime_set_autosuspend_delay(dev, 500);
-
 	return 0;
 
 disable_clk:
diff --git a/drivers/gpu/drm/tegra/gr3d.c b/drivers/gpu/drm/tegra/gr3d.c
index 47b0c6c56bfd08..388e47943d5ec6 100644
--- a/drivers/gpu/drm/tegra/gr3d.c
+++ b/drivers/gpu/drm/tegra/gr3d.c
@@ -109,9 +109,6 @@ static int gr3d_exit(struct host1x_client *client)
 	if (err < 0)
 		return err;
 
-	pm_runtime_dont_use_autosuspend(client->dev);
-	pm_runtime_force_suspend(client->dev);
-
 	host1x_client_iommu_detach(client);
 	host1x_syncpt_put(client->syncpts[0]);
 	host1x_channel_put(gr3d->channel);
@@ -510,13 +507,19 @@ static int gr3d_probe(struct platform_device *pdev)
 	for (i = 0; i < ARRAY_SIZE(gr3d_addr_regs); i++)
 		set_bit(gr3d_addr_regs[i], gr3d->addr_regs);
 
+	pm_runtime_enable(&pdev->dev);
+
 	err = host1x_client_register(&gr3d->client.base);
 	if (err < 0) {
+		pm_runtime_disable(&pdev->dev);
 		dev_err(&pdev->dev, "failed to register host1x client: %d\n",
 			err);
 		return err;
 	}
 
+	pm_runtime_use_autosuspend(&pdev->dev);
+	pm_runtime_set_autosuspend_delay(&pdev->dev, 500);
+
 	return 0;
 }
 
@@ -578,10 +581,6 @@ static int __maybe_unused gr3d_runtime_resume(struct device *dev)
 		goto disable_clk;
 	}
 
-	pm_runtime_enable(dev);
-	pm_runtime_use_autosuspend(dev);
-	pm_runtime_set_autosuspend_delay(dev, 500);
-
 	return 0;
 
 disable_clk:
-- 
2.53.0



