Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5288647AF6E;
	Sat, 12 Sep 2026 12:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216577; cv=none; b=In5PYLWZ5uSohIyVfVrTIUgDCkDg9hKTpb/24liTovlq+6XAbqKmGnnIxTPi0AcDmwTl76J9ueJb2M5Im+J/bBeVZHfResCPhQC1iG1DEDr2rxT1pzyh5qqZkb4tnT9iL+JvLWJytvPsGo5LiJPnK9jOVPIjr71ndqWGozQ6eOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216577; c=relaxed/simple;
	bh=kQMkgqHv8SXu0zKF8ZbG6GdtlVj6/BHZXTq5L42OXMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rFwJPzi7tPSekiyGVEaMd5PnID6hG1GcNJ/hwxlop79za/2BNBqr1vwT/NxlryZWK6anvzArhn3l5IXZwlR1bg9m+rMWK2NvYICMTcyVJDpHyxMlztd6Mp4dgJOXndFHutgZ8HUrD9v1B1M6wjXOyfD1gHBQNwBQ9cZF/yahvvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JVRaeDjv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JVRaeDjv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C39DA1F000FF;
	Sat, 12 Sep 2026 12:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216573;
	bh=WXXUNFLFs8nrH/sm1pcJUEtQNJOHh0G3QQVDQWXbZ5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JVRaeDjvPFUnbX4WuK9zwBCNpZDzcLkBObi3ugVVd+OKvt7696Xl4MVTkgrkt2OC/
	 tSiJqq/kVjSy7L7Oexd/LA5NEchNnPeRkw/RgyKGHg6Tb1LBLFkPZ7AoynrkDrWVI0
	 As57E1fu99z4wwv8J7V5O9k0hCjOpqAzpljLnucY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0764/1376] firmware: qcom: scm: Fix tzmem state on probe retry
Date: Sat, 12 Sep 2026 08:53:10 +0200
Message-ID: <20260912065624.568269311@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>

[ Upstream commit 9941fe8a04f3d258e07eb5899db3027252a4190f ]

qcom_tzmem_enable() returns -EBUSY if called a second time, but this
causes probe retries to fail permanently if a later step in
qcom_scm_probe() defers after qcom_tzmem_enable() has already succeeded.

Use DO_ONCE() to ensure qcom_tzmem_init() runs exactly once across all
calls in a thread-safe manner. qcom_tzmem_dev is set on every call since
probe retries use the same device pointer. The result of the first
initialisation is cached and returned to every subsequent caller.

Fixes: 40289e35ca52 ("firmware: qcom: scm: enable the TZ mem allocator")
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260724094939.613844-4-mukesh.ojha@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/qcom/qcom_tzmem.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/qcom/qcom_tzmem.c b/drivers/firmware/qcom/qcom_tzmem.c
index f8fef622e48fe..91f1efd83d712 100644
--- a/drivers/firmware/qcom/qcom_tzmem.c
+++ b/drivers/firmware/qcom/qcom_tzmem.c
@@ -15,6 +15,7 @@
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/mm.h>
+#include <linux/once.h>
 #include <linux/radix-tree.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
@@ -465,14 +466,18 @@ phys_addr_t qcom_tzmem_to_phys(void *vaddr)
 }
 EXPORT_SYMBOL_GPL(qcom_tzmem_to_phys);
 
+static void qcom_tzmem_do_init(int *result)
+{
+	*result = qcom_tzmem_init();
+}
+
 int qcom_tzmem_enable(struct device *dev)
 {
-	if (qcom_tzmem_dev)
-		return -EBUSY;
+	static int result;
 
 	qcom_tzmem_dev = dev;
-
-	return qcom_tzmem_init();
+	DO_ONCE(qcom_tzmem_do_init, &result);
+	return result;
 }
 EXPORT_SYMBOL_GPL(qcom_tzmem_enable);
 
-- 
2.53.0



