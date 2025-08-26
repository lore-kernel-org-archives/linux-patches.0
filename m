Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453FF34F498;
	Tue, 26 Aug 2025 14:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218615; cv=none; b=JKEQ2xXPFPmD1PtqrX5qfP47AVCYZwGImXtimAUhv73F3Z2QoW9GeUUe67BCSydgtZnJW6gqCIaani7YIYZYUAsSJ2qMZFVLxDMGliz8JOioULZLlXsgXsMN2lWe1NTQiyFEqEdYNCown4grvtETUjyl95QIq/7EXa0wlWb1ZIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218615; c=relaxed/simple;
	bh=QFssTEfa78om6eXwr5NLJYM/2EMR5iUgr50fgFv+D9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Smi55R1kmnWWgcEEnFnNtOOqhCHWhRYgA/d/xZFDGS0yfmor3AqPFDhRCiAogHtK9HfzVd/Hf5RJk+PJQeVSlvjfI4CHjHBaYybpUeh/25MawO0enoimmNBJbuMZNI7s1NCjkT9eJ4YGdP+1WuWYzZ6aI52gXi386zYsHLsJOPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S2waD9/Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S2waD9/Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CACDBC4CEF1;
	Tue, 26 Aug 2025 14:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218615;
	bh=QFssTEfa78om6eXwr5NLJYM/2EMR5iUgr50fgFv+D9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S2waD9/Q/+uY2hoUvF2VvTvWhq3j+gX3vM4UtOPP9QPtDP1Wda+VwiE2V4a3If2sJ
	 vj0yIPPEiFOiKfgiFs5dboba0N6ex57DtHMqdfiMV1PVad5I1AubYQU9okZPuNXonR
	 ySJnfi4KxQR1dB8EhRxnQy/reCgW5HivM5oeEntw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Chen <peter.chen@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 067/403] usb: chipidea: introduce CI_HDRC_CONTROLLER_VBUS_EVENT glue layer use
Date: Tue, 26 Aug 2025 13:06:33 +0200
Message-ID: <20250826110908.010073235@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Peter Chen <peter.chen@nxp.com>

[ Upstream commit d755cdb1b9d7e1b645e176b97eb137194bbe8cf9 ]

Some vendors glue layer need to handle some events for vbus, eg,
some i.mx platforms (imx7d, imx8mm, imx8mn, etc) needs vbus event
to handle charger detection, its charger detection is finished at
glue layer code, but not at USB PHY driver.

Signed-off-by: Peter Chen <peter.chen@nxp.com>
Stable-dep-of: b7a62611fab7 ("usb: chipidea: add USB PHY event")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/chipidea/udc.c   | 7 ++++++-
 include/linux/usb/chipidea.h | 1 +
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/chipidea/udc.c b/drivers/usb/chipidea/udc.c
index 9212c3842a1b..dfae454ca9ba 100644
--- a/drivers/usb/chipidea/udc.c
+++ b/drivers/usb/chipidea/udc.c
@@ -1569,6 +1569,7 @@ static int ci_udc_vbus_session(struct usb_gadget *_gadget, int is_active)
 {
 	struct ci_hdrc *ci = container_of(_gadget, struct ci_hdrc, gadget);
 	unsigned long flags;
+	int ret = 0;
 
 	spin_lock_irqsave(&ci->lock, flags);
 	ci->vbus_active = is_active;
@@ -1578,10 +1579,14 @@ static int ci_udc_vbus_session(struct usb_gadget *_gadget, int is_active)
 		usb_phy_set_charger_state(ci->usb_phy, is_active ?
 			USB_CHARGER_PRESENT : USB_CHARGER_ABSENT);
 
+	if (ci->platdata->notify_event)
+		ret = ci->platdata->notify_event(ci,
+				CI_HDRC_CONTROLLER_VBUS_EVENT);
+
 	if (ci->driver)
 		ci_hdrc_gadget_connect(_gadget, is_active);
 
-	return 0;
+	return ret;
 }
 
 static int ci_udc_wakeup(struct usb_gadget *_gadget)
diff --git a/include/linux/usb/chipidea.h b/include/linux/usb/chipidea.h
index edd89b7c8f18..54167a2d28ea 100644
--- a/include/linux/usb/chipidea.h
+++ b/include/linux/usb/chipidea.h
@@ -67,6 +67,7 @@ struct ci_hdrc_platform_data {
 #define CI_HDRC_CONTROLLER_STOPPED_EVENT	1
 #define CI_HDRC_IMX_HSIC_ACTIVE_EVENT		2
 #define CI_HDRC_IMX_HSIC_SUSPEND_EVENT		3
+#define CI_HDRC_CONTROLLER_VBUS_EVENT		4
 	int	(*notify_event) (struct ci_hdrc *ci, unsigned event);
 	struct regulator	*reg_vbus;
 	struct usb_otg_caps	ci_otg_caps;
-- 
2.39.5



