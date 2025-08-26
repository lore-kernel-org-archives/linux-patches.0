Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61A0935A299;
	Tue, 26 Aug 2025 14:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218754; cv=none; b=N2tl+MultRMUGZqoZtMUwsJwosa+ioKj2nYIB+BoPyVStL585NNyI+VwgiG/aEDcDpGvcl2WqQlH/ipOQCesfriYEEps+lEcw5TSCrOeDyKVeBPUyJEODjci1m/cPgWM2nZkOfsP0JF4BA74enj3TdV8tyigiX7P1oVMbM6jChI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218754; c=relaxed/simple;
	bh=3vJJ4Bv54JXW2OlGQql1t3lC3JIh6HTbXmDBx37acbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K5mNBXoofq9KTtLrPVDXr+Yi27TIOwap4maPQgWbp8mv9Ffd8xcJwR1lbx9jgdbAspSCN4w7qY+HTx5cQNAT9G8WuaurQyot4bt7lbDi5XbDqRW4XbLDHwlHBeE3qKNu5w7snVecyuK+di8uSqXyGX2+ZYW00BMWvVB+XFxGJAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mKsasrD/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mKsasrD/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB9DCC4CEF1;
	Tue, 26 Aug 2025 14:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218754;
	bh=3vJJ4Bv54JXW2OlGQql1t3lC3JIh6HTbXmDBx37acbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mKsasrD/hAXFz0OykwmgoFzdrGvgBiKrZgtOplGWBnrsS1sP0wL4F3+4HkRiUdJUT
	 zrMqB3yNhj3g9OZ69Pej9Fhvp2Ux+uUKzaJ1GkOvKsIYh6KB1B/YVgNT66z/pIRfnQ
	 RsN8q+joo+nsyCKymjWKKsu3eWWplyWguvtW9AAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 089/403] iwlwifi: Add missing check for alloc_ordered_workqueue
Date: Tue, 26 Aug 2025 13:06:55 +0200
Message-ID: <20250826110909.124067505@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 90a0d9f339960448a3acc1437a46730f975efd6a ]

Add check for the return value of alloc_ordered_workqueue since it may
return NULL pointer.

Fixes: b481de9ca074 ("[IWLWIFI]: add iwlwifi wireless drivers")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Link: https://patch.msgid.link/20230110014848.28226-1-jiasheng@iscas.ac.cn
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/dvm/main.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/main.c b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
index 4f2789bb3b5b..9ca704a2c679 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
@@ -1055,9 +1055,11 @@ static void iwl_bg_restart(struct work_struct *data)
  *
  *****************************************************************************/
 
-static void iwl_setup_deferred_work(struct iwl_priv *priv)
+static int iwl_setup_deferred_work(struct iwl_priv *priv)
 {
 	priv->workqueue = alloc_ordered_workqueue(DRV_NAME, 0);
+	if (!priv->workqueue)
+		return -ENOMEM;
 
 	INIT_WORK(&priv->restart, iwl_bg_restart);
 	INIT_WORK(&priv->beacon_update, iwl_bg_beacon_update);
@@ -1074,6 +1076,8 @@ static void iwl_setup_deferred_work(struct iwl_priv *priv)
 	timer_setup(&priv->statistics_periodic, iwl_bg_statistics_periodic, 0);
 
 	timer_setup(&priv->ucode_trace, iwl_bg_ucode_trace, 0);
+
+	return 0;
 }
 
 void iwl_cancel_deferred_work(struct iwl_priv *priv)
@@ -1469,7 +1473,9 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	/********************
 	 * 6. Setup services
 	 ********************/
-	iwl_setup_deferred_work(priv);
+	if (iwl_setup_deferred_work(priv))
+		goto out_uninit_drv;
+
 	iwl_setup_rx_handlers(priv);
 
 	iwl_power_initialize(priv);
@@ -1507,6 +1513,7 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	iwl_cancel_deferred_work(priv);
 	destroy_workqueue(priv->workqueue);
 	priv->workqueue = NULL;
+out_uninit_drv:
 	iwl_uninit_drv(priv);
 out_free_eeprom_blob:
 	kfree(priv->eeprom_blob);
-- 
2.39.5



