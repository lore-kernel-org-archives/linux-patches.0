Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD51279DB6;
	Tue, 12 Aug 2025 19:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025714; cv=none; b=MoqbRG0Ipv4PvqWT1bayAHltOSeHkZmHC1btEKLLf1T6ZN8Ocj8zMJTzmQSiUoXknuz0lmDewjAaeEU43/u/o5TlDIILVtWfala0Negoef65MzT+IO+IJymkVJTJQDQFYoxLd9wUD5N0VMcpw4uqzXfJLyN6z+jYZ4wo8QX7V6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025714; c=relaxed/simple;
	bh=Fdqa0PjYdtVnfAI5wCT47AbM+43V0Zhp8c5YXihcbig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G7ISfSaObuRAqee7tQ5QvitaAaFFU8dHfaLCLQj9uKfj1oKHG6db+WtuCwj/WrSPRgJuI6ZYNIx+8qKcAkX24zpJiyHGj7aVWDpBsBQSCg+7f/zYxnlwq5T9oxDM0J/zatlOOyUX7WeKxAFH7wc0jXykLTwBuzVanDOkHbn6dgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t0erxvmY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t0erxvmY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF49DC4CEF0;
	Tue, 12 Aug 2025 19:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025714;
	bh=Fdqa0PjYdtVnfAI5wCT47AbM+43V0Zhp8c5YXihcbig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t0erxvmYPHISWm8gVEQoZmb8+CBRyDjNdKanGzZlmkg44LuWlcz5DfUwrfl0dYlHk
	 d6J8osWrSKgcuSKkTkvdAKM2iPQeyTBJg5Ork+fkzTUhOdyff/WBCPihH3k6IIK+Za
	 SgpAlhXSj+fIY9ZfQxhwavo3UN8f+StTX9aPr1cU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 123/480] iwlwifi: Add missing check for alloc_ordered_workqueue
Date: Tue, 12 Aug 2025 19:45:31 +0200
Message-ID: <20250812174402.600292187@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index a7f9e244c097..cd20958fb91a 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
@@ -1048,9 +1048,11 @@ static void iwl_bg_restart(struct work_struct *data)
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
@@ -1067,6 +1069,8 @@ static void iwl_setup_deferred_work(struct iwl_priv *priv)
 	timer_setup(&priv->statistics_periodic, iwl_bg_statistics_periodic, 0);
 
 	timer_setup(&priv->ucode_trace, iwl_bg_ucode_trace, 0);
+
+	return 0;
 }
 
 void iwl_cancel_deferred_work(struct iwl_priv *priv)
@@ -1464,7 +1468,9 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	/********************
 	 * 6. Setup services
 	 ********************/
-	iwl_setup_deferred_work(priv);
+	if (iwl_setup_deferred_work(priv))
+		goto out_uninit_drv;
+
 	iwl_setup_rx_handlers(priv);
 
 	iwl_power_initialize(priv);
@@ -1503,6 +1509,7 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	iwl_cancel_deferred_work(priv);
 	destroy_workqueue(priv->workqueue);
 	priv->workqueue = NULL;
+out_uninit_drv:
 	iwl_uninit_drv(priv);
 out_free_eeprom_blob:
 	kfree(priv->eeprom_blob);
-- 
2.39.5



