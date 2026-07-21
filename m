Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63CB345BD4E;
	Tue, 21 Jul 2026 15:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648819; cv=none; b=qPVJWrv7yZMgAulIoqQW/HgNWGKja1QyAN7Z5QmvdK4A8T9fD7mZRcFA4q2BAuhf/mkN93CfOPoBdQ4fvBKwVC01wtH3/4tKvQ/fjtHCBGyb9+YIhTSe5wS/q0BiT5d4B5HFe3xEBLHsG4cPdJlnUWzZ3e+tvbRaaWvBPbhyBes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648819; c=relaxed/simple;
	bh=bWJ1hiIgb1xDVMlxLFZik+Pt5OMryokt8Jbu0AE4pLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G0C65L4RF4hwwUmT41M+L5VAi99XS07caBndDfraVabn/YuPDml9tVXBGuPheWQYPPzKIdEsSxpoh0i5TQwpafXFvnmoAbhY1Pway6/jKctF6uwECGrIgwHUMW/XQHgGmv5yeYUPpMj/bUgwf3VzgWCNcsXDLI0jt1jBKAhjks0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r1+ihoyz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r1+ihoyz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89E121F000E9;
	Tue, 21 Jul 2026 15:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648818;
	bh=G0HF0MpjbklmvXftLvz5fPq0pwefoF0PqJfON7Vka9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r1+ihoyziY2ail87wLYAedu5L4Q08LCGdH5BLiTNqCgfEv4IOuVSHSjWhmhvFXcyV
	 YRU6DxjxecAWpd8U+ChhTwYaQHni0zpPAblLhFT+dzMvnt7ZqNrTsfDy4uJiB0VM4i
	 wttYGIPOU0MDyiGJU7MfXfx2qeAxPLKfkw4NBrfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Ion Agorria <ion@agorria.com>,
	Svyatoslav Ryhel <clamor95@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0343/2077] drm/tegra: gr2d/gr3d: Contain PM in the gr*d_probe/gr*d_remove
Date: Tue, 21 Jul 2026 17:00:16 +0200
Message-ID: <20260721152600.776839808@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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



