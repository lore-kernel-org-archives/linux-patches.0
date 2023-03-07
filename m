Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E37BA34
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:31:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38305C4339E;
	Tue,  7 Mar 2023 17:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678210318;
	bh=D+yubnDFXwrN/gENUSmFX9771EZyWlo4SabxxbJ/s1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mltR5b+2IAuAUaT3G3oLMNG75XZhmkosQrs29oYFdVC4XDClcsf+ipOgb2RCkZmMe
	 6qYKXwXlcKZF4epHUGNrtNscDX5QwxocnygyVC1DnGj5LYqGse1IlzILMab3QpqsPT
	 VTqSaay8IR9qwIegHv7Lwy0IAc+QWnDfjrmXnEJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinlong Mao <quic_jinlmao@quicinc.com>,
	James Clark <james.clark@arm.com>,
	Mike Leach <mike.leach@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0503/1001] coresight: cti: Prevent negative values of enable count
Date: Tue,  7 Mar 2023 17:54:35 +0100
Message-Id: <20230307170043.224079356@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: James Clark <james.clark@arm.com>

[ Upstream commit 3244fb6dbbf1ffc114cdf382cc167bdd8c18088a ]

Writing 0 to the enable control repeatedly results in a negative value
for enable_req_count. After this, writing 1 to the enable control
appears to not work until the count returns to positive.

Change it so that it's impossible for enable_req_count to be < 0.
Return an error to indicate that the disable request was invalid.

Fixes: 835d722ba10a ("coresight: cti: Initial CoreSight CTI Driver")
Tested-by: Jinlong Mao <quic_jinlmao@quicinc.com>
Signed-off-by: James Clark <james.clark@arm.com>
Reviewed-by: Mike Leach <mike.leach@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20230110110736.2709917-2-james.clark@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-cti-core.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-cti-core.c b/drivers/hwtracing/coresight/coresight-cti-core.c
index d2cf4f4848e1b..838872f2484d3 100644
--- a/drivers/hwtracing/coresight/coresight-cti-core.c
+++ b/drivers/hwtracing/coresight/coresight-cti-core.c
@@ -151,9 +151,16 @@ static int cti_disable_hw(struct cti_drvdata *drvdata)
 {
 	struct cti_config *config = &drvdata->config;
 	struct coresight_device *csdev = drvdata->csdev;
+	int ret = 0;
 
 	spin_lock(&drvdata->spinlock);
 
+	/* don't allow negative refcounts, return an error */
+	if (!atomic_read(&drvdata->config.enable_req_count)) {
+		ret = -EINVAL;
+		goto cti_not_disabled;
+	}
+
 	/* check refcount - disable on 0 */
 	if (atomic_dec_return(&drvdata->config.enable_req_count) > 0)
 		goto cti_not_disabled;
@@ -171,12 +178,12 @@ static int cti_disable_hw(struct cti_drvdata *drvdata)
 	coresight_disclaim_device_unlocked(csdev);
 	CS_LOCK(drvdata->base);
 	spin_unlock(&drvdata->spinlock);
-	return 0;
+	return ret;
 
 	/* not disabled this call */
 cti_not_disabled:
 	spin_unlock(&drvdata->spinlock);
-	return 0;
+	return ret;
 }
 
 void cti_write_single_reg(struct cti_drvdata *drvdata, int offset, u32 value)
-- 
2.39.2



