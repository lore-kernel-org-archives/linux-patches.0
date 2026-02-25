Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC4F42494FE;
	Wed, 25 Feb 2026 01:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983542; cv=none; b=CmvF24uveeS+UDN3Wnp0p5fjdZWPWPwiSuZw9iCJ5vqWNjZnVAbUgwOIbOs8xqtZYhpjtX7VZ0UHDP3yYCX+i/98E76pMHlw3V8FicrrkHCLespok9N7iPGGuX+BabT0181NA4FX4evZ+nj06dMKEahMN+aftlRGahmx+M0pCq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983542; c=relaxed/simple;
	bh=MmaYPBUB9PlmD07+JreWXgFg/STmUXNg5WiqW8O4mg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kPIU2lXPQsjrb98nR3dO5vU0D31poThT3ZnM0b01i5VrgIBijPHOhGhcml+05N5HobhDsSl5++HxfdZLaBZamF1S6QMbkcFseRFHnRzxbHudFK4ulHuMJqSWE3d6exllQplHRYPXWEI+dDqjArMIfGlZJ+rHplEnfAnLwRAuYRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EEUu5Eb2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EEUu5Eb2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 981ECC116D0;
	Wed, 25 Feb 2026 01:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983542;
	bh=MmaYPBUB9PlmD07+JreWXgFg/STmUXNg5WiqW8O4mg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EEUu5Eb2sNkI93OxFs2bi4VTEoQsOo1ffeK2PdABpyvqlIwL+wr6elXnf62hG4ubR
	 hC4weuyekMopXQwPYtSjvVzXUdbo/Hm8AVZhPO2CJr0iKzgE/ARO4BK5n0YJtbTftK
	 VdQ7Z8K1hHQHG8td3iAOIQF+fSjgYJs44PlLlkow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <dg573847474@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 646/781] fbnic: close fw_log race between users and teardown
Date: Tue, 24 Feb 2026 17:22:35 -0800
Message-ID: <20260225012415.640718587@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index 9240673c7533d..e92187bc1c0fa 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_pci.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_pci.c
@@ -307,11 +307,17 @@ static int fbnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
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
@@ -319,11 +325,7 @@ static int fbnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
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
@@ -370,6 +372,8 @@ static int fbnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	  * firmware updates for fixes.
 	  */
 	return 0;
+free_fw_log:
+	fbnic_fw_log_free(fbd);
 free_irqs:
 	fbnic_free_irqs(fbd);
 err_destroy_health:
@@ -404,8 +408,9 @@ static void fbnic_remove(struct pci_dev *pdev)
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



