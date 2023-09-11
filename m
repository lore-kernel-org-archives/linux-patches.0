Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E8271170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:20:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED697C433C7;
	Mon, 11 Sep 2023 14:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442025;
	bh=HqQaYsSG2YUcVBfMX18YfEHkjpBHzYgCFrUzn6UOA8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qaR0KTmeEdeCiTaILh0tMmqmfRS4aIqgsR8TI5e8Q/osPMBIGSBpMx29SAvJC8bmg
	 eDp3OFeqFAgG80GjjJFXsJOlg2XOGeNGqKDdsc/HjOPlMulmNPyA5M2ySoitbcGTCZ
	 h1J1ZD/Zy+cFkyv58h5NFOVfq7QDWNtQYWUxKuUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fenghua Yu <fenghua.yu@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 620/739] dmaengine: idxd: Simplify WQ attribute visibility checks
Date: Mon, 11 Sep 2023 15:46:59 +0200
Message-ID: <20230911134708.417755424@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fenghua Yu <fenghua.yu@intel.com>

[ Upstream commit 97b1185fe54c8ce94104e3c7fa4ee0bbedd85920 ]

The functions that check if WQ attributes are invisible are almost
duplicate. Define a helper to simplify these functions and future
WQ attribute visibility checks as well.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/20230712174436.3435088-1-fenghua.yu@intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: 0056a7f07b0a ("dmaengine: idxd: Allow ATS disable update only for configurable devices")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/sysfs.c | 20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/drivers/dma/idxd/sysfs.c b/drivers/dma/idxd/sysfs.c
index b6a0a12412afd..36a30957ac9a3 100644
--- a/drivers/dma/idxd/sysfs.c
+++ b/drivers/dma/idxd/sysfs.c
@@ -1288,12 +1288,9 @@ static struct attribute *idxd_wq_attributes[] = {
 	NULL,
 };
 
-static bool idxd_wq_attr_op_config_invisible(struct attribute *attr,
-					     struct idxd_device *idxd)
-{
-	return attr == &dev_attr_wq_op_config.attr &&
-	       !idxd->hw.wq_cap.op_config;
-}
+/*  A WQ attr is invisible if the feature is not supported in WQCAP. */
+#define idxd_wq_attr_invisible(name, cap_field, a, idxd)		\
+	((a) == &dev_attr_wq_##name.attr && !(idxd)->hw.wq_cap.cap_field)
 
 static bool idxd_wq_attr_max_batch_size_invisible(struct attribute *attr,
 						  struct idxd_device *idxd)
@@ -1303,13 +1300,6 @@ static bool idxd_wq_attr_max_batch_size_invisible(struct attribute *attr,
 	       idxd->data->type == IDXD_TYPE_IAX;
 }
 
-static bool idxd_wq_attr_wq_prs_disable_invisible(struct attribute *attr,
-						  struct idxd_device *idxd)
-{
-	return attr == &dev_attr_wq_prs_disable.attr &&
-	       !idxd->hw.wq_cap.wq_prs_support;
-}
-
 static umode_t idxd_wq_attr_visible(struct kobject *kobj,
 				    struct attribute *attr, int n)
 {
@@ -1317,13 +1307,13 @@ static umode_t idxd_wq_attr_visible(struct kobject *kobj,
 	struct idxd_wq *wq = confdev_to_wq(dev);
 	struct idxd_device *idxd = wq->idxd;
 
-	if (idxd_wq_attr_op_config_invisible(attr, idxd))
+	if (idxd_wq_attr_invisible(op_config, op_config, attr, idxd))
 		return 0;
 
 	if (idxd_wq_attr_max_batch_size_invisible(attr, idxd))
 		return 0;
 
-	if (idxd_wq_attr_wq_prs_disable_invisible(attr, idxd))
+	if (idxd_wq_attr_invisible(prs_disable, wq_prs_support, attr, idxd))
 		return 0;
 
 	return attr->mode;
-- 
2.40.1



