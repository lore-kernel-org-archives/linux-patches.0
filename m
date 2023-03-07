Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE42BA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:19:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 120A5C4339B;
	Tue,  7 Mar 2023 18:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678213171;
	bh=S0IHoom/Ez/Qg5GDkNcK+ovHZifsOmMXa5mxuheiAU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2I+iLgihtnexvSXhHwPHNf2TW82RKBWZo/LOVa6At6xvSAbXX9RAPIJ32+gr0yyio
	 1UkiZbZf/XPPRW6g1EHA7MiERqQoiSc/83C116qjbazGs2HHlLXe0hKg0ENRD/34nu
	 xglmEo/App+dgd02yMDRVBYQqqbbXHyjwuEcfo4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mao Jinlong <quic_jinlmao@quicinc.com>,
	James Clark <james.clark@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 422/885] coresight: cti: Add PM runtime call in enable_store
Date: Tue,  7 Mar 2023 17:55:56 +0100
Message-Id: <20230307170020.755100752@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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
index 6d59c815ecf5e..71e7a8266bb32 100644
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



