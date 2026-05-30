Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75846332919;
	Sat, 30 May 2026 16:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160135; cv=none; b=R3lZRB9agMPAz1gGfJ3s/H7hftehJK2dCjDIYP90jTFqbXKvaSfOdoZL6heFsBwNUVevVjt75CrIR1yWdDlv0KXi0zCnQ4Ri3ezAfTfjlX2lI6yXi8E+JcL5clIkNlBYVR3NyL2tifcQOS02SGxKHIM5nCLJQ9Lkpe8gk7wyE/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160135; c=relaxed/simple;
	bh=Ql8nxipa/hQ3grSutY0mesI8pff4vD6K9fnCRgthGSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JSj16LR421M88H7KpODf37HY7vsCRddZZM9GLMmO3DjWesj7PjeaV+yLzs1cWRxb3Gr30eha0N/jsV2/jF1gXIkfNsULc3oTOgywxMvQA58i5h+z0wui5wxZmDqq5Dm7oxlUux30zVpwMay5a2Z71kBcaxOZ3gqBMThG061j11k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XBQ0WkoK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XBQ0WkoK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6DAD1F00893;
	Sat, 30 May 2026 16:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160134;
	bh=Btvg6Jju0Qg+j9N+u5KxjD2bGhehH1sSvOn2Ca/2d30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XBQ0WkoKdNQvVaTh0CeakoWjfgGB0N+GoxBd5H5pKzoEmWEcdhSeINT6BpCG7cQSn
	 fG1ztXuvwmeLBMz97jPV7ofcTYYKckKwv5UW+tLxcH+jk/jk1S9ugL0yvvwLf+kbqL
	 DJHvY7tU1jVdoSEi2T8gAOGk1VWIIxhpGQnALRG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakob Unterwurzacher <jakob.unterwurzacher@theobroma-systems.com>,
	Johan Hovold <johan@kernel.org>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.1 254/969] can: ucan: fix devres lifetime
Date: Sat, 30 May 2026 17:56:18 +0200
Message-ID: <20260530160307.487331950@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit fed4626501c871890da287bec62a96e52da1af89 upstream.

USB drivers bind to USB interfaces and any device managed resources
should have their lifetime tied to the interface rather than parent USB
device. This avoids issues like memory leaks when drivers are unbound
without their devices being physically disconnected (e.g. on probe
deferral or configuration changes).

Fix the control message buffer lifetime so that it is released on driver
unbind.

Fixes: 9f2d3eae88d2 ("can: ucan: add driver for Theobroma Systems UCAN devices")
Cc: stable@vger.kernel.org	# 4.19
Cc: Jakob Unterwurzacher <jakob.unterwurzacher@theobroma-systems.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260327104520.1310158-1-johan@kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/ucan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/can/usb/ucan.c
+++ b/drivers/net/can/usb/ucan.c
@@ -1398,7 +1398,7 @@ static int ucan_probe(struct usb_interfa
 	 */
 
 	/* Prepare Memory for control transfers */
-	ctl_msg_buffer = devm_kzalloc(&udev->dev,
+	ctl_msg_buffer = devm_kzalloc(&intf->dev,
 				      sizeof(union ucan_ctl_payload),
 				      GFP_KERNEL);
 	if (!ctl_msg_buffer) {


