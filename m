Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A38EA298CB2;
	Thu, 28 May 2026 20:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000743; cv=none; b=sD3nkrUSH+4r4DWuD9rynjmbPMBzEGZB18NIkMPGffB8dFGWhjglynSwJJqxmxC0sufVriO/oFoYQSY/ZAWO5p+41pMePAWo12x36oKxFVxYBvaW1kdYZFKBe+Ri9RI9XGk60RBXUrMEy9ZDWA/K6mrAIQ9g7IhyIXDaUEzc06c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000743; c=relaxed/simple;
	bh=tb+/7UeosWQwPkNiu3OqjylUB9SYoEEF62OjUCm9fi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iz2hshUjNd/ObtXVlikXWmmVvhW6xsfOyETbtgrsgf+O/hKCRDNHWoLkrLqvctYit7Vr0MA9au0hEV9lXrPte/Ujf+dep1qO9I8kQ0WLnDNrHKWvbar+W0cW2jgmPejN/U3WfBBkmOnM/+phChVtrW2tByLmgvBiB76UbO0WI48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S0jHA6pB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S0jHA6pB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D9B51F000E9;
	Thu, 28 May 2026 20:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000742;
	bh=7hkriVZD9Rrw1kotkyIwKjUBQ02YdDC9svs7kwPzAT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S0jHA6pBqa22iJdzzs+54qH3CB3LVeFYbdU3I8Uc4uiGKW+ij2aak9MStZIqtiI/y
	 BLk8UnhdU63mYZvrVLm/Q6HYXeui6YZE/r1zH5Vmu6XLwzgrrB/iDRZSA9oO6itgV5
	 PCSO8e+50YcchhC+J8Pqbn3ByYsOTpJWk9bdnkH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 153/272] firmware: arm_ffa: Unregister bus notifier on teardown for FF-A v1.0
Date: Thu, 28 May 2026 21:48:47 +0200
Message-ID: <20260528194633.645686512@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

From: Sudeep Holla <sudeep.holla@kernel.org>

[ Upstream commit 6d3daa9b8d313f42d52e75590310f26a29b61b44 ]

For FF-A v1.0 the driver registers a bus notifier to backfill UUID
matching, but the notifier was never unregistered on cleanup paths.
Track the registration state and unregister it during teardown and early
partition-setup failure.

Fixes: 9dd15934f60d ("firmware: arm_ffa: Move the FF-A v1.0 NULL UUID workaround to bus notifier")
Link: https://patch.msgid.link/20260428-ffa_fixes-v2-5-8595ae450034@kernel.org
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_ffa/driver.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index 6961cb44194a1..a6c5f89476c06 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -100,6 +100,7 @@ struct ffa_drv_info {
 	bool mem_ops_native;
 	bool msg_direct_req2_supp;
 	bool bitmap_created;
+	bool bus_notifier_registered;
 	bool notif_enabled;
 	unsigned int sched_recv_irq;
 	unsigned int notif_pend_irq;
@@ -1436,6 +1437,15 @@ static struct notifier_block ffa_bus_nb = {
 	.notifier_call = ffa_bus_notifier,
 };
 
+static void ffa_bus_notifier_unregister(void)
+{
+	if (!drv_info->bus_notifier_registered)
+		return;
+
+	bus_unregister_notifier(&ffa_bus_type, &ffa_bus_nb);
+	drv_info->bus_notifier_registered = false;
+}
+
 static int ffa_xa_add_partition_info(struct ffa_device *dev)
 {
 	struct ffa_dev_part_info *info;
@@ -1519,6 +1529,8 @@ static void ffa_partitions_cleanup(void)
 	struct list_head *phead;
 	unsigned long idx;
 
+	ffa_bus_notifier_unregister();
+
 	/* Clean up/free all registered devices */
 	ffa_devices_unregister();
 
@@ -1546,11 +1558,14 @@ static int ffa_setup_partitions(void)
 		ret = bus_register_notifier(&ffa_bus_type, &ffa_bus_nb);
 		if (ret)
 			pr_err("Failed to register FF-A bus notifiers\n");
+		else
+			drv_info->bus_notifier_registered = true;
 	}
 
 	count = ffa_partition_probe(&uuid_null, &pbuf);
 	if (count <= 0) {
 		pr_info("%s: No partitions found, error %d\n", __func__, count);
+		ffa_bus_notifier_unregister();
 		return -EINVAL;
 	}
 
-- 
2.53.0



