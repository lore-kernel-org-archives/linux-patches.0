Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AFBE188CB3;
	Tue, 10 Sep 2024 09:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962093; cv=none; b=BEqKDgXzn/I5C1Xnn6/7t6ebD3kW3FzfLkrzAJYhXroXXp8MINzgnODS+J70Q2wdz1S6xxV+qOmTdqMN9/S5JKg2ud6AX1pnHJtO+fn3fBzB2uSsoywzYMT7M1ykrycJ3zssf7OGTz990x2dLD89Def+3YWIiMduBYk9xrd6bCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962093; c=relaxed/simple;
	bh=JPZtCO61VVZKJvVXjUJxEf2PMR7gqJKSY9hjHvt+Ej8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e3c9zFI2hc92YLqfYyPvAPDJvI0tU0c/+39k+TSxNk9pi2vJbscjB5RSwGo3K72z89DOx1/1f2Nl3vJc6v7Ft+UFL99QwbpfEU7rf9V+EENZuzLxnsN5llMMLznrqjRXQRbrvXKWfGG22UjV5PO8r5spJ9o8UOzTW/XM+yQXY74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b1bJXp1R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b1bJXp1R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C609AC4CEC3;
	Tue, 10 Sep 2024 09:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962093;
	bh=JPZtCO61VVZKJvVXjUJxEf2PMR7gqJKSY9hjHvt+Ej8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b1bJXp1RAKY9JRXcoWb2c+/T+FuS8eTrZh+W1dQlh+PujPLFy1zbRfoZk93RUOiBg
	 7V4Lyq03YpLTWg6VT+gPQqTT5Y3v+UAEZyJSRkCKUKieRXARfttPPtqvyF9Ejr+Y+4
	 Z+imYZR4LM7/ajnfM1LrIjvgCouzg8/nuVzY3+cM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Faisal Hassan <quic_faisalh@quicinc.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.10 293/375] usb: dwc3: core: update LC timer as per USB Spec V3.2
Date: Tue, 10 Sep 2024 11:31:30 +0200
Message-ID: <20240910092632.407042383@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1368,6 +1368,21 @@ static int dwc3_core_init(struct dwc3 *d
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
@@ -417,6 +417,7 @@
 
 /* Global User Control Register 2 */
 #define DWC3_GUCTL2_RST_ACTBITLATER		BIT(14)
+#define DWC3_GUCTL2_LC_TIMER			BIT(19)
 
 /* Global User Control Register 3 */
 #define DWC3_GUCTL3_SPLITDISABLE		BIT(14)
@@ -1262,6 +1263,7 @@ struct dwc3 {
 #define DWC3_REVISION_290A	0x5533290a
 #define DWC3_REVISION_300A	0x5533300a
 #define DWC3_REVISION_310A	0x5533310a
+#define DWC3_REVISION_320A	0x5533320a
 #define DWC3_REVISION_330A	0x5533330a
 
 #define DWC31_REVISION_ANY	0x0


