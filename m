Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B7F51EB21;
	Wed,  2 Oct 2024 14:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880472; cv=none; b=rVZrfDLUdvr4jg6pba0Gc1qw4pme0+V5wm6u/Qa9FzXYnsnKV8dVdIXuAN44HnIEy21q4zACV7Z4W8d+ZFR5ZqFyfYH2k0Gz7U20/Yg1VihMow8eF08peXo1s3Bb52oPJg+mVFLWznfuuNoX8Xps1alz20mlM4Kj1SsZMhyAsnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880472; c=relaxed/simple;
	bh=+easFohQk2Whb/1xife9TrU+OKHyBX4dhNtHesBARQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pYG4zs2FqGytRhjrifqp/zCFamYDStAoWFARLI+KhJoRkrWXE2dWBY9uCpuFoCfE2fIt6uuc0HP18JiuAmeuTQ2MO8VD26cypR4Rka1v5H0uoih7jNGtAM48irOBaOd9OT6BEs3hFHH/DajELe0Zm5/qA5AtRkaxXtusdEAQX7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IoQe2cqu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IoQe2cqu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B523C4CEC2;
	Wed,  2 Oct 2024 14:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880471;
	bh=+easFohQk2Whb/1xife9TrU+OKHyBX4dhNtHesBARQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IoQe2cquhfeExIi393TMYeAHtsoopcFkUuKeKYE95jgl0kk624PWYx5EMM3tzGQIW
	 s+rvkxwgLHJVMEsPEcPFT0dN6Fc0qPamtvgG8oRHkThXW+4//lfmv0i+LwDhp1vQ9h
	 0ADi/KPSW+oOMzr7QFtYyB7xQfbb8cGth+v94eGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomas Marek <tomas.marek@elrest.cz>
Subject: [PATCH 6.6 438/538] usb: dwc2: drd: fix clock gating on USB role switch
Date: Wed,  2 Oct 2024 15:01:17 +0200
Message-ID: <20241002125809.727884959@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomas Marek <tomas.marek@elrest.cz>

commit 2c6b6afa59e78bebcb65bbc8a76b3459f139547c upstream.

The dwc2_handle_usb_suspend_intr() function disables gadget clocks in USB
peripheral mode when no other power-down mode is available (introduced by
commit 0112b7ce68ea ("usb: dwc2: Update dwc2_handle_usb_suspend_intr function.")).
However, the dwc2_drd_role_sw_set() USB role update handler attempts to
read DWC2 registers if the USB role has changed while the USB is in suspend
mode (when the clocks are gated). This causes the system to hang.

Release the gadget clocks before handling the USB role update.

Fixes: 0112b7ce68ea ("usb: dwc2: Update dwc2_handle_usb_suspend_intr function.")
Cc: stable@vger.kernel.org
Signed-off-by: Tomas Marek <tomas.marek@elrest.cz>
Link: https://lore.kernel.org/r/20240906055025.25057-1-tomas.marek@elrest.cz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc2/drd.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/usb/dwc2/drd.c
+++ b/drivers/usb/dwc2/drd.c
@@ -127,6 +127,15 @@ static int dwc2_drd_role_sw_set(struct u
 			role = USB_ROLE_DEVICE;
 	}
 
+	if ((IS_ENABLED(CONFIG_USB_DWC2_PERIPHERAL) ||
+	     IS_ENABLED(CONFIG_USB_DWC2_DUAL_ROLE)) &&
+	     dwc2_is_device_mode(hsotg) &&
+	     hsotg->lx_state == DWC2_L2 &&
+	     hsotg->params.power_down == DWC2_POWER_DOWN_PARAM_NONE &&
+	     hsotg->bus_suspended &&
+	     !hsotg->params.no_clock_gating)
+		dwc2_gadget_exit_clock_gating(hsotg, 0);
+
 	if (role == USB_ROLE_HOST) {
 		already = dwc2_ovr_avalid(hsotg, true);
 	} else if (role == USB_ROLE_DEVICE) {


