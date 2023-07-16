Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D7E8F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:21:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6549FC433C7;
	Sun, 16 Jul 2023 20:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538861;
	bh=OVpzEYXIcKHz40d2vmShbRYKi/NDi9ENrrnx3dggL0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oYulQc1f9zEJqVrGH/lD0pGUzCl1B67oX738f3LgzobeGeOCkchS4XcnOm+0hyjRp
	 pjno09flp80/1W30BRT/aYT6bh2YHN9Y/PLyq9ufAje2cLvvRYPe7cwBc9L13exwm/
	 Th9CnwbV4eICW2GOdCAgJKCUyDSXparQnXjDDmxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junhao He <hejunhao3@huawei.com>,
	Mike Leach <mike.leach@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 603/800] coresight: etm4x: Fix missing trctraceidr file in sysfs
Date: Sun, 16 Jul 2023 21:47:36 +0200
Message-ID: <20230716195003.111390651@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mike Leach <mike.leach@linaro.org>

[ Upstream commit 9f37d3798026f9a7447d851a2cb356610852e426 ]

The trace ID patchset adjusted the handling of the TRCTRACEIDR register
sysfs to allocate on read.

Although this was initally correct, the final version of the patch series
introduced an error which resulted in the mgmt/trctraceidr file in sysfs
not being visible.

This patch fixes that issue.

Fixes: df4871204e5d ("coresight: etm4x: Update ETM4 driver to use Trace ID API")
Reported-by: Junhao He <hejunhao3@huawei.com>
Link: https://lists.linaro.org/archives/list/coresight@lists.linaro.org/thread/KK3CVVMRHJWVUORKMFJRSXYCEDFKENQJ/
Signed-off-by: Mike Leach <mike.leach@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20230512133054.235073-1-mike.leach@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../coresight/coresight-etm4x-sysfs.c         | 27 ++++++++++++-------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c b/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c
index 5e62aa40ecd0f..a9f19629f3f84 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c
@@ -2411,7 +2411,6 @@ static ssize_t trctraceid_show(struct device *dev,
 
 	return sysfs_emit(buf, "0x%x\n", trace_id);
 }
-static DEVICE_ATTR_RO(trctraceid);
 
 struct etmv4_reg {
 	struct coresight_device *csdev;
@@ -2528,13 +2527,23 @@ coresight_etm4x_attr_reg_implemented(struct kobject *kobj,
 	return 0;
 }
 
-#define coresight_etm4x_reg(name, offset)				\
-	&((struct dev_ext_attribute[]) {				\
-	   {								\
-		__ATTR(name, 0444, coresight_etm4x_reg_show, NULL),	\
-		(void *)(unsigned long)offset				\
-	   }								\
-	})[0].attr.attr
+/*
+ * Macro to set an RO ext attribute with offset and show function.
+ * Offset is used in mgmt group to ensure only correct registers for
+ * the ETM / ETE variant are visible.
+ */
+#define coresight_etm4x_reg_showfn(name, offset, showfn) (	\
+	&((struct dev_ext_attribute[]) {			\
+	   {							\
+		__ATTR(name, 0444, showfn, NULL),		\
+		(void *)(unsigned long)offset			\
+	   }							\
+	})[0].attr.attr						\
+	)
+
+/* macro using the default coresight_etm4x_reg_show function */
+#define coresight_etm4x_reg(name, offset)	\
+	coresight_etm4x_reg_showfn(name, offset, coresight_etm4x_reg_show)
 
 static struct attribute *coresight_etmv4_mgmt_attrs[] = {
 	coresight_etm4x_reg(trcpdcr, TRCPDCR),
@@ -2549,7 +2558,7 @@ static struct attribute *coresight_etmv4_mgmt_attrs[] = {
 	coresight_etm4x_reg(trcpidr3, TRCPIDR3),
 	coresight_etm4x_reg(trcoslsr, TRCOSLSR),
 	coresight_etm4x_reg(trcconfig, TRCCONFIGR),
-	&dev_attr_trctraceid.attr,
+	coresight_etm4x_reg_showfn(trctraceid, TRCTRACEIDR, trctraceid_show),
 	coresight_etm4x_reg(trcdevarch, TRCDEVARCH),
 	NULL,
 };
-- 
2.39.2



