Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03BC01CC89D;
	Wed,  6 Nov 2024 12:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897115; cv=none; b=FEGFbYga5ONNYpEZgzsrcLa01CEebS8pV/qyQdQPhcsr6yJy3WfE9Ei4sUitU1bx0+R2zFzWfLMaj8hWPnVcngmrTcslz/AVu9UFRy18G2KmTMl30HkwgyzdOBal0VZr3l+2igtofG0uUJ9r3cT2vx0nQPpNCWTR/pCnow11e10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897115; c=relaxed/simple;
	bh=eceqGWV2LIvwXulq6g2m8Ob2gFMwCTinsFojGG7W7/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g8n7LkRFpETi2Iv2hpSpHsZUw17BA/IuxutN6idxKnik6tCVE2NXdk5cfvATxJw/CcAGNf4GfXBpellVnr1gLlJhVYG7qI5EFoZol90kgb8gjuFtxhBeI6HpiOMBeRxuipt0ZUCr4vaSCGXoni9wVu9L7u98AHS3t01BheVi7g4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DKu/4t8t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DKu/4t8t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D05FC4CECD;
	Wed,  6 Nov 2024 12:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897114;
	bh=eceqGWV2LIvwXulq6g2m8Ob2gFMwCTinsFojGG7W7/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DKu/4t8thJdiQ/d9QP8PY+s6h4lyG/b8/ngVXV6zo1P/UWPEDo87ut0pydvlP3FaR
	 s19bXB8n03isKnSBKi83dQtqUPCOnzPTXQwutbGEr7q+KQ6UsnCdBsuCbYQ9KPUP8C
	 x2lUau/n6ufeD5uwC17eMYvPqg4fY7EoAxokMT4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.1 070/126] xhci: Use pm_runtime_get to prevent RPM on unsupported systems
Date: Wed,  6 Nov 2024 13:04:31 +0100
Message-ID: <20241106120307.980947571@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -526,7 +526,7 @@ static int xhci_pci_probe(struct pci_dev
 	pm_runtime_put_noidle(&dev->dev);
 
 	if (pci_choose_state(dev, PMSG_SUSPEND) == PCI_D0)
-		pm_runtime_forbid(&dev->dev);
+		pm_runtime_get(&dev->dev);
 	else if (xhci->quirks & XHCI_DEFAULT_PM_RUNTIME_ALLOW)
 		pm_runtime_allow(&dev->dev);
 
@@ -553,7 +553,9 @@ static void xhci_pci_remove(struct pci_d
 
 	xhci->xhc_state |= XHCI_STATE_REMOVING;
 
-	if (xhci->quirks & XHCI_DEFAULT_PM_RUNTIME_ALLOW)
+	if (pci_choose_state(dev, PMSG_SUSPEND) == PCI_D0)
+		pm_runtime_put(&dev->dev);
+	else if (xhci->quirks & XHCI_DEFAULT_PM_RUNTIME_ALLOW)
 		pm_runtime_forbid(&dev->dev);
 
 	if (xhci->shared_hcd) {


