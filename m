Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 528EE125B3
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:20:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B15BBC433D2;
	Mon,  8 May 2023 10:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683541233;
	bh=ka65zs60x+QSe9eH/Rob1ZLl2kjLhdUvHSAhUNgccDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e9/TL/5cvzSkcc2raJeaA332Mjd1qvvenJmryM00Mom6Zl7x6BJgzVjwvyZiah1W1
	 14MVvTmmr6FP2KCrLMtX0gAHBsHCO5PvDn2Ez5ycLg/oewHrt7CLjZvDJAH5e+LcH8
	 82CyspOs0sgS6L8ZQApWtTY0vRERZINGyOjkggyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>
Subject: [PATCH 6.2 049/663] xhci: fix debugfs register accesses while suspended
Date: Mon,  8 May 2023 11:37:55 +0200
Message-Id: <20230508094430.071277981@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johan Hovold <johan+linaro@kernel.org>

commit 735baf1b23458f71a8b15cb924af22c9ff9cd125 upstream.

Wire up the debugfs regset device pointer so that the controller is
resumed before accessing registers to avoid crashing or locking up if it
happens to be runtime suspended.

Fixes: 02b6fdc2a153 ("usb: xhci: Add debugfs interface for xHCI driver")
Cc: stable@vger.kernel.org # 4.15: 30332eeefec8: debugfs: regset32: Add Runtime PM support
Cc: stable@vger.kernel.org # 4.15
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20230405090342.7363-1-johan+linaro@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-debugfs.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/host/xhci-debugfs.c
+++ b/drivers/usb/host/xhci-debugfs.c
@@ -133,6 +133,7 @@ static void xhci_debugfs_regset(struct x
 	regset->regs = regs;
 	regset->nregs = nregs;
 	regset->base = hcd->regs + base;
+	regset->dev = hcd->self.controller;
 
 	debugfs_create_regset32((const char *)rgs->name, 0444, parent, regset);
 }


