Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 992423587DE;
	Sat, 17 Oct 2026 17:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256635; cv=none; b=o2Sg3AjU/Ri49BDeX2viJve2+aT1ptxuyxXo0Cje16v8T3Z7zI549UYvg7QCOIdyeaBtcHPeiLwDT3eyLx4+URGWU8OM4SOfmkvxrY3EedeiasjL9oVyDZ9nZv5Th52O0QSBedJmmKktLLzpA6cDQn5nPydTePaYQup1R7K0j3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256635; c=relaxed/simple;
	bh=E1cagARZwYy2miOTASVj3aMYWyvYKsHy6IVwDG67FUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H/c8muLLVEb9jnIyuxEOQQ1RgHUt5dwDRLFMQ8guoJQ90tHjd2m5aq2moWs9Tz2vWxWD7fomp/W+4zsal7RZyRiaquq7npfrBcEf/Sqlyw1mX2GeqBk7MFqg0cLJ1d2SCeFSJrCGctw3f4PrfKQVDaH4T/oqcc5V5qxlR3dC7dA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2iiW1jDh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2iiW1jDh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A75F21F000C4;
	Sat, 17 Oct 2026 17:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256634;
	bh=ZiGHuwncYDH70oe488ngYytsHspxR+rNFUoXi63ZEcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2iiW1jDh11FHmbRmrr5FX3hdvsWL6tTauR5W6oVAYRof0jMGFWnppuPBx2NDMDxGH
	 BidUxo2L8ULZm3yA00tfJz1AZ0tlYuc7PtfzdSZ+nP92SKGAUlCsxbGUnNEPRKsTCA
	 45uot50semNQzOPVpbVbpcKPBGFmIKd/nQLfaxkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Fluhr <mathieu.fluhr@gmail.com>,
	stable <stable@kernel.org>,
	Lovekesh Solanki <lovekeshsolanki00@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.6 0259/1674] usb: hub: use shorter 120ms post resume hold for SS root hubs
Date: Sat, 17 Oct 2026 17:42:11 +0200
Message-ID: <20261017160437.775381921@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -69,8 +69,11 @@
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
@@ -1332,7 +1335,9 @@ static void hub_activate(struct usb_hub
 
 		queue_delayed_work(system_power_efficient_wq,
 				   &hub->post_resume_work,
-				   msecs_to_jiffies(USB_SS_PORT_U0_WAKE_TIME));
+				   msecs_to_jiffies(hdev->parent ?
+				USB_SS_PORT_U0_WAKE_TIME :
+				USB_SS_RH_PORT_U0_WAKE_TIME));
 		return;
 	}
 


