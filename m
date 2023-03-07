Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 311E2BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:59:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8923BC433D2;
	Tue,  7 Mar 2023 18:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678215555;
	bh=FSGum066H8DLs7chsRR9U1ki+a10J237cgsA36SWWTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DuikJD28V4+jQmb9pmDu/3JY7MxP64z3Sc61z88FHGNXBJeSagD0XmUaxPrMM8Y/2
	 Gr4J/qc0+ENCf8M5mP1mEiEMMQfxKdGdk3eQBDAsW2HA31nAh+WGY3ZgmcyMxUD8x0
	 DXqGQTt6UQXhOfGwpmEMmsMYMkjFb3ENZy4Egt6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mao Jinlong <quic_jinlmao@quicinc.com>,
	James Clark <james.clark@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 292/567] coresight: cti: Add PM runtime call in enable_store
Date: Tue,  7 Mar 2023 18:00:28 +0100
Message-Id: <20230307165918.550167445@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mao Jinlong <quic_jinlmao@quicinc.com>

[ Upstream commit eff674a9b86a6ffdd10c3af3863545acf7f1ce4f ]

In commit 6746eae4bbad ("coresight: cti: Fix hang in cti_disable_hw()")
PM runtime calls are removed from cti_enable_hw/cti_disable_hw. When
enabling CTI by writing enable sysfs node, clock for accessing CTI
register won't be enabled. Device will crash due to register access
issue. Add PM runtime call in enable_store to fix this issue.

Fixes: 6746eae4bbad ("coresight: cti: Fix hang in cti_disable_hw()")
Signed-off-by: Mao Jinlong <quic_jinlmao@quicinc.com>
[Change to only call pm_runtime_put if a disable happened]
Tested-by: Jinlong Mao <quic_jinlmao@quicinc.com>
Signed-off-by: James Clark <james.clark@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20230110110736.2709917-3-james.clark@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-cti-sysfs.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-cti-sysfs.c b/drivers/hwtracing/coresight/coresight-cti-sysfs.c
index 7ff7e7780bbfb..92fc3000872a1 100644
--- a/drivers/hwtracing/coresight/coresight-cti-sysfs.c
+++ b/drivers/hwtracing/coresight/coresight-cti-sysfs.c
@@ -108,10 +108,19 @@ static ssize_t enable_store(struct device *dev,
 	if (ret)
 		return ret;
 
-	if (val)
+	if (val) {
+		ret = pm_runtime_resume_and_get(dev->parent);
+		if (ret)
+			return ret;
 		ret = cti_enable(drvdata->csdev);
-	else
+		if (ret)
+			pm_runtime_put(dev->parent);
+	} else {
 		ret = cti_disable(drvdata->csdev);
+		if (!ret)
+			pm_runtime_put(dev->parent);
+	}
+
 	if (ret)
 		return ret;
 	return size;
-- 
2.39.2



