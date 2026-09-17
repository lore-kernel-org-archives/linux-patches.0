Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9C54ABBDF;
	Thu, 17 Sep 2026 15:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659636; cv=none; b=OcvNRoiPyzLnjQxe2kxVEqxBKxtjD2/2rDIb5JQpagakVcJhEW/gdDMYw+WZAKX0DQ5OSPMSLY601GeFM3gP0n34TeisM6aoM3KwqUAk1TRC0ly24zI/xZcKr8t0a0wm9Pi9oNLPNhAu3tioumHCl+lzN6nKziaJn+zULuHRL/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659636; c=relaxed/simple;
	bh=7VJu7ImFYW2ibjE/1SUIOTYuCt5kGP7Xtx8aeEid4u4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MS3hV79yLgSKT5hsMJBH5dlNtxELi5pC0bBlBNw218TD6vL1yo//ePOMqTBzLoyTWRMPWQH5kf/eTUnxqmBoXzNu/sEY80WJdb0I0iaGisH4vG/TrlR2wZAG4Lnnb1OSMRx2S/9bCXo62r586zDI6Onod3jQH2rmFgYGaJKNArU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=trU4CyPK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="trU4CyPK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFEC71F00898;
	Thu, 17 Sep 2026 15:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659625;
	bh=O/YapDgK+0tmApeoenta7h7RfIImbRH1a70tWn42gZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=trU4CyPKbIwLMyat66g6LuZqUcfpE6nfR2OsA75SNNY2RGQIirfjW+ofnJs1pddK2
	 8itH1kDh+mbhT218Wv3RnbuXrJEQUus7xVI2G7A+WGLr+0+F6hXeIA1M2H1s7MSoup
	 5U9Bii50myhWZmaW/n5dNjD57CgANkla847nuKVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fangyu Yu <fangyu.yu@linux.alibaba.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 318/733] iommu/riscv: Avoid waiting on failed command enqueue
Date: Thu, 17 Sep 2026 16:10:26 +0100
Message-ID: <20260917151359.412776093@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fangyu Yu <fangyu.yu@linux.alibaba.com>

[ Upstream commit 4c50bec3d54288230aafb7fe3d2930d42beb14fd ]

Do not wait for IOFENCE.C completion when the command failed to enter the
queue. The command was not published to hardware, so waiting for its
producer index can only report a misleading execution timeout.

Fixes: 856c0cfe5c5f ("iommu/riscv: Command and fault queue support")
Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/riscv/iommu.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/riscv/iommu.c b/drivers/iommu/riscv/iommu.c
index e335beb70e422..fe8e6d0f8a23b 100644
--- a/drivers/iommu/riscv/iommu.c
+++ b/drivers/iommu/riscv/iommu.c
@@ -419,8 +419,9 @@ static int riscv_iommu_queue_wait_for_space(struct riscv_iommu_queue *queue,
 }
 
 /* Enqueue an entry and publish it to the hardware queue. */
-static unsigned int riscv_iommu_queue_send(struct riscv_iommu_queue *queue,
-					   void *entry, size_t entry_size)
+static int riscv_iommu_queue_send(struct riscv_iommu_queue *queue,
+					  void *entry, size_t entry_size,
+					  unsigned int *out_prod)
 {
 	unsigned int prod;
 	unsigned int head;
@@ -462,14 +463,16 @@ static unsigned int riscv_iommu_queue_send(struct riscv_iommu_queue *queue,
 	atomic_set(&queue->tail, prod + 1);
 	atomic_set(&queue->prod, prod + 1);
 
-	raw_spin_unlock_irqrestore(&queue->lock, flags);
+	if (out_prod)
+		*out_prod = prod;
 
-	return prod;
+	raw_spin_unlock_irqrestore(&queue->lock, flags);
+	return 0;
 
 err_busy:
 	/* Report the failure and continue; full RAS recovery is not implemented. */
 	dev_err_once(queue->iommu->dev, "Hardware error: command enqueue failed\n");
-	return prod;
+	return ret;
 }
 
 /*
@@ -508,7 +511,7 @@ static irqreturn_t riscv_iommu_cmdq_process(int irq, void *data)
 static void riscv_iommu_cmd_send(struct riscv_iommu_device *iommu,
 				 struct riscv_iommu_command *cmd)
 {
-	riscv_iommu_queue_send(&iommu->cmdq, cmd, sizeof(*cmd));
+	riscv_iommu_queue_send(&iommu->cmdq, cmd, sizeof(*cmd), NULL);
 }
 
 /* Send IOFENCE.C command and wait for all scheduled commands to complete. */
@@ -517,9 +520,12 @@ static void riscv_iommu_cmd_sync(struct riscv_iommu_device *iommu,
 {
 	struct riscv_iommu_command cmd;
 	unsigned int prod;
+	int ret;
 
 	riscv_iommu_cmd_iofence(&cmd);
-	prod = riscv_iommu_queue_send(&iommu->cmdq, &cmd, sizeof(cmd));
+	ret = riscv_iommu_queue_send(&iommu->cmdq, &cmd, sizeof(cmd), &prod);
+	if (ret)
+		return;
 
 	if (!timeout_us)
 		return;
-- 
2.53.0



