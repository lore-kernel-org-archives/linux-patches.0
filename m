Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742E93218C9;
	Mon, 18 Aug 2025 13:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522609; cv=none; b=eEtl77u3AUGs+1P1gDijTVkZy3Pv9xVXYTxYExAUQ/7QxG2pWDA+BBc6876iuMAbwY8hCfWUm3bD1TEayebI4wNCraiOmpK4aNQdAiXP4qI4SJX2gjcomIppuTRfRdHt01ekmPLr4cKDGJCi9RjXvnVnKv9m+jrD3IXd3E4BUfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522609; c=relaxed/simple;
	bh=rWDMWMZd+RfJMApEDkTPvn7TpX5q0aN4wg9ZjqGGe+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uHcFM0akyA47XUSDGo7wsViQvNnopb1nifM8EnhfypdXSQtx6Siec7FOpa8eHKjXbuI7ec+zn6q1XCh7+xkWwldb/9/Olr+gIqMc/Al05Ub9GAXfWwjsK7QdZ8/EYUOSLkM3xiTQ1IRXYofKoXyu92YAb66R/iUtam4nWu6RU8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PzUnyob6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PzUnyob6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98D31C4CEEB;
	Mon, 18 Aug 2025 13:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522609;
	bh=rWDMWMZd+RfJMApEDkTPvn7TpX5q0aN4wg9ZjqGGe+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PzUnyob6QFtA8jf3HIsKh6wNrLv0ze8FW3zskbIVXshJZJr4JLs7ccnilX/rE6UT0
	 ie9BtRTSS6yEG1fik4gFNCNy1QNhtd+SEXPXUB+qUXQYE9OJsUD+KkFXTu8iI/fL6M
	 PaJEePQFTr+ObJAze+KsqR3+qL9T442o13Ur+8UE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 324/444] soundwire: amd: serialize amd manager resume sequence during pm_prepare
Date: Mon, 18 Aug 2025 14:45:50 +0200
Message-ID: <20250818124501.089025992@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1895fba5e70b..dc7d54cb1740 100644
--- a/drivers/soundwire/amd_manager.c
+++ b/drivers/soundwire/amd_manager.c
@@ -1076,10 +1076,10 @@ static int __maybe_unused amd_pm_prepare(struct device *dev)
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



