Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0576350D43;
	Tue, 26 Aug 2025 14:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218618; cv=none; b=HPSM4OTdxIOut4DAUXMzHcZtUkjHiZZ7sOeDAS3t9WReIqErWnwj1TkgV93DAfhs6XjGIwKRK882SUCZM56jv0OeW6CJ7253TIRtEIkg2HP+W3ffBbXBRYBBLwGsD1C4n7CYA42TsaVULJOHbDtbDVhFp64OUGsXEU2IYu9iB04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218618; c=relaxed/simple;
	bh=KGPmO0qwnGpKxoFtPHg/N4J1ICHgWc6aFGZ82Tx7r9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oFsDvPNxhOjMhILbgBs78DJy7JpaJC953+s4jPK0KLbxjj0YdYu05A5extPKpkQUBtAZIG1AwRzV82I0aB9oLL1Mz1M0jW8x+LKeLuDgYT1nizD7oxQhHuZBkE+kbjifb5gaC0HcIZyG0Box+s/0HWsknA0BagoZOMg5u+24qCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vFz7XTBp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vFz7XTBp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75B0AC113CF;
	Tue, 26 Aug 2025 14:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218617;
	bh=KGPmO0qwnGpKxoFtPHg/N4J1ICHgWc6aFGZ82Tx7r9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vFz7XTBp0CtcTrJ9o091aBQcbZrsBkHx8x9TiUXOni0gvlgjAdx6WBbpJBlQqsAFs
	 g8Qmo+asGxOK1rlDWOdah/xVLI3K/CEpbZEhAV7xMdSVmm5wzXxxAU5ejDcuxAYaBV
	 FGjCRR5RWSmTCQT6AfR8gVLtVfu9/z2DG6E7VCjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Yang <xu.yang_2@nxp.com>,
	Peter Chen <peter.chen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 068/403] usb: chipidea: add USB PHY event
Date: Tue, 26 Aug 2025 13:06:34 +0200
Message-ID: <20250826110908.055549062@linuxfoundation.org>
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

From: Xu Yang <xu.yang_2@nxp.com>

[ Upstream commit b7a62611fab72e585c729a7fcf666aa9c4144214 ]

Add USB PHY event for below situation:
- usb role changed
- vbus connect
- vbus disconnect
- gadget driver is enumerated

USB PHY driver can get the last event after above situation occurs
and deal with different situations.

Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Acked-by: Peter Chen <peter.chen@kernel.org>
Link: https://lore.kernel.org/r/20230627110353.1879477-1-xu.yang_2@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/chipidea/ci.h  | 18 ++++++++++++++++--
 drivers/usb/chipidea/udc.c | 10 ++++++++++
 2 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/chipidea/ci.h b/drivers/usb/chipidea/ci.h
index ff61f88fc867..3a22bc727bb9 100644
--- a/drivers/usb/chipidea/ci.h
+++ b/drivers/usb/chipidea/ci.h
@@ -277,8 +277,19 @@ static inline int ci_role_start(struct ci_hdrc *ci, enum ci_role role)
 		return -ENXIO;
 
 	ret = ci->roles[role]->start(ci);
-	if (!ret)
-		ci->role = role;
+	if (ret)
+		return ret;
+
+	ci->role = role;
+
+	if (ci->usb_phy) {
+		if (role == CI_ROLE_HOST)
+			usb_phy_set_event(ci->usb_phy, USB_EVENT_ID);
+		else
+			/* in device mode but vbus is invalid*/
+			usb_phy_set_event(ci->usb_phy, USB_EVENT_NONE);
+	}
+
 	return ret;
 }
 
@@ -292,6 +303,9 @@ static inline void ci_role_stop(struct ci_hdrc *ci)
 	ci->role = CI_ROLE_END;
 
 	ci->roles[role]->stop(ci);
+
+	if (ci->usb_phy)
+		usb_phy_set_event(ci->usb_phy, USB_EVENT_NONE);
 }
 
 static inline enum usb_role ci_role_to_usb_role(struct ci_hdrc *ci)
diff --git a/drivers/usb/chipidea/udc.c b/drivers/usb/chipidea/udc.c
index dfae454ca9ba..19a9a4b83346 100644
--- a/drivers/usb/chipidea/udc.c
+++ b/drivers/usb/chipidea/udc.c
@@ -1583,6 +1583,13 @@ static int ci_udc_vbus_session(struct usb_gadget *_gadget, int is_active)
 		ret = ci->platdata->notify_event(ci,
 				CI_HDRC_CONTROLLER_VBUS_EVENT);
 
+	if (ci->usb_phy) {
+		if (is_active)
+			usb_phy_set_event(ci->usb_phy, USB_EVENT_VBUS);
+		else
+			usb_phy_set_event(ci->usb_phy, USB_EVENT_NONE);
+	}
+
 	if (ci->driver)
 		ci_hdrc_gadget_connect(_gadget, is_active);
 
@@ -1898,6 +1905,9 @@ static irqreturn_t udc_irq(struct ci_hdrc *ci)
 		if (USBi_PCI & intr) {
 			ci->gadget.speed = hw_port_is_high_speed(ci) ?
 				USB_SPEED_HIGH : USB_SPEED_FULL;
+			if (ci->usb_phy)
+				usb_phy_set_event(ci->usb_phy,
+					USB_EVENT_ENUMERATED);
 			if (ci->suspended) {
 				if (ci->driver->resume) {
 					spin_unlock(&ci->lock);
-- 
2.39.5



