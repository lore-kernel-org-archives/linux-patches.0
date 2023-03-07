Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F46EBA34
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:31:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7544C433D2;
	Tue,  7 Mar 2023 17:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678210270;
	bh=oPU6qUz5ZF+zMnR8ofn4lmGbaBzavbEGU4Z5bJEbaeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z/6dfA/svsDdg99flxDBjoOiwmMlp/QZYum8qY+tN7+/q4e59iDEv34kQUA1YwIIx
	 y8qPv3fJrl8tMr4dGHlZL23XwK1laocpxBAP2BmybKXp/+GGvuJz8bBTybD8goCHyp
	 oqVIuU46Lu6oB9lE3kHu/p5EwrhXpofRU4r0hvRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fenghua Yu <fenghua.yu@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0486/1001] dmaengine: idxd: Set traffic class values in GRPCFG on DSA 2.0
Date: Tue,  7 Mar 2023 17:54:18 +0100
Message-Id: <20230307170042.487264280@linuxfoundation.org>
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

From: Fenghua Yu <fenghua.yu@intel.com>

[ Upstream commit 9735bde36487da43d3c3fc910df49639f72decbf ]

On DSA/IAX 1.0, TC-A and TC-B in GRPCFG are set as 1 to have best
performance and cannot be changed through sysfs knobs unless override
option is given.

The same values should be set on DSA 2.0 as well.

Fixes: ea7c8f598c32 ("dmaengine: idxd: restore traffic class defaults after wq reset")
Fixes: ade8a86b512c ("dmaengine: idxd: Set defaults for GRPCFG traffic class")
Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/20221209172141.562648-1-fenghua.yu@intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/device.c | 2 +-
 drivers/dma/idxd/init.c   | 2 +-
 drivers/dma/idxd/sysfs.c  | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index 29dbb0f52e186..8b4573dc7ecc5 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -701,7 +701,7 @@ static void idxd_groups_clear_state(struct idxd_device *idxd)
 		group->use_rdbuf_limit = false;
 		group->rdbufs_allowed = 0;
 		group->rdbufs_reserved = 0;
-		if (idxd->hw.version < DEVICE_VERSION_2 && !tc_override) {
+		if (idxd->hw.version <= DEVICE_VERSION_2 && !tc_override) {
 			group->tc_a = 1;
 			group->tc_b = 1;
 		} else {
diff --git a/drivers/dma/idxd/init.c b/drivers/dma/idxd/init.c
index 529ea09c90940..e63b0c674d883 100644
--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -295,7 +295,7 @@ static int idxd_setup_groups(struct idxd_device *idxd)
 		}
 
 		idxd->groups[i] = group;
-		if (idxd->hw.version < DEVICE_VERSION_2 && !tc_override) {
+		if (idxd->hw.version <= DEVICE_VERSION_2 && !tc_override) {
 			group->tc_a = 1;
 			group->tc_b = 1;
 		} else {
diff --git a/drivers/dma/idxd/sysfs.c b/drivers/dma/idxd/sysfs.c
index 3229dfc786507..18cd8151dee02 100644
--- a/drivers/dma/idxd/sysfs.c
+++ b/drivers/dma/idxd/sysfs.c
@@ -387,7 +387,7 @@ static ssize_t group_traffic_class_a_store(struct device *dev,
 	if (idxd->state == IDXD_DEV_ENABLED)
 		return -EPERM;
 
-	if (idxd->hw.version < DEVICE_VERSION_2 && !tc_override)
+	if (idxd->hw.version <= DEVICE_VERSION_2 && !tc_override)
 		return -EPERM;
 
 	if (val < 0 || val > 7)
@@ -429,7 +429,7 @@ static ssize_t group_traffic_class_b_store(struct device *dev,
 	if (idxd->state == IDXD_DEV_ENABLED)
 		return -EPERM;
 
-	if (idxd->hw.version < DEVICE_VERSION_2 && !tc_override)
+	if (idxd->hw.version <= DEVICE_VERSION_2 && !tc_override)
 		return -EPERM;
 
 	if (val < 0 || val > 7)
-- 
2.39.2



