Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19451F4CA9;
	Tue, 26 Aug 2025 13:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215631; cv=none; b=W0cUQy+IcnKq1FFw8ip5AYHQiG2ADWZhjtYXK8barkTGkQYixzdtl9Z2MteEeUrj4Uq2CaQTNt4k4iTW6xdHXi1R8+s6yeJhdmxJywjMsf1lVVcfusFvz0qBcR9S8Y7wSvBNbLeGJpkswVBEkU7q1eNHFKnjNsLUzfdMgwj+NSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215631; c=relaxed/simple;
	bh=uycIWlXLdMRIsNNN//SGLqljIl9u1XFMlB+D+ZIInBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tUuKNG8HnoMDC5idXhsT72A0IuBBYbyPgIG8SWHOM4iPQOfWbuxFeGN9bs/cRNAYvEW68Irfd272pqgN1SKBlR1A4j4AwSGdU9oIXtJ64uEXUj8d5lebZo/ByQ0XOLLub2koY8lCEXgztFuiC2CLnnIjUD86T9Wx16Kyw5CXyVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ryr1STSI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ryr1STSI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60E3BC4CEF1;
	Tue, 26 Aug 2025 13:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215631;
	bh=uycIWlXLdMRIsNNN//SGLqljIl9u1XFMlB+D+ZIInBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ryr1STSIeTh3n2uHxUAxorcI3vI3fSFsre7+RrHd4FrPF8I7akTAQ8EZOyorJoDqc
	 PCKhwNy1/pzIzyWTaEmC1T/K7LU/fMiG5dL1/6XWbqAWbVBjqFtWj5X6LJdaEp3SD+
	 X3Bi0EbsJyxrqayxO314fWWD3k87tsnhx8Fdje94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Yang <xu.yang_2@nxp.com>,
	Peter Chen <peter.chen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 107/644] usb: chipidea: add USB PHY event
Date: Tue, 26 Aug 2025 13:03:18 +0200
Message-ID: <20250826110949.167176745@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 50e37846f037..2615afd76561 100644
--- a/drivers/usb/chipidea/ci.h
+++ b/drivers/usb/chipidea/ci.h
@@ -276,8 +276,19 @@ static inline int ci_role_start(struct ci_hdrc *ci, enum ci_role role)
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
 
@@ -291,6 +302,9 @@ static inline void ci_role_stop(struct ci_hdrc *ci)
 	ci->role = CI_ROLE_END;
 
 	ci->roles[role]->stop(ci);
+
+	if (ci->usb_phy)
+		usb_phy_set_event(ci->usb_phy, USB_EVENT_NONE);
 }
 
 static inline enum usb_role ci_role_to_usb_role(struct ci_hdrc *ci)
diff --git a/drivers/usb/chipidea/udc.c b/drivers/usb/chipidea/udc.c
index 187c13af4b35..386019484ede 100644
--- a/drivers/usb/chipidea/udc.c
+++ b/drivers/usb/chipidea/udc.c
@@ -1703,6 +1703,13 @@ static int ci_udc_vbus_session(struct usb_gadget *_gadget, int is_active)
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
 
@@ -2018,6 +2025,9 @@ static irqreturn_t udc_irq(struct ci_hdrc *ci)
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



