Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB02C34A32E;
	Tue, 26 Aug 2025 14:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217334; cv=none; b=Tfu/XaRI4IQ2yqgj3TQVg/sp8IyHmm788CKgxPt/lm6NxqHQJg2i+cGTHrgsXM+AzAwrOVdjjzbQHaQg2RUKfHGWoohm/tRnFxbMyoHZRY+fcXKNeeFt5s6sYUcXJJ13QeG6Sbmjz7q/auFAmo9xMJdNjkTaj2vjo7RxSiDq8HI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217334; c=relaxed/simple;
	bh=9uUomh74xzFMnRUyk7DT+t68LUHPq9AwmHHRHlFqx5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dDn+vVY8tCOpGmQ3zLmUrLt00HkOZsRhlCj4VYTrscxVtj5nzJBzAu2uSuX4Hybeay56Zys1aokR0mjoOrQ3puPuEDeZ5P5vLDD+B1knypom8H7NVGieVx0vGCgQCaf+e7eaOI1qk2Rw6KOhPgQ5RMiYJF0Uut+pL7UE+D7Ss6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cGqzrXQ4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cGqzrXQ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70308C4CEF1;
	Tue, 26 Aug 2025 14:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217334;
	bh=9uUomh74xzFMnRUyk7DT+t68LUHPq9AwmHHRHlFqx5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cGqzrXQ4DUXrdDvmRO9Vgo+QOk8qgjaEQ1kLIwhwBEdr97wpMurGCNgX1G5cSA1Dm
	 +y29sdlCu9ArXthOs/L4MOp5ebtghGwuekdDtVqyo2W82DQzh865tYOMDQ4xX1u8qJ
	 mwPSxvY2sRQQw+nrOdzSjgDhh3oLkqplOVOP42y0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Yang <xu.yang_2@nxp.com>,
	Peter Chen <peter.chen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 073/523] usb: chipidea: add USB PHY event
Date: Tue, 26 Aug 2025 13:04:43 +0200
Message-ID: <20250826110926.371168030@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7b00b93dad9b..f12e177bfc55 100644
--- a/drivers/usb/chipidea/ci.h
+++ b/drivers/usb/chipidea/ci.h
@@ -278,8 +278,19 @@ static inline int ci_role_start(struct ci_hdrc *ci, enum ci_role role)
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
 
@@ -293,6 +304,9 @@ static inline void ci_role_stop(struct ci_hdrc *ci)
 	ci->role = CI_ROLE_END;
 
 	ci->roles[role]->stop(ci);
+
+	if (ci->usb_phy)
+		usb_phy_set_event(ci->usb_phy, USB_EVENT_NONE);
 }
 
 static inline enum usb_role ci_role_to_usb_role(struct ci_hdrc *ci)
diff --git a/drivers/usb/chipidea/udc.c b/drivers/usb/chipidea/udc.c
index 1c7af91bf03a..122d2d82c67c 100644
--- a/drivers/usb/chipidea/udc.c
+++ b/drivers/usb/chipidea/udc.c
@@ -1697,6 +1697,13 @@ static int ci_udc_vbus_session(struct usb_gadget *_gadget, int is_active)
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
 
@@ -2012,6 +2019,9 @@ static irqreturn_t udc_irq(struct ci_hdrc *ci)
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



