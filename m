Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5ED61C0DE7;
	Mon,  1 Apr 2024 16:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989177; cv=none; b=nloNv885hkGbHNDiJ/nP96QyKIq7sSTFxcSNTWAESS2W3BdJYZNlmsoBsufjbWTZJ4zm97D4ppsW64zwk3zorNqvJj8t1k0qVzZt9kZW6vdniW9b8xLFGZoEVi4o8CtFK3XK/kJ2VWQ7Qs1bAW1Gh+REdCZJiEvIZwAA3DE7ZK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989177; c=relaxed/simple;
	bh=HTDdvG/HwXd13xvJA/eP9vrtyPa3AClRCVxrhkTElU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fVIO9pvnDbNpcapl1P/q8KrbmhNJsPNP4y0CJAH8Uv0gpWhXSTlAuO9TcJZ66uWmnYe9jcMGa67zQRY5hHk43asbStHLOOyoioMD/l5P0iLgTX1N9mwp3hr9W2sMVk7EKp2zHUDJW3U0mJN8X7Rnlpnpw72kkmTQjLQ5homFCy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xWud3Lu4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xWud3Lu4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1857C43390;
	Mon,  1 Apr 2024 16:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989177;
	bh=HTDdvG/HwXd13xvJA/eP9vrtyPa3AClRCVxrhkTElU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xWud3Lu4qhha75HhZG/5ePgmmVfpaTLX4Ylp/14CsvsfdCyVHS5kaTIQM5gS9K2Fq
	 o45Sl2+CfDGKWmQ2uQU03muoGEhYfRrxofpcNGsHgFRkqUI7jARsbgbpaLngxgxuYv
	 sL0vTnuT1MWGk071qzYKLNkgLNXU0Z91fTWJ+P/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	yuan linyu <yuanlinyu@hihonor.com>
Subject: [PATCH 6.7 404/432] usb: udc: remove warning when queue disabled ep
Date: Mon,  1 Apr 2024 17:46:31 +0200
Message-ID: <20240401152605.431837906@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: yuan linyu <yuanlinyu@hihonor.com>

commit 2a587a035214fa1b5ef598aea0b81848c5b72e5e upstream.

It is possible trigger below warning message from mass storage function,

WARNING: CPU: 6 PID: 3839 at drivers/usb/gadget/udc/core.c:294 usb_ep_queue+0x7c/0x104
pc : usb_ep_queue+0x7c/0x104
lr : fsg_main_thread+0x494/0x1b3c

Root cause is mass storage function try to queue request from main thread,
but other thread may already disable ep when function disable.

As there is no function failure in the driver, in order to avoid effort
to fix warning, change WARN_ON_ONCE() in usb_ep_queue() to pr_debug().

Suggested-by: Alan Stern <stern@rowland.harvard.edu>
Cc: stable@vger.kernel.org
Signed-off-by: yuan linyu <yuanlinyu@hihonor.com>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20240315020144.2715575-1-yuanlinyu@hihonor.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/gadget/udc/core.c
+++ b/drivers/usb/gadget/udc/core.c
@@ -292,7 +292,9 @@ int usb_ep_queue(struct usb_ep *ep,
 {
 	int ret = 0;
 
-	if (WARN_ON_ONCE(!ep->enabled && ep->address)) {
+	if (!ep->enabled && ep->address) {
+		pr_debug("USB gadget: queue request to disabled ep 0x%x (%s)\n",
+				 ep->address, ep->name);
 		ret = -ESHUTDOWN;
 		goto out;
 	}


