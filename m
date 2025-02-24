Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40014254863;
	Mon, 24 Feb 2025 14:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408342; cv=none; b=IB78Lxsyq1zkL+kXOLEkNzsNdDRm85B5+UL19kcv/fiopmJYRHlmaatE9Wr7kWCO+qQzcKAT2/HkP5aZ/n/uXuDmKGrvoLjUY+Jn5mqNKvVPWQhrwBpoIy+4jjtmp4jw/PaXEmIDQreNBBjdOs+hH33PglnY5xIjvPxVv1KaHac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408342; c=relaxed/simple;
	bh=TAYpFPzzjML0TRN2bysKfN4mDHrdKcOtFOhT1L+dgTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aqRYK1U7fdnMReNrV5zcUTwav54qCKNEUelAf1rnf+8hbQqqxldn77d9fVc9EKAQjG1RY+AAj0HjRym+y6NQHakweuzOAR22NE6O2D4u62Iwno0YsmgwsryALS9crmZBMG2AKvhtQrvUzXJmg11EpGWof1RiT12CxxbIemZ8T9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CQ186IJR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CQ186IJR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53BE5C4CED6;
	Mon, 24 Feb 2025 14:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408341;
	bh=TAYpFPzzjML0TRN2bysKfN4mDHrdKcOtFOhT1L+dgTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CQ186IJRjpfRtHgZCfgw+bHhrJnsiZqNn5US1cGU7tEGMcBJbQ8ZOg30doDE+lTDe
	 B3ma26uxir6uEFgiqpp7E4yHIiWsciWjenQZw+qfyUInYgTNp2bLy49dq+NN81ym0w
	 MPjJT/GQneme/vhn1dcj5iZW9YepwF5A3Sua9ORM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Philipp Stanner <pstanner@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 030/154] PCI: Restore original INTX_DISABLE bit by pcim_intx()
Date: Mon, 24 Feb 2025 15:33:49 +0100
Message-ID: <20250224142608.265870886@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit d555ed45a5a10a813528c7685f432369d536ae3d ]

pcim_intx() tries to restore the INTx bit at removal via devres, but there
is a chance that it restores a wrong value.

Because the value to be restored is blindly assumed to be the negative of
the enable argument, when a driver calls pcim_intx() unnecessarily for the
already enabled state, it'll restore to the disabled state in turn.  That
is, the function assumes the case like:

  // INTx == 1
  pcim_intx(pdev, 0); // old INTx value assumed to be 1 -> correct

but it might be like the following, too:

  // INTx == 0
  pcim_intx(pdev, 0); // old INTx value assumed to be 1 -> wrong

Also, when a driver calls pcim_intx() multiple times with different enable
argument values, the last one will win no matter what value it is.  This
can lead to inconsistency, e.g.

  // INTx == 1
  pcim_intx(pdev, 0); // OK
  ...
  pcim_intx(pdev, 1); // now old INTx wrongly assumed to be 0

This patch addresses those inconsistencies by saving the original INTx
state at the first pcim_intx() call.  For that, get_or_create_intx_devres()
is folded into pcim_intx() caller side; it allows us to simply check the
already allocated devres and record the original INTx along with the
devres_alloc() call.

Link: https://lore.kernel.org/r/20241031134300.10296-1-tiwai@suse.de
Fixes: 25216afc9db5 ("PCI: Add managed pcim_intx()")
Link: https://lore.kernel.org/87v7xk2ps5.wl-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Philipp Stanner <pstanner@redhat.com>
Cc: stable@vger.kernel.org	# v6.11+
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/devres.c | 34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/drivers/pci/devres.c b/drivers/pci/devres.c
index 70f1a46d07c5e..643f85849ef64 100644
--- a/drivers/pci/devres.c
+++ b/drivers/pci/devres.c
@@ -419,19 +419,12 @@ static void pcim_intx_restore(struct device *dev, void *data)
 	pci_intx(pdev, res->orig_intx);
 }
 
-static struct pcim_intx_devres *get_or_create_intx_devres(struct device *dev)
+static void save_orig_intx(struct pci_dev *pdev, struct pcim_intx_devres *res)
 {
-	struct pcim_intx_devres *res;
-
-	res = devres_find(dev, pcim_intx_restore, NULL, NULL);
-	if (res)
-		return res;
+	u16 pci_command;
 
-	res = devres_alloc(pcim_intx_restore, sizeof(*res), GFP_KERNEL);
-	if (res)
-		devres_add(dev, res);
-
-	return res;
+	pci_read_config_word(pdev, PCI_COMMAND, &pci_command);
+	res->orig_intx = !(pci_command & PCI_COMMAND_INTX_DISABLE);
 }
 
 /**
@@ -447,12 +440,23 @@ static struct pcim_intx_devres *get_or_create_intx_devres(struct device *dev)
 int pcim_intx(struct pci_dev *pdev, int enable)
 {
 	struct pcim_intx_devres *res;
+	struct device *dev = &pdev->dev;
 
-	res = get_or_create_intx_devres(&pdev->dev);
-	if (!res)
-		return -ENOMEM;
+	/*
+	 * pcim_intx() must only restore the INTx value that existed before the
+	 * driver was loaded, i.e., before it called pcim_intx() for the
+	 * first time.
+	 */
+	res = devres_find(dev, pcim_intx_restore, NULL, NULL);
+	if (!res) {
+		res = devres_alloc(pcim_intx_restore, sizeof(*res), GFP_KERNEL);
+		if (!res)
+			return -ENOMEM;
+
+		save_orig_intx(pdev, res);
+		devres_add(dev, res);
+	}
 
-	res->orig_intx = !enable;
 	pci_intx(pdev, enable);
 
 	return 0;
-- 
2.39.5



