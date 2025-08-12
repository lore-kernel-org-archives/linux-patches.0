Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 002102F5E;
	Tue, 12 Aug 2025 18:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023882; cv=none; b=GMyJfDw3di2UVC+bMNicJNzDvd2GlrWM2mW5bBfkCCSpWwIuplnq8Pb2OTOgDZ5x56t2dL572vc6N9eM+dW8CpOc3XqJ4VVnT3HPRW0lqBi5ZE/6FWp70mJbeiWDHaKkHSXo365/sJBOriuTK7pGH0giW3AXlSVDk0stkqu7wtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023882; c=relaxed/simple;
	bh=mGjvi31KJqGPeLRzBFP3QzF8dZ11jTmcg4X+eOXCAVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EUcwjnM+4p5pmJPf5exhR2LMJ5O6qKdaOmgjeTfyRFfx4TPsQThMqiRKvcd7FZCk0PeMrxn+VWKDdtqtw1EqMshS23b4k/fv8X4nwsFykPeFmDjjDC7Y62iPRlkJs+XED02N1RMqd9TeVMZOjqtS5DwYH3iaccCWGF5j57y75pQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZqGnwnfL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZqGnwnfL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61D5DC4CEF1;
	Tue, 12 Aug 2025 18:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023881;
	bh=mGjvi31KJqGPeLRzBFP3QzF8dZ11jTmcg4X+eOXCAVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZqGnwnfL8AGNZh0Azy6O3z/Pq6lCie5lrJw1NkK0kcSduK7h+7k3LZuxNsgfoVDW/
	 icGUSR1kFJ9ZJpLkLk5qjdP0bGy4ncNk1jxKZMvkNgzlnBydlWirgmfFv64UYuvcFn
	 kDpx4de545p5U6v1RsFTAt2adf8HEiW3uMTHv37Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 167/627] iwlwifi: Add missing check for alloc_ordered_workqueue
Date: Tue, 12 Aug 2025 19:27:42 +0200
Message-ID: <20250812173425.637193836@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 66211426aa3a..e015b83bb6e9 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
@@ -1049,9 +1049,11 @@ static void iwl_bg_restart(struct work_struct *data)
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
@@ -1068,6 +1070,8 @@ static void iwl_setup_deferred_work(struct iwl_priv *priv)
 	timer_setup(&priv->statistics_periodic, iwl_bg_statistics_periodic, 0);
 
 	timer_setup(&priv->ucode_trace, iwl_bg_ucode_trace, 0);
+
+	return 0;
 }
 
 void iwl_cancel_deferred_work(struct iwl_priv *priv)
@@ -1463,7 +1467,9 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	/********************
 	 * 6. Setup services
 	 ********************/
-	iwl_setup_deferred_work(priv);
+	if (iwl_setup_deferred_work(priv))
+		goto out_uninit_drv;
+
 	iwl_setup_rx_handlers(priv);
 
 	iwl_power_initialize(priv);
@@ -1502,6 +1508,7 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	iwl_cancel_deferred_work(priv);
 	destroy_workqueue(priv->workqueue);
 	priv->workqueue = NULL;
+out_uninit_drv:
 	iwl_uninit_drv(priv);
 out_free_eeprom_blob:
 	kfree(priv->eeprom_blob);
-- 
2.39.5



