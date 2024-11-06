Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 829661E048F;
	Wed,  6 Nov 2024 12:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896836; cv=none; b=NHfWDdfgT272sPipzc6SLPwi2HDLFVWygl65TUZdUy2upVJ+6Q0/PO+eYAGXZ+AL5D3h0v2BkfRagUIxquYQ8NfzP4FoQcwelr6ft/NYgyjiGETmatZXPnzu+ZFobY8G/SNjhLXMnjenlUlCORFmLKT2SI83rlKXAOxE9jsIz10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896836; c=relaxed/simple;
	bh=hL/e20zQFdBu7F6otNOc3roN66k/6SHwggsa4lftdEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YbW6Xj8UK8h4YjE598SPO74Vwo0KfydJQn0SulAH7FP1p4Kc1ZQSzdsQEjsb1RUEF5NJA8C+0JVCpqcO0vleSz1ZmVoPMMNg8COsqIwOekT0TPw8iU4E++J7CrukhdtygAah/PMJiW6qG8NBCDDyHDVh/ACYxmpEnXliC7N6mu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZAVHBTbP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZAVHBTbP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C262CC4CECD;
	Wed,  6 Nov 2024 12:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896836;
	bh=hL/e20zQFdBu7F6otNOc3roN66k/6SHwggsa4lftdEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZAVHBTbPAmxh1XJPjs5lejEqmFxLmMvr+vCy3/0YMFrvSH3OC8S3JVDl2jK37hHvz
	 4YKsuc9lA8BAfp2Kmbm7VvL7h2dVkHuWTG4TBx8wOO/EBtDpTlyiem+0ijjMNdNdBr
	 QceGzf4sNGkZmNtX6QAHbNOu+FCYXPFaz/5m8u+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 5.10 088/110] xhci: Use pm_runtime_get to prevent RPM on unsupported systems
Date: Wed,  6 Nov 2024 13:04:54 +0100
Message-ID: <20241106120305.619701004@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120303.135636370@linuxfoundation.org>
References: <20241106120303.135636370@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Basavaraj Natikar <Basavaraj.Natikar@amd.com>

commit 31004740e42846a6f0bb255e6348281df3eb8032 upstream.

Use pm_runtime_put in the remove function and pm_runtime_get to disable
RPM on platforms that don't support runtime D3, as re-enabling it through
sysfs auto power control may cause the controller to malfunction. This
can lead to issues such as hotplug devices not being detected due to
failed interrupt generation.

Fixes: a5d6264b638e ("xhci: Enable RPM on controllers that support low-power states")
Cc: stable <stable@kernel.org>
Signed-off-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20241024133718.723846-1-Basavaraj.Natikar@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-pci.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -516,7 +516,7 @@ static int xhci_pci_probe(struct pci_dev
 	pm_runtime_put_noidle(&dev->dev);
 
 	if (pci_choose_state(dev, PMSG_SUSPEND) == PCI_D0)
-		pm_runtime_forbid(&dev->dev);
+		pm_runtime_get(&dev->dev);
 	else if (xhci->quirks & XHCI_DEFAULT_PM_RUNTIME_ALLOW)
 		pm_runtime_allow(&dev->dev);
 
@@ -543,7 +543,9 @@ static void xhci_pci_remove(struct pci_d
 
 	xhci->xhc_state |= XHCI_STATE_REMOVING;
 
-	if (xhci->quirks & XHCI_DEFAULT_PM_RUNTIME_ALLOW)
+	if (pci_choose_state(dev, PMSG_SUSPEND) == PCI_D0)
+		pm_runtime_put(&dev->dev);
+	else if (xhci->quirks & XHCI_DEFAULT_PM_RUNTIME_ALLOW)
 		pm_runtime_forbid(&dev->dev);
 
 	if (xhci->shared_hcd) {


