Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 070D619E48
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:41:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D982C433D2;
	Wed,  7 Jun 2023 20:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686170497;
	bh=JAtkvFZ0/2pDlmSFKy5Da72TvMQtgupm8Xn67ZxEypA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vEjCKPp+N/UipH1iZv94hMO6MczejuxnExYhg9e0TR63vxqyQjkA06022KdTmkL9i
	 mpBzIa/7j8fn2gdneXKGQFb26NToAVwa4w4I1JrsPEWgXrfswR0dIF80pVsNIJcdXZ
	 yeJr8oXzjwdzs9DR4D8cs84GVXKJvfveeupsU0SY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 107/225] ASoC: SOF: sof-client-probes: fix pm_runtime imbalance in error handling
Date: Wed,  7 Jun 2023 22:15:00 +0200
Message-ID: <20230607200917.877218047@linuxfoundation.org>
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

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit bc424273c74c1565c459c8f2a6ed95caee368d0a ]

When an error occurs, we need to make sure the device can pm_runtime
suspend instead of keeping it active.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com
Reviewed-by: Daniel Baluta <daniel.baluta@nxp.com
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com
Link: https://lore.kernel.org/r/20230512103315.8921-4-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/sof-client-probes.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/sound/soc/sof/sof-client-probes.c b/sound/soc/sof/sof-client-probes.c
index ddeabbb5580e1..1e521a9e34d27 100644
--- a/sound/soc/sof/sof-client-probes.c
+++ b/sound/soc/sof/sof-client-probes.c
@@ -441,12 +441,7 @@ static ssize_t sof_probes_dfs_points_read(struct file *file, char __user *to,
 
 	ret = sof_probes_points_info(cdev, &desc, &num_desc);
 	if (ret < 0)
-		goto exit;
-
-	pm_runtime_mark_last_busy(dev);
-	err = pm_runtime_put_autosuspend(dev);
-	if (err < 0)
-		dev_err_ratelimited(dev, "debugfs read failed to idle %d\n", err);
+		goto pm_error;
 
 	for (i = 0; i < num_desc; i++) {
 		offset = strlen(buf);
@@ -464,6 +459,13 @@ static ssize_t sof_probes_dfs_points_read(struct file *file, char __user *to,
 	ret = simple_read_from_buffer(to, count, ppos, buf, strlen(buf));
 
 	kfree(desc);
+
+pm_error:
+	pm_runtime_mark_last_busy(dev);
+	err = pm_runtime_put_autosuspend(dev);
+	if (err < 0)
+		dev_err_ratelimited(dev, "debugfs read failed to idle %d\n", err);
+
 exit:
 	kfree(buf);
 	return ret;
-- 
2.39.2



