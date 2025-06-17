Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7146D2DFF1B;
	Tue, 17 Jun 2025 16:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177353; cv=none; b=KJmIiir7cIUcmwdheKLF5aaKGHjetgJYeSvEjrx2TH/tMKPMtxENpHfhE58MgxzIH5leYjKYNimFDsByQSQkBD4UBDHSWt1kehxjIPYuV6xUq9SOrXkXfYwqJVBZ14/IK+KTfdQdAc0+B7Tr6yLb/VSDzdYmMt4c19mCKURdwgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177353; c=relaxed/simple;
	bh=4RDlr5qFhnwE+IqXGQTEk189gN9LmAbILar1TZm7D9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RTAHRBpPS8vzu20RghAtHk3weArvCwG9wQ2Qj7Alo6ciqGbq70uRGQEvuzWY4zysFtKqTbBvyIFBIYDvwNcA0XOMTe8bfOvME58nu9bweEjwPSkpVYwD+hthcgHy/EUYelkovK4IByhrjGxO6BvTk0DNn0FUu4RgUk5n3qESbrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CHEUyu3r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CHEUyu3r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5B1DC4CEE3;
	Tue, 17 Jun 2025 16:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177353;
	bh=4RDlr5qFhnwE+IqXGQTEk189gN9LmAbILar1TZm7D9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CHEUyu3rtrLSAjW2ALGokqBjNyNLTfgl60r3s8GBENfyc8ristUFimqPLVU5Xv3Bq
	 D2rlBfkAPDfhcrpgLgOh+KmpwHXr9RIxntmPZpwQF+pyzagwGCi0EQ0Q80N9N7zXHb
	 fF8up6YKpDkVHv0Gf2imsnTbY6rt4Hspd/INGo0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junhao He <hejunhao3@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 331/512] coresight: Fixes devices owner field for registered using coresight_init_driver()
Date: Tue, 17 Jun 2025 17:24:57 +0200
Message-ID: <20250617152433.025010167@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

From: Junhao He <hejunhao3@huawei.com>

[ Upstream commit 9f52aecc952ddf307571517d5c91136c8c4e87c9 ]

The coresight_init_driver() of the coresight-core module is called from
the sub coresgiht device (such as tmc/stm/funnle/...) module. It calls
amba_driver_register() and Platform_driver_register(), which are macro
functions that use the coresight-core's module to initialize the caller's
owner field.  Therefore, when the sub coresight device calls
coresight_init_driver(), an incorrect THIS_MODULE value is captured.

The sub coesgiht modules can be removed while their callbacks are
running, resulting in a general protection failure.

Add module parameter to coresight_init_driver() so can be called
with the module of the callback.

Fixes: 075b7cd7ad7d ("coresight: Add helpers registering/removing both AMBA and platform drivers")
Signed-off-by: Junhao He <hejunhao3@huawei.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20240918035327.9710-1-hejunhao3@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-catu.c       | 2 +-
 drivers/hwtracing/coresight/coresight-core.c       | 6 +++---
 drivers/hwtracing/coresight/coresight-cpu-debug.c  | 3 ++-
 drivers/hwtracing/coresight/coresight-funnel.c     | 3 ++-
 drivers/hwtracing/coresight/coresight-replicator.c | 3 ++-
 drivers/hwtracing/coresight/coresight-stm.c        | 2 +-
 drivers/hwtracing/coresight/coresight-tmc-core.c   | 2 +-
 drivers/hwtracing/coresight/coresight-tpiu.c       | 2 +-
 include/linux/coresight.h                          | 2 +-
 9 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-catu.c b/drivers/hwtracing/coresight/coresight-catu.c
index d8ad64ea81f11..8cf85ff216bbe 100644
--- a/drivers/hwtracing/coresight/coresight-catu.c
+++ b/drivers/hwtracing/coresight/coresight-catu.c
@@ -702,7 +702,7 @@ static int __init catu_init(void)
 {
 	int ret;
 
-	ret = coresight_init_driver("catu", &catu_driver, &catu_platform_driver);
+	ret = coresight_init_driver("catu", &catu_driver, &catu_platform_driver, THIS_MODULE);
 	tmc_etr_set_catu_ops(&etr_catu_buf_ops);
 	return ret;
 }
diff --git a/drivers/hwtracing/coresight/coresight-core.c b/drivers/hwtracing/coresight/coresight-core.c
index c42aa9fddab9b..c7e35a431ab00 100644
--- a/drivers/hwtracing/coresight/coresight-core.c
+++ b/drivers/hwtracing/coresight/coresight-core.c
@@ -1422,17 +1422,17 @@ module_init(coresight_init);
 module_exit(coresight_exit);
 
 int coresight_init_driver(const char *drv, struct amba_driver *amba_drv,
-			  struct platform_driver *pdev_drv)
+			  struct platform_driver *pdev_drv, struct module *owner)
 {
 	int ret;
 
-	ret = amba_driver_register(amba_drv);
+	ret = __amba_driver_register(amba_drv, owner);
 	if (ret) {
 		pr_err("%s: error registering AMBA driver\n", drv);
 		return ret;
 	}
 
-	ret = platform_driver_register(pdev_drv);
+	ret = __platform_driver_register(pdev_drv, owner);
 	if (!ret)
 		return 0;
 
diff --git a/drivers/hwtracing/coresight/coresight-cpu-debug.c b/drivers/hwtracing/coresight/coresight-cpu-debug.c
index 75962dae9aa18..cc599c5ef4b22 100644
--- a/drivers/hwtracing/coresight/coresight-cpu-debug.c
+++ b/drivers/hwtracing/coresight/coresight-cpu-debug.c
@@ -774,7 +774,8 @@ static struct platform_driver debug_platform_driver = {
 
 static int __init debug_init(void)
 {
-	return coresight_init_driver("debug", &debug_driver, &debug_platform_driver);
+	return coresight_init_driver("debug", &debug_driver, &debug_platform_driver,
+				     THIS_MODULE);
 }
 
 static void __exit debug_exit(void)
diff --git a/drivers/hwtracing/coresight/coresight-funnel.c b/drivers/hwtracing/coresight/coresight-funnel.c
index 5a819c8970fbf..8f451b051ddc3 100644
--- a/drivers/hwtracing/coresight/coresight-funnel.c
+++ b/drivers/hwtracing/coresight/coresight-funnel.c
@@ -433,7 +433,8 @@ static struct amba_driver dynamic_funnel_driver = {
 
 static int __init funnel_init(void)
 {
-	return coresight_init_driver("funnel", &dynamic_funnel_driver, &funnel_driver);
+	return coresight_init_driver("funnel", &dynamic_funnel_driver, &funnel_driver,
+				     THIS_MODULE);
 }
 
 static void __exit funnel_exit(void)
diff --git a/drivers/hwtracing/coresight/coresight-replicator.c b/drivers/hwtracing/coresight/coresight-replicator.c
index 3e55be9c84186..f7607c72857c5 100644
--- a/drivers/hwtracing/coresight/coresight-replicator.c
+++ b/drivers/hwtracing/coresight/coresight-replicator.c
@@ -438,7 +438,8 @@ static struct amba_driver dynamic_replicator_driver = {
 
 static int __init replicator_init(void)
 {
-	return coresight_init_driver("replicator", &dynamic_replicator_driver, &replicator_driver);
+	return coresight_init_driver("replicator", &dynamic_replicator_driver, &replicator_driver,
+				     THIS_MODULE);
 }
 
 static void __exit replicator_exit(void)
diff --git a/drivers/hwtracing/coresight/coresight-stm.c b/drivers/hwtracing/coresight/coresight-stm.c
index cb3e04755c992..65bc50a6d3e9a 100644
--- a/drivers/hwtracing/coresight/coresight-stm.c
+++ b/drivers/hwtracing/coresight/coresight-stm.c
@@ -1047,7 +1047,7 @@ static struct platform_driver stm_platform_driver = {
 
 static int __init stm_init(void)
 {
-	return coresight_init_driver("stm", &stm_driver, &stm_platform_driver);
+	return coresight_init_driver("stm", &stm_driver, &stm_platform_driver, THIS_MODULE);
 }
 
 static void __exit stm_exit(void)
diff --git a/drivers/hwtracing/coresight/coresight-tmc-core.c b/drivers/hwtracing/coresight/coresight-tmc-core.c
index 3a482fd2cb225..475fa4bb6813b 100644
--- a/drivers/hwtracing/coresight/coresight-tmc-core.c
+++ b/drivers/hwtracing/coresight/coresight-tmc-core.c
@@ -741,7 +741,7 @@ static struct platform_driver tmc_platform_driver = {
 
 static int __init tmc_init(void)
 {
-	return coresight_init_driver("tmc", &tmc_driver, &tmc_platform_driver);
+	return coresight_init_driver("tmc", &tmc_driver, &tmc_platform_driver, THIS_MODULE);
 }
 
 static void __exit tmc_exit(void)
diff --git a/drivers/hwtracing/coresight/coresight-tpiu.c b/drivers/hwtracing/coresight/coresight-tpiu.c
index b048e146fbb10..f9ecd05cbe5c5 100644
--- a/drivers/hwtracing/coresight/coresight-tpiu.c
+++ b/drivers/hwtracing/coresight/coresight-tpiu.c
@@ -318,7 +318,7 @@ static struct platform_driver tpiu_platform_driver = {
 
 static int __init tpiu_init(void)
 {
-	return coresight_init_driver("tpiu", &tpiu_driver, &tpiu_platform_driver);
+	return coresight_init_driver("tpiu", &tpiu_driver, &tpiu_platform_driver, THIS_MODULE);
 }
 
 static void __exit tpiu_exit(void)
diff --git a/include/linux/coresight.h b/include/linux/coresight.h
index f106b10251118..59f99b7da43f5 100644
--- a/include/linux/coresight.h
+++ b/include/linux/coresight.h
@@ -683,7 +683,7 @@ coresight_find_output_type(struct coresight_platform_data *pdata,
 			   union coresight_dev_subtype subtype);
 
 int coresight_init_driver(const char *drv, struct amba_driver *amba_drv,
-			  struct platform_driver *pdev_drv);
+			  struct platform_driver *pdev_drv, struct module *owner);
 
 void coresight_remove_driver(struct amba_driver *amba_drv,
 			     struct platform_driver *pdev_drv);
-- 
2.39.5



