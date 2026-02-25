Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26C02FF176;
	Wed, 25 Feb 2026 06:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002717; cv=none; b=NAT4eF/aSwyVD1glmkzYb8rARiTDxKcSbgDFd7Q4qPNQYbv1BIXMeN+bGPaJ9gfHDiwG7wh5wrDicytYW+jOzsAZfLbE6XskHB6nG1RFuqQ/udr33+2fxpHs4Ganrcep2mIqq9g2DeZ0CkkNXSKy036sH5Av3teuMPdNZYz/okc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002717; c=relaxed/simple;
	bh=CQQTRJOU3QjeNAypWFybPr78CimSC8hrQPJ74BxHPrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HdZ3plUHoB8XeM+T8f1f5MTFOgXJeQknaLU6nKjaFlY9yYTPMLJuHUTa1dcMD+jGWK0UB3h5WDU/Xx7oZjum8dqN1puYLo8uXpxmFIobsTXq3JLIRA31WytefVhKjdrg1VyfGa7oWox3HByPhoVfNvPoUtLHg3k4v6799dsy0Qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QhmLpYR4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QhmLpYR4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C0A1C116D0;
	Wed, 25 Feb 2026 06:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002717;
	bh=CQQTRJOU3QjeNAypWFybPr78CimSC8hrQPJ74BxHPrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QhmLpYR4Qb+h1JwgJDXJKXuNWynxPI+Agc/NCAF1pS6xYpLMk3ISbItPBxOQ243bB
	 QdcorYacmX9FVnQB9CuaIB+RjH2faRxrKtvC+y5iy15LS1T+O5bmE0QyjKl1WjELza
	 PXWCncgUJrVd6biII3IC9Px+3qDePBNjutVoj7Gs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <dg573847474@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 526/641] fbnic: close fw_log race between users and teardown
Date: Tue, 24 Feb 2026 17:24:12 -0800
Message-ID: <20260225012401.274752252@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengfeng Ye <dg573847474@gmail.com>

[ Upstream commit ee5492fd88cfc079c19fbeac78e9e53b7f6c04f3 ]

Fixes a theoretical race on fw_log between the teardown path and fw_log
write functions.

fw_log is written inside fbnic_fw_log_write() and can be reached from
the mailbox handler fbnic_fw_msix_intr(), but fw_log is freed before
IRQ/MBX teardown during cleanup, resulting in a potential data race of
dereferencing a freed/null variable.

Possible Interleaving Scenario:
  CPU0: fbnic_fw_msix_intr() // Entry
          fbnic_fw_log_write()
            if (fbnic_fw_log_ready())   // true
            ... preempt ...
  CPU1: fbnic_remove() // Entry
          fbnic_fw_log_free()
            vfree(log->data_start);
            log->data_start = NULL;
  CPU0: continues, walks log->entries or writes to log->data_start

The initialization also has an incorrect order problem, as the fw_log
is currently allocated after MBX setup during initialization.
Fix the problems by adjusting the synchronization order to put
initialization in place before the mailbox is enabled, and not cleared
until after the mailbox has been disabled.

Fixes: ecc53b1b46c89 ("eth: fbnic: Enable firmware logging")
Signed-off-by: Chengfeng Ye <dg573847474@gmail.com>
Link: https://patch.msgid.link/20260211191329.530886-1-dg573847474@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/meta/fbnic/fbnic_fw_log.c    |  3 ---
 drivers/net/ethernet/meta/fbnic/fbnic_pci.c   | 19 ++++++++++++-------
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_fw_log.c b/drivers/net/ethernet/meta/fbnic/fbnic_fw_log.c
index 85a883dba385f..d8a9a7d7c2375 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_fw_log.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_fw_log.c
@@ -51,8 +51,6 @@ int fbnic_fw_log_init(struct fbnic_dev *fbd)
 	log->data_start = data;
 	log->data_end = data + FBNIC_FW_LOG_SIZE;
 
-	fbnic_fw_log_enable(fbd, true);
-
 	return 0;
 }
 
@@ -63,7 +61,6 @@ void fbnic_fw_log_free(struct fbnic_dev *fbd)
 	if (!fbnic_fw_log_ready(fbd))
 		return;
 
-	fbnic_fw_log_disable(fbd);
 	INIT_LIST_HEAD(&log->entries);
 	log->size = 0;
 	vfree(log->data_start);
diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_pci.c b/drivers/net/ethernet/meta/fbnic/fbnic_pci.c
index 0fa90baad5f88..698b8a85afb31 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_pci.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_pci.c
@@ -303,11 +303,17 @@ static int fbnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto free_irqs;
 	}
 
+	err = fbnic_fw_log_init(fbd);
+	if (err)
+		dev_warn(fbd->dev,
+			 "Unable to initialize firmware log buffer: %d\n",
+			 err);
+
 	err = fbnic_fw_request_mbx(fbd);
 	if (err) {
 		dev_err(&pdev->dev,
 			"Firmware mailbox initialization failure\n");
-		goto free_irqs;
+		goto free_fw_log;
 	}
 
 	/* Send the request to enable the FW logging to host. Note if this
@@ -315,11 +321,7 @@ static int fbnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 * possible the FW is just too old to support the logging and needs
 	 * to be updated.
 	 */
-	err = fbnic_fw_log_init(fbd);
-	if (err)
-		dev_warn(fbd->dev,
-			 "Unable to initialize firmware log buffer: %d\n",
-			 err);
+	fbnic_fw_log_enable(fbd, true);
 
 	fbnic_devlink_register(fbd);
 	fbnic_devlink_otp_check(fbd, "error detected during probe");
@@ -363,6 +365,8 @@ static int fbnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	  * firmware updates for fixes.
 	  */
 	return 0;
+free_fw_log:
+	fbnic_fw_log_free(fbd);
 free_irqs:
 	fbnic_free_irqs(fbd);
 err_destroy_health:
@@ -397,8 +401,9 @@ static void fbnic_remove(struct pci_dev *pdev)
 	fbnic_hwmon_unregister(fbd);
 	fbnic_dbg_fbd_exit(fbd);
 	fbnic_devlink_unregister(fbd);
-	fbnic_fw_log_free(fbd);
+	fbnic_fw_log_disable(fbd);
 	fbnic_fw_free_mbx(fbd);
+	fbnic_fw_log_free(fbd);
 	fbnic_free_irqs(fbd);
 
 	fbnic_devlink_health_destroy(fbd);
-- 
2.51.0



