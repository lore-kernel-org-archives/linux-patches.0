Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 945A146444;
	Tue, 10 Sep 2024 10:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964606; cv=none; b=LGBj4u93OyvNRNirtd5I0318+ZoCyjNMFZmxHRaKT9Tr2PCakfieI5aa7F1HbgyM7kEgXoXLKY3ChBnFn/ymOEZaj/7mXXMkMPbjIRAfGQkoWIGeefiS9/KTslhdbVzm1qcpmBXLKFwqtQN4sYjLOfvqu2dbriMxVsozWR8b0aM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964606; c=relaxed/simple;
	bh=5RdPCRze4CaUIs7aKPY9ci1qrsRtgUPvjsdjxHCfebs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NTc/stbTLmx8z7xTc5jAxv8gAb1/A2NqfyzZO2mocYvJEx4hzdm6FsJoBsE1vhzlrHW3klcunMjHTjBzncoizdOdGRzzkoemh9NbNXDBKQ10MuBAFrW/H/iRCzPMhVTf95kegRvtXtTXbruX95EoNnCTkloKNVLXQZ1GsyJBX6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=piFDSyvT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="piFDSyvT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C87BC4CECF;
	Tue, 10 Sep 2024 10:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964606;
	bh=5RdPCRze4CaUIs7aKPY9ci1qrsRtgUPvjsdjxHCfebs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=piFDSyvTMX6kPTLgonr9ISBS6xy1uwR9MsO4APGD57bjNLxy8/rCjDhlcfdxrbTfC
	 qTJLzSmwKKkzoNOjZrP8TQG0w4UgM29SzOiElTKVyaC6YaBITr5SLv0YLdQGHPhX1U
	 hEQiY5bQgS9pss3zhanyQj09wNNOSAawFAvsomTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawel Laszczak <pawell@cadence.com>
Subject: [PATCH 6.6 212/269] usb: cdns2: Fix controller reset issue
Date: Tue, 10 Sep 2024 11:33:19 +0200
Message-ID: <20240910092615.570161730@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pawel Laszczak <pawell@cadence.com>

commit e2940928115e83d707b21bf00b0db7d6c15f8341 upstream.

Patch fixes the procedure of resetting controller.
The CPUCTRL register is write only and reading returns 0.
Waiting for reset to complite is incorrect.

Fixes: 3eb1f1efe204 ("usb: cdns2: Add main part of Cadence USBHS driver")
cc: stable@vger.kernel.org
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Link: https://lore.kernel.org/r/PH7PR07MB9538D56D75F1F399D0BB96F0DD922@PH7PR07MB9538.namprd07.prod.outlook.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/cdns2/cdns2-gadget.c |   12 +++---------
 drivers/usb/gadget/udc/cdns2/cdns2-gadget.h |    9 +++++++++
 2 files changed, 12 insertions(+), 9 deletions(-)

--- a/drivers/usb/gadget/udc/cdns2/cdns2-gadget.c
+++ b/drivers/usb/gadget/udc/cdns2/cdns2-gadget.c
@@ -2251,7 +2251,6 @@ static int cdns2_gadget_start(struct cdn
 {
 	u32 max_speed;
 	void *buf;
-	int val;
 	int ret;
 
 	pdev->usb_regs = pdev->regs;
@@ -2261,14 +2260,9 @@ static int cdns2_gadget_start(struct cdn
 	pdev->adma_regs = pdev->regs + CDNS2_ADMA_REGS_OFFSET;
 
 	/* Reset controller. */
-	set_reg_bit_8(&pdev->usb_regs->cpuctrl, CPUCTRL_SW_RST);
-
-	ret = readl_poll_timeout_atomic(&pdev->usb_regs->cpuctrl, val,
-					!(val & CPUCTRL_SW_RST), 1, 10000);
-	if (ret) {
-		dev_err(pdev->dev, "Error: reset controller timeout\n");
-		return -EINVAL;
-	}
+	writeb(CPUCTRL_SW_RST | CPUCTRL_UPCLK | CPUCTRL_WUEN,
+	       &pdev->usb_regs->cpuctrl);
+	usleep_range(5, 10);
 
 	usb_initialize_gadget(pdev->dev, &pdev->gadget, NULL);
 
--- a/drivers/usb/gadget/udc/cdns2/cdns2-gadget.h
+++ b/drivers/usb/gadget/udc/cdns2/cdns2-gadget.h
@@ -292,8 +292,17 @@ struct cdns2_usb_regs {
 #define SPEEDCTRL_HSDISABLE	BIT(7)
 
 /* CPUCTRL- bitmasks. */
+/* UP clock enable */
+#define CPUCTRL_UPCLK		BIT(0)
 /* Controller reset bit. */
 #define CPUCTRL_SW_RST		BIT(1)
+/**
+ * If the wuen bit is ‘1’, the upclken is automatically set to ‘1’ after
+ * detecting rising edge of wuintereq interrupt. If the wuen bit is ‘0’,
+ * the wuintereq interrupt is ignored.
+ */
+#define CPUCTRL_WUEN		BIT(7)
+
 
 /**
  * struct cdns2_adma_regs - ADMA controller registers.


