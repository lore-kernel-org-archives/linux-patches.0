Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C742BD2EF
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:38:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30600C433EF;
	Mon, 15 May 2023 16:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684168694;
	bh=sypC027um3qpwnK/xf8twdB7zMhShxVJ1WGqkiTBpIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BeI4WTA/L1F8dMzmPvcVRVc2+dO20Jlcyyy81o+zpoMWqLUzBsuZH5zORSExOEsgz
	 3Aq6kCN5Z6bnPM56tg9M+OjnVuGPj5qf2Hslz8TQ9h2z74ITgkSPZAJvvbE4kRhcoR
	 P90MylIbb1On6meUsyKUOKkkqk6yR2m7O9YRSOoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>
Subject: [PATCH 4.19 012/191] xhci: fix debugfs register accesses while suspended
Date: Mon, 15 May 2023 18:24:09 +0200
Message-Id: <20230515161707.662761001@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161707.203549282@linuxfoundation.org>
References: <20230515161707.203549282@linuxfoundation.org>
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
@@ -132,6 +132,7 @@ static void xhci_debugfs_regset(struct x
 	regset->regs = regs;
 	regset->nregs = nregs;
 	regset->base = hcd->regs + base;
+	regset->dev = hcd->self.controller;
 
 	debugfs_create_regset32((const char *)rgs->name, 0444, parent, regset);
 }


