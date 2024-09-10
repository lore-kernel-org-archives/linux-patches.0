Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B29183CB0;
	Tue, 10 Sep 2024 10:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963201; cv=none; b=X/TnBNzYzAoDqK14L9u5TIThEu7woOxCi+2J8OHyczRcnHYeaMg/gPtVOWTNFlcdw+VyMBBDiP8Q7JcGNWNKpyNfR/xpTz0vuy8TQUqISSblONxNilqBkkD61DPyLLKm6KZKQwNk+toCq56OncupNqeWdwCBWJCGcv4L8FeMMqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963201; c=relaxed/simple;
	bh=UG7SfAHM2MVFUwyhGcdoGZfgg8YIVrWG16UNgpbHPnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=daXKwzK3BYO6d0Y4yKYV2VpQ/z+EEnePN5flrUqgFr/Q7LzVIKJyQfCCKxMrnX9o0RAXWe6vguLOQLY/1rPzHWbnaDUZk2sfJcXxOR7fK15oyQHsx/xRfkdd9bl3Wa5McWaVLJ6Yl1kXSK9eoHNiD/IIfsFf+oBy/qhXSE+WX1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QzKiQYaH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QzKiQYaH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90A36C4CEC3;
	Tue, 10 Sep 2024 10:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963201;
	bh=UG7SfAHM2MVFUwyhGcdoGZfgg8YIVrWG16UNgpbHPnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QzKiQYaHzooxaFh6XcBUL6xTvW3/CAZkC3BLKRMG74+ggqejeBzsvSBa0ieY1a02C
	 lVXmYegwTFBBZSGrp7jbxal0iQ2QjZTkxOa0cffVr0UkJ9DAY1t8rxAJEn3S1aLsO+
	 BWq+Vl5PXk6Yp627uyqTi3XttVjHE9kIswNruJgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Faisal Hassan <quic_faisalh@quicinc.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.1 142/192] usb: dwc3: core: update LC timer as per USB Spec V3.2
Date: Tue, 10 Sep 2024 11:32:46 +0200
Message-ID: <20240910092603.817195655@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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

From: Faisal Hassan <quic_faisalh@quicinc.com>

commit 9149c9b0c7e046273141e41eebd8a517416144ac upstream.

This fix addresses STAR 9001285599, which only affects DWC_usb3 version
3.20a. The timer value for PM_LC_TIMER in DWC_usb3 3.20a for the Link
ECN changes is incorrect. If the PM TIMER ECN is enabled via GUCTL2[19],
the link compliance test (TD7.21) may fail. If the ECN is not enabled
(GUCTL2[19] = 0), the controller will use the old timer value (5us),
which is still acceptable for the link compliance test. Therefore, clear
GUCTL2[19] to pass the USB link compliance test: TD 7.21.

Cc: stable@vger.kernel.org
Signed-off-by: Faisal Hassan <quic_faisalh@quicinc.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/20240829094502.26502-1-quic_faisalh@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/core.c |   15 +++++++++++++++
 drivers/usb/dwc3/core.h |    2 ++
 2 files changed, 17 insertions(+)

--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -1306,6 +1306,21 @@ static int dwc3_core_init(struct dwc3 *d
 	}
 
 	/*
+	 * STAR 9001285599: This issue affects DWC_usb3 version 3.20a
+	 * only. If the PM TIMER ECM is enabled through GUCTL2[19], the
+	 * link compliance test (TD7.21) may fail. If the ECN is not
+	 * enabled (GUCTL2[19] = 0), the controller will use the old timer
+	 * value (5us), which is still acceptable for the link compliance
+	 * test. Therefore, do not enable PM TIMER ECM in 3.20a by
+	 * setting GUCTL2[19] by default; instead, use GUCTL2[19] = 0.
+	 */
+	if (DWC3_VER_IS(DWC3, 320A)) {
+		reg = dwc3_readl(dwc->regs, DWC3_GUCTL2);
+		reg &= ~DWC3_GUCTL2_LC_TIMER;
+		dwc3_writel(dwc->regs, DWC3_GUCTL2, reg);
+	}
+
+	/*
 	 * When configured in HOST mode, after issuing U3/L2 exit controller
 	 * fails to send proper CRC checksum in CRC5 feild. Because of this
 	 * behaviour Transaction Error is generated, resulting in reset and
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -404,6 +404,7 @@
 
 /* Global User Control Register 2 */
 #define DWC3_GUCTL2_RST_ACTBITLATER		BIT(14)
+#define DWC3_GUCTL2_LC_TIMER			BIT(19)
 
 /* Global User Control Register 3 */
 #define DWC3_GUCTL3_SPLITDISABLE		BIT(14)
@@ -1232,6 +1233,7 @@ struct dwc3 {
 #define DWC3_REVISION_290A	0x5533290a
 #define DWC3_REVISION_300A	0x5533300a
 #define DWC3_REVISION_310A	0x5533310a
+#define DWC3_REVISION_320A	0x5533320a
 #define DWC3_REVISION_330A	0x5533330a
 
 #define DWC31_REVISION_ANY	0x0


