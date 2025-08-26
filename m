Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E102E2AD04;
	Tue, 26 Aug 2025 13:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215234; cv=none; b=D39NXb/znqc/XUuzhUFX4xP9uh8m5OyugssCIaT/O2hqvEdli8IUpZhV5V2VpvQDOJweMTdop0PPVRfq4EIOy5fwph0EU6DvHLRHz0aujeSBB6VthO2mRqCHIqLhhlR2Pg4YfviWMsfsSvToMq+UGqTXA9ALGfEY4jlPSQL8+NM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215234; c=relaxed/simple;
	bh=c6UuT36KxkfWi4OInFIi9DjBvn5I0w0K3hdV/mawW6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QBnciwWU54NxudDmWy+iI6woRKwaunk5BbwAuUloX/A5CfjIL25DGQSAKwatUx999khgdwrVKBCSiC6B4UafBAISlV4C5eupxdlz7PfJowU4tViWrP94HPD4rngjrlf3csCPSV27COBBS3QQO3rr6/wrTtIPlucBwZZC/UrBhV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gBkLHbZs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gBkLHbZs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FAFFC16AAE;
	Tue, 26 Aug 2025 13:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215233;
	bh=c6UuT36KxkfWi4OInFIi9DjBvn5I0w0K3hdV/mawW6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gBkLHbZsdcSgnE+WZd/kmAfoIKxOW3RFw7+S4/n62pnXj4GsIymaoRfCCJ8BXD8ug
	 lcsWkMD+PD7W8WR23rC7YLRl7pW3plr857TFLR7ZPLQdWoP7reEjlvtBhtjrizM382
	 YtXwhR3hheeER5X8eyF0qeqHM5zd52hDp4/qYcgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Helgaas <bhelgaas@google.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 437/482] mmc: sdhci-pci-gli: Use PCI AER definitions, not hard-coded values
Date: Tue, 26 Aug 2025 13:11:30 +0200
Message-ID: <20250826110941.626731396@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Helgaas <bhelgaas@google.com>

[ Upstream commit 951b7ccc54591ba48755b5e0c7fc8b9623a64640 ]

015c9cbcf0ad ("mmc: sdhci-pci-gli: GL9750: Mask the replay timer timeout of
AER") added PCI_GLI_9750_CORRERR_MASK, the offset of the AER Capability in
config space, and PCI_GLI_9750_CORRERR_MASK_REPLAY_TIMER_TIMEOUT, the
Replay Timer Timeout bit in the AER Correctable Error Status register.

Use pci_find_ext_capability() to locate the AER Capability and use the
existing PCI_ERR_COR_REP_TIMER definition to mask the bit.

This removes a little bit of unnecessarily device-specific code and makes
AER-related things more greppable.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://lore.kernel.org/r/20240327214831.1544595-2-helgaas@kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-pci-gli.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

--- a/drivers/mmc/host/sdhci-pci-gli.c
+++ b/drivers/mmc/host/sdhci-pci-gli.c
@@ -27,8 +27,6 @@
 #define PCI_GLI_9750_PM_CTRL	0xFC
 #define   PCI_GLI_9750_PM_STATE	  GENMASK(1, 0)
 
-#define PCI_GLI_9750_CORRERR_MASK				0x214
-#define   PCI_GLI_9750_CORRERR_MASK_REPLAY_TIMER_TIMEOUT	  BIT(12)
 
 #define SDHCI_GLI_9750_CFG2          0x848
 #define   SDHCI_GLI_9750_CFG2_L1DLY    GENMASK(28, 24)
@@ -154,8 +152,6 @@
 #define PCI_GLI_9755_PM_CTRL     0xFC
 #define   PCI_GLI_9755_PM_STATE    GENMASK(1, 0)
 
-#define PCI_GLI_9755_CORRERR_MASK				0x214
-#define   PCI_GLI_9755_CORRERR_MASK_REPLAY_TIMER_TIMEOUT	  BIT(12)
 
 #define GLI_MAX_TUNING_LOOP 40
 
@@ -501,9 +497,7 @@ static void gl9750_hw_setting(struct sdh
 	pci_write_config_dword(pdev, PCI_GLI_9750_PM_CTRL, value);
 
 	/* mask the replay timer timeout of AER */
-	pci_read_config_dword(pdev, PCI_GLI_9750_CORRERR_MASK, &value);
-	value |= PCI_GLI_9750_CORRERR_MASK_REPLAY_TIMER_TIMEOUT;
-	pci_write_config_dword(pdev, PCI_GLI_9750_CORRERR_MASK, value);
+	sdhci_gli_mask_replay_timer_timeout(pdev);
 
 	gl9750_wt_off(host);
 }
@@ -715,9 +709,7 @@ static void gl9755_hw_setting(struct sdh
 	pci_write_config_dword(pdev, PCI_GLI_9755_PM_CTRL, value);
 
 	/* mask the replay timer timeout of AER */
-	pci_read_config_dword(pdev, PCI_GLI_9755_CORRERR_MASK, &value);
-	value |= PCI_GLI_9755_CORRERR_MASK_REPLAY_TIMER_TIMEOUT;
-	pci_write_config_dword(pdev, PCI_GLI_9755_CORRERR_MASK, value);
+	sdhci_gli_mask_replay_timer_timeout(pdev);
 
 	gl9755_wt_off(pdev);
 }


