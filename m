Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E92F55E5E;
	Wed, 21 Feb 2024 13:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523452; cv=none; b=fvR1bPk5OX8w+TmhHdAAsEIy1O3g2hyTGYL6pFCSN1cIOJrxDxqEeMW55a3TY54Cj//OzOpTaxCUr4jq1epkJoHvd7TB9W5mxIqXcF6nB7ZTqOv+U7uCWZ61g9c0CUSf5rW3pAxCKehL9t6x4SEKn5d+2bo2bj5dAUFfgPS56PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523452; c=relaxed/simple;
	bh=+ZSYjfVp2LzuH1NaV9ZNzb5+avtu1/5dJ9SHaQ4enDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mz1WVEbOOa2iyttV8f8v1q73ts5hhRkjL+jdIglcgA9mUX/p6yI9KNAeqq6SRtt8Zggp4f40qQu/BiNGDZIWo6hSiRwGlU1Sd8HGM2/uCU1Gpf9Vmkrgd7McyxLaXFqfL7SBlUGNtIOEOoRthG1jJvU1wnee63Sy6yFdoYLOJgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rN3Y2Vnm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rN3Y2Vnm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A4CCC433C7;
	Wed, 21 Feb 2024 13:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523452;
	bh=+ZSYjfVp2LzuH1NaV9ZNzb5+avtu1/5dJ9SHaQ4enDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rN3Y2VnmURxj5xKjrYX6PQ812Esmzx0XvKJDTJzh1FRwj5Z3NQDs2QRGIldZeKgKE
	 U55HPUY7jz4VsW6cLfE6EcnOd6EWO0p29uo7phOjfXFG4rbWjp6nyP6mZE7OvFVwXG
	 a6qZOlNArnjCgRd4j25N6rwrtrusimCERLyd2lGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Wesley Cheng <quic_wcheng@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 439/476] usb: dwc3: gadget: Submit endxfer command if delayed during disconnect
Date: Wed, 21 Feb 2024 14:08:10 +0100
Message-ID: <20240221130024.258708200@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

From: Wesley Cheng <quic_wcheng@quicinc.com>

[ Upstream commit 8422b769fa46bd429dc0f324012629a4691f0dd9 ]

During a cable disconnect sequence, if ep0state is not in the SETUP phase,
then nothing will trigger any pending end transfer commands.  Force
stopping of any pending SETUP transaction, and move back to the SETUP
phase.

Reviewed-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Signed-off-by: Wesley Cheng <quic_wcheng@quicinc.com>
Link: https://lore.kernel.org/r/20220901193625.8727-6-quic_wcheng@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 730e12fbec53 ("usb: dwc3: gadget: Handle EP0 request dequeuing properly")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/gadget.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index ba1b2e70b351..c61b6f49701a 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -3739,13 +3739,24 @@ static void dwc3_gadget_disconnect_interrupt(struct dwc3 *dwc)
 	reg &= ~DWC3_DCTL_INITU2ENA;
 	dwc3_gadget_dctl_write_safe(dwc, reg);
 
+	dwc->connected = false;
+
 	dwc3_disconnect_gadget(dwc);
 
 	dwc->gadget->speed = USB_SPEED_UNKNOWN;
 	dwc->setup_packet_pending = false;
 	usb_gadget_set_state(dwc->gadget, USB_STATE_NOTATTACHED);
 
-	dwc->connected = false;
+	if (dwc->ep0state != EP0_SETUP_PHASE) {
+		unsigned int    dir;
+
+		dir = !!dwc->ep0_expect_in;
+		if (dwc->ep0state == EP0_DATA_PHASE)
+			dwc3_ep0_end_control_data(dwc, dwc->eps[dir]);
+		else
+			dwc3_ep0_end_control_data(dwc, dwc->eps[!dir]);
+		dwc3_ep0_stall_and_restart(dwc);
+	}
 }
 
 static void dwc3_gadget_reset_interrupt(struct dwc3 *dwc)
-- 
2.43.0



