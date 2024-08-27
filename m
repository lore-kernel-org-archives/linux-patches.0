Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC011BD514;
	Tue, 27 Aug 2024 15:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771590; cv=none; b=Omo48bmT24BhMTP9DZdCzA+CF8thASIOmBiv1/sAIxI58hVmg/Am3IYc5Znzhobj2oimsDzshh5F+PzgN5YACSqa/J6L9A87T0WjmzSuTcRMJpJFekanGn/hF80Rlj0NSsO323IkCIQvWvxCgjxfJLYKkvFvLKv70fKaXvG0P+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771590; c=relaxed/simple;
	bh=q6RAYBdVxeiR0nZ/epzsAVhm8vUzUcg8Y9AeTtADteE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VsRHo5N5JN5rFHQfeiPtRaV1K0RR18mbEGc978JstWIvPbthCDfANell/3EIxVNWNqZ+UeRBqo9953nrbu9QObgTCgl4Q/sKsCfwK3PX80wbssCR9p9GxLmXrdVeNMkfVbjA5RUP5GqYMhzT0UmgSfV5Hv+T6V+JbsrpC7hZFWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jI0YQNP6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jI0YQNP6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4022C61048;
	Tue, 27 Aug 2024 15:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771590;
	bh=q6RAYBdVxeiR0nZ/epzsAVhm8vUzUcg8Y9AeTtADteE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jI0YQNP6HvjqzoVzOuOOhFqNusoDN3PpNB6IgV+QrAXYkicJmys8IFdOF40fvl0tY
	 sfdfQd7BOtymMR/mwH3iRMPBlLxr9EptuXBFXs8l1QIgdhPY7gNw7/XG1qc0+hSoJW
	 P6a75nT1JJGP6R7A91qi0YuvpQv92D+qi2xu7/xI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 203/273] spi: spi-cadence-quadspi: Fix OSPI NOR failures during system resume
Date: Tue, 27 Aug 2024 16:38:47 +0200
Message-ID: <20240827143841.136241767@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

From: Vignesh Raghavendra <vigneshr@ti.com>

[ Upstream commit 57d5af2660e9443b081eeaf1c373b3ce48477828 ]

Its necessary to call pm_runtime_force_*() hooks as part of system
suspend/resume calls so that the runtime_pm hooks get called. This
ensures latest state of the IP is cached and restored during system
sleep. This is especially true if runtime autosuspend is enabled as
runtime suspend hooks may not be called at all before system sleeps.

Without this patch, OSPI NOR enumeration (READ_ID) fails during resume
as context saved during suspend path is inconsistent.

Fixes: 078d62de433b ("spi: cadence-qspi: add system-wide suspend and resume callbacks")
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Link: https://patch.msgid.link/20240814151237.3856184-1-vigneshr@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cadence-quadspi.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-cadence-quadspi.c b/drivers/spi/spi-cadence-quadspi.c
index 05ebb03d319fc..d4607cb89c484 100644
--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -2000,13 +2000,25 @@ static int cqspi_runtime_resume(struct device *dev)
 static int cqspi_suspend(struct device *dev)
 {
 	struct cqspi_st *cqspi = dev_get_drvdata(dev);
+	int ret;
 
-	return spi_controller_suspend(cqspi->host);
+	ret = spi_controller_suspend(cqspi->host);
+	if (ret)
+		return ret;
+
+	return pm_runtime_force_suspend(dev);
 }
 
 static int cqspi_resume(struct device *dev)
 {
 	struct cqspi_st *cqspi = dev_get_drvdata(dev);
+	int ret;
+
+	ret = pm_runtime_force_resume(dev);
+	if (ret) {
+		dev_err(dev, "pm_runtime_force_resume failed on resume\n");
+		return ret;
+	}
 
 	return spi_controller_resume(cqspi->host);
 }
-- 
2.43.0



