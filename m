Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8131C2BD;
	Sat,  3 Feb 2024 04:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933821; cv=none; b=QEwtFL5ZiX6i7kmyxrlkQuafUDImd4R+ZPQ+KIcrM4jAjrsn6wZIHLTYa5uEvEYHCD2dzXOgVabhxj+K0klgr5TSTuA3bQa2OHRv5JIDmMrGWqh5ipFn9bc1eU+ptUT/87WjR0fMj+zXQl6xtjnYlQ9rSSZT8YeHTCIumtkUCKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933821; c=relaxed/simple;
	bh=GWfvDG2oJvWi4yvCL40MfFiYZG+ISkKerGnmVKVve78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qFnXMCa5v/UNnnzFZNDhAFl0adsFyIGB3Mc7eMZx4RRwTjyv7upOTuZAtTo9MZ75ilejFNMHOL447kPYngr8qwjiD5Kj4DRdujRET59lhZ2POyguZ82gAKfqgf/BW0WC2o8PKCcKfbjqy4QYg+TBALJN9eDmjLRvdaKLeWq33R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rf8qHDia; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rf8qHDia"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7F9EC43394;
	Sat,  3 Feb 2024 04:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933821;
	bh=GWfvDG2oJvWi4yvCL40MfFiYZG+ISkKerGnmVKVve78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rf8qHDiaQbhk2/a5XorQdhj0nJ5xHwqDdJFo78lLJxfC9azkWlxzDZgqzNM89y3V4
	 oKs6D2A8fJdATdCwJ4LB0bpQGHB9K5UGAOPkFlAMo0DN0v5oNFh2dtzqSykI0uuVIe
	 pkjHkrEpL9c9ut0kbug0mITwbif3fZplcHzW9p38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shannon Nelson <shannon.nelson@amd.com>,
	Brett Creeley <brett.creeley@amd.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 116/353] ionic: bypass firmware cmds when stuck in reset
Date: Fri,  2 Feb 2024 20:03:54 -0800
Message-ID: <20240203035407.420875613@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shannon Nelson <shannon.nelson@amd.com>

[ Upstream commit ca5fdf9a7c5b65968c718f2be159cda4c13556a1 ]

If the driver or firmware is stuck in reset state, don't bother
trying to use adminq commands.  This speeds up shutdown and
prevents unnecessary timeouts and error messages.

This includes a bit of rework on ionic_adminq_post_wait()
and ionic_adminq_post_wait_nomsg() to both use
__ionic_adminq_post_wait() which can do the checks needed in
both cases.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Reviewed-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/pensando/ionic/ionic_bus_pci.c   |  4 ++++
 .../net/ethernet/pensando/ionic/ionic_lif.c   |  3 +++
 .../net/ethernet/pensando/ionic/ionic_main.c  | 20 ++++++++++++-------
 3 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
index d6ce113a4210..fa4237c27e06 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
@@ -392,6 +392,10 @@ static void ionic_remove(struct pci_dev *pdev)
 	del_timer_sync(&ionic->watchdog_timer);
 
 	if (ionic->lif) {
+		/* prevent adminq cmds if already known as down */
+		if (test_and_clear_bit(IONIC_LIF_F_FW_RESET, ionic->lif->state))
+			set_bit(IONIC_LIF_F_FW_STOPPING, ionic->lif->state);
+
 		ionic_lif_unregister(ionic->lif);
 		ionic_devlink_unregister(ionic);
 		ionic_lif_deinit(ionic->lif);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index bad919343180..075e0e3fc2ea 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -3238,6 +3238,9 @@ static void ionic_lif_reset(struct ionic_lif *lif)
 {
 	struct ionic_dev *idev = &lif->ionic->idev;
 
+	if (!ionic_is_fw_running(idev))
+		return;
+
 	mutex_lock(&lif->ionic->dev_cmd_lock);
 	ionic_dev_cmd_lif_reset(idev, lif->index);
 	ionic_dev_cmd_wait(lif->ionic, DEVCMD_TIMEOUT);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index 1b547acfd8e9..83c413a10f79 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -410,22 +410,28 @@ int ionic_adminq_wait(struct ionic_lif *lif, struct ionic_admin_ctx *ctx,
 				      do_msg);
 }
 
-int ionic_adminq_post_wait(struct ionic_lif *lif, struct ionic_admin_ctx *ctx)
+static int __ionic_adminq_post_wait(struct ionic_lif *lif,
+				    struct ionic_admin_ctx *ctx,
+				    const bool do_msg)
 {
 	int err;
 
+	if (!ionic_is_fw_running(&lif->ionic->idev))
+		return 0;
+
 	err = ionic_adminq_post(lif, ctx);
 
-	return ionic_adminq_wait(lif, ctx, err, true);
+	return ionic_adminq_wait(lif, ctx, err, do_msg);
 }
 
-int ionic_adminq_post_wait_nomsg(struct ionic_lif *lif, struct ionic_admin_ctx *ctx)
+int ionic_adminq_post_wait(struct ionic_lif *lif, struct ionic_admin_ctx *ctx)
 {
-	int err;
-
-	err = ionic_adminq_post(lif, ctx);
+	return __ionic_adminq_post_wait(lif, ctx, true);
+}
 
-	return ionic_adminq_wait(lif, ctx, err, false);
+int ionic_adminq_post_wait_nomsg(struct ionic_lif *lif, struct ionic_admin_ctx *ctx)
+{
+	return __ionic_adminq_post_wait(lif, ctx, false);
 }
 
 static void ionic_dev_cmd_clean(struct ionic *ionic)
-- 
2.43.0



