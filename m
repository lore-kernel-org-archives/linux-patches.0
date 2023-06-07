Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98BEC19E48
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:41:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BDD4C433EF;
	Wed,  7 Jun 2023 20:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686170500;
	bh=+wRpFKaNgkKh78Cigl7p41FzWfXPIwLCJ7DvoU6/oLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pnfx6odXZr5kkxM4FhkqayckabvgVKLluY/jASxDldwJ7I3ypsURCDa6tL9eVSnf/
	 W7Jbe5JVHZ9OmTmlZKKtqpp5C/R7cEPy5CDhW4ESQur0Xx0NRKIJmHvjDEacQU1cpj
	 1qhvHyMMXlRThZaMuIRVQKtBDOvZCB4wdwFGoMcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 108/225] ASoC: SOF: pm: save io region state in case of errors in resume
Date: Wed,  7 Jun 2023 22:15:01 +0200
Message-ID: <20230607200917.913565648@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200913.334991024@linuxfoundation.org>
References: <20230607200913.334991024@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

[ Upstream commit 171b53be635ac15d4feafeb33946035649b1ca14 ]

If there are failures in DSP runtime resume, the device state will not
reach active and this makes it impossible e.g. to retrieve a possible
DSP panic dump via "exception" debugfs node. If
CONFIG_SND_SOC_SOF_DEBUG_ENABLE_DEBUGFS_CACHE=y is set, the data in
cache is stale. If debugfs cache is not used, the region simply cannot
be read.

To allow debugging these scenarios, update the debugfs cache contents in
resume error handler. User-space can then later retrieve DSP panic and
other state via debugfs (requires SOF debugfs cache to be enabled in
build).

Reported-by: Curtis Malainey <cujomalainey@chromium.org
Link: https://github.com/thesofproject/linux/issues/4274
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com
Reviewed-by: Curtis Malainey <cujomalainey@chromium.org
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com
Link: https://lore.kernel.org/r/20230512104638.21376-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/pm.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/sound/soc/sof/pm.c b/sound/soc/sof/pm.c
index 26ffcbb6e30f4..a1bfa5a37e2ad 100644
--- a/sound/soc/sof/pm.c
+++ b/sound/soc/sof/pm.c
@@ -159,7 +159,7 @@ static int sof_resume(struct device *dev, bool runtime_resume)
 		ret = tplg_ops->set_up_all_pipelines(sdev, false);
 		if (ret < 0) {
 			dev_err(sdev->dev, "Failed to restore pipeline after resume %d\n", ret);
-			return ret;
+			goto setup_fail;
 		}
 	}
 
@@ -173,6 +173,18 @@ static int sof_resume(struct device *dev, bool runtime_resume)
 			dev_err(sdev->dev, "ctx_restore IPC error during resume: %d\n", ret);
 	}
 
+setup_fail:
+#if IS_ENABLED(CONFIG_SND_SOC_SOF_DEBUG_ENABLE_DEBUGFS_CACHE)
+	if (ret < 0) {
+		/*
+		 * Debugfs cannot be read in runtime suspend, so cache
+		 * the contents upon failure. This allows to capture
+		 * possible DSP coredump information.
+		 */
+		sof_cache_debugfs(sdev);
+	}
+#endif
+
 	return ret;
 }
 
-- 
2.39.2



