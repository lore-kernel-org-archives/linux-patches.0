Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA6E1C07EF;
	Tue, 15 Oct 2024 12:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728996820; cv=none; b=DLTu0jN+SFirYmMmmJgQ0k5X5W4r31zVIHAeuzKX9QcuqbXDLsNpJPDQkqdyaHSZak44RkikCOB8VIwWwLtCBmkXm9lpxDnVir5lZH6U6GlP9g6pbtlDTOyDHwhXZCZ06X9/wRa8VV9lppLIyk/Gli9uXMZLfHdxofbL35FBp3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728996820; c=relaxed/simple;
	bh=RclqezL13YuiNO2rCRsE/4AdxrOnllJ8qyV0S3rISRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FVPNjVJjUjA5vz0YqoSitQmjeRSfmQy4NsMHOMstWIRk5fKYhCDjrdVQ1/FmQR4MBadyJ0dB4DXWXV5H3th1Gt4hcW4U6dU3tYI9fsGpxOu3/ZHgX1kD3gEvuXaLbrNjWwKmHYVbCNJ65LT/K9Ecs3xnYntUx0Q7QS6k9QBx3i8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nEAlEADw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nEAlEADw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5508CC4CECE;
	Tue, 15 Oct 2024 12:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728996819;
	bh=RclqezL13YuiNO2rCRsE/4AdxrOnllJ8qyV0S3rISRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nEAlEADw8aVciMGbQmjaOmD/Ij/57vYnvwTT7CUFgDSAQ3ps5FBHLEjElnCKwhYgt
	 F2KmUvHmDgONDM5LKsN4gV4eaGGZ+ZnPEC8h5+3nDHafjjLkN+w85qZAtRl7JldIWw
	 Wg8DVYUYqhpL1WL7vz4Y66Qy5I8z9YF2vCFwpcZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jun Li <jun.li@nxp.com>,
	Felipe Balbi <balbi@kernel.org>,
	Jack Pham <jackp@codeaurora.org>,
	Sasha Levin <sashal@kernel.org>,
	Amit Pundir <amit.pundir@linaro.org>,
	John Stultz <john.stultz@linaro.org>
Subject: [PATCH 5.10 001/518] usb: dwc3: Decouple USB 2.0 L1 & L2 events
Date: Tue, 15 Oct 2024 14:38:25 +0200
Message-ID: <20241015123916.885180494@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

From: Jack Pham <jackp@codeaurora.org>

[ Upstream commit 843714bb37d9a3780160d7b4a4a72b8077a77589 ]

On DWC_usb3 revisions 3.00a and newer (including DWC_usb31 and
DWC_usb32) the GUCTL1 register gained the DEV_DECOUPLE_L1L2_EVT
field (bit 31) which when enabled allows the controller in device
mode to treat USB 2.0 L1 LPM & L2 events separately.

After commit d1d90dd27254 ("usb: dwc3: gadget: Enable suspend
events") the controller will now receive events (and therefore
interrupts) for every state change when entering/exiting either
L1 or L2 states.  Since L1 is handled entirely by the hardware
and requires no software intervention, there is no need to even
enable these events and unnecessarily notify the gadget driver.
Enable the aforementioned bit to help reduce the overall interrupt
count for these L1 events that don't need to be handled while
retaining the events for full L2 suspend/wakeup.

Tested-by: Jun Li <jun.li@nxp.com>
Tested-by: Amit Pundir <amit.pundir@linaro.org> # for RB5 (sm8250)
Tested-by: John Stultz <john.stultz@linaro.org> # for HiKey960 & db845c
Reviewed-by: Jun Li <jun.li@nxp.com>
Acked-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Jack Pham <jackp@codeaurora.org>
Link: https://lore.kernel.org/r/20210812082635.12924-1-jackp@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 9149c9b0c7e0 ("usb: dwc3: core: update LC timer as per USB Spec V3.2")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/core.c | 9 +++++++++
 drivers/usb/dwc3/core.h | 5 +++--
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index ee7682faa6f3..3a88e4268590 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -1064,6 +1064,15 @@ static int dwc3_core_init(struct dwc3 *dwc)
 		if (!DWC3_VER_IS_PRIOR(DWC3, 290A))
 			reg |= DWC3_GUCTL1_DEV_L1_EXIT_BY_HW;
 
+		/*
+		 * Decouple USB 2.0 L1 & L2 events which will allow for
+		 * gadget driver to only receive U3/L2 suspend & wakeup
+		 * events and prevent the more frequent L1 LPM transitions
+		 * from interrupting the driver.
+		 */
+		if (!DWC3_VER_IS_PRIOR(DWC3, 300A))
+			reg |= DWC3_GUCTL1_DEV_DECOUPLE_L1L2_EVT;
+
 		if (dwc->dis_tx_ipgap_linecheck_quirk)
 			reg |= DWC3_GUCTL1_TX_IPGAP_LINECHECK_DIS;
 
diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index 1c8496fc732e..620c19deeee7 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -250,9 +250,10 @@
 #define DWC3_GCTL_DSBLCLKGTNG		BIT(0)
 
 /* Global User Control 1 Register */
-#define DWC3_GUCTL1_PARKMODE_DISABLE_SS	BIT(17)
+#define DWC3_GUCTL1_DEV_DECOUPLE_L1L2_EVT	BIT(31)
 #define DWC3_GUCTL1_TX_IPGAP_LINECHECK_DIS	BIT(28)
-#define DWC3_GUCTL1_DEV_L1_EXIT_BY_HW	BIT(24)
+#define DWC3_GUCTL1_DEV_L1_EXIT_BY_HW		BIT(24)
+#define DWC3_GUCTL1_PARKMODE_DISABLE_SS		BIT(17)
 
 /* Global Status Register */
 #define DWC3_GSTS_OTG_IP	BIT(10)
-- 
2.43.0



