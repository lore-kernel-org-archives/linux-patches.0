Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 175AF2882DC;
	Mon, 18 Aug 2025 13:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524166; cv=none; b=HK1uAvElKfL/CpJJfF2uwoy5M6MyK0f9scF1i+slb8LoV8d0c4neZnh1RwG1hIMCldvEpyIEFoH/rv/GRV3pjny+UaFFVm/0nH9mdjGvqSDhawvbixPd3vGMlYupYweZuDZ0mS2XpV9RGZQuwPlul37ThLyQ53cidTzEk7HnFsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524166; c=relaxed/simple;
	bh=O0MlNt/hO9cX41fGURkVHrJfrIn59EOzsj6inaUNNRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FInBlWyXhaemkMM/abhM4PPruttW8CgDHRDSdv5kXacNMXzUU30KQ/LYHxwdDmncSV1PHjo4QOA5p3bRi77M7UNd8LB+2/sevxHj1JwPM5eidcNEDOxzt3/CtKyL10UYWRssJgDWJHmnGWHP/3CgiBQ3WJ9s/WHzKDGu/pLlQhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0cNvt7Vg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0cNvt7Vg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84151C4CEEB;
	Mon, 18 Aug 2025 13:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524165;
	bh=O0MlNt/hO9cX41fGURkVHrJfrIn59EOzsj6inaUNNRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0cNvt7Vgx6h3wwxXlE/dTb5Kqflgu2R22XRTh8hZWVwk01uEd4bey/+fKb63KXW/q
	 9X63TP88xm7YB43cYXFKEs1FP1jTMuwkiz/7NiCAy/bwxsT8meDv4qppGV1wo/hhwz
	 8toA3OGPFU2OaxuqOBJH+y6TFS6jbfvYPYXsXiwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 387/515] soundwire: amd: serialize amd manager resume sequence during pm_prepare
Date: Mon, 18 Aug 2025 14:46:13 +0200
Message-ID: <20250818124513.312040601@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vijendar Mukunda <Vijendar.Mukunda@amd.com>

[ Upstream commit 03837341790039d6f1cbf7a1ae7dfa2cb77ef0a4 ]

During pm_prepare callback, pm_request_resume() delays SoundWire manager D0
entry sequence. Synchronize runtime resume sequence for amd_manager
instance prior to invoking child devices resume sequence for both the amd
power modes(ClockStop Mode and Power off mode).
Change the power_mode_mask check and use pm_runtime_resume() in
amd_pm_prepare() callback.

Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://lore.kernel.org/r/20250530054447.1645807-3-Vijendar.Mukunda@amd.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/amd_manager.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/soundwire/amd_manager.c b/drivers/soundwire/amd_manager.c
index 7a671a786197..3b335d6eaa94 100644
--- a/drivers/soundwire/amd_manager.c
+++ b/drivers/soundwire/amd_manager.c
@@ -1178,10 +1178,10 @@ static int __maybe_unused amd_pm_prepare(struct device *dev)
 	 * device is not in runtime suspend state, observed that device alerts are missing
 	 * without pm_prepare on AMD platforms in clockstop mode0.
 	 */
-	if (amd_manager->power_mode_mask & AMD_SDW_CLK_STOP_MODE) {
-		ret = pm_request_resume(dev);
+	if (amd_manager->power_mode_mask) {
+		ret = pm_runtime_resume(dev);
 		if (ret < 0) {
-			dev_err(bus->dev, "pm_request_resume failed: %d\n", ret);
+			dev_err(bus->dev, "pm_runtime_resume failed: %d\n", ret);
 			return 0;
 		}
 	}
-- 
2.39.5



