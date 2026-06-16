Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F603C65F2;
	Tue, 16 Jun 2026 17:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632419; cv=none; b=p4I9PiAGIABygFFv5LWy1NoS1LEeKOVQ9FOtWpx4tG/9gQJ8XsV4Qsg4XOChsBG15DK6FYB00SUxauWVZG0cWdAlvPfwCs4HQxSasUY8L/XS5YhR4Vms8scrwHZL82Pijft8t31FctPVU1i7TaVGRQTPXyK7wfkIy2UZbq6E2cU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632419; c=relaxed/simple;
	bh=jLVOvIugr57a7bIwWpZWQHqXnpwxwJQiJ24vue/S//4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HaUFGISYAzogR4HgXiYLF3bEdpAV27MKvYIKXPUvhufcc7F+N5yZLdJy69wCN6HwOcco/Jv5n0gf5kWW0xigGsncNTadyOadxzVhaII0/78MpLB7lJSxk7Z07mdww07HjcZJ+IXikyfXSUB0/HURCRviudEH8/7Kza2fTv5jhnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Msifq+lZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Msifq+lZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68DCD1F000E9;
	Tue, 16 Jun 2026 17:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632418;
	bh=7E2Fa3zHQler70GAzbcK/7bPxrk26kKKWFpir8V6SGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Msifq+lZU8z8y2eB6WnFh7/Bu0VGwuh6x9XuF4P8OvKrCtiHRjGwim8ns/zoAZBq3
	 +S4LEDu3WJSLt9J5LwbWseaRQiO97jBY5qyKdpS/rrYCpFFO6xjbLmtppWuZuQvzM3
	 WrRZDp6TWxPpuspx4/ITOUKDap5Tdp2DgmJPZeG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Pritam Manohar Sutar <pritam.sutar@samsung.com>,
	Selvarasu Ganesan <selvarasu.g@samsung.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 374/522] usb: dwc3: Move GUID programming after PHY initialization
Date: Tue, 16 Jun 2026 20:28:41 +0530
Message-ID: <20260616145143.276353122@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Selvarasu Ganesan <selvarasu.g@samsung.com>

[ Upstream commit aad35f9c926ec220b0742af1ada45666ae667956 ]

The Linux Version Code is currently written to the GUID register before
PHY initialization. Certain PHY implementations (such as Synopsys eUSB
PHY performing link_sw_reset) clear the GUID register to its default
value during initialization, causing the kernel version information to
be lost.

Move the GUID register programming to occur after PHY initialization
completes to ensure the Linux version information persists.

Fixes: fa0ea13e9f1c ("usb: dwc3: core: write LINUX_VERSION_CODE to our GUID register")
Cc: stable <stable@kernel.org>
Reported-by: Pritam Manohar Sutar <pritam.sutar@samsung.com>
Signed-off-by: Selvarasu Ganesan <selvarasu.g@samsung.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://patch.msgid.link/20260417063314.2359-1-selvarasu.g@samsung.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ adapted dwc3_writel(dwc, ...) to dwc3_writel(dwc->regs, ...) ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/core.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -1239,12 +1239,6 @@ static int dwc3_core_init(struct dwc3 *d
 
 	hw_mode = DWC3_GHWPARAMS0_MODE(dwc->hwparams.hwparams0);
 
-	/*
-	 * Write Linux Version Code to our GUID register so it's easy to figure
-	 * out which kernel version a bug was found.
-	 */
-	dwc3_writel(dwc->regs, DWC3_GUID, LINUX_VERSION_CODE);
-
 	ret = dwc3_phy_setup(dwc);
 	if (ret)
 		goto err0;
@@ -1284,6 +1278,12 @@ static int dwc3_core_init(struct dwc3 *d
 	if (ret)
 		goto err1;
 
+	/*
+	 * Write Linux Version Code to our GUID register so it's easy to figure
+	 * out which kernel version a bug was found.
+	 */
+	dwc3_writel(dwc->regs, DWC3_GUID, LINUX_VERSION_CODE);
+
 	dwc3_core_setup_global_control(dwc);
 	dwc3_core_num_eps(dwc);
 


