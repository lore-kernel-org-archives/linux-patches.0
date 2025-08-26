Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A8423570B9;
	Tue, 26 Aug 2025 14:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219409; cv=none; b=epsFn0eZBAx8BfMZ9Dq2vp4IGemY83PNi6rDMscLAG3BeuWL64xWRPJXqhQUfRiJ4YcR3MqUdHIw5Gs8Tot2J2olvQk8VEv7JfAI7IUXJm9RzacZjStR6aVNEP/6XpyG4Yof3/A7JwI14DLkwAHFhD+B3ydOdJXU53MJDHoqBG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219409; c=relaxed/simple;
	bh=Q0VpzMIFFzSWITD716La6SR+tpAPNB83+EO5kylzX2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lKebT4aBg4/+3iGip8VUXmc/kdPHv49dOp0T8lPo60pmtINgzVdbQInFB1lpZ+mEeqYT/ncBDjRBY2UiH5/4QT6Rc/FXSgBu+9Y2KW5WHPvjhuJ2U1V0x3klxJOrcunVNN/+DSRDTVwjp2JIA1qZa0ZBKdC16B1PDHF1sspeL24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y8e2wFkK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y8e2wFkK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C71ECC113CF;
	Tue, 26 Aug 2025 14:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219409;
	bh=Q0VpzMIFFzSWITD716La6SR+tpAPNB83+EO5kylzX2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y8e2wFkKqqHMHCfyGYqKZScm5H1jbwtS4PmWyS0+uZFB7lKW4VWWTy/OLbknjSJAj
	 Ftmu/OzDAIDJfAzP3QQlbyKqyaefH0ro3RqNjh28ZIikH7ek4ELLdteJFcIJSc1ppI
	 HIP+IuC6uR/D01U/W6HhSAT6eySRpNVMjWkR2t9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 353/403] cdc-acm: fix race between initial clearing halt and open
Date: Tue, 26 Aug 2025 13:11:19 +0200
Message-ID: <20250826110916.627524290@linuxfoundation.org>
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

From: Oliver Neukum <oneukum@suse.com>

[ Upstream commit 64690a90cd7c6db16d3af8616be1f4bf8d492850 ]

On the devices that need their endpoints to get an
initial clear_halt, this needs to be done before
the devices can be opened. That means it needs to be
before the devices are registered.

Fixes: 15bf722e6f6c0 ("cdc-acm: Add support of ATOL FPrint fiscal printers")
Cc: stable <stable@kernel.org>
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/r/20250717141259.2345605-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-acm.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1527,6 +1527,12 @@ skip_countries:
 	usb_driver_claim_interface(&acm_driver, data_interface, acm);
 	usb_set_intfdata(data_interface, acm);
 
+	if (quirks & CLEAR_HALT_CONDITIONS) {
+		/* errors intentionally ignored */
+		usb_clear_halt(usb_dev, acm->in);
+		usb_clear_halt(usb_dev, acm->out);
+	}
+
 	tty_dev = tty_port_register_device(&acm->port, acm_tty_driver, minor,
 			&control_interface->dev);
 	if (IS_ERR(tty_dev)) {
@@ -1534,11 +1540,6 @@ skip_countries:
 		goto alloc_fail6;
 	}
 
-	if (quirks & CLEAR_HALT_CONDITIONS) {
-		usb_clear_halt(usb_dev, acm->in);
-		usb_clear_halt(usb_dev, acm->out);
-	}
-
 	dev_info(&intf->dev, "ttyACM%d: USB ACM device\n", minor);
 
 	return 0;


