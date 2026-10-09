Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2542FBA45;
	Fri,  9 Oct 2026 14:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556614; cv=none; b=rt+zezqhUnZcz/RTMHpG40hp4bjMPOmqX9vnLY1h33vzafivDXQp7EUojjmIlH0JzuTtKvCOlkAnBeMkkdXntJ7SW10oFNoTTIk8v54/Go2SGrm50j3MLSztfCFDqhOwJr69VTRZYrGeSHFz/29Dvy6slr211FxprCq3m5Yr+f0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556614; c=relaxed/simple;
	bh=sTVLFvhYa5gCGqsD0FcIh/Bu5JzRG+JBMiysxqe+BAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gkTi7BNi9tOolBKA/lx+hoV5pG3zwBumT54GlnIHiT+/PGHFsEHxMa8p03tfjLd3RDrNcXjk4V+mxk4h/AbtHCkJZyZyXdX2cSIHw+l2Zi3dLhj1ONkAX+jOo0Cm0KKNrob5yr0pe4mePUrmk3qX9I9sQlRXK9k8gqNrM7g/IZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rsym2r0B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rsym2r0B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E9C91F000FF;
	Fri,  9 Oct 2026 14:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556613;
	bh=8Wb/YpGN2OC++CbAehIJiRyRVMEOEZyG8egPGniAlYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rsym2r0BshzoOXS+WGp4GYe5iyYccEs/KqoQ5Kj771Q2cQF0xnQKmfiJRkUrVPy+k
	 aoLliFGS4hCCOi+hd9xiEUlOCg5piFhkW/uVWrcf1BatHx8nlYNq8SKRBIny/JwwcN
	 L39bkLFsR1Imeu83ZIjCX06spZSUJfxBrouIJZRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Fluhr <mathieu.fluhr@gmail.com>,
	stable <stable@kernel.org>,
	Lovekesh Solanki <lovekeshsolanki00@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 7.2 209/428] usb: hub: use shorter 120ms post resume hold for SS root hubs
Date: Fri,  9 Oct 2026 16:09:06 +0200
Message-ID: <20261009140950.718729288@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lovekesh Solanki <lovekeshsolanki00@gmail.com>

commit 29480b05e6e226594dc11ccf2a036fbd5cdd0e42 upstream.

Holding a USB3 hub PM runtime reference for 200ms at hub resume triggers
an AMD platform issue.  Users running Android adb report crashes after
adb has been polling and waking up the USB subsystem once a second for
some time.  Vendors are working on a solution.  Disabling USB runtime PM
is one way to prevent this issue, but it is also proven that reducing the
hold time to 120ms in resume also mitigates it.  See Link for more
details.

Reducing the hold time to 120ms for the USB3 roothub is in itself a valid
change and optimization, as the current 200ms is excessive: a root hub
has no upstream suspended hub whose wake propagation needs to be
accounted for, but still need some time for USB3 link training to
complete.

Keep the 200ms hold for external hubs that commit 8f5b7e2bec1c
("usb: hub: fix detection of high tier USB3 devices behind suspended
hubs") is intended for.

Reported-by: Mathieu Fluhr <mathieu.fluhr@gmail.com>
Link: https://lore.kernel.org/all/CAPyJwA_D9qw0T72f8zwM1yKjP+To=maVANbcdsWM7yRmbBxYvw@mail.gmail.com/
Cc: stable <stable@kernel.org>
Fixes: 8f5b7e2bec1c ("usb: hub: fix detection of high tier USB3 devices behind suspended hubs")
Signed-off-by: Lovekesh Solanki <lovekeshsolanki00@gmail.com>
Acked-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://patch.msgid.link/20260903112903.542719-1-lovekeshsolanki00@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/hub.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -73,8 +73,11 @@
 /*
  * Give SS hubs 200ms time after wake to train downstream links before
  * assuming no port activity and allowing hub to runtime suspend back.
+ * Root hubs have no upstream hub whose wake propagation needs to be
+ * accounted for, so they need less time, use 120ms for them.
  */
 #define USB_SS_PORT_U0_WAKE_TIME	200  /* ms */
+#define USB_SS_RH_PORT_U0_WAKE_TIME     120 /* ms */
 
 /* Protect struct usb_device->state and ->children members
  * Note: Both are also protected by ->dev.sem, except that ->state can
@@ -1358,7 +1361,9 @@ static void hub_activate(struct usb_hub
 
 		queue_delayed_work(system_power_efficient_wq,
 				   &hub->post_resume_work,
-				   msecs_to_jiffies(USB_SS_PORT_U0_WAKE_TIME));
+				   msecs_to_jiffies(hdev->parent ?
+				USB_SS_PORT_U0_WAKE_TIME :
+				USB_SS_RH_PORT_U0_WAKE_TIME));
 		return;
 	}
 


