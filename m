Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1780817E900;
	Sun,  1 Sep 2024 16:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208880; cv=none; b=WgCcpq/QxNSpqNwUWvyBYrs0yXQLXC/e4hvQYU1N0Ny3RoHmTJcEzY4CULxZIwpP703ueyyByzCRs19XMYNaEeSyvGJVDgQRcawlsQ5v5o3LpgZLIKdnK2/kBz8Wz8Zyvx2xo8b/c3vUWlvuxtZvYt7CBCgQs4uLY8rdPv1fjAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208880; c=relaxed/simple;
	bh=TcQCz3fd78ZU2g2ZGnDtVrsbODsQCZD6g/8TiyebfL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hkKbb3gVjSITdteynpTMDouy7f1onr7pKvCD3SKyl8P3XmRQM+DNEJrccT+ndo1WRkQVdEyCeojopLHo4PkENUPORRBrK6VZb18JsLVCgiNY0IGcGGCajgNWcvX60ZhudzhgEsBVpRNuOLqiKouXA8O/pBxeAcjSmtu7InUH6/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yTiZ9TdG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yTiZ9TdG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76EE6C4CEC3;
	Sun,  1 Sep 2024 16:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208880;
	bh=TcQCz3fd78ZU2g2ZGnDtVrsbODsQCZD6g/8TiyebfL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yTiZ9TdGk6if/tiHSA8uasWP2K+2JaFVIcd/ZMyXR0zjAc2SR/8zZLO/E8N0fLTSO
	 5OQOmxoKhg3FPYwPlcAEO2sJ4yVto4cdcaX7XQWiWdl2Crm05hRgzV4AwIyQe90hv3
	 ZYq7P9DkaGAeqdOWcwkyxvLhBRNyJyjLF79aH05s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Krishna Kurapati <quic_kriskura@quicinc.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 068/134] usb: dwc3: core: Skip setting event buffers for host only controllers
Date: Sun,  1 Sep 2024 18:16:54 +0200
Message-ID: <20240901160812.658703893@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krishna Kurapati <quic_kriskura@quicinc.com>

[ Upstream commit 89d7f962994604a3e3d480832788d06179abefc5 ]

On some SoC's like SA8295P where the tertiary controller is host-only
capable, GEVTADDRHI/LO, GEVTSIZ, GEVTCOUNT registers are not accessible.
Trying to access them leads to a crash.

For DRD/Peripheral supported controllers, event buffer setup is done
again in gadget_pullup. Skip setup or cleanup of event buffers if
controller is host-only capable.

Suggested-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Krishna Kurapati <quic_kriskura@quicinc.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Tested-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20240420044901.884098-4-quic_kriskura@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/core.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 12e72e804278e..cbe475134b3c6 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -391,6 +391,13 @@ static void dwc3_free_event_buffers(struct dwc3 *dwc)
 static int dwc3_alloc_event_buffers(struct dwc3 *dwc, unsigned length)
 {
 	struct dwc3_event_buffer *evt;
+	unsigned int hw_mode;
+
+	hw_mode = DWC3_GHWPARAMS0_MODE(dwc->hwparams.hwparams0);
+	if (hw_mode == DWC3_GHWPARAMS0_MODE_HOST) {
+		dwc->ev_buf = NULL;
+		return 0;
+	}
 
 	evt = dwc3_alloc_one_event_buffer(dwc, length);
 	if (IS_ERR(evt)) {
@@ -412,6 +419,9 @@ int dwc3_event_buffers_setup(struct dwc3 *dwc)
 {
 	struct dwc3_event_buffer	*evt;
 
+	if (!dwc->ev_buf)
+		return 0;
+
 	evt = dwc->ev_buf;
 	evt->lpos = 0;
 	dwc3_writel(dwc->regs, DWC3_GEVNTADRLO(0),
@@ -429,6 +439,9 @@ void dwc3_event_buffers_cleanup(struct dwc3 *dwc)
 {
 	struct dwc3_event_buffer	*evt;
 
+	if (!dwc->ev_buf)
+		return;
+
 	evt = dwc->ev_buf;
 
 	evt->lpos = 0;
-- 
2.43.0



