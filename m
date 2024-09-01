Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3907A2C190;
	Sun,  1 Sep 2024 17:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210169; cv=none; b=pc/yLcCFn4jPq4pevpcxAE5ua44qNsZfe4nIJmvU+lIGIxDNqMHLIO+0vuhteSM838cG+XPWq7nqnWD00kj6lHKNKckLJ6vEVrS9vYaAyxj/yHnbqxLTLcIV471NTFKD9ufc13tr+fP3//q+auUKI9L3WBVOvOvIcImDiGWn6kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210169; c=relaxed/simple;
	bh=Mg9KoRx0GFyED+boTO/XXz+tRxIPPHPftcD3tawbaGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nd4MVpGXBrqdC9JLetN0Gc+fAqzQ1fMgNJUSk3rKXjjRqA6P50Jw2X5CkVaPu+DqWO0sa/Bkp1vNdGQPPC+GjpurKChMXcJKAmNf/BzZaqW4cxI2JGyAoW7e5r0/SsnF0NDJXoxXvjjOifvjyZMqBWcVZEIGtPkOmnzK25Pvydo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R8Ev4bt5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R8Ev4bt5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B307FC4CEC3;
	Sun,  1 Sep 2024 17:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210169;
	bh=Mg9KoRx0GFyED+boTO/XXz+tRxIPPHPftcD3tawbaGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R8Ev4bt5Rqj6DZdF6G9k5feH6gPjySl1HwTqKUKcOhRQiNS6DeFDX7+geOYEY01Pe
	 HcpfsoYhZKaiNsoilxT1Y0nWUaruByLr6kf8j3QK8VbYEqYsPTna0965xNvtlvSHZ6
	 32VFJl573nRuZcUZo3S0NJV8TlQx/o5QutzA3t0s=
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
Subject: [PATCH 5.15 102/215] usb: dwc3: core: Skip setting event buffers for host only controllers
Date: Sun,  1 Sep 2024 18:16:54 +0200
Message-ID: <20240901160827.205125256@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1dc417da1a0fe..26eaeb7a0301b 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -430,6 +430,13 @@ static void dwc3_free_event_buffers(struct dwc3 *dwc)
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
@@ -451,6 +458,9 @@ int dwc3_event_buffers_setup(struct dwc3 *dwc)
 {
 	struct dwc3_event_buffer	*evt;
 
+	if (!dwc->ev_buf)
+		return 0;
+
 	evt = dwc->ev_buf;
 	evt->lpos = 0;
 	dwc3_writel(dwc->regs, DWC3_GEVNTADRLO(0),
@@ -468,6 +478,9 @@ void dwc3_event_buffers_cleanup(struct dwc3 *dwc)
 {
 	struct dwc3_event_buffer	*evt;
 
+	if (!dwc->ev_buf)
+		return;
+
 	evt = dwc->ev_buf;
 
 	evt->lpos = 0;
-- 
2.43.0



