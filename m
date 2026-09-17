Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B95224CDDDF;
	Thu, 17 Sep 2026 17:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667200; cv=none; b=j7bMw2lB+eGCDAhpBzTJAg7S1sUsue/WiBkfga7Lu0NzJhofsPiUbW1qxYV9AHyDJwPSA+p3M882eu4SxBf0FUmLE2v7CGauP8om5898jf1kK2d2li0Nu62MmuGI/6cGC4vHOKL2ZENg48OXdCbtCxsmGYDdZY9rECr+eS3DFaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667200; c=relaxed/simple;
	bh=dV1NR0iP1JrnjfoIKy4z0QTmjoT8xB1h0lO4ZS814I8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UIJhJX8fKBFRrMzrHc2wdOEH+VjNGeNIxYCWmowbcC5uZjaNwcOhbAQDZL43c7K28NaOqKuDDSgiRxLfMAPgG6+s4JuXx1mPTlPtDja3Oyz4vGTCwEUA81br2rExLvHOr5EEG1Ndi0SWbWH3i776NbsbgNTVX5Zekjn/PMg/LX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a4FuAID/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a4FuAID/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13A4D1F000FF;
	Thu, 17 Sep 2026 17:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667198;
	bh=pEEtHKg+RMdD8HrlL1YsFPcgIqK+eUXC9nyB0g/p1ww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a4FuAID/7nua6RxdjDcyV2WqiLHUD9XLKSYliG4DS318v2QbJ1/0eORa0sGmvlmZM
	 K61yyNMugg9Q4UJqga88DyABjCc9pUNJAcqE62JuCmcrdP9QIAygZ3ykuVhkuGQh07
	 FWihI55+rl/XaRUOHVmEKSXsmSKKaBvskb5oEP70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Yang <xu.yang_2@nxp.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0014/1102] usb: gadget: udc: skip pullup() if already connected
Date: Thu, 17 Sep 2026 15:59:17 +0100
Message-ID: <20260917151539.782658826@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Yang <xu.yang_2@nxp.com>

[ Upstream commit 62911bc82b0332aee7546156800d3516500fa1e1 ]

The device controller may update vbus status via usb_udc_vbus_handler(),
which tries to connect the gadget even though gadget_bind_driver() has
already called usb_udc_connect_control_locked(). This causes pullup() to
be called twice. Avoid this by checking if gadget->connected is true.

This also set gadget->connected as false in usb_gadget_activate() if it
became connected while it was being deactivated. Otherwise,
usb_gadget_connect_locked will return early and pullup() won't be called.

Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://patch.msgid.link/20260423095355.2673035-1-xu.yang_2@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/core.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/core.c b/drivers/usb/gadget/udc/core.c
index ab1bcc5512b2c..fa49746d54036 100644
--- a/drivers/usb/gadget/udc/core.c
+++ b/drivers/usb/gadget/udc/core.c
@@ -714,6 +714,9 @@ static int usb_gadget_connect_locked(struct usb_gadget *gadget)
 		goto out;
 	}
 
+	if (gadget->connected)
+		goto out;
+
 	if (gadget->deactivated || !gadget->udc->allow_connect || !gadget->udc->started) {
 		/*
 		 * If the gadget isn't usable (because it is deactivated,
@@ -887,8 +890,10 @@ int usb_gadget_activate(struct usb_gadget *gadget)
 	 * If gadget has been connected before deactivation, or became connected
 	 * while it was being deactivated, we call usb_gadget_connect().
 	 */
-	if (gadget->connected)
+	if (gadget->connected) {
+		gadget->connected = false;
 		ret = usb_gadget_connect_locked(gadget);
+	}
 
 unlock:
 	mutex_unlock(&gadget->udc->connect_lock);
-- 
2.53.0



