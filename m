Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9223ACEF4;
	Thu, 17 Sep 2026 18:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671385; cv=none; b=QYMrNcklrZDMHu2avoq+3RP0u0LTL2S54HZc8dTFXucKF9R/JXI46815cKW0yHnw5yPYkizyFVK8ZJxwJIjodR5mZ+vSOZBOOl0uCnB9WUtIlo1QFXPHcDYEjoKEdUiE/yHo0Sy504/F+UvIMOIe+AN45hYAChsabVpyogY+0k0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671385; c=relaxed/simple;
	bh=Nw4aME9douo2a/7hsRIGGc8KfszIAuwYfbzEB9KSGks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JS/wM28EGG1OtPAWV0VRzeuuT1TURWNEaFhLxAbDaJe4CbBrEkARo8wVYv0m01vZLJAxt1/RPXWMdsRQab21TuguFMYpQv7MDXe1RjLwW1Eoez49i2aZQNxBjVdO6EIkKOOkEyG9OLpOWtJTAXYflUT20FjxRQcVxp9gMAaIvpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tUGyJSN1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tUGyJSN1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEBB61F000FF;
	Thu, 17 Sep 2026 18:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671384;
	bh=tQgXATRODlsNci1w6YOhhV7rCd2Kp1Ff4wICxrCjEr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tUGyJSN1jmm8tyM4kT2m/YRhVciTr0sCazgxMGBxVUyNxYrybaSFarPLccXgFOjyC
	 R+GVKCT4kU2CfO6WNt8RJ8GK5vqb+WZXGDNiLNwd3Py+fNn8MPgrjJYoOFXmbVy5Hq
	 4Dt4rfI0F2NbSJMh7ujZP0LngiY+e3xxH/u1W4XA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Neronin <niklas.neronin@linux.intel.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0957/1102] usb: xhci: use cached HCSPARAMS1 value
Date: Thu, 17 Sep 2026 16:15:00 +0100
Message-ID: <20260917151604.687159441@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Neronin <niklas.neronin@linux.intel.com>

[ Upstream commit 70651cc3f5a4c7cec529f121e36ea3b45ea84778 ]

The Structural Parameters 1 (HCSPARAMS1) register is read and cached in
'xhci->hcs_params1' during host controller initialization. Since this
register is read-only and its value remains constant for the lifetime of
the controller, re-reading it later is unnecessary.

Replace subsequent register reads with the cached 'xhci->hcs_params1'
value to avoid redundant MMIO access.

Signed-off-by: Niklas Neronin <niklas.neronin@linux.intel.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://patch.msgid.link/20251119142417.2820519-15-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 78203d5b54a4 ("usb: xhci: bail out of setup if the controller is inaccessible")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -4044,8 +4044,7 @@ int xhci_alloc_dev(struct usb_hcd *hcd,
 		xhci_err(xhci, "Error while assigning device slot ID: %s\n",
 			 xhci_trb_comp_code_string(command->status));
 		xhci_err(xhci, "Max number of devices this xHCI host supports is %u.\n",
-				HCS_MAX_SLOTS(
-					readl(&xhci->cap_regs->hcs_params1)));
+			 HCS_MAX_SLOTS(xhci->hcs_params1));
 		xhci_free_command(xhci, command);
 		return 0;
 	}


