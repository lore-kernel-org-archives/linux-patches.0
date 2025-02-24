Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5087E19E997;
	Mon, 24 Feb 2025 14:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408815; cv=none; b=tMFN11ilfWHa2euOGApjnKu+HuODWN5Qnx+y/bYuYSnCbAH1co+wuGvBq/zG5fDbQwCFcLOJM0MX8FQdaSuVgy86ypUXPVWQyEazuHTixlccRmoIUaEAqWHzESn2ndPDFo9yxt8irzYJMJ9HFIoTpJdZuznOTBY8upgYkBC4jDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408815; c=relaxed/simple;
	bh=d9/f2OGY++pfH/rgpfeTm+oPTTEwASKN8PWxf71bWao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n2HM0lpfQtgE9yaRJa0GwnCuxBsKNeF3mEFDm/t3RFynxmHHOOv/CNZ4bVJgQYKO1fznIqHcnd6hx+xSFz6RY2ecrop17+y9yJCppfS9Y/a+leH1yyWMwKYbPrqdRdRFH7iQ09vKNcrst2PVCLLm9NwSK2Bq9IAyINOD+Hnfu/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lS17JDxi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lS17JDxi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B51AAC4CED6;
	Mon, 24 Feb 2025 14:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408815;
	bh=d9/f2OGY++pfH/rgpfeTm+oPTTEwASKN8PWxf71bWao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lS17JDxiHGrLSNy/tItfHe0lvXU3SmhZiNnBV5ZAxbbAaef9B6ctrO9suf5xgsYQJ
	 rpGQskV6H+0qOuPf5Wt0F9SQe7xiChKeCoDjzR6WXElMeeGDkYGG2utocLUZdAhaMZ
	 JiieTf213HdiNqEix9zsaLXpbLMdYEASWQVmrUIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Philipp Stanner <pstanner@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 014/138] PCI: Restore original INTX_DISABLE bit by pcim_intx()
Date: Mon, 24 Feb 2025 15:34:04 +0100
Message-ID: <20250224142605.022716672@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index cc31951347210..1adebcb263bd0 100644
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



