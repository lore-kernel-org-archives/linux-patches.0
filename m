Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60228159574;
	Mon, 29 Jan 2024 17:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548183; cv=none; b=WOu+U0BgxDO2SUZKufZELMHoWRzFrA4S4DC4uAzcy1TagwOXK7g+BnX3xOc+93W0X6jDJjHfM1KfCq5whNB+V4Oar6n/9VzZMGY6JiW+Pi0g5b6f2eyI93Y/miDXuelvJCSchzemW67OYu1ptanCTbyMpKxnyKgs2v2j6EAkCd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548183; c=relaxed/simple;
	bh=JisxY2D1/KZVAK9OWXdGAI8RzVvTwCryJlwEokh79X4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nv3EshmtO0ehJhj6Sbf/KqcTiDOXGK389z5TGDkL16k2J0YNakK3YuygmvURvS/6OKgZZBwPDNGubR1Wuo5XWmW/HFv5h9W0OmtEaIk5k/j9RlnJPbbon6kTuUFvu0rr1lM51rzbmao71SPAVjoQYK27e2rO2o503K8j1ztZwyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EQFcjUlA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EQFcjUlA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26CBFC433A6;
	Mon, 29 Jan 2024 17:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548183;
	bh=JisxY2D1/KZVAK9OWXdGAI8RzVvTwCryJlwEokh79X4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EQFcjUlAjT2+CBpS/ijksB4+Td9z4VI6xlcEEGqxsQ4FtlMIEQBXNIOMluvJafdND
	 XGB6eEgpM8EVMg5UoLfqGcAquE8501cJ+5r7aLqHmAwtkpoVxu+r3dDuYImOcAEUpO
	 dMhcu9bhfyx/cwcVeRB5S7jSJhm9izJBMtRnOjtw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wesley Cheng <quic_wcheng@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 002/185] usb: dwc3: gadget: Queue PM runtime idle on disconnect event
Date: Mon, 29 Jan 2024 09:03:22 -0800
Message-ID: <20240129165958.678243194@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

From: Wesley Cheng <quic_wcheng@quicinc.com>

[ Upstream commit 3c7af52c7616c3aa6dacd2336ec748d4a65df8f4 ]

There is a scenario where DWC3 runtime suspend is blocked due to the
dwc->connected flag still being true while PM usage_count is zero after
DWC3 giveback is completed and the USB gadget session is being terminated.
This leads to a case where nothing schedules a PM runtime idle for the
device.

The exact condition is seen with the following sequence:
  1.  USB bus reset is issued by the host
  2.  Shortly after, or concurrently, a USB PD DR SWAP request is received
      (sink->source)
  3.  USB bus reset event handler runs and issues
      dwc3_stop_active_transfers(), and pending transfer are stopped
  4.  DWC3 usage_count decremented to 0, and runtime idle occurs while
      dwc->connected == true, returns -EBUSY
  5.  DWC3 disconnect event seen, dwc->connected set to false due to DR
      swap handling
  6.  No runtime idle after this point

Address this by issuing an asynchronous PM runtime idle call after the
disconnect event is completed, as it modifies the dwc->connected flag,
which is what blocks the initial runtime idle.

Fixes: fc8bb91bc83e ("usb: dwc3: implement runtime PM")
Cc:  <stable@vger.kernel.org>
Signed-off-by: Wesley Cheng <quic_wcheng@quicinc.com>
Link: https://lore.kernel.org/r/20240103214946.2596-1-quic_wcheng@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/gadget.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 339e8c3f7c50..5617a75b0d74 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -3860,6 +3860,13 @@ static void dwc3_gadget_disconnect_interrupt(struct dwc3 *dwc)
 	usb_gadget_set_state(dwc->gadget, USB_STATE_NOTATTACHED);
 
 	dwc3_ep0_reset_state(dwc);
+
+	/*
+	 * Request PM idle to address condition where usage count is
+	 * already decremented to zero, but waiting for the disconnect
+	 * interrupt to set dwc->connected to FALSE.
+	 */
+	pm_request_idle(dwc->dev);
 }
 
 static void dwc3_gadget_reset_interrupt(struct dwc3 *dwc)
-- 
2.43.0



