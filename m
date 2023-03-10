Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12A5846C
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:31:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55B44C433D2;
	Fri, 10 Mar 2023 14:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678458661;
	bh=eFFEmjfEf1yKi9xwzzIyajdTeyu+WH9yOVfDCKLNtkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ch1ZavrR8n27YzgcG+a2uKtuZ530L04gAkvmLzhgGlGINX8eFAbQTkl0bXTY+EjuL
	 cUKhmpoSey00RzwJWAYlvkaqZW4imE56fGfKbIJFmh0bQ3xfVpmyQfEo5qhKxZaE1P
	 jHqcl/OGufUhFERapyaifgpabFIh0tinc4Xln0GA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>,
	Stanislaw Gruszka <stf_xl@wp.pl>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 085/357] wifi: iwl3945: Add missing check for create_singlethread_workqueue
Date: Fri, 10 Mar 2023 14:36:14 +0100
Message-Id: <20230310133737.740868536@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 1fdeb8b9f29dfd64805bb49475ac7566a3cb06cb ]

Add the check for the return value of the create_singlethread_workqueue
in order to avoid NULL pointer dereference.

Fixes: b481de9ca074 ("[IWLWIFI]: add iwlwifi wireless drivers")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230208063032.42763-2-jiasheng@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlegacy/3945-mac.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/3945-mac.c b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
index 206b43b9dff86..a1bd61d5e024d 100644
--- a/drivers/net/wireless/intel/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
@@ -3382,10 +3382,12 @@ static DEVICE_ATTR(dump_errors, 0200, NULL, il3945_dump_error_log);
  *
  *****************************************************************************/
 
-static void
+static int
 il3945_setup_deferred_work(struct il_priv *il)
 {
 	il->workqueue = create_singlethread_workqueue(DRV_NAME);
+	if (!il->workqueue)
+		return -ENOMEM;
 
 	init_waitqueue_head(&il->wait_command_queue);
 
@@ -3404,6 +3406,8 @@ il3945_setup_deferred_work(struct il_priv *il)
 	tasklet_init(&il->irq_tasklet,
 		     il3945_irq_tasklet,
 		     (unsigned long)il);
+
+	return 0;
 }
 
 static void
@@ -3725,7 +3729,10 @@ il3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	il_set_rxon_channel(il, &il->bands[NL80211_BAND_2GHZ].channels[5]);
-	il3945_setup_deferred_work(il);
+	err = il3945_setup_deferred_work(il);
+	if (err)
+		goto out_remove_sysfs;
+
 	il3945_setup_handlers(il);
 	il_power_initialize(il);
 
@@ -3737,7 +3744,7 @@ il3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	err = il3945_setup_mac(il);
 	if (err)
-		goto out_remove_sysfs;
+		goto out_destroy_workqueue;
 
 	il_dbgfs_register(il, DRV_NAME);
 
@@ -3746,9 +3753,10 @@ il3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	return 0;
 
-out_remove_sysfs:
+out_destroy_workqueue:
 	destroy_workqueue(il->workqueue);
 	il->workqueue = NULL;
+out_remove_sysfs:
 	sysfs_remove_group(&pdev->dev.kobj, &il3945_attribute_group);
 out_release_irq:
 	free_irq(il->pci_dev->irq, il);
-- 
2.39.2



